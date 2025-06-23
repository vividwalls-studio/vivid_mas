# Enhanced Supabase MCP Server

An enhanced Model Context Protocol (MCP) server for Supabase with SQL execution capabilities.

## Features

### Core Database Operations
- **check-connection**: Test connection to Supabase
- **query-table**: Query data from tables with filtering and limits
- **insert-data**: Insert new records into tables
- **update-data**: Update existing records
- **delete-data**: Delete records from tables

### SQL Execution (NEW)
- **execute-sql**: Execute raw SQL queries directly on the database
- **list-tables**: List all tables in a schema
- **describe-table**: Get detailed table structure information

### Resources
- Access table schemas and sample data
- Browse complete database schema

### Prompts
- **query-builder**: Generate Supabase query code
- **schema-design**: Design database schemas
- **migration-script**: Create migration scripts
- **sql-query**: Generate SQL from natural language

## Installation

```bash
# Install dependencies
npm install

# Build the TypeScript source
npm run build
```

## Configuration

Create a `.env` file with your Supabase credentials:

```env
# Required
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key

# Optional - for admin operations
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Required for SQL execution
SUPABASE_DB_URL=postgresql://user:password@host:port/database
```

### Getting the Database URL

You can find your database URL in the Supabase dashboard:
1. Go to Settings → Database
2. Find the Connection String section
3. Copy the URI (make sure to use the correct password)

## Usage

### With Claude Desktop

Add to your Claude Desktop configuration:

```json
{
  "mcpServers": {
    "supabase": {
      "command": "node",
      "args": ["/path/to/supabase-mcp-server/build/index.js"],
      "env": {
        "SUPABASE_URL": "https://your-project.supabase.co",
        "SUPABASE_KEY": "your-anon-key",
        "SUPABASE_SERVICE_ROLE_KEY": "your-service-role-key",
        "SUPABASE_DB_URL": "postgresql://user:password@host:port/database"
      }
    }
  }
}
```

### With n8n

The server can be integrated with n8n workflows for automation.

## Tool Examples

### Execute SQL Query
```javascript
{
  "tool": "execute-sql",
  "arguments": {
    "sql": "SELECT * FROM users WHERE created_at > NOW() - INTERVAL '7 days'"
  }
}
```

### List Tables
```javascript
{
  "tool": "list-tables",
  "arguments": {
    "schema": "public"
  }
}
```

### Describe Table Structure
```javascript
{
  "tool": "describe-table",
  "arguments": {
    "table": "users",
    "schema": "public"
  }
}
```

## Development

```bash
# Run in development mode with auto-reload
npm run dev

# Clean and rebuild
npm run rebuild

# Run tests
npm test
```

## Security Notes

- The `execute-sql` tool requires the `SUPABASE_DB_URL` environment variable
- Be cautious with SQL execution permissions in production
- Consider using read-only database users for query operations
- The service role key provides admin access - use with caution

## Troubleshooting

### SQL Execution Not Working
- Ensure `SUPABASE_DB_URL` is correctly set
- Verify that `psql` command is available in your system PATH
- Check database connection permissions

### Connection Issues
- Verify your Supabase URL and keys are correct
- Check if your IP is allowed in Supabase database settings
- Ensure your project is not paused

## License

MIT