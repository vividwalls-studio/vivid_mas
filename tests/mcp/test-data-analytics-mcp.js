#!/usr/bin/env node

import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { spawn } from "child_process";

async function testDataAnalyticsMCP() {
  console.log("Testing Data Analytics Prompts MCP Server...\n");

  // Start the MCP server as a subprocess
  const serverProcess = spawn("node", ["dist/index.js"], {
    cwd: "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents/data-analytics-prompts",
    env: { ...process.env }
  });

  // Create client with stdio transport
  const transport = new StdioClientTransport({
    command: "node",
    args: ["dist/index.js"],
    cwd: "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents/data-analytics-prompts"
  });

  const client = new Client(
    {
      name: "test-client",
      version: "1.0.0"
    },
    {
      capabilities: {}
    }
  );

  try {
    // Connect to the server
    await client.connect(transport);
    console.log("✅ Connected to Data Analytics Prompts MCP Server\n");

    // List available prompts
    console.log("📋 Listing available prompts:");
    const promptsResponse = await client.request(
      { method: "prompts/list" },
      {}
    );
    
    if (promptsResponse.prompts && promptsResponse.prompts.length > 0) {
      promptsResponse.prompts.forEach((prompt, index) => {
        console.log(`  ${index + 1}. ${prompt.name}`);
        console.log(`     Description: ${prompt.description}`);
      });

      // Get details of the first prompt
      if (promptsResponse.prompts.length > 0) {
        console.log(`\n📝 Getting details for prompt: ${promptsResponse.prompts[0].name}`);
        const promptDetail = await client.request(
          { method: "prompts/get" },
          { name: promptsResponse.prompts[0].name }
        );
        console.log("  Template preview (first 200 chars):");
        console.log(`  ${promptDetail.template.substring(0, 200)}...`);
      }
    } else {
      console.log("  No prompts available");
    }

  } catch (error) {
    console.error("❌ Error:", error.message);
  } finally {
    // Clean up
    await client.close();
    serverProcess.kill();
    console.log("\n✅ Test completed");
  }
}

// Run the test
testDataAnalyticsMCP().catch(console.error);