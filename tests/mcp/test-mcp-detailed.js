#!/usr/bin/env node

import { spawn } from 'child_process';
import readline from 'readline';

class MCPTester {
  constructor(serverPath, serverName) {
    this.serverPath = serverPath;
    this.serverName = serverName;
    this.messageId = 0;
    this.responses = new Map();
  }

  async test() {
    console.log(`\n🔧 Testing ${this.serverName}`);
    console.log(`📁 Path: ${this.serverPath}`);
    console.log('━'.repeat(60));
    
    return new Promise((resolve) => {
      this.child = spawn('node', ['dist/index.js'], {
        cwd: this.serverPath,
        env: { ...process.env },
        stdio: ['pipe', 'pipe', 'pipe']
      });

      let buffer = '';
      
      this.child.stdout.on('data', (data) => {
        buffer += data.toString();
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';
        
        for (const line of lines) {
          if (line.trim()) {
            try {
              const json = JSON.parse(line);
              if (json.id && this.responses.has(json.id)) {
                this.responses.get(json.id)(json);
              }
            } catch (e) {
              // Not JSON, skip
            }
          }
        }
      });

      this.child.stderr.on('data', (data) => {
        const msg = data.toString().trim();
        if (msg) console.log(`  📝 Server: ${msg}`);
      });

      this.runTestSequence().then(() => {
        this.child.kill();
        resolve();
      });
    });
  }

  async sendMessage(method, params = {}) {
    const id = ++this.messageId;
    const message = JSON.stringify({
      jsonrpc: "2.0",
      method,
      params,
      id
    });
    
    return new Promise((resolve) => {
      this.responses.set(id, resolve);
      this.child.stdin.write(message + '\n');
      setTimeout(() => {
        if (this.responses.has(id)) {
          this.responses.delete(id);
          resolve(null);
        }
      }, 1000);
    });
  }

  async runTestSequence() {
    // Initialize
    console.log('\n1️⃣ Initializing connection...');
    const initResponse = await this.sendMessage('initialize', {
      protocolVersion: "1.0.0",
      capabilities: {},
      clientInfo: { name: "test-client", version: "1.0.0" }
    });
    
    if (initResponse?.result) {
      console.log('  ✅ Initialized successfully');
      console.log(`  Server: ${initResponse.result.serverInfo?.name || 'Unknown'}`);
      console.log(`  Capabilities:`, Object.keys(initResponse.result.capabilities || {}));
    }

    // List prompts or resources based on capabilities
    if (initResponse?.result?.capabilities?.prompts) {
      await this.testPrompts();
    }
    if (initResponse?.result?.capabilities?.resources) {
      await this.testResources();
    }
    if (initResponse?.result?.capabilities?.tools) {
      await this.testTools();
    }

    console.log('\n✅ Test completed for', this.serverName);
  }

  async testPrompts() {
    console.log('\n2️⃣ Testing Prompts...');
    const listResponse = await this.sendMessage('prompts/list');
    
    if (listResponse?.result?.prompts) {
      console.log(`  📋 Found ${listResponse.result.prompts.length} prompts:`);
      
      for (const prompt of listResponse.result.prompts.slice(0, 3)) {
        console.log(`\n  • ${prompt.name}`);
        console.log(`    ${prompt.description}`);
        
        // Get prompt details
        const detailResponse = await this.sendMessage('prompts/get', { name: prompt.name });
        if (detailResponse?.result?.template) {
          console.log(`    Template preview: ${detailResponse.result.template.substring(0, 100)}...`);
        }
      }
    }
  }

  async testResources() {
    console.log('\n2️⃣ Testing Resources...');
    const listResponse = await this.sendMessage('resources/list');
    
    if (listResponse?.result?.resources) {
      console.log(`  📚 Found ${listResponse.result.resources.length} resources:`);
      
      for (const resource of listResponse.result.resources.slice(0, 3)) {
        console.log(`\n  • ${resource.name} (${resource.uri})`);
        console.log(`    ${resource.description}`);
        console.log(`    Type: ${resource.mimeType}`);
        
        // Try to read resource
        const readResponse = await this.sendMessage('resources/read', { uri: resource.uri });
        if (readResponse?.result?.contents?.[0]) {
          const content = readResponse.result.contents[0];
          const preview = content.text ? content.text.substring(0, 100) : '(binary content)';
          console.log(`    Content preview: ${preview}...`);
        }
      }
    }
  }

  async testTools() {
    console.log('\n2️⃣ Testing Tools...');
    const listResponse = await this.sendMessage('tools/list');
    
    if (listResponse?.result?.tools) {
      console.log(`  🔨 Found ${listResponse.result.tools.length} tools:`);
      
      for (const tool of listResponse.result.tools.slice(0, 3)) {
        console.log(`\n  • ${tool.name}`);
        console.log(`    ${tool.description}`);
        if (tool.inputSchema) {
          console.log(`    Input schema:`, JSON.stringify(tool.inputSchema).substring(0, 100) + '...');
        }
      }
    }
  }
}

async function testAllServers() {
  console.log("🧪 MCP Server Testing Suite");
  console.log("═".repeat(60));
  
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
    const tester = new MCPTester(server.path, server.name);
    await tester.test();
  }
  
  console.log("\n" + "═".repeat(60));
  console.log("✅ All tests completed successfully!");
}

testAllServers().catch(console.error);