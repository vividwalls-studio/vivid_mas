#!/usr/bin/env node

// Simple test to check if MCP servers can be invoked and respond

import { spawn } from 'child_process';
import readline from 'readline';

async function testMCPServer(serverPath, serverName) {
  console.log(`\n🔧 Testing ${serverName}...`);
  console.log(`Path: ${serverPath}`);
  
  return new Promise((resolve) => {
    const child = spawn('node', ['dist/index.js'], {
      cwd: serverPath,
      env: { ...process.env },
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let output = '';
    let errorOutput = '';
    
    // Send initialization message
    const initMessage = JSON.stringify({
      jsonrpc: "2.0",
      method: "initialize",
      params: {
        protocolVersion: "1.0.0",
        capabilities: {},
        clientInfo: {
          name: "test-client",
          version: "1.0.0"
        }
      },
      id: 1
    });
    
    child.stdin.write(initMessage + '\n');
    
    // Send list prompts request
    setTimeout(() => {
      const listMessage = JSON.stringify({
        jsonrpc: "2.0",
        method: "prompts/list",
        params: {},
        id: 2
      });
      child.stdin.write(listMessage + '\n');
    }, 500);

    child.stdout.on('data', (data) => {
      output += data.toString();
    });

    child.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    setTimeout(() => {
      child.kill();
      
      console.log('  Stderr output:', errorOutput || '(none)');
      
      // Try to parse JSON responses from stdout
      const lines = output.split('\n').filter(line => line.trim());
      let foundResponse = false;
      
      for (const line of lines) {
        try {
          const json = JSON.parse(line);
          if (json.result) {
            console.log('  ✅ Got valid response:', JSON.stringify(json.result).substring(0, 100) + '...');
            foundResponse = true;
          }
        } catch (e) {
          // Not JSON, skip
        }
      }
      
      if (!foundResponse && output) {
        console.log('  ⚠️ Got output but no valid JSON response');
        console.log('  Raw output preview:', output.substring(0, 200));
      } else if (!output) {
        console.log('  ❌ No output received');
      }
      
      resolve();
    }, 2000);
  });
}

async function runTests() {
  console.log("🧪 Testing MCP Servers\n");
  
  // Test each server
  const servers = [
    {
      path: '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents/data-analytics-prompts',
      name: 'Data Analytics Prompts'
    },
    {
      path: '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents/data-analytics-resource',
      name: 'Data Analytics Resource'
    }
  ];
  
  for (const server of servers) {
    try {
      await testMCPServer(server.path, server.name);
    } catch (error) {
      console.log(`  ❌ Error testing ${server.name}:`, error.message);
    }
  }
  
  console.log("\n✅ All tests completed");
}

runTests().catch(console.error);