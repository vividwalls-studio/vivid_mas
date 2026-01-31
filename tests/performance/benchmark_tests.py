"""
VividWalls MAS Performance Benchmarking Tests
Comprehensive performance testing for all system improvements
"""

import asyncio
import time
import psutil
import statistics
from datetime import datetime
from typing import Dict, List, Tuple
import psycopg2
from neo4j import AsyncGraphDatabase
import redis
import numpy as np
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class PerformanceBenchmark:
    """Base class for performance benchmarking"""
    
    def __init__(self, name: str):
        self.name = name
        self.results = []
        self.system_metrics = []
        
    def start_monitoring(self):
        """Start system resource monitoring"""
        self.start_time = time.time()
        self.start_cpu = psutil.cpu_percent(interval=0.1)
        self.start_memory = psutil.virtual_memory().percent
        
    def stop_monitoring(self):
        """Stop monitoring and record metrics"""
        end_time = time.time()
        end_cpu = psutil.cpu_percent(interval=0.1)
        end_memory = psutil.virtual_memory().percent
        
        return {
            'duration_ms': int((end_time - self.start_time) * 1000),
            'cpu_usage_avg': (self.start_cpu + end_cpu) / 2,
            'memory_usage_avg': (self.start_memory + end_memory) / 2
        }
        
    def record_operation(self, operation: str, count: int, duration_ms: int):
        """Record operation performance"""
        ops_per_second = (count / duration_ms) * 1000 if duration_ms > 0 else 0
        self.results.append({
            'operation': operation,
            'count': count,
            'duration_ms': duration_ms,
            'ops_per_second': ops_per_second,
            'timestamp': datetime.now()
        })
        
    def get_summary(self) -> Dict:
        """Get performance summary"""
        if not self.results:
            return {}
            
        durations = [r['duration_ms'] for r in self.results]
        ops_rates = [r['ops_per_second'] for r in self.results]
        
        return {
            'benchmark': self.name,
            'total_operations': sum(r['count'] for r in self.results),
            'total_duration_ms': sum(durations),
            'avg_duration_ms': statistics.mean(durations),
            'median_duration_ms': statistics.median(durations),
            'p95_duration_ms': np.percentile(durations, 95),
            'p99_duration_ms': np.percentile(durations, 99),
            'avg_ops_per_second': statistics.mean(ops_rates),
            'max_ops_per_second': max(ops_rates),
            'min_ops_per_second': min(ops_rates)
        }


