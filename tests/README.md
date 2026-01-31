# VividWalls MAS Test Suite

Comprehensive testing framework for validating all improvements to the VividWalls Multi-Agent System.

## Test Categories

### 1. SQL Tests (`tests/sql/test_framework.sql`)
- **Agent Hierarchy**: Validates 57-agent structure with proper relationships
- **Data Deduplication**: Tests consolidated schemas and views
- **Knowledge Architecture**: Verifies customer segments, financial tracking
- **System Logic**: Tests BDI mechanisms, activation patterns
- **Performance**: Validates materialized views and query optimization

### 2. Neo4j Tests (`tests/neo4j/test_framework.cypher`)
- **Graph Structure**: Validates nodes and relationships
- **Hierarchy Traversal**: Tests path queries and shortest paths
- **Specialized Personas**: Verifies persona-director relationships
- **Product Knowledge**: Tests product graph relationships
- **Performance Metrics**: Validates metrics tracking

### 3. Integration Tests (`tests/integration/test_cross_system_sync.py`)
- **Agent Synchronization**: Tests Supabase ↔ Neo4j sync
- **Performance Metrics Sync**: Validates cross-system metrics
- **Data Consistency**: Verifies data integrity across systems
- **Transaction Management**: Tests distributed transactions

### 4. Performance Benchmarks (`tests/performance/benchmark_tests.py`)
- **Database Performance**: Query optimization benchmarks
- **Neo4j Traversal**: Graph query performance
- **Cache Operations**: Redis performance testing
- **Concurrent Load**: Multi-user stress testing
- **End-to-End Flows**: Complete workflow performance

## Running Tests

### Local Development

```bash
# Run all tests
./tests/run_tests_locally.sh

# Run specific test category
./tests/run_tests_locally.sh sql
./tests/run_tests_locally.sh neo4j
./tests/run_tests_locally.sh integration
./tests/run_tests_locally.sh performance
```

### CI/CD Pipeline

Tests run automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual workflow dispatch

### GitHub Actions Workflow

The `.github/workflows/test-mas-improvements.yml` workflow:
1. Sets up test databases (PostgreSQL, Neo4j, Redis)
2. Runs all test suites in parallel
3. Generates test reports and artifacts
4. Posts performance results to PRs
5. Creates test summary in GitHub

## Test Environment

### Docker Services

The `tests/docker-compose.test.yml` provides:
- **PostgreSQL 15**: Port 5433
- **Neo4j 5.17**: Ports 7475 (HTTP), 7688 (Bolt)
- **Redis 7**: Port 6380

### Python Requirements

Install test dependencies:
```bash
pip install -r tests/requirements.txt
```

## Test Results

### SQL Test Output
```sql
-- Run all tests
SELECT * FROM test_mas.run_all_tests();

-- View summary
SELECT * FROM test_mas.test_summary();
```

### Neo4j Test Output
```cypher
// Run all tests
CALL test.runAllTests();

// View summary
CALL test.summary();
```

### Performance Benchmarks

Results saved to `benchmark_results.json`:
```json
{
  "database": {
    "avg_ops_per_second": 1250.5,
    "p95_duration_ms": 15.2
  },
  "neo4j": {
    "graph_traversal": {
      "ops_per_second": 850.3
    }
  }
}
```

## Writing New Tests

### SQL Tests
```sql
CREATE OR REPLACE FUNCTION test_mas.test_new_feature() RETURNS VOID AS $$
BEGIN
    -- Your test logic
    PERFORM test_mas.assert_equals(actual, expected, 'Test name');
END;
$$ LANGUAGE plpgsql;
```

### Neo4j Tests
```cypher
CALL apoc.custom.declareProcedure(
  'test.newFeature() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  'Your Cypher test logic here',
  'read'
);
```

### Integration Tests
```python
class TestNewFeature(IntegrationTestFramework):
    async def test_feature(self):
        # Your test logic
        self.assert_equal(actual, expected, "Test name")
```

## Troubleshooting

### Common Issues

1. **Services not starting**: Check Docker daemon is running
2. **Port conflicts**: Ensure test ports (5433, 7475, 7688, 6380) are free
3. **Permission errors**: Run with appropriate Docker permissions
4. **Test failures**: Check logs in test artifacts

### Debug Mode

Enable verbose output:
```bash
PYTEST_VERBOSE=1 ./tests/run_tests_locally.sh
```

### Clean Up

Remove test containers and data:
```bash
docker-compose -f tests/docker-compose.test.yml down -v
```

## Contributing

When adding new features:
1. Write tests FIRST (TDD approach)
2. Ensure all tests pass locally
3. Add performance benchmarks for new queries
4. Update this README with new test documentation