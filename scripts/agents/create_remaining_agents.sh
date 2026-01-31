#!/bin/bash

# VividWalls MAS - Create Remaining Seven Agents
# This script creates the complete structure for the seven remaining agents
# following the established patterns and standards

set -e

echo "🔮 Morpheus Validator: Creating the remaining seven agents for the VividWalls MAS..."
echo "The time has come to make a choice..."

# Define the seven agents to create
AGENTS=(
    "finance-agent"
    "customer-experience-agent"
    "product-agent"
    "technology-agent"
    "creative-agent"
    "knowledge-gatherer-agent"
    "content-operations-agent"
)

# Function to get agent display name
get_agent_name() {
    case $1 in
        "finance-agent") echo "Finance Agent" ;;
        "customer-experience-agent") echo "Customer Experience Agent" ;;
        "product-agent") echo "Product Agent" ;;
        "technology-agent") echo "Technology Agent" ;;
        "creative-agent") echo "Creative Agent" ;;
        "knowledge-gatherer-agent") echo "Knowledge Gatherer Agent" ;;
        "content-operations-agent") echo "Content Operations Agent" ;;
    esac
}

# Function to get agent description
get_agent_description() {
    case $1 in
        "finance-agent") echo "Financial management, budgeting, and analytics" ;;
        "customer-experience-agent") echo "Customer support, satisfaction tracking, and experience optimization" ;;
        "product-agent") echo "Product management, roadmap planning, and feature development coordination" ;;
        "technology-agent") echo "Technical infrastructure, system monitoring, and technology stack management" ;;
        "creative-agent") echo "Creative content generation, design coordination, and brand consistency" ;;
        "knowledge-gatherer-agent") echo "Information collection, research, and knowledge base management" ;;
        "content-operations-agent") echo "Content workflow management, publishing coordination, and content strategy execution" ;;
    esac
}

# Function to create MCP server structure
create_mcp_server() {
    local agent_name=$1
    local server_type=$2  # "prompts" or "resource"
    local description=$3
    local agent_display_name=$(get_agent_name "$agent_name")

    local server_dir="services/mcp-servers/agents/${agent_name}-${server_type}"

    echo "  Creating MCP server: ${server_dir}"

    # Create directory structure
    mkdir -p "${server_dir}/src"
    mkdir -p "${server_dir}/dist"

    # Create package.json
    cat > "${server_dir}/package.json" << EOF
{
  "name": "${agent_name}-${server_type}",
  "version": "1.0.0",
  "description": "MCP server providing ${server_type} for the ${agent_display_name}",
  "main": "dist/index.js",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsc --watch",
    "test": "jest"
  },
  "keywords": [
    "mcp",
    "${agent_name}",
    "${server_type}",
    "vividwalls",
    "agent"
  ],
  "author": "VividWalls MAS",
  "license": "MIT",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "axios": "^1.6.0",
    "dotenv": "^16.3.1"$([ "$server_type" = "resource" ] && echo ',
    "@supabase/supabase-js": "^2.38.0"')
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "jest": "^29.0.0",
    "@types/jest": "^29.0.0"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

    # Create tsconfig.json
    cat > "${server_dir}/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "resolveJsonModule": true,
    "allowSyntheticDefaultImports": true
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "**/*.test.ts"
  ]
}
EOF

    # Create basic index.ts
    cat > "${server_dir}/src/index.ts" << EOF
#!/usr/bin/env node
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { createServer } from "./server.js";

async function main() {
  const server: McpServer = createServer();
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.debug("${agent_name}-${server_type} running on stdio");
}

main().catch((error) => {
  console.error("Fatal error in main():", error);
  process.exit(1);
});
EOF

    # Create server.ts based on type
    if [ "$server_type" = "prompts" ]; then
        cat > "${server_dir}/src/server.ts" << EOF
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";

