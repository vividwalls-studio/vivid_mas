#!/usr/bin/env node
// Enhanced Supabase MCP Server with SQL Execution Support
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema
} from '@modelcontextprotocol/sdk/types.js';
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// Load environment variables
dotenv.config();

// Environment variables
const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_KEY = process.env.SUPABASE_KEY || '';
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const SUPABASE_DB_URL = process.env.SUPABASE_DB_URL || '';

// Debug logging
console.error('Initializing Enhanced Supabase MCP Server...');
console.error(`SUPABASE_URL: ${SUPABASE_URL}`);
console.error(`SUPABASE_KEY available: ${Boolean(SUPABASE_KEY)}`);
console.error(`SUPABASE_SERVICE_ROLE_KEY available: ${Boolean(SUPABASE_SERVICE_ROLE_KEY)}`);
console.error(`SUPABASE_DB_URL available: ${Boolean(SUPABASE_DB_URL)}`);

// Initialize Supabase client
const supabaseClient = createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: {
    persistSession: false,
    autoRefreshToken: false
  }
});

// Optional admin client using service role key
let supabaseAdminClient = null;
if (SUPABASE_SERVICE_ROLE_KEY) {
  console.error('Initializing admin client');
  supabaseAdminClient = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
    auth: {
      persistSession: false,
      autoRefreshToken: false
    }
  });
}

// Create MCP server
const server = new Server(
  {
    name: 'supabase-mcp-server',
    version: '2.0.0',
  },
  {
    capabilities: {
      tools: {},
      resources: {},
      prompts: {},
    },
  }
);

// Helper to format tool results
const formatToolResult = (data: any) => {
  return {
    content: [
      {
        type: 'text',
        text: JSON.stringify(data, null, 2)
      }
    ]
  };
};

// Helper to execute SQL using Supabase CLI
const executeSQL = async (sql: string): Promise<any> => {
  if (!SUPABASE_DB_URL) {
    throw new Error('SUPABASE_DB_URL environment variable is not set');
  }

  try {
    // Use psql to execute the SQL command
    const command = `psql "${SUPABASE_DB_URL}" -c "${sql.replace(/"/g, '\\"')}"`;
    const { stdout, stderr } = await execAsync(command);
    
    if (stderr && !stderr.includes('NOTICE:')) {
      throw new Error(stderr);
    }
    
    return stdout;
  } catch (error: any) {
    throw new Error(`SQL execution failed: ${error.message}`);
  }
};

// Handle tool listing
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'check-connection',
        description: 'Check connection to Supabase',
        inputSchema: {
          type: 'object',
          properties: {}
        }
      },
      {
        name: 'query-table',
        description: 'Query data from a Supabase table',
        inputSchema: {
          type: 'object',
          properties: {
            table: {
              type: 'string',
              description: 'Table name to query'
            },
            columns: {
              type: 'string',
              description: 'Comma-separated list of columns to select'
            },
            filter: {
              type: 'object',
              description: 'Filter conditions',
              additionalProperties: true
            },
            limit: {
              type: 'number',
              description: 'Maximum number of records to return'
            }
          },
          required: ['table', 'columns']
        }
      },
      {
        name: 'insert-data',
        description: 'Insert data into a Supabase table',
        inputSchema: {
          type: 'object',
          properties: {
            table: {
              type: 'string',
              description: 'Table name to insert into'
            },
            data: {
              type: 'object',
              description: 'Data to insert',
              additionalProperties: true
            }
          },
          required: ['table', 'data']
        }
      },
      {
        name: 'update-data',
        description: 'Update data in a Supabase table',
        inputSchema: {
          type: 'object',
          properties: {
            table: {
              type: 'string',
              description: 'Table name to update'
            },
            match: {
              type: 'object',
              description: 'Match condition for update',
              additionalProperties: true
            },
            data: {
              type: 'object',
              description: 'Data to update',
              additionalProperties: true
            }
          },
          required: ['table', 'match', 'data']
        }
      },
      {
        name: 'delete-data',
        description: 'Delete data from a Supabase table',
        inputSchema: {
          type: 'object',
          properties: {
            table: {
              type: 'string',
              description: 'Table name to delete from'
            },
            match: {
              type: 'object',
              description: 'Match condition for delete',
              additionalProperties: true
            }
          },
          required: ['table', 'match']
        }
      },
      {
        name: 'execute-sql',
        description: 'Execute raw SQL query on Supabase database (requires SUPABASE_DB_URL)',
        inputSchema: {
          type: 'object',
          properties: {
            sql: {
              type: 'string',
              description: 'SQL query to execute'
            },
            useAdmin: {
              type: 'boolean',
              description: 'Whether to use admin privileges (if available)',
              default: false
            }
          },
          required: ['sql']
        }
      },
      {
        name: 'list-tables',
        description: 'List all tables in the database',
        inputSchema: {
          type: 'object',
          properties: {
            schema: {
              type: 'string',
              description: 'Schema name (default: public)',
              default: 'public'
            }
          }
        }
      },
      {
        name: 'describe-table',
        description: 'Get detailed information about a table structure',
        inputSchema: {
          type: 'object',
          properties: {
            table: {
              type: 'string',
              description: 'Table name to describe'
            },
            schema: {
              type: 'string',
              description: 'Schema name (default: public)',
              default: 'public'
            }
          },
          required: ['table']
        }
      }
    ]
  };
});

