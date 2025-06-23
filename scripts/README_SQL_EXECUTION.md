# SQL Execution Instructions

The complete SQL script has been split into 4 manageable chunks located in the `sql_chunks/` directory.

## Option 1: Execute via Supabase Web Interface

1. Go to your Supabase dashboard at https://supabase.vividwalls.blog
2. Navigate to the SQL Editor
3. Execute each chunk in order:
   - chunk_001.sql - Clears existing data and inserts agents
   - chunk_002.sql - Continues agent insertions and starts BDI components
   - chunk_003.sql - Completes BDI components and adds configurations
   - chunk_004.sql - Final configurations and relationships

## Option 2: Execute All at Once

If your SQL editor can handle large files:
1. Open `scripts/populate_mas_complete.sql` in the Supabase SQL editor
2. Execute the entire script

## Important Notes:

- The script includes a transaction (BEGIN/COMMIT) to ensure data integrity
- It will DELETE all existing agent data before inserting new data
- If you want to preserve existing data, comment out the DELETE statements
- The script populates 30 agents with complete configurations including:
  - 8 Director-level agents (Core department)
  - 3 Marketing task agents
  - 19 Operational task agents

## Verification

After execution, you can verify the data was inserted by running:

```sql
SELECT COUNT(*) as agent_count FROM agents;
-- Should return 30

SELECT name, role FROM agents ORDER BY name;
-- Should list all 30 agents
```