#!/bin/bash
# Comprehensive PostgREST operations via SSH/curl
# Based on https://postgrest.org/en/stable/references/api/

# Configuration
SUPABASE_URL="${SUPABASE_URL:-https://supabase.vividwalls.blog}"
SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

echo "PostgREST API Operations Guide"
echo "=============================="
echo ""

# 1. BULK INSERT - Insert multiple records at once
echo "1. BULK INSERT - Insert all agents at once"
echo "==========================================="
echo "curl -X POST \\"
echo "  '${SUPABASE_URL}/rest/v1/agents' \\"
echo "  -H 'apikey: ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Authorization: Bearer ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Prefer: return=minimal' \\"
echo "  -d @mcp_conversion/agents.json"
echo ""

# 2. UPSERT - Insert or update on conflict
echo "2. UPSERT - Insert or update if exists"
echo "======================================"
echo "curl -X POST \\"
echo "  '${SUPABASE_URL}/rest/v1/agents?on_conflict=id' \\"
echo "  -H 'apikey: ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Authorization: Bearer ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Prefer: resolution=merge-duplicates' \\"
echo "  -d @mcp_conversion/agents.json"
echo ""

# 3. Query with filters
echo "3. QUERY - Get agents with filters"
echo "=================================="
echo "# Get all directors"
echo "curl -X GET \\"
echo "  '${SUPABASE_URL}/rest/v1/agents?role=like.*Director*&select=id,name,role' \\"
echo "  -H 'apikey: ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Authorization: Bearer ${SUPABASE_ANON_KEY}'"
echo ""

# 4. RPC Functions
echo "4. RPC - Call stored procedures"
echo "==============================="
echo "# If you have a bulk_insert_agents function:"
echo "curl -X POST \\"
echo "  '${SUPABASE_URL}/rest/v1/rpc/bulk_insert_agents' \\"
echo "  -H 'apikey: ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Authorization: Bearer ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"agent_data\": {...}}'"
echo ""

# 5. Transaction-like operations
echo "5. TRANSACTION-LIKE - Multiple operations"
echo "========================================="
echo "# PostgREST doesn't support true transactions, but you can:"
echo "# a) Use RPC functions with BEGIN/COMMIT"
echo "# b) Use upsert with on_conflict"
echo "# c) Design idempotent operations"
echo ""

# Create a function to execute all insertions
cat << 'EOF' > postgrest_insert_all.sh
#!/bin/bash
# Execute all table insertions in order

SUPABASE_URL="${SUPABASE_URL:-https://supabase.vividwalls.blog}"
SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

# Function to insert and report
insert_data() {
    local table=$1
    local file=$2
    
    echo "Inserting into $table..."
    
    curl -X POST \
        "${SUPABASE_URL}/rest/v1/${table}" \
        -H "apikey: ${SUPABASE_ANON_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=minimal" \
        -d @"${file}" \
        -s -o /dev/null -w "HTTP Status: %{http_code}\n"
}

# Insert in dependency order
insert_data "agents" "mcp_conversion/agents.json"
sleep 1
insert_data "agent_beliefs" "mcp_conversion/agent_beliefs.json"
sleep 1
insert_data "agent_desires" "mcp_conversion/agent_desires.json"
sleep 1
insert_data "agent_intentions" "mcp_conversion/agent_intentions.json"
sleep 1
insert_data "agent_heuristic_imperatives" "mcp_conversion/agent_heuristic_imperatives.json"
sleep 1
insert_data "agent_domain_knowledge" "mcp_conversion/agent_domain_knowledge.json"
sleep 1
insert_data "agent_personalities" "mcp_conversion/agent_personalities.json"
sleep 1
insert_data "agent_goals" "mcp_conversion/agent_goals.json"
sleep 1
insert_data "agent_llm_config" "mcp_conversion/agent_llm_config.json"
sleep 1
insert_data "agent_voice_config" "mcp_conversion/agent_voice_config.json"

echo "All insertions complete!"
EOF

chmod +x postgrest_insert_all.sh

echo "6. USING SSH TO EXECUTE"
echo "======================="
echo "# If you have SSH access to a server:"
echo "ssh user@server 'cd /path/to/project && ./postgrest_insert_all.sh'"
echo ""
echo "# Or copy files and execute:"
echo "scp -r mcp_conversion/ user@server:/tmp/"
echo "scp postgrest_insert_all.sh user@server:/tmp/"
echo "ssh user@server 'cd /tmp && ./postgrest_insert_all.sh'"
echo ""

echo "7. VERIFY INSERTION"
echo "==================="
echo "# Count all agents"
echo "curl -X GET \\"
echo "  '${SUPABASE_URL}/rest/v1/agents?select=count' \\"
echo "  -H 'apikey: ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Authorization: Bearer ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Prefer: count=exact' \\"
echo "  -H 'Range: 0-0'"
echo ""

echo "Files created:"
echo "- postgrest_insert_all.sh - Execute all insertions"
echo "- postgrest_direct_insert.sh - Interactive insertion script"
echo ""
echo "Next steps:"
echo "1. Set your API key: export SUPABASE_ANON_KEY='your-key'"
echo "2. Run: ./postgrest_direct_insert.sh"
echo "3. Or use individual curl commands above"