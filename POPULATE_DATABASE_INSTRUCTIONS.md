# Database Population Instructions

The agent data has been successfully extracted and prepared for insertion into your Supabase database. Due to MCP server limitations, you'll need to use one of these methods:

## Option 1: Supabase Dashboard (Recommended)

1. **Open your Supabase Dashboard**: https://supabase.vividwalls.blog
2. **Navigate to the SQL Editor**
3. **Execute the SQL chunks in order**:
   - `sql_chunks/chunk_001.sql` (743 lines) - Clears data and begins agent insertion
   - `sql_chunks/chunk_002.sql` (801 lines) - Continues agent and BDI insertions
   - `sql_chunks/chunk_003.sql` (550 lines) - Completes BDI and adds configurations
   - `sql_chunks/chunk_004.sql` (300 lines) - Final configurations

## Option 2: Python Script with Supabase Client

Create a Python script using the Supabase Python client:

```python
from supabase import create_client
import json
import os

# Initialize Supabase client
SUPABASE_URL = "your-supabase-url"
SUPABASE_KEY = "your-supabase-key"
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Load and insert data
data_dir = "mcp_data"
tables = ["agents", "agent_beliefs", "agent_desires", "agent_intentions", 
          "agent_heuristic_imperatives", "agent_domain_knowledge", 
          "agent_personalities", "agent_goals", "agent_llm_config", 
          "agent_voice_config"]

for table in tables:
    file_path = os.path.join(data_dir, f"{table}.json")
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            data = json.load(f)
        
        # Insert data
        result = supabase.table(table).insert(data).execute()
        print(f"Inserted {len(data)} records into {table}")
```

## Data Summary

- **Total Agents**: 29 (missing 1 - AnalyticsDirectorAgent)
- **Total Records**: 592 across 10 tables
- **Data Location**: `mcp_data/` directory with JSON files for each table

## Verification

After insertion, verify the data:

```sql
-- Check agent count
SELECT COUNT(*) FROM agents;
-- Expected: 29 (or 30 if AnalyticsDirectorAgent is added)

-- List all agents
SELECT id, name, role FROM agents ORDER BY name;

-- Check related data
SELECT table_name, count(*) 
FROM (
    SELECT 'agent_beliefs' as table_name, COUNT(*) as count FROM agent_beliefs
    UNION ALL
    SELECT 'agent_desires', COUNT(*) FROM agent_desires
    UNION ALL
    SELECT 'agent_intentions', COUNT(*) FROM agent_intentions
    -- Add other tables as needed
) counts;
```

## Notes

- The MCP Supabase server doesn't support raw SQL execution
- It's limited to basic CRUD operations through its API
- For bulk operations or schema changes, use the Supabase Dashboard
- The extracted JSON files can be used with any Supabase client library