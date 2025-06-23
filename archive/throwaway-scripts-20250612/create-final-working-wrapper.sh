#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Creating Final Working MCP Wrapper ==="
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Creating proper stdio wrapper..."
cat > shopify-mcp-n8n.cjs << 'WRAPPER'
#!/usr/bin/env node

const { spawn } = require('child_process');

// Map environment variables
const env = {
    ...process.env,
    MYSHOPIFY_DOMAIN: process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN,
    SHOPIFY_ACCESS_TOKEN: process.env.SHOPIFY_ACCESS_TOKEN,
    SHOPIFY_API_VERSION: process.env.SHOPIFY_API_VERSION || '2024-01'
};

// Validate required variables
if (!env.MYSHOPIFY_DOMAIN) {
    console.error('Error: SHOPIFY_STORE_URL or MYSHOPIFY_DOMAIN required');
    process.exit(1);
}

if (!env.SHOPIFY_ACCESS_TOKEN) {
    console.error('Error: SHOPIFY_ACCESS_TOKEN required');
    process.exit(1);
}

// Spawn the MCP server with piped stdio
const serverProcess = spawn('node', ['build/index.js'], {
    env: env,
    stdio: ['pipe', 'pipe', 'pipe'],
    cwd: __dirname
});

// Connect stdio streams
process.stdin.pipe(serverProcess.stdin);
serverProcess.stdout.pipe(process.stdout);
serverProcess.stderr.pipe(process.stderr);

// Handle process errors
serverProcess.on('error', (err) => {
    console.error('Failed to start Shopify MCP server:', err);
    process.exit(1);
});

// Handle process exit
serverProcess.on('exit', (code, signal) => {
    if (signal) {
        process.exit(1);
    } else {
        process.exit(code || 0);
    }
});

// Handle parent process signals
process.on('SIGTERM', () => {
    serverProcess.kill('SIGTERM');
});

process.on('SIGINT', () => {
    serverProcess.kill('SIGINT');
});

// Ensure stdin doesn't close the process
process.stdin.on('end', () => {
    serverProcess.stdin.end();
});
WRAPPER

chmod +x shopify-mcp-n8n.cjs

echo -e "\n2. Testing the wrapper with MCP protocol..."
cat > test-wrapper.cjs << 'TEST'
const { spawn } = require('child_process');
const readline = require('readline');

console.log('Testing MCP wrapper...');

const child = spawn('node', ['shopify-mcp-n8n.cjs'], {
    env: {
        ...process.env,
        SHOPIFY_STORE_URL: 'vividwalls-2.myshopify.com',
        SHOPIFY_ACCESS_TOKEN: '***REMOVED***',
        SHOPIFY_API_VERSION: '2024-01'
    },
    stdio: ['pipe', 'pipe', 'pipe']
});

const rl = readline.createInterface({ input: child.stdout });
const errRl = readline.createInterface({ input: child.stderr });

let initialized = false;

rl.on('line', (line) => {
    console.log('STDOUT:', line);
    
    try {
        const msg = JSON.parse(line);
        if (msg.id === 1 && msg.result) {
            console.log('\n✅ Initialization successful!');
            initialized = true;
            
            // Test tools/list
            const toolsReq = {
                jsonrpc: "2.0",
                method: "tools/list",
                params: {},
                id: 2
            };
            console.log('Sending tools/list request...');
            child.stdin.write(JSON.stringify(toolsReq) + '\n');
        } else if (msg.id === 2 && msg.result) {
            console.log(`✅ Got ${msg.result.tools.length} tools!`);
            console.log('First 3 tools:', msg.result.tools.slice(0, 3).map(t => t.name));
            child.kill();
        }
    } catch (e) {
        // Not JSON
    }
});

errRl.on('line', (line) => {
    if (!line.includes('Shopify MCP Server running')) {
        console.error('STDERR:', line);
    }
});

child.on('exit', (code) => {
    if (initialized) {
        console.log('\n✅ MCP WRAPPER WORKING CORRECTLY!');
    } else {
        console.log('\n❌ Failed to initialize');
    }
    process.exit(code || 0);
});

// Send initialization
setTimeout(() => {
    const init = {
        jsonrpc: "2.0",
        method: "initialize",
        params: {
            protocolVersion: "2024-11-05",
            capabilities: {},
            clientInfo: { name: "n8n", version: "1.0.0" }
        },
        id: 1
    };
    
    console.log('Sending initialization...');
    child.stdin.write(JSON.stringify(init) + '\n');
}, 200);

// Timeout
setTimeout(() => {
    if (!initialized) {
        console.log('Timeout - no response');
        child.kill();
    }
}, 5000);
TEST

echo -e "\n3. Running wrapper test..."
node test-wrapper.cjs

echo -e "\n4. Creating alternative ESM import wrapper..."
cat > shopify-mcp-import.mjs << 'ESMWRAPPER'
#!/usr/bin/env node

// Set environment variables
process.env.MYSHOPIFY_DOMAIN = process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN;

// Validate
if (!process.env.MYSHOPIFY_DOMAIN || !process.env.SHOPIFY_ACCESS_TOKEN) {
    console.error('Error: Required environment variables missing');
    process.exit(1);
}

// Import the MCP server
await import('./build/index.js');
ESMWRAPPER

chmod +x shopify-mcp-import.mjs

echo -e "\n5. Testing ESM import wrapper..."
SHOPIFY_STORE_URL=vividwalls-2.myshopify.com \
SHOPIFY_ACCESS_TOKEN=***REMOVED*** \
timeout 2 node shopify-mcp-import.mjs 2>&1 || true

echo -e "\n=== FINAL CONFIGURATION ==="
echo "✅ Created working wrapper: shopify-mcp-n8n.cjs"
echo ""
echo "UPDATE YOUR N8N CREDENTIAL:"
echo "=========================="
echo "Transport Type: stdio"
echo "Command: node"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/shopify-mcp-n8n.cjs"
echo ""
echo "Environment Variables (keep as is):"
echo "- SHOPIFY_STORE_URL = vividwalls-2.myshopify.com"
echo "- SHOPIFY_ACCESS_TOKEN = ***REMOVED***"
echo "- SHOPIFY_API_VERSION = 2024-01"
echo ""
echo "This wrapper properly handles stdio pipes for n8n compatibility."

rm -f test-wrapper.cjs
EOF