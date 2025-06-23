# Final Guide: Inserting Agent Data into Supabase

## Summary of the Situation

We have successfully converted your SQL INSERT statements into PostgREST-compatible JSON format. The data is ready in the `mcp_conversion/` directory with:
- 30 agents 
- 600 total records across 10 tables
- Proper foreign key relationships maintained

However, the MCP server appears to have configuration issues (returning 404 errors).

## Your Options for Data Insertion

### Option 1: Supabase Dashboard (Simplest)
Execute the original SQL chunks directly:

1. Go to https://supabase.vividwalls.blog
2. Navigate to SQL Editor
3. Execute these files in order:
   - `sql_chunks/chunk_001.sql`
   - `sql_chunks/chunk_002.sql`
   - `sql_chunks/chunk_003.sql`
   - `sql_chunks/chunk_004.sql`

### Option 2: Python Script with Supabase Client

1. Install the Supabase Python client:
   ```bash
   pip install supabase
   ```

2. Set your credentials:
   ```bash
   export SUPABASE_URL='https://supabase.vividwalls.blog'
   export SUPABASE_KEY='your-anon-key-here'
   ```

3. Run the population script:
   ```bash
   python scripts/populate_agents_postgrest.py
   ```

### Option 3: Direct PostgREST API Calls

Use the generated curl commands:

```bash
# Make the script executable
chmod +x test_postgrest_curl.sh

# Set your Supabase key
export SUPABASE_KEY='your-anon-key-here'

# Test the connection
./test_postgrest_curl.sh
```

### Option 4: Create an RPC Function

1. First, create the bulk insert function in Supabase:
   - Execute `scripts/create_bulk_insert_function.sql` in SQL Editor

2. Then use the RPC approach:
   ```bash
   python scripts/populate_via_rpc.py
   ```

## Data Structure

The converted data is organized as follows:

```
mcp_conversion/
├── agents.json                    # 30 agents
├── agent_beliefs.json            # 90 beliefs
├── agent_desires.json            # 90 desires
├── agent_intentions.json         # 90 intentions
├── agent_heuristic_imperatives.json # 90 imperatives
├── agent_domain_knowledge.json   # 30 knowledge entries
├── agent_personalities.json      # 30 personality profiles
├── agent_goals.json             # 90 goals
├── agent_llm_config.json        # 30 LLM configurations
├── agent_voice_config.json      # 30 voice configurations
├── mcp_commands.json            # MCP tool commands
└── conversion_summary.json      # Summary of conversion
```

## Verification

After insertion, verify the data:

```sql
-- Check agent count
SELECT COUNT(*) FROM agents;
-- Expected: 30

-- Check all tables
SELECT 
    'agents' as table_name, COUNT(*) as count FROM agents
UNION ALL
SELECT 'agent_beliefs', COUNT(*) FROM agent_beliefs
UNION ALL
SELECT 'agent_desires', COUNT(*) FROM agent_desires
UNION ALL
SELECT 'agent_intentions', COUNT(*) FROM agent_intentions;

-- List all agents
SELECT id, name, role FROM agents ORDER BY name;
```

## Troubleshooting

### If MCP Server Returns 404:
- The MCP server configuration might be incorrect
- Check if the Supabase URL is correct
- Verify the API keys are properly set

### If PostgREST Returns Errors:
- Check if tables exist (run schema creation first)
- Verify foreign key constraints
- Ensure UUID format is correct

### If Python Scripts Fail:
- Install required dependencies: `pip install supabase`
- Check environment variables are set
- Verify network connectivity to Supabase

## Next Steps

1. Choose your preferred method above
2. Execute the data insertion
3. Verify in Supabase dashboard
4. Configure the MCP server properly for future use

The data has been prepared in multiple formats to ensure you can successfully populate your database regardless of the MCP server issues.