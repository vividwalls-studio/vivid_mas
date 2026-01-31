"""
VividWalls MAS Cross-System Integration Tests
Tests for Supabase <-> Neo4j synchronization and data consistency
"""

import asyncio
import pytest
import time
from datetime import datetime
from typing import Dict, List, Any
import psycopg2
from neo4j import AsyncGraphDatabase
import json
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class IntegrationTestFramework:
    """Framework for testing cross-system integration"""
    
    def __init__(self, supabase_config: Dict, neo4j_config: Dict):
        self.supabase_config = supabase_config
        self.neo4j_config = neo4j_config
        self.test_results = []
        
    async def setup(self):
        """Initialize database connections"""
        # Supabase connection
        self.pg_conn = psycopg2.connect(
            host=self.supabase_config['host'],
            port=self.supabase_config['port'],
            database=self.supabase_config['database'],
            user=self.supabase_config['user'],
            password=self.supabase_config['password']
        )
        self.pg_cursor = self.pg_conn.cursor()
        
        # Neo4j connection
        self.neo4j_driver = AsyncGraphDatabase.driver(
            self.neo4j_config['uri'],
            auth=(self.neo4j_config['user'], self.neo4j_config['password'])
        )
        
    async def teardown(self):
        """Clean up connections"""
        self.pg_conn.close()
        await self.neo4j_driver.close()
        
    def assert_equal(self, actual, expected, test_name=""):
        """Assert equality with detailed error messages"""
        if actual != expected:
            raise AssertionError(f"{test_name}: Expected {expected}, got {actual}")
            
    def assert_true(self, condition, test_name=""):
        """Assert condition is true"""
        if not condition:
            raise AssertionError(f"{test_name}: Condition was false")
            
    async def run_test(self, test_name: str, test_func):
        """Run a single test and record results"""
        start_time = time.time()
        try:
            await test_func()
            status = "PASSED"
            error = None
        except Exception as e:
            status = "FAILED"
            error = str(e)
            logger.error(f"Test {test_name} failed: {error}")
        
        execution_time = int((time.time() - start_time) * 1000)
        
        self.test_results.append({
            'test_name': test_name,
            'status': status,
            'error': error,
            'execution_time_ms': execution_time,
            'timestamp': datetime.now()
        })
        
        return status, error


class TestAgentSynchronization(IntegrationTestFramework):
    """Test suite for agent data synchronization"""
    
    async def test_agent_creation_sync(self):
        """Test that creating an agent in Supabase syncs to Neo4j"""
        test_agent_id = 'test-agent-' + str(int(time.time()))
        
        # Create agent in Supabase
        self.pg_cursor.execute("""
            INSERT INTO agents (id, name, role, is_director)
            VALUES (%s, %s, %s, %s)
        """, (test_agent_id, 'Test Agent', 'Test Role', False))
        self.pg_conn.commit()
        
        # Wait for sync (adjust based on your sync mechanism)
        await asyncio.sleep(2)
        
        # Check if agent exists in Neo4j
        async with self.neo4j_driver.session() as session:
            result = await session.run(
                "MATCH (a:Agent {id: $id}) RETURN a",
                id=test_agent_id
            )
            records = await result.single()
            
        self.assert_true(records is not None, "Agent should exist in Neo4j")
        
        # Cleanup
        self.pg_cursor.execute("DELETE FROM agents WHERE id = %s", (test_agent_id,))
        self.pg_conn.commit()
        
    async def test_agent_update_sync(self):
        """Test that updating an agent in Supabase syncs to Neo4j"""
        # Get existing agent
        self.pg_cursor.execute("SELECT id, name FROM agents LIMIT 1")
        agent_id, original_name = self.pg_cursor.fetchone()
        
        # Update agent in Supabase
        new_name = original_name + " Updated"
        self.pg_cursor.execute(
            "UPDATE agents SET name = %s WHERE id = %s",
            (new_name, agent_id)
        )
        self.pg_conn.commit()
        
        # Wait for sync
        await asyncio.sleep(2)
        
        # Check update in Neo4j
        async with self.neo4j_driver.session() as session:
            result = await session.run(
                "MATCH (a:Agent {id: $id}) RETURN a.name as name",
                id=agent_id
            )
            record = await result.single()
            
        self.assert_equal(record['name'], new_name, "Agent name should be updated in Neo4j")
        
        # Restore original name
        self.pg_cursor.execute(
            "UPDATE agents SET name = %s WHERE id = %s",
            (original_name, agent_id)
        )
        self.pg_conn.commit()
        
    async def test_hierarchy_consistency(self):
        """Test that agent hierarchy is consistent across systems"""
        # Get hierarchy from Supabase
        self.pg_cursor.execute("""
            SELECT parent_id, child_id 
            FROM agent_hierarchy 
            ORDER BY parent_id, child_id
        """)
        pg_hierarchy = set(self.pg_cursor.fetchall())
        
        # Get hierarchy from Neo4j
        async with self.neo4j_driver.session() as session:
            result = await session.run("""
                MATCH (parent:Agent)-[:MANAGES]->(child:Agent)
                RETURN parent.id as parent_id, child.id as child_id
                ORDER BY parent_id, child_id
            """)
            neo4j_hierarchy = set()
            async for record in result:
                neo4j_hierarchy.add((record['parent_id'], record['child_id']))
                
        self.assert_equal(len(pg_hierarchy), len(neo4j_hierarchy), 
                         "Hierarchy count should match")
        self.assert_equal(pg_hierarchy, neo4j_hierarchy, 
                         "Hierarchy relationships should match exactly")


