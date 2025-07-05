#!/usr/bin/env node

import "dotenv/config";
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
  ErrorCode,
  McpError,
} from "@modelcontextprotocol/sdk/types.js";
import * as prompts from "./prompts.js";

// Create server instance
const server = new Server(
  {
    name: "analytics-director-prompts",
    version: "1.0.0"
  },
  {
    capabilities: {
      prompts: {}
    }
  }
);

// Get all prompts as an array
const promptList = Object.values(prompts);

// List prompts handler
server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: promptList.map(prompt => ({
      name: prompt.name,
      description: prompt.description
    }))
  };
});

// Get prompt handler
server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  const { name } = request.params;
  const prompt = promptList.find(p => p.name === name);
  
  if (!prompt) {
    throw new McpError(
      ErrorCode.InvalidRequest,
      `Unknown prompt: ${name}`
    );
  }
  
  return {
    name: prompt.name,
    description: prompt.description,
    template: prompt.template
  };
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Analytics Director Prompts MCP server started");
}

main().catch((error) => {
  console.error("Server error:", error);
  process.exit(1);
});