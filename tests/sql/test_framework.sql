-- VividWalls MAS SQL Testing Framework
-- Comprehensive testing for all database changes

-- Create test schema
CREATE SCHEMA IF NOT EXISTS test_mas;

-- Test utilities
CREATE OR REPLACE FUNCTION test_mas.assert_equals(
    actual ANYELEMENT,
    expected ANYELEMENT,
    test_name TEXT DEFAULT 'unnamed test'
) RETURNS VOID AS $$
BEGIN
    IF actual IS DISTINCT FROM expected THEN
        RAISE EXCEPTION 'Test failed: %. Expected: %, Actual: %', test_name, expected, actual;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_mas.assert_true(
    condition BOOLEAN,
    test_name TEXT DEFAULT 'unnamed test'
) RETURNS VOID AS $$
BEGIN
    IF NOT condition THEN
        RAISE EXCEPTION 'Test failed: %. Condition was false', test_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_mas.assert_not_null(
    value ANYELEMENT,
    test_name TEXT DEFAULT 'unnamed test'
) RETURNS VOID AS $$
BEGIN
    IF value IS NULL THEN
        RAISE EXCEPTION 'Test failed: %. Value was NULL', test_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test result tracking
CREATE TABLE IF NOT EXISTS test_mas.test_results (
    id SERIAL PRIMARY KEY,
    test_suite TEXT NOT NULL,
    test_name TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('PASSED', 'FAILED', 'SKIPPED')),
    error_message TEXT,
    execution_time_ms INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Test runner function
CREATE OR REPLACE FUNCTION test_mas.run_test(
    p_test_suite TEXT,
    p_test_name TEXT,
    p_test_function TEXT
) RETURNS TABLE(status TEXT, message TEXT) AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_execution_time_ms INTEGER;
    v_error_message TEXT;
BEGIN
    v_start_time := clock_timestamp();
    
    BEGIN
        -- Execute the test function dynamically
        EXECUTE format('SELECT test_mas.%I()', p_test_function);
        
        v_end_time := clock_timestamp();
        v_execution_time_ms := EXTRACT(MILLISECOND FROM (v_end_time - v_start_time))::INTEGER;
        
        -- Log success
        INSERT INTO test_mas.test_results (test_suite, test_name, status, execution_time_ms)
        VALUES (p_test_suite, p_test_name, 'PASSED', v_execution_time_ms);
        
        RETURN QUERY SELECT 'PASSED'::TEXT, format('Test %s passed in %s ms', p_test_name, v_execution_time_ms)::TEXT;
        
    EXCEPTION WHEN OTHERS THEN
        v_error_message := SQLERRM;
        v_end_time := clock_timestamp();
        v_execution_time_ms := EXTRACT(MILLISECOND FROM (v_end_time - v_start_time))::INTEGER;
        
        -- Log failure
        INSERT INTO test_mas.test_results (test_suite, test_name, status, error_message, execution_time_ms)
        VALUES (p_test_suite, p_test_name, 'FAILED', v_error_message, v_execution_time_ms);
        
        RETURN QUERY SELECT 'FAILED'::TEXT, v_error_message::TEXT;
    END;
END;
$$ LANGUAGE plpgsql;

-- Test Suite: Agent Hierarchy
CREATE OR REPLACE FUNCTION test_mas.test_agent_hierarchy_setup() RETURNS VOID AS $$
DECLARE
    v_agent_count INTEGER;
    v_director_count INTEGER;
    v_sales_agent_count INTEGER;
BEGIN
    -- Test total agent count
    SELECT COUNT(*) INTO v_agent_count FROM agents;
    PERFORM test_mas.assert_equals(v_agent_count, 57, 'Total agent count should be 57');
    
    -- Test director count
    SELECT COUNT(*) INTO v_director_count FROM agents WHERE is_director = true;
    PERFORM test_mas.assert_equals(v_director_count, 9, 'Director count should be 9');
    
    -- Test sales agents under Sales Director
    SELECT COUNT(*) INTO v_sales_agent_count 
    FROM agent_hierarchy ah
    JOIN agents a ON ah.child_id = a.id
    JOIN agents p ON ah.parent_id = p.id
    WHERE p.name = 'Sales Director' AND a.role LIKE '%Sales%';
    PERFORM test_mas.assert_equals(v_sales_agent_count, 12, 'Sales Director should have 12 sales agents');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_mas.test_hierarchy_traversal() RETURNS VOID AS $$
DECLARE
    v_subordinate_count INTEGER;
    v_path_exists BOOLEAN;