// Handle resource listing
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  try {
    // Get list of tables
    const { data: tables, error } = await supabaseClient
      .from('information_schema.tables')
      .select('table_name')
      .eq('table_schema', 'public');

    if (error) {
      return { resources: [] };
    }

    const resources = (tables || []).map((table: any) => ({
      uri: `supabase://table/${table.table_name}`,
      name: `Table: ${table.table_name}`,
      description: `Schema and sample data from ${table.table_name} table`,
      mimeType: 'application/json'
    }));

    resources.push({
      uri: 'supabase://schema',
      name: 'Database Schema',
      description: 'Complete database schema information',
      mimeType: 'application/json'
    });

    return { resources };
  } catch (error) {
    console.error('Error listing resources:', error);
    return { resources: [] };
  }
});

// Handle resource reading
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  try {
    if (uri === 'supabase://schema') {
      const { data, error } = await supabaseClient
        .from('information_schema.columns')
        .select('table_name, column_name, data_type, is_nullable')
        .eq('table_schema', 'public')
        .order('table_name', { ascending: true })
        .order('ordinal_position', { ascending: true });

      if (error) throw error;

      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify(data, null, 2)
          }
        ]
      };
    }

    if (uri.startsWith('supabase://table/')) {
      const tableName = uri.replace('supabase://table/', '');
      
      // Get table schema
      const { data: schema, error: schemaError } = await supabaseClient
        .from('information_schema.columns')
        .select('column_name, data_type, is_nullable')
        .eq('table_schema', 'public')
        .eq('table_name', tableName)
        .order('ordinal_position', { ascending: true });

      if (schemaError) throw schemaError;

      // Get sample data
      const { data: sample, error: sampleError } = await supabaseClient
        .from(tableName)
        .select('*')
        .limit(5);

      if (sampleError) throw sampleError;

      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify({ schema, sample }, null, 2)
          }
        ]
      };
    }

    throw new Error(`Unknown resource: ${uri}`);
  } catch (error: any) {
    return {
      contents: [
        {
          uri,
          mimeType: 'text/plain',
          text: `Error: ${error.message}`
        }
      ]
    };
  }
});

// Handle prompts listing
server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: [
      {
        name: 'query-builder',
        description: 'Generate Supabase query code',
        arguments: [
          {
            name: 'table',
            description: 'Table name to query',
            required: true
          },
          {
            name: 'operation',
            description: 'Operation type (select, insert, update, delete)',
            required: true
          },
          {
            name: 'requirements',
            description: 'Natural language description of query requirements',
            required: true
          }
        ]
      },
      {
        name: 'schema-design',
        description: 'Design a database schema',
        arguments: [
          {
            name: 'requirements',
            description: 'Description of data model requirements',
            required: true
          },
          {
            name: 'constraints',
            description: 'Any specific constraints or relationships',
            required: false
          }
        ]
      },
      {
        name: 'migration-script',
        description: 'Generate a database migration script',
        arguments: [
          {
            name: 'current_schema',
            description: 'Description of current schema',
            required: true
          },
          {
            name: 'target_schema',
            description: 'Description of target schema',
            required: true
          }
        ]
      },
      {
        name: 'sql-query',
        description: 'Generate SQL query from natural language',
        arguments: [
          {
            name: 'description',
            description: 'Natural language description of what you want to query',
            required: true
          },
          {
            name: 'tables',
            description: 'Comma-separated list of tables involved',
            required: false
          }
        ]
      }
    ]
  };
});

// Handle prompt retrieval
server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'query-builder':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Generate a Supabase JavaScript/TypeScript query for the following:
Table: ${args?.table}
Operation: ${args?.operation}
Requirements: ${args?.requirements}

Please provide:
1. The complete query code
2. Explanation of the query
3. Any performance considerations
4. Example of how to handle the response`
            }
          }
        ]
      };

    case 'schema-design':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Design a Supabase database schema for:
Requirements: ${args?.requirements}
${args?.constraints ? `Constraints: ${args.constraints}` : ''}

Please provide:
1. SQL CREATE TABLE statements
2. Indexes and constraints
3. RLS (Row Level Security) policies if applicable
4. Example queries for common operations`
            }
          }
        ]
      };

    case 'migration-script':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Generate a Supabase migration script:
Current Schema: ${args?.current_schema}
Target Schema: ${args?.target_schema}

Please provide:
1. SQL migration script
2. Rollback script
3. Data migration considerations
4. Testing recommendations`
            }
          }
        ]
      };

    case 'sql-query':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Generate an SQL query for Supabase:
Description: ${args?.description}
${args?.tables ? `Tables: ${args.tables}` : ''}

Please provide:
1. The SQL query
2. Explanation of the query logic
3. Any indexes that would improve performance
4. Supabase JavaScript/TypeScript equivalent if applicable`
            }
          }
        ]
      };

    default:
      throw new Error(`Unknown prompt: ${name}`);
  }
});