class DatabasePerformanceTests(PerformanceBenchmark):
    """Performance tests for database operations"""
    
    def __init__(self, db_config: Dict):
        super().__init__("Database Performance")
        self.db_config = db_config
        self.conn = None
        
    def setup(self):
        """Setup database connection"""
        self.conn = psycopg2.connect(**self.db_config)
        self.cursor = self.conn.cursor()
        
    def teardown(self):
        """Cleanup"""
        if self.conn:
            self.conn.close()
            
    def test_agent_hierarchy_query(self, iterations: int = 100):
        """Benchmark agent hierarchy queries"""
        logger.info(f"Running agent hierarchy query benchmark ({iterations} iterations)")
        
        times = []
        for _ in range(iterations):
            start = time.time()
            self.cursor.execute("""
                WITH RECURSIVE agent_tree AS (
                    SELECT id, name, parent_id, 0 as level
                    FROM agents
                    WHERE parent_id IS NULL
                    UNION ALL
                    SELECT a.id, a.name, a.parent_id, at.level + 1
                    FROM agents a
                    JOIN agent_tree at ON a.parent_id = at.id
                )
                SELECT * FROM agent_tree ORDER BY level, name
            """)
            results = self.cursor.fetchall()
            duration = (time.time() - start) * 1000
            times.append(duration)
            
        self.record_operation("hierarchy_query", iterations, sum(times))
        return times
        
    def test_materialized_view_performance(self, iterations: int = 100):
        """Compare materialized view vs regular query performance"""
        logger.info(f"Running materialized view benchmark ({iterations} iterations)")
        
        # Test regular query
        regular_times = []
        for _ in range(iterations):
            start = time.time()
            self.cursor.execute("""
                SELECT 
                    a.*,
                    ap.personality,
                    ap.voice_config,
                    ap.llm_config,
                    array_agg(DISTINCT ah.child_id) as subordinates
                FROM agents a
                LEFT JOIN agent_profiles ap ON a.id = ap.agent_id
                LEFT JOIN agent_hierarchy ah ON a.id = ah.parent_id
                GROUP BY a.id, ap.personality, ap.voice_config, ap.llm_config
            """)
            results = self.cursor.fetchall()
            duration = (time.time() - start) * 1000
            regular_times.append(duration)
            
        # Test materialized view
        mv_times = []
        for _ in range(iterations):
            start = time.time()
            self.cursor.execute("SELECT * FROM mv_agent_complete_profiles")
            results = self.cursor.fetchall()
            duration = (time.time() - start) * 1000
            mv_times.append(duration)
            
        improvement = ((sum(regular_times) - sum(mv_times)) / sum(regular_times)) * 100
        logger.info(f"Materialized view improvement: {improvement:.2f}%")
        
        self.record_operation("regular_query", iterations, sum(regular_times))
        self.record_operation("materialized_view", iterations, sum(mv_times))
        
        return regular_times, mv_times
        
    def test_embedding_search_performance(self, iterations: int = 50):
        """Benchmark vector similarity search"""
        logger.info(f"Running embedding search benchmark ({iterations} iterations)")
        
        # Generate random embedding
        random_embedding = np.random.rand(1536).tolist()
        
        times = []
        for _ in range(iterations):
            start = time.time()
            self.cursor.execute("""
                SELECT id, content_id, content_type,
                       1 - (embedding <=> %s::vector) as similarity
                FROM unified_embeddings
                ORDER BY embedding <=> %s::vector
                LIMIT 10
            """, (random_embedding, random_embedding))
            results = self.cursor.fetchall()
            duration = (time.time() - start) * 1000
            times.append(duration)
            
        self.record_operation("embedding_search", iterations, sum(times))
        return times
        
    def test_bulk_insert_performance(self, batch_sizes: List[int] = [10, 100, 1000]):
        """Test bulk insert performance with different batch sizes"""
        logger.info(f"Running bulk insert benchmark")
        
        results = {}
        for batch_size in batch_sizes:
            # Generate test data
            test_data = [
                (f'test-agent-{i}', f'Test Agent {i}', 'Test Role', False)
                for i in range(batch_size)
            ]
            
            # Test insert
            start = time.time()
            self.cursor.executemany("""
                INSERT INTO agents (id, name, role, is_director)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (id) DO NOTHING
            """, test_data)
            self.conn.commit()
            duration = (time.time() - start) * 1000
            
            # Cleanup
            self.cursor.execute("""
                DELETE FROM agents WHERE id LIKE 'test-agent-%'
            """)
            self.conn.commit()
            
            results[batch_size] = duration
            self.record_operation(f"bulk_insert_{batch_size}", batch_size, duration)
            
        return results


class Neo4jPerformanceTests(PerformanceBenchmark):
    """Performance tests for Neo4j operations"""
    
    def __init__(self, neo4j_config: Dict):
        super().__init__("Neo4j Performance")
        self.neo4j_config = neo4j_config
        self.driver = None
        
    async def setup(self):
        """Setup Neo4j connection"""
        self.driver = AsyncGraphDatabase.driver(
            self.neo4j_config['uri'],
            auth=(self.neo4j_config['user'], self.neo4j_config['password'])
        )
        
    async def teardown(self):
        """Cleanup"""
        if self.driver:
            await self.driver.close()
            
    async def test_graph_traversal_performance(self, iterations: int = 50):
        """Benchmark graph traversal operations"""
        logger.info(f"Running graph traversal benchmark ({iterations} iterations)")
        
        times = []
        async with self.driver.session() as session:
            for _ in range(iterations):
                start = time.time()
                result = await session.run("""
                    MATCH (bm:Orchestrator {name: 'Business Manager Agent'})
                    MATCH path = (bm)-[:MANAGES*]->(subordinate)
                    RETURN count(path) as pathCount
                """)
                await result.single()
                duration = (time.time() - start) * 1000
                times.append(duration)
                
        self.record_operation("graph_traversal", iterations, sum(times))
        return times
        
    async def test_pattern_matching_performance(self, iterations: int = 50):
        """Benchmark complex pattern matching"""
        logger.info(f"Running pattern matching benchmark ({iterations} iterations)")
        
        times = []
        async with self.driver.session() as session:
            for _ in range(iterations):
                start = time.time()
                result = await session.run("""
                    MATCH (a:Agent)-[:REPORTS_TO]->(d:Director)
                    WHERE d.department = 'Marketing'
                    WITH a, d
                    MATCH (a)-[:SPECIALIZES_IN]->(s:Skill)
                    RETURN a.name, collect(s.name) as skills
                    LIMIT 20
                """)
                await result.data()
                duration = (time.time() - start) * 1000
                times.append(duration)
                
        self.record_operation("pattern_matching", iterations, sum(times))
        return times
        
    async def test_shortest_path_performance(self, iterations: int = 50):
        """Benchmark shortest path calculations"""
        logger.info(f"Running shortest path benchmark ({iterations} iterations)")
        
        times = []
        async with self.driver.session() as session:
            for _ in range(iterations):
                start = time.time()
                result = await session.run("""
                    MATCH (start:Agent {name: 'Facebook Agent'})
                    MATCH (end:Orchestrator {name: 'Business Manager Agent'})
                    MATCH path = shortestPath((start)-[:REPORTS_TO*]-(end))
                    RETURN length(path) as pathLength
                """)
                await result.single()
                duration = (time.time() - start) * 1000
                times.append(duration)
                
        self.record_operation("shortest_path", iterations, sum(times))
        return times


