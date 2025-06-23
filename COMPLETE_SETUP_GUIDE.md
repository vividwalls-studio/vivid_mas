# Complete Setup Guide: Database Schema and Agent Data

## Overview

This guide will walk you through setting up your Multi-Agent System in Supabase from start to finish.

## Step 1: Create the Database Schema

### Option A: Via Supabase Dashboard (Recommended)

1. Go to https://supabase.vividwalls.blog
2. Navigate to **SQL Editor**
3. Copy and paste the contents of `scripts/create_mas_schema.sql`
4. Click **Run** to execute

This will create:
- 16 tables for the agent system
- Proper foreign key relationships
- Indexes for performance
- UUID generation support

### Option B: Via Supabase CLI

```bash
# Install Supabase CLI if not already installed
brew install supabase/tap/supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run the schema
supabase db push < scripts/create_mas_schema.sql
```

## Step 2: Verify Schema Creation

Run this query in the SQL Editor to verify:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'agent%'
ORDER BY table_name;
```

You should see 16 tables starting with "agent".

## Step 3: Get Your API Keys

1. In Supabase Dashboard, go to **Settings > API**
2. Copy the **anon public** key
3. Copy the **URL**

## Step 4: Set Environment Variables

```bash
export SUPABASE_URL='https://supabase.vividwalls.blog'
export SUPABASE_ANON_KEY='your-anon-key-here'
```

## Step 5: Test PostgREST Connection

```bash
# Run the connection test
./scripts/test_postgrest_connection.sh
```

## Step 6: Insert Agent Data

### Option A: Using PostgREST Direct (Recommended)

```bash
# This script will insert all agent data
./scripts/postgrest_direct_insert.sh
```

### Option B: Using Python Script

```bash
# Install dependencies
pip install requests

# Run the insertion
python scripts/postgrest_http_insert.py
```

### Option C: Manual SQL in Dashboard

Execute these files in order:
1. `sql_chunks/chunk_001.sql`
2. `sql_chunks/chunk_002.sql`
3. `sql_chunks/chunk_003.sql`
4. `sql_chunks/chunk_004.sql`

## Step 7: Verify Data Insertion

Run these queries to verify:

```sql
-- Count agents
SELECT COUNT(*) as agent_count FROM agents;
-- Expected: 30

-- View all agents
SELECT id, name, role FROM agents ORDER BY name;

-- Check all tables
SELECT 
    'agents' as table_name, COUNT(*) as count FROM agents
UNION ALL
    SELECT 'agent_beliefs', COUNT(*) FROM agent_beliefs
UNION ALL
    SELECT 'agent_desires', COUNT(*) FROM agent_desires
UNION ALL
    SELECT 'agent_intentions', COUNT(*) FROM agent_intentions
UNION ALL
    SELECT 'agent_goals', COUNT(*) FROM agent_goals
UNION ALL
    SELECT 'agent_personalities', COUNT(*) FROM agent_personalities
UNION ALL
    SELECT 'agent_llm_config', COUNT(*) FROM agent_llm_config
ORDER BY table_name;
```

## File Structure

```
vivid_mas/
├── scripts/
│   ├── create_mas_schema.sql           # Database schema
│   ├── populate_mas_complete.sql       # Original SQL with INSERT statements
│   ├── test_postgrest_connection.sh    # Test connectivity
│   ├── postgrest_direct_insert.sh      # Shell script for insertion
│   └── postgrest_http_insert.py        # Python script for insertion
├── mcp_conversion/
│   ├── agents.json                     # 30 agents
│   ├── agent_beliefs.json              # 90 beliefs
│   ├── agent_desires.json              # 90 desires
│   ├── agent_intentions.json           # 90 intentions
│   └── ... (other table data)
└── sql_chunks/
    ├── chunk_001.sql                   # SQL split for manual execution
    ├── chunk_002.sql
    ├── chunk_003.sql
    └── chunk_004.sql
```

## Troubleshooting

### If PostgREST returns 404:
- Ensure tables exist (run schema creation first)
- Check if URL is correct
- Verify API key is valid

### If insertion fails:
- Check foreign key constraints (agents must be inserted first)
- Verify UUID format
- Ensure no duplicate IDs

### If MCP server fails:
- Use PostgREST directly instead
- Check MCP server configuration
- Verify Supabase connection details

## Next Steps

Once your data is loaded:

1. **Configure MCP Server**: Update the Supabase MCP server configuration with correct credentials
2. **Test Agent Queries**: Use the MCP tools to query and interact with agents
3. **Build Your Application**: Use the agent data for your multi-agent system

## Support

- Supabase Documentation: https://supabase.com/docs
- PostgREST Documentation: https://postgrest.org/en/stable/
- MCP Documentation: https://modelcontextprotocol.io/