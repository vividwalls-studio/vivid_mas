#!/bin/bash
# Final insertion script

echo "Setting default values for JSONB columns..."
docker exec -i supabase-db psql -U postgres -d postgres << 'EOF'
UPDATE agents SET 
    short_term_memory = COALESCE(short_term_memory, '[]'::jsonb),
    long_term_memory = COALESCE(long_term_memory, '[]'::jsonb),
    communication_preferences = COALESCE(communication_preferences, '[]'::jsonb),
    episodic_memory = COALESCE(episodic_memory, '[]'::jsonb),
    procedural_memory = COALESCE(procedural_memory, '[]'::jsonb),
    semantic_memory = COALESCE(semantic_memory, '[]'::jsonb)
WHERE id IS NOT NULL;
EOF

echo "Running SQL chunks..."

echo "===== CHUNK 1 ====="
docker exec -i supabase-db psql -U postgres -d postgres < sql_chunks/chunk_001.sql

echo "===== CHUNK 2 ====="
docker exec -i supabase-db psql -U postgres -d postgres < sql_chunks/chunk_002.sql

echo "===== CHUNK 3 ====="
docker exec -i supabase-db psql -U postgres -d postgres < sql_chunks/chunk_003.sql

echo "===== CHUNK 4 ====="
docker exec -i supabase-db psql -U postgres -d postgres < sql_chunks/chunk_004.sql

echo "===== VERIFICATION ====="
docker exec -i supabase-db psql -U postgres -d postgres << 'EOF'
SELECT 'Total Agents:' as metric, COUNT(*) as count FROM agents
UNION ALL
SELECT 'With Beliefs:', COUNT(DISTINCT agent_id) FROM agent_beliefs
UNION ALL
SELECT 'With Goals:', COUNT(DISTINCT agent_id) FROM agent_goals
UNION ALL
SELECT 'With LLM Config:', COUNT(DISTINCT agent_id) FROM agent_llm_config;

SELECT id, name, role, type FROM agents LIMIT 5;
EOF