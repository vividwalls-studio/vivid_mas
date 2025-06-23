#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Direct Shopify MCP Server Test ==="
echo "You'll be prompted for SSH passphrase (freedom)"
echo ""

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Checking if index.js exists and is executable..."
ls -la build/index.js

echo -e "\n2. Checking environment variables in .env file..."
if [ -f .env ]; then
    echo "Contents of .env:"
    cat .env
else
    echo "No .env file found"
fi

echo -e "\n3. Testing MCP server initialization..."
cat > test-mcp.js << 'EOTEST'
const { spawn } = require('child_process');
const readline = require('readline');

console.log('Starting MCP server test...');

const env = {
    ...process.env,
    SHOPIFY_STORE_URL: 'vividwalls-2.myshopify.com',
    SHOPIFY_ACCESS_TOKEN: '***REMOVED***',
    SHOPIFY_API_VERSION: '2024-01'
};

const mcpProcess = spawn('node', ['build/index.js'], {
    env: env,
    stdio: ['pipe', 'pipe', 'pipe']
});

const rl = readline.createInterface({
    input: mcpProcess.stdout
});

// Send initialization request
const initRequest = {
    jsonrpc: "2.0",
    method: "initialize",
    params: {
        protocolVersion: "2024-11-05",
        capabilities: {},
        clientInfo: {
            name: "test-client",
            version: "1.0.0"
        }
    },
    id: 1
};

console.log('Sending initialization request:', JSON.stringify(initRequest));
mcpProcess.stdin.write(JSON.stringify(initRequest) + '\n');

// Handle responses
let responseReceived = false;
rl.on('line', (line) => {
    console.log('Response:', line);
    responseReceived = true;
    
    try {
        const response = JSON.parse(line);
        if (response.id === 1) {
            console.log('✅ Initialization successful!');
            
            // Send list tools request
            const toolsRequest = {
                jsonrpc: "2.0",
                method: "tools/list",
                params: {},
                id: 2
            };
            console.log('\nSending tools list request...');
            mcpProcess.stdin.write(JSON.stringify(toolsRequest) + '\n');
        } else if (response.id === 2) {
            console.log('✅ Tools retrieved successfully!');
            console.log('Number of tools:', response.result.tools.length);
            mcpProcess.kill();
            process.exit(0);
        }
    } catch (e) {
        console.error('Failed to parse response:', e.message);
    }
});

// Error handling
mcpProcess.stderr.on('data', (data) => {
    console.error('MCP Error:', data.toString());
});

mcpProcess.on('error', (error) => {
    console.error('Process error:', error);
    process.exit(1);
});

// Timeout after 10 seconds
setTimeout(() => {
    if (!responseReceived) {
        console.error('❌ Timeout: No response from MCP server after 10 seconds');
        mcpProcess.kill();
        process.exit(1);
    }
}, 10000);
EOTEST

echo -e "\n4. Running MCP test..."
node test-mcp.js

echo -e "\n5. Checking for TypeScript compilation issues..."
if [ -f tsconfig.json ]; then
    echo "TypeScript config:"
    cat tsconfig.json
fi

echo -e "\n6. Checking package.json type..."
grep -E '"type":|"main":' package.json

echo -e "\n7. Testing direct execution with debugging..."
echo "Running with DEBUG enabled..."
DEBUG=* SHOPIFY_STORE_URL=vividwalls-2.myshopify.com \
SHOPIFY_ACCESS_TOKEN=***REMOVED*** \
SHOPIFY_API_VERSION=2024-01 \
timeout 5 node build/index.js 2>&1 | head -50 || true

echo -e "\n8. Checking if it's an ESM module issue..."
if grep -q '"type": "module"' package.json; then
    echo "This is an ESM module. Testing with proper import..."
    node --input-type=module -e "
    import { fileURLToPath } from 'url';
    import { dirname, join } from 'path';
    const __filename = fileURLToPath(import.meta.url);
    const __dirname = dirname(__filename);
    console.log('Testing ESM import from:', join(__dirname, 'build/index.js'));
    " 2>&1 || true
fi

echo -e "\n9. Looking for any startup scripts or wrappers..."
find . -name "*.sh" -o -name "start*" -o -name "run*" 2>/dev/null | grep -v node_modules | head -10

rm -f test-mcp.js
EOF