# Working with Supabase PostgREST API

## Understanding PostgREST Limitations

Supabase uses PostgREST to provide a RESTful API interface to PostgreSQL. This means:

### What PostgREST CAN do:
- **CRUD Operations** on tables (CREATE, READ, UPDATE, DELETE)
- **Bulk inserts** via arrays in POST requests
- **Filtering** with various operators (eq, gt, lt, like, etc.)
- **Sorting and pagination**
- **Calling stored procedures** via RPC
- **Querying views** as if they were tables
- **Basic joins** via foreign key relationships

### What PostgREST CANNOT do:
- Execute arbitrary SQL queries
- Run DDL commands (CREATE TABLE, ALTER TABLE, etc.)
- Execute complex multi-statement transactions
- Perform complex JOINs beyond foreign keys
- Run administrative commands

## Solutions for Complex Operations

### 1. Use RPC (Remote Procedure Calls)

Create PostgreSQL functions and call them via RPC:

```sql
-- In Supabase SQL Editor
CREATE OR REPLACE FUNCTION my_complex_operation(param1 TEXT, param2 INTEGER)
RETURNS JSON
LANGUAGE plpgsql
AS $$
BEGIN
    -- Your complex SQL logic here
    RETURN json_build_object('success', true, 'result', 'data');
END;
$$;
```

```python
# Call via Python client
result = supabase.rpc('my_complex_operation', {
    'param1': 'value',
    'param2': 42
}).execute()
```

### 2. Use Database Views

Create views for complex queries:

```sql
-- In Supabase SQL Editor
CREATE VIEW agent_summary AS
SELECT 
    a.id,
    a.name,
    COUNT(DISTINCT ab.belief) as belief_count,
    COUNT(DISTINCT ad.desire) as desire_count
FROM agents a
LEFT JOIN agent_beliefs ab ON a.id = ab.agent_id
LEFT JOIN agent_desires ad ON a.id = ad.agent_id
GROUP BY a.id, a.name;
```

```python
# Query the view like a table
result = supabase.table('agent_summary').select('*').execute()
```

### 3. Bulk Operations

PostgREST supports efficient bulk operations:

```python
# Bulk insert
agents = [
    {'name': 'Agent1', 'role': 'Role1'},
    {'name': 'Agent2', 'role': 'Role2'},
    # ... up to thousands of records
]
result = supabase.table('agents').insert(agents).execute()

# Bulk update with filter
result = supabase.table('agents') \
    .update({'status': 'active'}) \
    .eq('department', 'sales') \
    .execute()

# Bulk delete
result = supabase.table('old_records') \
    .delete() \
    .lt('created_at', '2023-01-01') \
    .execute()
```

### 4. Working with the MCP Server

The Supabase MCP server provides these tools:

- **check-connection**: Verify database connectivity
- **query-table**: SELECT with filters
- **insert-data**: INSERT single or multiple records
- **update-data**: UPDATE with match conditions
- **delete-data**: DELETE with match conditions

## Best Practices

### 1. Use Transactions via RPC

Since PostgREST doesn't support multi-statement transactions, wrap complex operations in functions:

```sql
CREATE OR REPLACE FUNCTION create_agent_with_config(
    agent_data JSONB,
    config_data JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    v_agent_id UUID;
BEGIN
    -- Insert agent
    INSERT INTO agents (name, role)
    VALUES (
        agent_data->>'name',
        agent_data->>'role'
    )
    RETURNING id INTO v_agent_id;
    
    -- Insert config
    INSERT INTO agent_config (agent_id, config)
    VALUES (v_agent_id, config_data);
    
    RETURN jsonb_build_object(
        'success', true,
        'agent_id', v_agent_id
    );
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'success', false,
        'error', SQLERRM
    );
END;
$$;
```

### 2. Optimize Bulk Inserts

For large datasets:

```python
def insert_in_chunks(supabase, table, data, chunk_size=1000):
    """Insert data in chunks to avoid timeouts."""
    for i in range(0, len(data), chunk_size):
        chunk = data[i:i + chunk_size]
        supabase.table(table).insert(chunk).execute()
        print(f"Inserted chunk {i//chunk_size + 1}")
```

### 3. Use Proper Filtering

PostgREST supports various operators:

```python
# Equals
.eq('column', 'value')

# Not equals
.neq('column', 'value')

# Greater than / Less than
.gt('age', 18)
.lt('price', 100)

# LIKE pattern matching
.like('name', '%john%')

# IN operator
.in_('status', ['active', 'pending'])

# IS NULL
.is_('deleted_at', 'null')

# Multiple conditions
.eq('status', 'active').gt('score', 80)
```

### 4. Handle Errors Gracefully

```python
try:
    result = supabase.table('agents').insert(data).execute()
except Exception as e:
    if 'duplicate key' in str(e):
        # Handle unique constraint violation
        pass
    elif 'foreign key' in str(e):
        # Handle foreign key constraint
        pass
    else:
        # Handle other errors
        raise
```

## Migration Path

If you need to execute complex SQL:

1. **Development**: Use Supabase SQL Editor
2. **Production**: Create database migrations
3. **Runtime**: Use RPC functions for complex operations
4. **Maintenance**: Use database views for complex queries

## Resources

- [PostgREST Documentation](https://postgrest.org/en/stable/)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [Supabase Python Client](https://supabase.com/docs/reference/python/introduction)
- [PostgREST Operators](https://postgrest.org/en/stable/references/api/tables_views.html#operators)