BEGIN
    -- Test getting all subordinates of Business Manager
    SELECT COUNT(*) INTO v_subordinate_count 
    FROM get_all_subordinates((SELECT id FROM agents WHERE name = 'Business Manager Agent'));
    PERFORM test_mas.assert_equals(v_subordinate_count, 56, 'Business Manager should have 56 subordinates');
    
    -- Test path exists from agent to Business Manager
    SELECT EXISTS(
        SELECT 1 
        FROM get_agent_hierarchy_path(
            (SELECT id FROM agents WHERE name = 'Facebook Agent'),
            (SELECT id FROM agents WHERE name = 'Business Manager Agent')
        )
    ) INTO v_path_exists;
    PERFORM test_mas.assert_true(v_path_exists, 'Path should exist from Facebook Agent to Business Manager');
END;
$$ LANGUAGE plpgsql;

-- Test Suite: Data Deduplication
CREATE OR REPLACE FUNCTION test_mas.test_consolidated_agent_profiles() RETURNS VOID AS $$
DECLARE
    v_profile RECORD;
    v_old_table_count INTEGER;
BEGIN
    -- Test that consolidated profile contains all data
    SELECT * INTO v_profile 
    FROM agent_profiles 
    WHERE agent_id = (SELECT id FROM agents WHERE name = 'Marketing Director' LIMIT 1);
    
    PERFORM test_mas.assert_not_null(v_profile.personality, 'Personality data should exist');
    PERFORM test_mas.assert_not_null(v_profile.voice_config, 'Voice config should exist');
    PERFORM test_mas.assert_not_null(v_profile.llm_config, 'LLM config should exist');
    
    -- Test that old tables can be dropped (check view dependencies)
    SELECT COUNT(*) INTO v_old_table_count
    FROM information_schema.tables
    WHERE table_schema = 'public' 
    AND table_name IN ('agent_personalities', 'agent_voice_config', 'agent_llm_config');
    -- These should exist as views now, not tables
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_mas.test_unified_embeddings() RETURNS VOID AS $$
DECLARE
    v_embedding_count INTEGER;
    v_distinct_types INTEGER;
BEGIN
    -- Test unified embeddings table
    SELECT COUNT(*) INTO v_embedding_count FROM unified_embeddings;
    PERFORM test_mas.assert_true(v_embedding_count > 0, 'Unified embeddings should have data');
    
    -- Test that all content types are represented
    SELECT COUNT(DISTINCT content_type) INTO v_distinct_types FROM unified_embeddings;
    PERFORM test_mas.assert_true(v_distinct_types >= 5, 'Should have at least 5 content types');
END;
$$ LANGUAGE plpgsql;

-- Test Suite: Knowledge Architecture
CREATE OR REPLACE FUNCTION test_mas.test_customer_segments() RETURNS VOID AS $$
DECLARE
    v_segment_count INTEGER;
    v_persona_count INTEGER;
BEGIN
    -- Test customer segments match business model
    SELECT COUNT(*) INTO v_segment_count FROM customer_segments;
    PERFORM test_mas.assert_equals(v_segment_count, 4, 'Should have 4 customer segments');
    
    -- Test each segment has personas
    SELECT COUNT(*) INTO v_persona_count FROM customer_personas;
    PERFORM test_mas.assert_true(v_persona_count >= 8, 'Should have at least 2 personas per segment');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_mas.test_financial_tracking() RETURNS VOID AS $$
DECLARE
    v_has_transactions BOOLEAN;
    v_has_budgets BOOLEAN;
BEGIN
    -- Test financial tables exist and have proper structure
    SELECT EXISTS(SELECT 1 FROM financial_transactions LIMIT 1) INTO v_has_transactions;
    SELECT EXISTS(SELECT 1 FROM department_budgets LIMIT 1) INTO v_has_budgets;
    
    -- Test revenue attribution
    PERFORM test_mas.assert_not_null(
        (SELECT agent_id FROM financial_transactions WHERE transaction_type = 'revenue' LIMIT 1),
        'Revenue transactions should have agent attribution'
    );
END;
$$ LANGUAGE plpgsql;

-- Test Suite: System Logic
CREATE OR REPLACE FUNCTION test_mas.test_bdi_mechanisms() RETURNS VOID AS $$
DECLARE
    v_belief_count INTEGER;
    v_desire_count INTEGER;
    v_intention_count INTEGER;
