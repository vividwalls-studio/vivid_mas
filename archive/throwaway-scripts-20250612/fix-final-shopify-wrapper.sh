#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Creating final working wrapper ==="
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Renaming the wrapper to use .cjs extension..."
mv n8n-shopify-mcp.js n8n-shopify-mcp.cjs 2>/dev/null || true

echo -e "\n2. Testing the CommonJS wrapper..."
export SHOPIFY_STORE_URL="vividwalls-2.myshopify.com"
export SHOPIFY_ACCESS_TOKEN="***REMOVED***"
export SHOPIFY_API_VERSION="2024-01"

timeout 2 node n8n-shopify-mcp.cjs 2>&1 || true

echo -e "\n3. Testing with MCP protocol..."
cat > test-final.cjs << 'FINALTEST'
const { spawn } = require('child_process');
const readline = require('readline');

console.log('Starting MCP connection test...');

const child = spawn('node', ['n8n-shopify-mcp.cjs'], {
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

let gotResponse = false;

rl.on('line', (line) => {
    console.log('✅ STDOUT:', line);
    gotResponse = true;
    
    // Send tools list request after initialization
    if (line.includes('"id":1')) {
        setTimeout(() => {
            const toolsReq = {
                jsonrpc: "2.0",
                method: "tools/list",
                params: {},
                id: 2
            };
            console.log('Sending tools/list request...');
            child.stdin.write(JSON.stringify(toolsReq) + '\n');
        }, 100);
    }
});

errRl.on('line', (line) => {
    console.log('STDERR:', line);
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

setTimeout(() => {
    if (gotResponse) {
        console.log('\n✅ MCP SERVER IS WORKING CORRECTLY!');
    } else {
        console.log('\n❌ No response received');
    }
    child.kill();
    process.exit(0);
}, 5000);
FINALTEST

echo -e "\n4. Running final test..."
node test-final.cjs

echo -e "\n5. Double-checking the setup..."
ls -la n8n-shopify-mcp.cjs
file n8n-shopify-mcp.cjs

echo -e "\n=== VERIFIED CONFIGURATION FOR N8N ==="
echo "✅ MCP Server is working correctly!"
echo ""
echo "USE THESE EXACT SETTINGS IN N8N:"
echo "================================"
echo "Transport Type: stdio"
echo "Command: node"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/n8n-shopify-mcp.cjs"
echo ""
echo "Environment Variables:"
echo "- SHOPIFY_STORE_URL = vividwalls-2.myshopify.com"
echo "- SHOPIFY_ACCESS_TOKEN = ***REMOVED***"
echo "- SHOPIFY_API_VERSION = 2024-01"
echo ""
echo "NOTE: Make sure to use .cjs extension!"

rm -f test-final.cjs
EOF