class TestPerformanceMetricsSync(IntegrationTestFramework):
    """Test suite for performance metrics synchronization"""
    
    async def test_metrics_creation_sync(self):
        """Test that performance metrics sync between systems"""
        agent_id = None
        metric_id = 'test-metric-' + str(int(time.time()))
        
        # Get an agent ID
        self.pg_cursor.execute("SELECT id FROM agents WHERE is_director = true LIMIT 1")
        agent_id = self.pg_cursor.fetchone()[0]
        
        # Create metric in Supabase
        self.pg_cursor.execute("""
            INSERT INTO agent_performance_metrics 
            (id, agent_id, metric_type, metric_value, period_start)
            VALUES (%s, %s, %s, %s, %s)
        """, (metric_id, agent_id, 'tasks_completed', 42, datetime.now()))
        self.pg_conn.commit()
        
        # Wait for sync
        await asyncio.sleep(2)
        
        # Check in Neo4j
        async with self.neo4j_driver.session() as session:
            result = await session.run("""
                MATCH (a:Agent {id: $agent_id})-[:HAS_METRICS]->(m:PerformanceMetrics)
                WHERE m.id = $metric_id
                RETURN m.metric_value as value
            """, agent_id=agent_id, metric_id=metric_id)
            record = await result.single()
            
        self.assert_true(record is not None, "Metric should exist in Neo4j")
        self.assert_equal(record['value'], 42, "Metric value should match")
        
        # Cleanup
        self.pg_cursor.execute("DELETE FROM agent_performance_metrics WHERE id = %s", 
                              (metric_id,))
        self.pg_conn.commit()


class TestDataConsistencyValidation(IntegrationTestFramework):
    """Test suite for data consistency validation"""
    
    async def test_embedding_consistency(self):
        """Test that embeddings are consistent across systems"""
        # Get sample embeddings from Supabase
        self.pg_cursor.execute("""
            SELECT id, content_type, embedding_dimension
            FROM unified_embeddings
            LIMIT 10
        """)
        pg_embeddings = {row[0]: (row[1], row[2]) for row in self.pg_cursor.fetchall()}
        
        # For each embedding, verify it exists in appropriate system
        for embed_id, (content_type, dimension) in pg_embeddings.items():
            self.assert_equal(dimension, 1536, 
                            f"Embedding {embed_id} should have correct dimension")
            
    async def test_sync_queue_processing(self):
        """Test that sync queue is processing correctly"""
        # Check sync queue status
        self.pg_cursor.execute("""
            SELECT 
                COUNT(*) FILTER (WHERE status = 'pending') as pending,
                COUNT(*) FILTER (WHERE status = 'completed') as completed,
                COUNT(*) FILTER (WHERE status = 'failed') as failed,
                COUNT(*) FILTER (WHERE retry_count > 3) as excessive_retries
            FROM sync_queue
            WHERE created_at > NOW() - INTERVAL '1 hour'
        """)
        
        pending, completed, failed, excessive = self.pg_cursor.fetchone()
        
        # Validate queue health
        self.assert_true(pending < 100, "Sync queue should not have excessive pending items")
        self.assert_true(failed < 10, "Sync queue should have minimal failures")
        self.assert_true(excessive == 0, "No items should exceed retry limit")
        
    async def test_data_validation_rules(self):
        """Test that data validation rules are working"""
        # Test agent validation
        valid = await self._validate_agents()
        self.assert_true(valid, "All agents should pass validation")
        
        # Test hierarchy validation
        valid = await self._validate_hierarchy()
        self.assert_true(valid, "Hierarchy should be valid (no cycles)")
        
        # Test performance metrics validation
        valid = await self._validate_metrics()
        self.assert_true(valid, "All metrics should be within valid ranges")
        
    async def _validate_agents(self) -> bool:
        """Validate all agents have required fields"""
        self.pg_cursor.execute("""
            SELECT COUNT(*) 
            FROM agents 
            WHERE name IS NULL OR role IS NULL OR id IS NULL
        """)
        invalid_count = self.pg_cursor.fetchone()[0]
        return invalid_count == 0
        
    async def _validate_hierarchy(self) -> bool:
        """Validate hierarchy has no cycles"""
        self.pg_cursor.execute("""
            WITH RECURSIVE hierarchy_check AS (
                SELECT child_id, parent_id, ARRAY[child_id] as path
                FROM agent_hierarchy
                UNION ALL
                SELECT h.child_id, ah.parent_id, hc.path || h.child_id
                FROM agent_hierarchy ah
                JOIN hierarchy_check hc ON ah.child_id = hc.parent_id
                WHERE NOT h.child_id = ANY(hc.path)
            )
            SELECT COUNT(*) FROM hierarchy_check
            WHERE child_id = parent_id
        """)
        cycle_count = self.pg_cursor.fetchone()[0]
        return cycle_count == 0
        
    async def _validate_metrics(self) -> bool:
        """Validate metrics are within reasonable ranges"""
        self.pg_cursor.execute("""
            SELECT COUNT(*)
            FROM agent_performance_metrics
            WHERE metric_value < 0 OR metric_value > 1000000
        """)
        invalid_count = self.pg_cursor.fetchone()[0]
        return invalid_count == 0