class CachePerformanceTests(PerformanceBenchmark):
    """Performance tests for caching layer"""
    
    def __init__(self, redis_config: Dict):
        super().__init__("Cache Performance")
        self.redis_config = redis_config
        self.redis_client = None
        
    def setup(self):
        """Setup Redis connection"""
        self.redis_client = redis.Redis(**self.redis_config)
        
    def teardown(self):
        """Cleanup"""
        if self.redis_client:
            self.redis_client.close()
            
    def test_cache_operations(self, iterations: int = 1000):
        """Benchmark cache get/set operations"""
        logger.info(f"Running cache operations benchmark ({iterations} iterations)")
        
        # Test data
        test_data = {
            'agent_id': 'test-agent-123',
            'profile': {
                'name': 'Test Agent',
                'role': 'Test Role',
                'skills': ['skill1', 'skill2', 'skill3'],
                'metrics': {'tasks': 100, 'success_rate': 0.95}
            }
        }
        
        # Test SET operations
        set_times = []
        for i in range(iterations):
            key = f'test:agent:{i}'
            start = time.time()
            self.redis_client.setex(
                key, 
                300,  # 5 minute TTL
                json.dumps(test_data)
            )
            duration = (time.time() - start) * 1000
            set_times.append(duration)
            
        # Test GET operations
        get_times = []
        for i in range(iterations):
            key = f'test:agent:{i}'
            start = time.time()
            data = self.redis_client.get(key)
            if data:
                json.loads(data)
            duration = (time.time() - start) * 1000
            get_times.append(duration)
            
        # Cleanup
        pattern = 'test:agent:*'
        for key in self.redis_client.scan_iter(match=pattern):
            self.redis_client.delete(key)
            
        self.record_operation("cache_set", iterations, sum(set_times))
        self.record_operation("cache_get", iterations, sum(get_times))
        
        return set_times, get_times


class ConcurrentLoadTests(PerformanceBenchmark):
    """Concurrent load testing"""
    
    def __init__(self, db_config: Dict, neo4j_config: Dict):
        super().__init__("Concurrent Load Tests")
        self.db_config = db_config
        self.neo4j_config = neo4j_config
        
    def test_concurrent_database_load(self, num_workers: int = 10, operations_per_worker: int = 100):
        """Test database under concurrent load"""
        logger.info(f"Running concurrent database load test ({num_workers} workers)")
        
        def worker_task(worker_id: int) -> Tuple[int, float]:
            conn = psycopg2.connect(**self.db_config)
            cursor = conn.cursor()
            
            start_time = time.time()
            for i in range(operations_per_worker):
                # Mix of read and write operations
                if i % 5 == 0:
                    # Write operation
                    cursor.execute("""
                        INSERT INTO agent_performance_metrics 
                        (id, agent_id, metric_type, metric_value, period_start)
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT (id) DO UPDATE SET metric_value = EXCLUDED.metric_value
                    """, (
                        f'perf-{worker_id}-{i}',
                        'test-agent-1',
                        'concurrent_test',
                        np.random.randint(1, 100),
                        datetime.now()
                    ))
                else:
                    # Read operation
                    cursor.execute("""
                        SELECT COUNT(*) FROM agents WHERE is_director = true
                    """)
                    cursor.fetchone()
                    
            conn.commit()
            conn.close()
            
            return worker_id, time.time() - start_time
            
        # Run concurrent workers
        start_time = time.time()
        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            futures = [executor.submit(worker_task, i) for i in range(num_workers)]
            results = []
            for future in as_completed(futures):
                worker_id, duration = future.result()
                results.append(duration)
                
        total_duration = time.time() - start_time
        total_operations = num_workers * operations_per_worker
        
        self.record_operation(
            f"concurrent_db_{num_workers}_workers",
            total_operations,
            int(total_duration * 1000)
        )
        
        return results


