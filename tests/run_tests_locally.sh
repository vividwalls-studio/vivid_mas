#!/bin/bash

# VividWalls MAS Local Test Runner
# Run all tests locally with Docker

set -e

echo "======================================"
echo "VividWalls MAS Test Suite"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse command line arguments
TEST_TYPE="${1:-all}"

echo -e "${YELLOW}Starting test environment...${NC}"

# Start test containers
docker-compose -f tests/docker-compose.test.yml up -d

# Wait for services to be ready
echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Function to check service health
check_service() {
    local service=$1
    local check_cmd=$2
    
    echo -n "Checking $service... "
    if eval $check_cmd; then
        echo -e "${GREEN}Ready${NC}"
        return 0
    else
        echo -e "${RED}Not ready${NC}"
        return 1
    fi
}

# Check all services
check_service "PostgreSQL" "docker exec vivid-test-postgres pg_isready -U postgres"
check_service "Neo4j" "curl -s http://localhost:7475 > /dev/null"
check_service "Redis" "docker exec vivid-test-redis redis-cli ping > /dev/null"

# Run SQL Tests
if [[ "$TEST_TYPE" == "all" || "$TEST_TYPE" == "sql" ]]; then
    echo -e "\n${YELLOW}Running SQL Tests...${NC}"
    
    # Apply migrations
    for file in scripts/*.sql; do
        if [ -f "$file" ]; then
            echo "Applying $file..."
            docker exec -i vivid-test-postgres psql -U postgres -d vivid_mas_test < "$file"
        fi
    done
    
    # Load test framework
    docker exec -i vivid-test-postgres psql -U postgres -d vivid_mas_test < tests/sql/test_framework.sql
    
    # Run tests
    docker exec vivid-test-postgres psql -U postgres -d vivid_mas_test -c "SELECT * FROM test_mas.run_all_tests();"
    
    # Show summary
    echo -e "\n${YELLOW}SQL Test Summary:${NC}"
    docker exec vivid-test-postgres psql -U postgres -d vivid_mas_test -c "SELECT * FROM test_mas.test_summary();"
fi

# Run Neo4j Tests
if [[ "$TEST_TYPE" == "all" || "$TEST_TYPE" == "neo4j" ]]; then
    echo -e "\n${YELLOW}Running Neo4j Tests...${NC}"
    
    # Apply schemas
    for file in scripts/*.cypher; do
        if [ -f "$file" ]; then
            echo "Applying $file..."
            docker exec -i vivid-test-neo4j cypher-shell -u neo4j -p password < "$file"
        fi
    done
    
    # Load test framework
    docker exec -i vivid-test-neo4j cypher-shell -u neo4j -p password < tests/neo4j/test_framework.cypher
    
    # Run tests
    docker exec vivid-test-neo4j cypher-shell -u neo4j -p password \
        "CALL test.runAllTests() YIELD suite, testName, status, message RETURN suite, testName, status, message"
    
    # Show summary
    echo -e "\n${YELLOW}Neo4j Test Summary:${NC}"
    docker exec vivid-test-neo4j cypher-shell -u neo4j -p password \
        "CALL test.summary() YIELD suite, totalTests, passed, failed, successRate RETURN suite, totalTests, passed, failed, successRate"
fi

# Run Integration Tests
if [[ "$TEST_TYPE" == "all" || "$TEST_TYPE" == "integration" ]]; then
    echo -e "\n${YELLOW}Running Integration Tests...${NC}"
    
    # Install Python dependencies if needed
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        source venv/bin/activate
        pip install -r tests/requirements.txt
    else
        source venv/bin/activate
    fi
    
    # Run integration tests
    POSTGRES_HOST=localhost POSTGRES_PORT=5433 \
    NEO4J_URI=bolt://localhost:7688 \
    REDIS_HOST=localhost REDIS_PORT=6380 \
    python -m pytest tests/integration/test_cross_system_sync.py -v
fi

# Run Performance Tests
if [[ "$TEST_TYPE" == "all" || "$TEST_TYPE" == "performance" ]]; then
    echo -e "\n${YELLOW}Running Performance Benchmarks...${NC}"
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Run benchmarks
    POSTGRES_HOST=localhost POSTGRES_PORT=5433 \
    NEO4J_URI=bolt://localhost:7688 \
    REDIS_HOST=localhost REDIS_PORT=6380 \
    python tests/performance/benchmark_tests.py
    
    # Show results
    if [ -f "benchmark_results.json" ]; then
        echo -e "\n${YELLOW}Performance Results:${NC}"
        python -c "
import json
with open('benchmark_results.json', 'r') as f:
    results = json.load(f)
    for category, summary in results.items():
        print(f'\n{category.upper()}:')
        for key, value in summary.items():
            if isinstance(value, (int, float)):
                print(f'  {key}: {value:.2f}')
            else:
                print(f'  {key}: {value}')
        "
    fi
fi

# Cleanup option
echo -e "\n${YELLOW}Test run complete!${NC}"
read -p "Do you want to stop and remove test containers? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose -f tests/docker-compose.test.yml down -v
    echo -e "${GREEN}Test environment cleaned up.${NC}"
else
    echo -e "${YELLOW}Test containers are still running. To stop them later, run:${NC}"
    echo "docker-compose -f tests/docker-compose.test.yml down -v"
fi