// VividWalls MAS Neo4j Testing Framework
// Comprehensive testing for graph database changes

// Create test utilities as stored procedures
CALL apoc.custom.declareProcedure(
  'test.assertEquals(actual :: ANY?, expected :: ANY?, testName :: STRING?) :: (success :: BOOLEAN?, message :: STRING?)',
  'RETURN $actual = $expected AS success, 
   CASE WHEN $actual = $expected 
        THEN "Test passed: " + $testName
        ELSE "Test failed: " + $testName + ". Expected: " + toString($expected) + ", Actual: " + toString($actual)
   END AS message',
  'read'
);

CALL apoc.custom.declareProcedure(
  'test.assertTrue(condition :: BOOLEAN?, testName :: STRING?) :: (success :: BOOLEAN?, message :: STRING?)',
  'RETURN $condition AS success,
   CASE WHEN $condition
        THEN "Test passed: " + $testName
        ELSE "Test failed: " + $testName + ". Condition was false"
   END AS message',
  'read'
);

CALL apoc.custom.declareProcedure(
  'test.assertNotNull(value :: ANY?, testName :: STRING?) :: (success :: BOOLEAN?, message :: STRING?)',
  'RETURN $value IS NOT NULL AS success,
   CASE WHEN $value IS NOT NULL
        THEN "Test passed: " + $testName
        ELSE "Test failed: " + $testName + ". Value was NULL"
   END AS message',
  'read'
);

// Test result storage
CREATE CONSTRAINT test_result_id IF NOT EXISTS ON (tr:TestResult) ASSERT tr.id IS UNIQUE;

// Test Suite 1: Agent Hierarchy Tests
CALL apoc.custom.declareProcedure(
  'test.agentHierarchySetup() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  '
  // Test total agent count
  MATCH (a:Agent) 
  WITH count(a) as agentCount
  CALL test.assertEquals(agentCount, 57, "Total agent count") YIELD success, message
  WITH collect({test: "Total agent count", success: success, message: message}) as results
  
  // Test director count
  MATCH (d:Director)
  WITH results, count(d) as directorCount
  CALL test.assertEquals(directorCount, 9, "Director count") YIELD success, message
  WITH results + [{test: "Director count", success: success, message: message}] as results
  
  // Test Sales Director subordinates
  MATCH (sd:Director {name: "Sales Director"})-[:MANAGES]->(sa:Agent)
  WHERE sa.role CONTAINS "Sales"
  WITH results, count(sa) as salesAgentCount
  CALL test.assertEquals(salesAgentCount, 12, "Sales Director agents") YIELD success, message
  WITH results + [{test: "Sales Director agents", success: success, message: message}] as results
  
  // Return all results
  UNWIND results as result
  RETURN result.test as testName, 
         CASE WHEN result.success THEN "PASSED" ELSE "FAILED" END as status,
         result.message as message
  ',
  'read'
);

CALL apoc.custom.declareProcedure(
  'test.hierarchyTraversal() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  '
  // Test Business Manager subordinates
  MATCH (bm:Orchestrator {name: "Business Manager Agent"})
  MATCH path = (bm)-[:MANAGES*]->(subordinate)
  WITH count(DISTINCT subordinate) as subordinateCount
  CALL test.assertEquals(subordinateCount, 56, "Business Manager subordinates") YIELD success, message
  WITH collect({test: "Business Manager subordinates", success: success, message: message}) as results
  
  // Test path from Facebook Agent to Business Manager
  MATCH (fb:Agent {name: "Facebook Agent"})
  MATCH (bm:Orchestrator {name: "Business Manager Agent"})
  WITH results, EXISTS((fb)-[:REPORTS_TO*]->(bm)) as pathExists
  CALL test.assertTrue(pathExists, "Path from Facebook to Business Manager") YIELD success, message
  WITH results + [{test: "Path exists", success: success, message: message}] as results
  
  // Test department structure
  MATCH (dept:Department)
  WITH results, count(DISTINCT dept) as deptCount
  CALL test.assertEquals(deptCount, 8, "Department count") YIELD success, message
  WITH results + [{test: "Department count", success: success, message: message}] as results
  
  UNWIND results as result
  RETURN result.test as testName,
         CASE WHEN result.success THEN "PASSED" ELSE "FAILED" END as status,
         result.message as message
  ',
  'read'
);

