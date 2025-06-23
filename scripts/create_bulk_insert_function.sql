-- PostgreSQL function for bulk agent insertion via PostgREST RPC
-- This function can be called through Supabase's RPC endpoint

CREATE OR REPLACE FUNCTION bulk_insert_agents(agent_data JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSONB;
    v_agent_count INTEGER := 0;
    v_total_records INTEGER := 0;
    v_errors JSONB := '[]'::JSONB;
BEGIN
    -- Start transaction
    BEGIN
        -- Insert agents
        IF agent_data ? 'agents' THEN
            INSERT INTO agents (id, name, role, backstory, short_term_memory, long_term_memory, episodic_memory)
            SELECT 
                (value->>'id')::UUID,
                value->>'name',
                value->>'role',
                value->>'backstory',
                value->>'short_term_memory',
                value->>'long_term_memory',
                value->>'episodic_memory'
            FROM jsonb_array_elements(agent_data->'agents') AS value
            ON CONFLICT (id) DO NOTHING;
            
            GET DIAGNOSTICS v_agent_count = ROW_COUNT;
            v_total_records := v_total_records + v_agent_count;
        END IF;
        
        -- Insert beliefs
        IF agent_data ? 'agent_beliefs' THEN
            INSERT INTO agent_beliefs (agent_id, belief)
            SELECT 
                (value->>'agent_id')::UUID,
                value->>'belief'
            FROM jsonb_array_elements(agent_data->'agent_beliefs') AS value
            WHERE EXISTS (SELECT 1 FROM agents WHERE id = (value->>'agent_id')::UUID)
            ON CONFLICT DO NOTHING;
            
            v_total_records := v_total_records + (SELECT COUNT(*) FROM jsonb_array_elements(agent_data->'agent_beliefs'));
        END IF;
        
        -- Insert desires
        IF agent_data ? 'agent_desires' THEN
            INSERT INTO agent_desires (agent_id, desire)
            SELECT 
                (value->>'agent_id')::UUID,
                value->>'desire'
            FROM jsonb_array_elements(agent_data->'agent_desires') AS value
            WHERE EXISTS (SELECT 1 FROM agents WHERE id = (value->>'agent_id')::UUID)
            ON CONFLICT DO NOTHING;
            
            v_total_records := v_total_records + (SELECT COUNT(*) FROM jsonb_array_elements(agent_data->'agent_desires'));
        END IF;
        
        -- Insert intentions
        IF agent_data ? 'agent_intentions' THEN
            INSERT INTO agent_intentions (agent_id, intention)
            SELECT 
                (value->>'agent_id')::UUID,
                value->>'intention'
            FROM jsonb_array_elements(agent_data->'agent_intentions') AS value
            WHERE EXISTS (SELECT 1 FROM agents WHERE id = (value->>'agent_id')::UUID)
            ON CONFLICT DO NOTHING;
            
            v_total_records := v_total_records + (SELECT COUNT(*) FROM jsonb_array_elements(agent_data->'agent_intentions'));
        END IF;
        
        -- Add more table inserts as needed...
        
        -- Build result
        v_result := jsonb_build_object(
            'success', true,
            'agents_inserted', v_agent_count,
            'total_records', v_total_records,
            'message', format('Successfully inserted %s agents and %s total records', v_agent_count, v_total_records)
        );
        
    EXCEPTION WHEN OTHERS THEN
        -- Rollback happens automatically
        v_result := jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'message', 'Bulk insert failed - all changes rolled back'
        );
    END;
    
    RETURN v_result;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION bulk_insert_agents(JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION bulk_insert_agents(JSONB) TO service_role;

-- Example usage via PostgREST/Supabase:
-- POST to: https://your-project.supabase.co/rest/v1/rpc/bulk_insert_agents
-- Body: {
--   "agent_data": {
--     "agents": [...],
--     "agent_beliefs": [...],
--     "agent_desires": [...]
--   }
-- }