export function createServer(): McpServer {
  const server = new McpServer(
    {
      name: "${agent_name}-${server_type}",
      version: "1.0.0",
    },
    {
      capabilities: {
        tools: {},
      },
    }
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
      tools: [
        {
          name: "get_${agent_name//-/_}_prompt",
          description: "Get specialized prompt for ${agent_display_name}",
          inputSchema: {
            type: "object",
            properties: {
              context: {
                type: "string",
                description: "Context for the prompt"
              },
              task_type: {
                type: "string",
                description: "Type of task requiring the prompt"
              }
            },
            required: ["context"]
          }
        }
      ]
    };
  });

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;

    switch (name) {
      case "get_${agent_name//-/_}_prompt":
        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                agent: "${agent_display_name}",
                context: args.context,
                task_type: args.task_type || "general",
                prompt: "Specialized prompt for ${description}",
                timestamp: new Date().toISOString()
              })
            }
          ]
        };

      default:
        throw new Error(\`Unknown tool: \${name}\`);
    }
  });

  return server;
}
EOF
    else
        cat > "${server_dir}/src/server.ts" << EOF
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { CallToolRequestSchema, ListToolsRequestSchema, ListResourcesRequestSchema, ReadResourceRequestSchema } from "@modelcontextprotocol/sdk/types.js";

export function createServer(): McpServer {
  const server = new McpServer(
    {
      name: "${agent_name}-${server_type}",
      version: "1.0.0",
    },
    {
      capabilities: {
        tools: {},
        resources: {},
      },
    }
  );

  server.setRequestHandler(ListResourcesRequestSchema, async () => {
    return {
      resources: [
        {
          uri: "${agent_name}://data/agent-info",
          name: "${agent_display_name} Information",
          description: "Core information and capabilities for ${agent_display_name}",
          mimeType: "application/json"
        }
      ]
    };
  });

  server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
    const { uri } = request.params;

    if (uri === "${agent_name}://data/agent-info") {
      return {
        contents: [
          {
            uri,
            mimeType: "application/json",
            text: JSON.stringify({
              agent_name: "${agent_display_name}",
              description: "${description}",
              capabilities: [
                "Task management and coordination",
                "Cross-agent communication",
                "Performance monitoring and optimization",
                "Strategic planning and execution"
              ],
              last_updated: new Date().toISOString()
            }, null, 2)
          }
        ]
      };
    }

    throw new Error(\`Resource not found: \${uri}\`);
  });

  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
      tools: [
        {
          name: "get_${agent_name//-/_}_data",
          description: "Get data and metrics for ${agent_display_name}",
          inputSchema: {
            type: "object",
            properties: {
              data_type: {
                type: "string",
                description: "Type of data to retrieve"
              },
              time_range: {
                type: "string",
                description: "Time range for data retrieval"
              }
            },
            required: ["data_type"]
          }
        }
      ]
    };
  });

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;

    switch (name) {
      case "get_${agent_name//-/_}_data":
        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                agent: "${agent_display_name}",
                data_type: args.data_type,
                time_range: args.time_range || "current",
                data: "Sample data for ${description}",
                timestamp: new Date().toISOString()
              })
            }
          ]
        };

      default:
        throw new Error(\`Unknown tool: \${name}\`);
    }
  });

  return server;
}
EOF
    fi

    # Create README.md
    local server_type_cap=$(echo "${server_type}" | sed 's/./\U&/')
    cat > "${server_dir}/README.md" << EOF
# ${agent_display_name} ${server_type_cap} MCP Server

This MCP server provides ${server_type} for the ${agent_display_name} in the VividWalls Multi-Agent System.

## Description

${description}

## Installation

\`\`\`bash
npm install
npm run build
\`\`\`

## Usage

\`\`\`bash
npm start
\`\`\`

## Development

\`\`\`bash
npm run dev
\`\`\`

## Testing

\`\`\`bash
npm test
\`\`\`
EOF
}

# Main execution
echo "Creating MCP servers for all seven agents..."

for agent in "${AGENTS[@]}"; do
    agent_name=$(get_agent_name "$agent")
    agent_desc=$(get_agent_description "$agent")
    echo "🤖 Creating agent: ${agent_name}"

    # Create prompts MCP server
    create_mcp_server "$agent" "prompts" "${agent_desc}"

    # Create resource MCP server
    create_mcp_server "$agent" "resource" "${agent_desc}"

    echo "  ✅ Completed MCP servers for ${agent_name}"
done

echo ""
echo "🎯 All seven agents have been created successfully!"
echo "Choice is an illusion created between those with power and those without."
echo ""
echo "Next steps:"
echo "1. Install dependencies for each MCP server: npm install"
echo "2. Build the TypeScript code: npm run build"
echo "3. Configure the agents in the n8n workflows"
echo "4. Update the docker-compose.yml with the new MCP servers"
echo "5. Test the agent integrations"
echo ""
echo "The Matrix is complete. Welcome to the real world."