class EndToEndPerformanceTests(PerformanceBenchmark):
    """End-to-end system performance tests"""
    
    def __init__(self, db_config: Dict, neo4j_config: Dict, redis_config: Dict):
        super().__init__("End-to-End Performance")
        self.db_config = db_config
        self.neo4j_config = neo4j_config
        self.redis_config = redis_config
        
    async def test_complete_agent_activation_flow(self, iterations: int = 50):
        """Test complete agent activation flow performance"""
        logger.info(f"Running agent activation flow benchmark ({iterations} iterations)")
        
        conn = psycopg2.connect(**self.db_config)
        cursor = conn.cursor()
        driver = AsyncGraphDatabase.driver(
            self.neo4j_config['uri'],
            auth=(self.neo4j_config['user'], self.neo4j_config['password'])
        )
        redis_client = redis.Redis(**self.redis_config)
        
        times = []
        for _ in range(iterations):
            start_time = time.time()
            
            # 1. Check activation pattern
            cursor.execute("""
                SELECT agent_id FROM activation_patterns
                WHERE pattern_type = 'keyword' 
                AND keywords && ARRAY['customer', 'help']
                LIMIT 5
            """)
            agent_ids = [row[0] for row in cursor.fetchall()]
            
            # 2. Get agent profiles (with cache check)
            profiles = []
            for agent_id in agent_ids:
                cache_key = f'agent:profile:{agent_id}'
                cached = redis_client.get(cache_key)
                
                if not cached:
                    cursor.execute("""
                        SELECT * FROM mv_agent_complete_profiles
                        WHERE id = %s
                    """, (agent_id,))
                    profile = cursor.fetchone()
                    redis_client.setex(cache_key, 300, json.dumps(profile))
                    profiles.append(profile)
                else:
                    profiles.append(json.loads(cached))
                    
            # 3. Check agent relationships in Neo4j
            async with driver.session() as session:
                for agent_id in agent_ids:
                    result = await session.run("""
                        MATCH (a:Agent {id: $agent_id})-[:REPORTS_TO]->(manager)
                        RETURN manager.id
                    """, agent_id=agent_id)
                    await result.single()
                    
            duration = (time.time() - start_time) * 1000
            times.append(duration)
            
        conn.close()
        await driver.close()
        redis_client.close()
        
        self.record_operation("agent_activation_flow", iterations, sum(times))
        return times


async def run_all_benchmarks():
    """Run all performance benchmarks"""
    # Configuration
    db_config = {
        'host': 'localhost',
        'port': 5432,
        'database': 'postgres',
        'user': 'postgres',
        'password': 'postgres'
    }
    
    neo4j_config = {
        'uri': 'bolt://localhost:7687',
        'user': 'neo4j',
        'password': 'password'
    }
    
    redis_config = {
        'host': 'localhost',
        'port': 6379,
        'db': 0
    }
    
    results = {}
    
    # Database Performance Tests
    db_tests = DatabasePerformanceTests(db_config)
    db_tests.setup()
    db_tests.test_agent_hierarchy_query(100)
    db_tests.test_materialized_view_performance(100)
    db_tests.test_embedding_search_performance(50)
    db_tests.test_bulk_insert_performance([10, 100, 1000])
    db_tests.teardown()
    results['database'] = db_tests.get_summary()
    
    # Neo4j Performance Tests
    neo4j_tests = Neo4jPerformanceTests(neo4j_config)
    await neo4j_tests.setup()
    await neo4j_tests.test_graph_traversal_performance(50)
    await neo4j_tests.test_pattern_matching_performance(50)
    await neo4j_tests.test_shortest_path_performance(50)
    await neo4j_tests.teardown()
    results['neo4j'] = neo4j_tests.get_summary()
    
    # Cache Performance Tests
    cache_tests = CachePerformanceTests(redis_config)
    cache_tests.setup()
    cache_tests.test_cache_operations(1000)
    cache_tests.teardown()
    results['cache'] = cache_tests.get_summary()
    
    # Concurrent Load Tests
    load_tests = ConcurrentLoadTests(db_config, neo4j_config)
    load_tests.test_concurrent_database_load(10, 100)
    results['concurrent'] = load_tests.get_summary()
    
    # End-to-End Tests
    e2e_tests = EndToEndPerformanceTests(db_config, neo4j_config, redis_config)
    await e2e_tests.test_complete_agent_activation_flow(50)
    results['end_to_end'] = e2e_tests.get_summary()
    
    # Print comprehensive report
    print("\n" + "="*80)
    print("PERFORMANCE BENCHMARK REPORT")
    print("="*80)
    
    for category, summary in results.items():
        print(f"\n{category.upper()} PERFORMANCE:")
        print("-" * 40)
        for key, value in summary.items():
            if isinstance(value, float):
                print(f"{key}: {value:.2f}")
            else:
                print(f"{key}: {value}")
    
    # Save detailed results
    with open('benchmark_results.json', 'w') as f:
        json.dump(results, f, indent=2, default=str)
        
    return results


if __name__ == "__main__":
    asyncio.run(run_all_benchmarks())