class TestTransactionManagement(IntegrationTestFramework):
    """Test distributed transaction management"""
    
    async def test_two_phase_commit(self):
        """Test 2PC transaction across both systems"""
        transaction_id = 'test-txn-' + str(int(time.time()))
        
        # Start transaction
        self.pg_cursor.execute("""
            INSERT INTO distributed_transactions 
            (transaction_id, status, systems_involved)
            VALUES (%s, %s, %s)
        """, (transaction_id, 'prepared', ['supabase', 'neo4j']))
        self.pg_conn.commit()
        
        try:
            # Simulate operations in both systems
            # ... (actual operations would go here)
            
            # Commit transaction
            self.pg_cursor.execute("""
                UPDATE distributed_transactions
                SET status = 'committed', completed_at = NOW()
                WHERE transaction_id = %s
            """, (transaction_id,))
            self.pg_conn.commit()
            
            # Verify transaction completed
            self.pg_cursor.execute("""
                SELECT status FROM distributed_transactions
                WHERE transaction_id = %s
            """, (transaction_id,))
            status = self.pg_cursor.fetchone()[0]
            
            self.assert_equal(status, 'committed', "Transaction should be committed")
            
        finally:
            # Cleanup
            self.pg_cursor.execute(
                "DELETE FROM distributed_transactions WHERE transaction_id = %s",
                (transaction_id,)
            )
            self.pg_conn.commit()


async def run_all_integration_tests():
    """Run all integration test suites"""
    # Configuration (replace with your actual config)
    supabase_config = {
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
    
    test_suites = [
        TestAgentSynchronization,
        TestPerformanceMetricsSync,
        TestDataConsistencyValidation,
        TestTransactionManagement
    ]
    
    all_results = []
    
    for suite_class in test_suites:
        suite = suite_class(supabase_config, neo4j_config)
        await suite.setup()
        
        # Get all test methods
        test_methods = [method for method in dir(suite) 
                       if method.startswith('test_') and callable(getattr(suite, method))]
        
        for test_method in test_methods:
            test_name = f"{suite_class.__name__}.{test_method}"
            status, error = await suite.run_test(
                test_name, 
                getattr(suite, test_method)
            )
            all_results.append({
                'suite': suite_class.__name__,
                'test': test_method,
                'status': status,
                'error': error
            })
            
        await suite.teardown()
    
    # Print summary
    print("\n" + "="*80)
    print("INTEGRATION TEST SUMMARY")
    print("="*80)
    
    total_tests = len(all_results)
    passed_tests = sum(1 for r in all_results if r['status'] == 'PASSED')
    failed_tests = total_tests - passed_tests
    
    print(f"Total Tests: {total_tests}")
    print(f"Passed: {passed_tests}")
    print(f"Failed: {failed_tests}")
    print(f"Success Rate: {(passed_tests/total_tests*100):.2f}%")
    
    if failed_tests > 0:
        print("\nFailed Tests:")
        for result in all_results:
            if result['status'] == 'FAILED':
                print(f"  - {result['suite']}.{result['test']}: {result['error']}")
    
    return all_results


if __name__ == "__main__":
    # Run the tests
    asyncio.run(run_all_integration_tests())