#!/usr/bin/env node
import { spawn } from 'child_process';
import { createInterface } from 'readline';

// Start the MCP server
const server = spawn('node', ['dist/index.js'], {
  cwd: process.cwd(),
  env: { ...process.env, POSTIZ_API_KEY: '8895d94a-8d76-4d69-a212-23f248a7f78d' }
});

const rl = createInterface({
  input: server.stdout,
  output: process.stdout,
  terminal: false
});

// Send initialization
const initMessage = {
  jsonrpc: "2.0",
  method: "initialize",
  params: {
    protocolVersion: "1.0.0",
    capabilities: {
      tools: {}
    },
    clientInfo: {
      name: "test-client",
      version: "1.0.0"
    }
  },
  id: 1
};

console.log('Sending initialization...');
server.stdin.write(JSON.stringify(initMessage) + '\n');

// Listen for responses
rl.on('line', (line) => {
  if (line.includes('postiz-mcp-server running on stdio')) {
    console.log('Server started successfully!');
    
    // Send tools/list request
    const toolsListMessage = {
      jsonrpc: "2.0",
      method: "tools/list",
      params: {},
      id: 2
    };
    
    setTimeout(() => {
      console.log('Requesting tools list...');
      server.stdin.write(JSON.stringify(toolsListMessage) + '\n');
    }, 1000);
  } else {
    try {
      const response = JSON.parse(line);
      console.log('Response:', JSON.stringify(response, null, 2));
      
      if (response.id === 2 && response.result?.tools) {
        console.log(`\nFound ${response.result.tools.length} tools:`);
        response.result.tools.forEach(tool => {
          console.log(`- ${tool.name}: ${tool.description}`);
        });
        
        // Test the get_weather tool
        const weatherRequest = {
          jsonrpc: "2.0",
          method: "tools/call",
          params: {
            name: "get_weather",
            arguments: { city: "New York" }
          },
          id: 3
        };
        
        setTimeout(() => {
          console.log('\nTesting get_weather tool...');
          server.stdin.write(JSON.stringify(weatherRequest) + '\n');
        }, 500);
      }
      
      if (response.id === 3) {
        console.log('\nWeather tool response received!');
        process.exit(0);
      }
    } catch (e) {
      // Not JSON, just a log message
    }
  }
});

server.stderr.on('data', (data) => {
  console.error('Error:', data.toString());
});

// Handle exit
setTimeout(() => {
  console.log('Test timeout reached');
  process.exit(1);
}, 10000);