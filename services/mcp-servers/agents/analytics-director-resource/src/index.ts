#!/usr/bin/env node

import "dotenv/config";
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { 
  ListResourcesRequestSchema, 
  ReadResourceRequestSchema,
  ErrorCode,
  McpError 
} from "@modelcontextprotocol/sdk/types.js";
import { resources } from "./resources.js";

// Create server instance
const server = new Server(
  {
    name: "analytics-director-resource",
    version: "1.0.0"
  },
  {
    capabilities: {
      resources: {}
    }
  }
);

// List available resources
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: resources.map(resource => ({
      uri: resource.uri,
      name: resource.name,
      description: resource.description,
      mimeType: resource.mimeType
    }))
  };
});

// Read specific resource
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const resource = resources.find(r => r.uri === request.params.uri);
  
  if (!resource) {
    throw new McpError(
      ErrorCode.InvalidRequest,
      `Resource not found: ${request.params.uri}`
    );
  }
  
  try {
    const data = await resource.fetchData();
    
    return {
      contents: [
        {
          uri: resource.uri,
          mimeType: resource.mimeType,
          text: JSON.stringify(data, null, 2)
        }
      ]
    };
  } catch (error) {
    console.error(`Error fetching resource ${resource.uri}:`, error);
    throw new McpError(
      ErrorCode.InternalError,
      `Failed to fetch resource: ${error instanceof Error ? error.message : 'Unknown error'}`
    );
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Analytics Director Resource MCP server started");
}

main().catch((error) => {
  console.error("Server error:", error);
  process.exit(1);
});