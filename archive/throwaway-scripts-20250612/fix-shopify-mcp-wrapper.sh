#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "Creating MCP wrapper for Shopify server..."
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Creating wrapper script..."
cat > shopify-mcp-wrapper.js << 'WRAPPER'
#!/usr/bin/env node

// Wrapper to handle environment variable mapping for n8n
process.env.MYSHOPIFY_DOMAIN = process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN;

// Import and run the actual MCP server
import('./build/index.js').catch(err => {
    console.error('Failed to start MCP server:', err);
    process.exit(1);
});
WRAPPER

chmod +x shopify-mcp-wrapper.js

echo -e "\n2. Testing wrapper with correct env vars..."
SHOPIFY_STORE_URL=vividwalls-2.myshopify.com \
MYSHOPIFY_DOMAIN=vividwalls-2.myshopify.com \
SHOPIFY_ACCESS_TOKEN=***REMOVED*** \
SHOPIFY_API_VERSION=2024-01 \
timeout 3 node shopify-mcp-wrapper.js 2>&1 | head -20 || true

echo -e "\n3. Creating a stdio test..."
cat > test-stdio.mjs << 'TESTFILE'
import { spawn } from 'child_process';
import { createInterface } from 'readline';

const env = {
    ...process.env,
    SHOPIFY_STORE_URL: 'vividwalls-2.myshopify.com',
    MYSHOPIFY_DOMAIN: 'vividwalls-2.myshopify.com',
    SHOPIFY_ACCESS_TOKEN: '***REMOVED***',
    SHOPIFY_API_VERSION: '2024-01'
};

console.log('Starting MCP server with wrapper...');
const mcpProcess = spawn('node', ['shopify-mcp-wrapper.js'], {
    env: env,
    stdio: ['pipe', 'pipe', 'pipe']
});

const rl = createInterface({ input: mcpProcess.stdout });

// Send initialization
const init = {
    jsonrpc: "2.0",
    method: "initialize",
    params: {
        protocolVersion: "2024-11-05",
        capabilities: {},
        clientInfo: { name: "test", version: "1.0" }
    },
    id: 1
};

setTimeout(() => {
    console.log('Sending:', JSON.stringify(init));
    mcpProcess.stdin.write(JSON.stringify(init) + '\n');
}, 100);

rl.on('line', (line) => {
    console.log('Response:', line);
    process.exit(0);
});

mcpProcess.stderr.on('data', (data) => {
    console.error('Error:', data.toString());
});

setTimeout(() => {
    console.log('Test complete');
    mcpProcess.kill();
    process.exit(0);
}, 5000);
TESTFILE

echo -e "\n4. Running stdio test..."
node test-stdio.mjs

echo -e "\n=== SUMMARY ==="
echo "The Shopify MCP server requires MYSHOPIFY_DOMAIN environment variable."
echo "Use the wrapper script in n8n:"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/shopify-mcp-wrapper.js"

rm -f test-stdio.mjs
EOF