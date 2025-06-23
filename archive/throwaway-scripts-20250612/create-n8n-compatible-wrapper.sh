#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Creating n8n-compatible MCP wrapper ==="
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Creating n8n-compatible wrapper..."
cat > n8n-shopify-mcp.js << 'WRAPPER'
#!/usr/bin/env node

const { spawn } = require('child_process');

// Debug logging
if (process.env.DEBUG) {
    console.error('Starting n8n Shopify MCP wrapper...');
    console.error('Environment:', {
        SHOPIFY_STORE_URL: process.env.SHOPIFY_STORE_URL,
        SHOPIFY_ACCESS_TOKEN: process.env.SHOPIFY_ACCESS_TOKEN ? 'SET' : 'NOT SET',
        SHOPIFY_API_VERSION: process.env.SHOPIFY_API_VERSION
    });
}

// Map n8n environment variables to what Shopify MCP expects
const env = {
    ...process.env,
    MYSHOPIFY_DOMAIN: process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN,
    SHOPIFY_ACCESS_TOKEN: process.env.SHOPIFY_ACCESS_TOKEN,
    SHOPIFY_API_VERSION: process.env.SHOPIFY_API_VERSION || '2024-01',
    NODE_ENV: 'production'
};

// Check required variables
if (!env.MYSHOPIFY_DOMAIN) {
    console.error('Error: SHOPIFY_STORE_URL or MYSHOPIFY_DOMAIN required');
    process.exit(1);
}

if (!env.SHOPIFY_ACCESS_TOKEN) {
    console.error('Error: SHOPIFY_ACCESS_TOKEN required');
    process.exit(1);
}

// Spawn the actual MCP server with stdio inheritance
const serverProcess = spawn('node', ['build/index.js'], {
    env: env,
    stdio: 'inherit',
    cwd: __dirname
});

serverProcess.on('error', (err) => {
    console.error('Failed to start Shopify MCP server:', err);
    process.exit(1);
});

serverProcess.on('exit', (code, signal) => {
    if (signal) {
        process.exit(1);
    } else {
        process.exit(code || 0);
    }
});

// Handle signals
process.on('SIGTERM', () => {
    serverProcess.kill('SIGTERM');
});

process.on('SIGINT', () => {
    serverProcess.kill('SIGINT');
});
WRAPPER

chmod +x n8n-shopify-mcp.js

echo -e "\n2. Testing the wrapper..."
cd /opt/mcp-servers/shopify-mcp-server
export SHOPIFY_STORE_URL="vividwalls-2.myshopify.com"
export SHOPIFY_ACCESS_TOKEN="***REMOVED***"
export SHOPIFY_API_VERSION="2024-01"
export DEBUG=1

timeout 2 node n8n-shopify-mcp.js 2>&1 || true

echo -e "\n3. Creating alternative ESM-compatible wrapper..."
cat > n8n-shopify-mcp.mjs << 'ESMWRAPPER'
#!/usr/bin/env node

import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Map environment variables
process.env.MYSHOPIFY_DOMAIN = process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN;

// Import the MCP server directly
import(join(__dirname, 'build/index.js')).catch(err => {
    console.error('Failed to load MCP server:', err);
    process.exit(1);
});
ESMWRAPPER

chmod +x n8n-shopify-mcp.mjs

echo -e "\n4. Creating a test script to verify MCP communication..."
cat > test-n8n-connection.js << 'TESTSCRIPT'
const { spawn } = require('child_process');
const readline = require('readline');

const child = spawn('node', ['n8n-shopify-mcp.js'], {
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

rl.on('line', (line) => {
    console.log('STDOUT:', line);
});

errRl.on('line', (line) => {
    console.log('STDERR:', line);
});

// Send initialization after a short delay
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
    
    console.log('Sending:', JSON.stringify(init));
    child.stdin.write(JSON.stringify(init) + '\n');
}, 100);

setTimeout(() => {
    console.log('Test complete');
    child.kill();
    process.exit(0);
}, 3000);
TESTSCRIPT

echo -e "\n5. Running connection test..."
node test-n8n-connection.js

echo -e "\n=== FINAL CONFIGURATION FOR N8N ==="
echo "✅ Wrapper created successfully!"
echo ""
echo "UPDATE YOUR N8N MCP CLIENT CREDENTIAL:"
echo "Transport Type: stdio"
echo "Command: node"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/n8n-shopify-mcp.js"
echo ""
echo "Environment Variables (keep as configured):"
echo "- SHOPIFY_STORE_URL = vividwalls-2.myshopify.com"
echo "- SHOPIFY_ACCESS_TOKEN = ***REMOVED***"
echo "- SHOPIFY_API_VERSION = 2024-01"

rm -f test-n8n-connection.js
EOF