// Test Suite 2: Specialized Personas Tests
CALL apoc.custom.declareProcedure(
  'test.specializedPersonas() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  '
  // Test persona creation
  MATCH (p:SpecializedPersona)
  WITH count(p) as personaCount
  CALL test.assertTrue(personaCount > 0, "Personas exist") YIELD success, message
  WITH collect({test: "Personas exist", success: success, message: message}) as results
  
  // Test persona relationships
  MATCH (d:Director)-[:EMBEDDED_IN]->(p:SpecializedPersona)
  WITH results, count(DISTINCT d) as directorsWithPersonas
  CALL test.assertTrue(directorsWithPersonas > 0, "Directors have personas") YIELD success, message
  WITH results + [{test: "Director personas", success: success, message: message}] as results
  
  // Test persona knowledge
  MATCH (p:SpecializedPersona)-[:USES_KNOWLEDGE]->(k:PersonaKnowledge)
  WITH results, count(DISTINCT p) as personasWithKnowledge
  CALL test.assertTrue(personasWithKnowledge > 0, "Personas have knowledge") YIELD success, message
  WITH results + [{test: "Persona knowledge", success: success, message: message}] as results
  
  UNWIND results as result
  RETURN result.test as testName,
         CASE WHEN result.success THEN "PASSED" ELSE "FAILED" END as status,
         result.message as message
  ',
  'read'
);

// Test Suite 3: Product Knowledge Graph Tests
CALL apoc.custom.declareProcedure(
  'test.productKnowledgeGraph() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  '
  // Test product nodes
  MATCH (p:Product)
  WITH count(p) as productCount
  CALL test.assertTrue(productCount > 0, "Products exist") YIELD success, message
  WITH collect({test: "Products exist", success: success, message: message}) as results
  
  // Test product relationships
  MATCH (p:Product)-[r:EXHIBITS|SUGGESTS|SUITABLE_FOR]->(c)
  WITH results, count(DISTINCT type(r)) as relationshipTypes
  CALL test.assertTrue(relationshipTypes >= 3, "Product relationships") YIELD success, message
  WITH results + [{test: "Product relationships", success: success, message: message}] as results
  
  // Test style hierarchies
  MATCH (s:Style)-[:IS_SUBTYPE_OF*]->(parent:Style)
  WITH results, count(DISTINCT s) as styleHierarchyCount
  CALL test.assertTrue(styleHierarchyCount > 0, "Style hierarchies") YIELD success, message
  WITH results + [{test: "Style hierarchies", success: success, message: message}] as results
  
  UNWIND results as result
  RETURN result.test as testName,
         CASE WHEN result.success THEN "PASSED" ELSE "FAILED" END as status,
         result.message as message
  ',
  'read'
);

// Test Suite 4: Performance Metrics Tests
CALL apoc.custom.declareProcedure(
  'test.performanceMetrics() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  '
  // Test metrics nodes
  MATCH (m:PerformanceMetrics)
  WITH count(m) as metricsCount
  CALL test.assertTrue(metricsCount >= 0, "Performance metrics structure") YIELD success, message
  WITH collect({test: "Metrics structure", success: success, message: message}) as results
  
  // Test agent-metrics relationships
  MATCH (a:Agent)-[:HAS_METRICS]->(m:PerformanceMetrics)
  WITH results, count(DISTINCT a) as agentsWithMetrics
  CALL test.assertTrue(agentsWithMetrics >= 0, "Agent metrics relationships") YIELD success, message
  WITH results + [{test: "Agent metrics", success: success, message: message}] as results
  
  UNWIND results as result
  RETURN result.test as testName,
         CASE WHEN result.success THEN "PASSED" ELSE "FAILED" END as status,
         result.message as message
  ',
  'read'
);

// Test Suite 5: Activation Patterns Tests
CALL apoc.custom.declareProcedure(
  'test.activationPatterns() :: (testName :: STRING?, status :: STRING?, message :: STRING?)',
  '
  // Test activation patterns exist
  MATCH (ap:ActivationPattern)
  WITH count(ap) as patternCount
  CALL test.assertTrue(patternCount > 0, "Activation patterns exist") YIELD success, message
  WITH collect({test: "Patterns exist", success: success, message: message}) as results
  
  // Test pattern relationships
  MATCH (p:SpecializedPersona)-[:ACTIVATED_BY]->(ap:ActivationPattern)
  WITH results, count(DISTINCT p) as activatedPersonas
  CALL test.assertTrue(activatedPersonas > 0, "Personas have activation patterns") YIELD success, message
  WITH results + [{test: "Pattern relationships", success: success, message: message}] as results
  
  UNWIND results as result
  RETURN result.test as testName,
         CASE WHEN result.success THEN "PASSED" ELSE "FAILED" END as status,
         result.message as message
  ',
  'read'
);

