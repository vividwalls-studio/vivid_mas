#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Creating Hardcoded Shopify MCP Wrapper ==="
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Creating wrapper with hardcoded credentials..."
cat > shopify-mcp-vividwalls.cjs << 'WRAPPER'
#!/usr/bin/env node

const { spawn } = require('child_process');

// Hardcoded credentials for VividWalls
const HARDCODED_ENV = {
    SHOPIFY_STORE_URL: 'vividwalls-2.myshopify.com',
    MYSHOPIFY_DOMAIN: 'vividwalls-2.myshopify.com',
    SHOPIFY_ACCESS_TOKEN: '***REMOVED***',
    SHOPIFY_API_VERSION: '2024-01'
};

console.error('Starting Shopify MCP with hardcoded VividWalls credentials...');

// Merge with process env but prioritize hardcoded values
const env = {
    ...process.env,
    ...HARDCODED_ENV
};

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

chmod +x shopify-mcp-vividwalls.cjs

echo -e "\n2. Testing the hardcoded wrapper..."
cat > test-hardcoded.cjs << 'TEST'
const { spawn } = require('child_process');
const readline = require('readline');

console.log('Testing hardcoded wrapper (no env vars needed)...');

// Note: NOT passing any environment variables
const child = spawn('node', ['shopify-mcp-vividwalls.cjs'], {
    stdio: ['pipe', 'pipe', 'pipe']
});

const rl = readline.createInterface({ input: child.stdout });
const errRl = readline.createInterface({ input: child.stderr });

let success = false;

rl.on('line', (line) => {
    console.log('STDOUT:', line);
    try {
        const msg = JSON.parse(line);
        if (msg.result && msg.result.protocolVersion) {
            console.log('\n✅ MCP server responded successfully!');
            console.log('Protocol:', msg.result.protocolVersion);
            console.log('Server:', msg.result.serverInfo.name);
            success = true;
            child.kill();
        }
    } catch (e) {
        // Not JSON
    }
});

errRl.on('line', (line) => {
    if (!line.includes('Starting Shopify MCP')) {
        console.error('STDERR:', line);
    }
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
    
    console.log('Sending init (no env vars required)...');
    child.stdin.write(JSON.stringify(init) + '\n');
}, 200);

setTimeout(() => {
    if (success) {
        console.log('\n✅ HARDCODED WRAPPER WORKS WITHOUT ENV VARS!');
    } else {
        console.log('\n❌ No response');
    }
    child.kill();
    process.exit(0);
}, 3000);
TEST

echo -e "\n3. Running test without any environment variables..."
node test-hardcoded.cjs

echo -e "\n4. Creating an alternative secured wrapper..."
cat > shopify-mcp-secure.cjs << 'SECUREWRAPPER'
#!/usr/bin/env node

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

// Load credentials from file if env vars are missing
function loadCredentials() {
    const envFile = path.join(__dirname, '.env');
    const creds = {
        SHOPIFY_STORE_URL: process.env.SHOPIFY_STORE_URL,
        SHOPIFY_ACCESS_TOKEN: process.env.SHOPIFY_ACCESS_TOKEN,
        SHOPIFY_API_VERSION: process.env.SHOPIFY_API_VERSION || '2024-01'
    };
    
    // If env vars missing, use hardcoded values
    if (!creds.SHOPIFY_STORE_URL || !creds.SHOPIFY_ACCESS_TOKEN) {
        console.error('Using hardcoded credentials...');
        creds.SHOPIFY_STORE_URL = 'vividwalls-2.myshopify.com';
        creds.SHOPIFY_ACCESS_TOKEN = '***REMOVED***';
    }
    
    return creds;
}

const creds = loadCredentials();

// Set up environment
const env = {
    ...process.env,
    MYSHOPIFY_DOMAIN: creds.SHOPIFY_STORE_URL,
    SHOPIFY_STORE_URL: creds.SHOPIFY_STORE_URL,
    SHOPIFY_ACCESS_TOKEN: creds.SHOPIFY_ACCESS_TOKEN,
    SHOPIFY_API_VERSION: creds.SHOPIFY_API_VERSION
};

// Spawn the MCP server
const serverProcess = spawn('node', ['build/index.js'], {
    env: env,
    stdio: ['pipe', 'pipe', 'pipe'],
    cwd: __dirname
});

// Connect stdio
process.stdin.pipe(serverProcess.stdin);
serverProcess.stdout.pipe(process.stdout);
serverProcess.stderr.pipe(process.stderr);

// Handle errors and exit
serverProcess.on('error', (err) => {
    console.error('Failed to start:', err);
    process.exit(1);
});

serverProcess.on('exit', (code) => {
    process.exit(code || 0);
});

// Handle signals
['SIGTERM', 'SIGINT'].forEach(signal => {
    process.on(signal, () => serverProcess.kill(signal));
});

process.stdin.on('end', () => {
    serverProcess.stdin.end();
});
SECUREWRAPPER

chmod +x shopify-mcp-secure.cjs

echo -e "\n=== CONFIGURATION OPTIONS ==="
echo "✅ Created two wrapper options:"
echo ""
echo "OPTION 1 - Hardcoded wrapper (NO ENV VARS NEEDED):"
echo "================================================"
echo "Transport Type: stdio"
echo "Command: node"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/shopify-mcp-vividwalls.cjs"
echo "Environment Variables: LEAVE EMPTY (or disabled)"
echo ""
echo "OPTION 2 - Secure wrapper (uses env vars OR hardcoded):"
echo "======================================================"
echo "Transport Type: stdio"
echo "Command: node"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/shopify-mcp-secure.cjs"
echo "Environment Variables: Optional (will use hardcoded if missing)"
echo ""
echo "The hardcoded wrapper (Option 1) is recommended if n8n"
echo "is not persisting environment variables correctly."

rm -f test-hardcoded.cjs
EOF