// Handle tool execution
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'check-connection': {
        try {
          // Test basic connectivity
          const { data: productsData, error: productsError } = await supabaseClient
            .from('products')
            .select('*')
            .limit(1);

          if (!productsError) {
            // Products table exists
            const { data: agentsData, error: agentsError } = await supabaseClient
              .from('agents')
              .select('*')
              .limit(1);

            return formatToolResult({
              status: 'connected',
              url: SUPABASE_URL,
              adminAccess: !!supabaseAdminClient,
              sqlAccess: !!SUPABASE_DB_URL,
              tables: {
                products: !productsError,
                agents: !agentsError
              },
              message: 'Successfully connected to Supabase'
            });
          } else {
            // If products table doesn't exist, check general connectivity
            return formatToolResult({
              status: 'connected',
              url: SUPABASE_URL,
              adminAccess: !!supabaseAdminClient,
              sqlAccess: !!SUPABASE_DB_URL,
              tables: [],
              message: 'Connected to Supabase',
              warning: productsError.message
            });
          }
        } catch (error: any) {
          return formatToolResult({
            error: `Failed to connect: ${error.message}`
          });
        }
      }

      case 'query-table': {
        const { table, columns, filter, limit } = args as any;
        let query = supabaseClient
          .from(table)
          .select(columns);

        if (limit) {
          query = query.limit(limit);
        }

        if (filter) {
          Object.entries(filter).forEach(([key, value]) => {
            query = query.eq(key, value as any);
          });
        }

        const { data, error } = await query;

        if (error) {
          return formatToolResult({
            error: `Query failed: ${error.message}`
          });
        }

        return formatToolResult({ data });
      }

      case 'insert-data': {
        const { table, data } = args as any;
        const { data: result, error } = await supabaseClient
          .from(table)
          .insert(data)
          .select();

        if (error) {
          return formatToolResult({
            error: `Insert failed: ${error.message}`
          });
        }

        return formatToolResult({ data: result });
      }

      case 'update-data': {
        const { table, match, data } = args as any;
        let query = supabaseClient
          .from(table)
          .update(data);

        Object.entries(match).forEach(([key, value]) => {
          query = query.eq(key, value as any);
        });

        const { data: result, error } = await query.select();

        if (error) {
          return formatToolResult({
            error: `Update failed: ${error.message}`
          });
        }

        return formatToolResult({ data: result });
      }

      case 'delete-data': {
        const { table, match } = args as any;
        let query = supabaseClient
          .from(table)
          .delete();

        Object.entries(match).forEach(([key, value]) => {
          query = query.eq(key, value as any);
        });

        const { data, error } = await query;

        if (error) {
          return formatToolResult({
            error: `Delete failed: ${error.message}`
          });
        }

        return formatToolResult({
          success: true,
          message: `Records deleted from ${table}`
        });
      }

      case 'execute-sql': {
        const { sql, useAdmin } = args as any;
        
        if (!SUPABASE_DB_URL) {
          return formatToolResult({
            error: 'SQL execution not available. SUPABASE_DB_URL environment variable is not set.'
          });
        }

        try {
          const result = await executeSQL(sql);
          return formatToolResult({
            success: true,
            result: result,
            query: sql
          });
        } catch (error: any) {
          return formatToolResult({
            error: error.message,
            query: sql
          });
        }
      }

      case 'list-tables': {
        const { schema = 'public' } = args as any;
        
        const { data, error } = await supabaseClient
          .from('information_schema.tables')
          .select('table_name, table_type')
          .eq('table_schema', schema)
          .order('table_name', { ascending: true });

        if (error) {
          return formatToolResult({
            error: `Failed to list tables: ${error.message}`
          });
        }

        return formatToolResult({
          schema,
          tables: data
        });
      }

      case 'describe-table': {
        const { table, schema = 'public' } = args as any;
        
        // Get columns
        const { data: columns, error: columnsError } = await supabaseClient
          .from('information_schema.columns')
          .select('column_name, data_type, is_nullable, column_default')
          .eq('table_schema', schema)
          .eq('table_name', table)
          .order('ordinal_position', { ascending: true });

        if (columnsError) {
          return formatToolResult({
            error: `Failed to describe table: ${columnsError.message}`
          });
        }

        // Get constraints
        const { data: constraints, error: constraintsError } = await supabaseClient
          .from('information_schema.table_constraints')
          .select('constraint_name, constraint_type')
          .eq('table_schema', schema)
          .eq('table_name', table);

        return formatToolResult({
          table,
          schema,
          columns,
          constraints: constraintsError ? [] : constraints
        });
      }

      default:
        return formatToolResult({
          error: `Unknown tool: ${name}`
        });
    }
  } catch (error: any) {
    console.error(`Error executing tool ${name}:`, error);
    return formatToolResult({
      error: `Exception: ${error.message}`
    });
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Supabase MCP Server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});