// Master test runner
CALL apoc.custom.declareProcedure(
  'test.runAllTests() :: (suite :: STRING?, testName :: STRING?, status :: STRING?, message :: STRING?, executionTime :: INTEGER?)',
  '
  WITH timestamp() as startTime
  
  // Run all test suites
  CALL test.agentHierarchySetup() YIELD testName, status, message
  WITH collect({suite: "Agent Hierarchy", test: testName, status: status, message: message}) as results, startTime
  
  CALL test.hierarchyTraversal() YIELD testName, status, message
  WITH results + collect({suite: "Agent Hierarchy", test: testName, status: status, message: message}) as allResults, startTime
  
  CALL test.specializedPersonas() YIELD testName, status, message
  WITH allResults + collect({suite: "Specialized Personas", test: testName, status: status, message: message}) as allResults, startTime
  
  CALL test.productKnowledgeGraph() YIELD testName, status, message
  WITH allResults + collect({suite: "Product Knowledge", test: testName, status: status, message: message}) as allResults, startTime
  
  CALL test.performanceMetrics() YIELD testName, status, message
  WITH allResults + collect({suite: "Performance Metrics", test: testName, status: status, message: message}) as allResults, startTime
  
  CALL test.activationPatterns() YIELD testName, status, message
  WITH allResults + collect({suite: "Activation Patterns", test: testName, status: status, message: message}) as allResults, startTime
  
  // Store results and return
  UNWIND allResults as result
  CREATE (tr:TestResult {
    id: randomUUID(),
    suite: result.suite,
    testName: result.test,
    status: result.status,
    message: result.message,
    executionTime: timestamp() - startTime,
    timestamp: datetime()
  })
  RETURN result.suite as suite,
         result.test as testName,
         result.status as status,
         result.message as message,
         timestamp() - startTime as executionTime
  ',
  'write'
);

// Test summary procedure
CALL apoc.custom.declareProcedure(
  'test.summary() :: (suite :: STRING?, totalTests :: INTEGER?, passed :: INTEGER?, failed :: INTEGER?, successRate :: FLOAT?, avgExecutionTime :: INTEGER?)',
  '
  MATCH (tr:TestResult)
  WITH tr.suite as suite,
       count(*) as totalTests,
       sum(CASE WHEN tr.status = "PASSED" THEN 1 ELSE 0 END) as passed,
       sum(CASE WHEN tr.status = "FAILED" THEN 1 ELSE 0 END) as failed,
       avg(tr.executionTime) as avgTime
  RETURN suite,
         totalTests,
         passed,
         failed,
         toFloat(passed) / totalTests * 100 as successRate,
         toInteger(avgTime) as avgExecutionTime
  ORDER BY suite
  ',
  'read'
);

// Performance benchmark tests
CALL apoc.custom.declareProcedure(
  'test.performanceBenchmark() :: (operation :: STRING?, recordCount :: INTEGER?, executionTime :: INTEGER?, opsPerSecond :: FLOAT?)',
  '
  // Test 1: Hierarchy traversal performance
  WITH timestamp() as start1
  MATCH (bm:Orchestrator {name: "Business Manager Agent"})
  MATCH path = (bm)-[:MANAGES*]->(subordinate)
  WITH count(path) as pathCount, timestamp() - start1 as time1
  WITH collect({op: "Hierarchy traversal", count: pathCount, time: time1}) as results
  
  // Test 2: Persona activation lookup
  WITH results, timestamp() as start2
  MATCH (ap:ActivationPattern)-[:ACTIVATED_BY]-(p:SpecializedPersona)
  WHERE ap.keywords CONTAINS "customer"
  WITH results, count(p) as activationCount, timestamp() - start2 as time2
  WITH results + [{op: "Activation lookup", count: activationCount, time: time2}] as results
  
  // Test 3: Product relationship query
  WITH results, timestamp() as start3
  MATCH (p:Product)-[r]->(related)
  WHERE p.category = "Abstract Art"
  WITH results, count(r) as relCount, timestamp() - start3 as time3
  WITH results + [{op: "Product relationships", count: relCount, time: time3}] as results
  
  UNWIND results as result
  RETURN result.op as operation,
         result.count as recordCount,
         result.time as executionTime,
         toFloat(result.count) / (toFloat(result.time) / 1000) as opsPerSecond
  ',
  'read'
);

// Cleanup test results
CALL apoc.custom.declareProcedure(
  'test.cleanup() :: (message :: STRING?)',
  '
  MATCH (tr:TestResult)
  WITH count(tr) as deletedCount
  DETACH DELETE tr
  RETURN "Deleted " + deletedCount + " test results" as message
  ',
  'write'
);

// Usage:
// CALL test.runAllTests();
// CALL test.summary();
// CALL test.performanceBenchmark();
// CALL test.cleanup();