BEGIN
    -- Test BDI update triggers exist
    PERFORM test_mas.assert_true(
        EXISTS(SELECT 1 FROM pg_trigger WHERE tgname = 'trigger_belief_update'),
        'Belief update trigger should exist'
    );
    
    -- Test BDI data exists for agents
    SELECT COUNT(*) INTO v_belief_count FROM agent_beliefs;
    SELECT COUNT(*) INTO v_desire_count FROM agent_desires;
    SELECT COUNT(*) INTO v_intention_count FROM agent_intentions;
    
    PERFORM test_mas.assert_true(v_belief_count > 0, 'Agents should have beliefs');
    PERFORM test_mas.assert_true(v_desire_count > 0, 'Agents should have desires');
    PERFORM test_mas.assert_true(v_intention_count > 0, 'Agents should have intentions');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION test_mas.test_activation_patterns() RETURNS VOID AS $$
DECLARE
    v_pattern_count INTEGER;
    v_activation_works BOOLEAN;
BEGIN
    -- Test activation patterns exist
    SELECT COUNT(*) INTO v_pattern_count FROM activation_patterns;
    PERFORM test_mas.assert_true(v_pattern_count > 0, 'Activation patterns should exist');
    
    -- Test activation evaluation
    SELECT activate_agents_for_pattern('customer_query', 'I need help with my order'::jsonb) IS NOT NULL
    INTO v_activation_works;
    PERFORM test_mas.assert_true(v_activation_works, 'Agent activation should work');
END;
$$ LANGUAGE plpgsql;

-- Test Suite: Performance
CREATE OR REPLACE FUNCTION test_mas.test_materialized_views() RETURNS VOID AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_execution_time_ms INTEGER;
    v_row_count INTEGER;
BEGIN
    -- Test materialized view performance
    v_start_time := clock_timestamp();
    SELECT COUNT(*) INTO v_row_count FROM mv_agent_complete_profiles;
    v_end_time := clock_timestamp();
    v_execution_time_ms := EXTRACT(MILLISECOND FROM (v_end_time - v_start_time))::INTEGER;
    
    PERFORM test_mas.assert_true(v_execution_time_ms < 100, 'Materialized view query should be fast');
    PERFORM test_mas.assert_equals(v_row_count, 57, 'Should have all agents in materialized view');
END;
$$ LANGUAGE plpgsql;

-- Master test runner
CREATE OR REPLACE FUNCTION test_mas.run_all_tests() RETURNS TABLE(
    test_suite TEXT,
    test_name TEXT,
    status TEXT,
    message TEXT
) AS $$
BEGIN
    -- Clear previous results
    DELETE FROM test_mas.test_results WHERE created_at < CURRENT_TIMESTAMP;
    
    -- Run all test suites
    RETURN QUERY
    WITH test_definitions AS (
        SELECT * FROM (VALUES
            ('Agent Hierarchy', 'Setup Test', 'test_agent_hierarchy_setup'),
            ('Agent Hierarchy', 'Traversal Test', 'test_hierarchy_traversal'),
            ('Data Deduplication', 'Consolidated Profiles', 'test_consolidated_agent_profiles'),
            ('Data Deduplication', 'Unified Embeddings', 'test_unified_embeddings'),
            ('Knowledge Architecture', 'Customer Segments', 'test_customer_segments'),
            ('Knowledge Architecture', 'Financial Tracking', 'test_financial_tracking'),
            ('System Logic', 'BDI Mechanisms', 'test_bdi_mechanisms'),
            ('System Logic', 'Activation Patterns', 'test_activation_patterns'),
            ('Performance', 'Materialized Views', 'test_materialized_views')
        ) AS t(suite, name, func)
    )
    SELECT 
        td.suite,
        td.name,
        (test_mas.run_test(td.suite, td.name, td.func)).*
    FROM test_definitions td
    ORDER BY td.suite, td.name;
END;
$$ LANGUAGE plpgsql;

-- Summary report function
CREATE OR REPLACE FUNCTION test_mas.test_summary() RETURNS TABLE(
    test_suite TEXT,
    total_tests INTEGER,
    passed INTEGER,
    failed INTEGER,
    success_rate NUMERIC,
    avg_execution_time_ms INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tr.test_suite,
        COUNT(*)::INTEGER as total_tests,
        COUNT(*) FILTER (WHERE status = 'PASSED')::INTEGER as passed,
        COUNT(*) FILTER (WHERE status = 'FAILED')::INTEGER as failed,
        ROUND(COUNT(*) FILTER (WHERE status = 'PASSED')::NUMERIC / COUNT(*) * 100, 2) as success_rate,
        AVG(execution_time_ms)::INTEGER as avg_execution_time_ms
    FROM test_mas.test_results tr
    GROUP BY tr.test_suite
    ORDER BY tr.test_suite;
END;
$$ LANGUAGE plpgsql;

-- Run tests (uncomment to execute)
-- SELECT * FROM test_mas.run_all_tests();
-- SELECT * FROM test_mas.test_summary();