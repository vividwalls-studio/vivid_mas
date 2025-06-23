#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Diagnosing n8n MCP Connection Issue ==="
echo "Credential ID: IDMt4Ps8BghDc2V67j"
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Checking current wrapper content..."
echo "=== n8n-shopify-mcp.cjs content ==="
cat n8n-shopify-mcp.cjs

echo -e "\n2. Creating a debug version of the wrapper..."
cp n8n-shopify-mcp.cjs n8n-shopify-mcp-debug.cjs

cat > n8n-shopify-mcp-debug.cjs << 'DEBUGWRAPPER'
#!/usr/bin/env node

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

// Create debug log file
const logFile = path.join(__dirname, 'mcp-debug.log');
const log = (msg) => {
    const timestamp = new Date().toISOString();
    fs.appendFileSync(logFile, `${timestamp}: ${msg}\n`);
    console.error(`${timestamp}: ${msg}`);
};

log('=== MCP Wrapper Started ===');
log(`Process PID: ${process.pid}`);
log(`Node version: ${process.version}`);
log(`Working directory: ${process.cwd()}`);
log(`Script directory: ${__dirname}`);

// Log environment variables
log('Environment variables:');
log(`  SHOPIFY_STORE_URL: ${process.env.SHOPIFY_STORE_URL}`);
log(`  SHOPIFY_ACCESS_TOKEN: ${process.env.SHOPIFY_ACCESS_TOKEN ? 'SET' : 'NOT SET'}`);
log(`  SHOPIFY_API_VERSION: ${process.env.SHOPIFY_API_VERSION}`);
log(`  MYSHOPIFY_DOMAIN: ${process.env.MYSHOPIFY_DOMAIN}`);

// Map environment variables
const env = {
    ...process.env,
    MYSHOPIFY_DOMAIN: process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN,
    SHOPIFY_ACCESS_TOKEN: process.env.SHOPIFY_ACCESS_TOKEN,
    SHOPIFY_API_VERSION: process.env.SHOPIFY_API_VERSION || '2024-01',
    NODE_ENV: 'production'
};

// Validate required variables
if (!env.MYSHOPIFY_DOMAIN) {
    log('ERROR: SHOPIFY_STORE_URL or MYSHOPIFY_DOMAIN required');
    process.exit(1);
}

if (!env.SHOPIFY_ACCESS_TOKEN) {
    log('ERROR: SHOPIFY_ACCESS_TOKEN required');
    process.exit(1);
}

log('Starting MCP server process...');
log(`Command: node ${path.join(__dirname, 'build/index.js')}`);

// Start the MCP server
const serverProcess = spawn('node', [path.join(__dirname, 'build/index.js')], {
    env: env,
    stdio: 'inherit',
    cwd: __dirname
});

serverProcess.on('error', (err) => {
    log(`ERROR spawning process: ${err.message}`);
    process.exit(1);
});

serverProcess.on('exit', (code, signal) => {
    log(`Server process exited with code: ${code}, signal: ${signal}`);
    if (signal) {
        process.exit(1);
    } else {
        process.exit(code || 0);
    }
});

// Handle signals
process.on('SIGTERM', () => {
    log('Received SIGTERM');
    serverProcess.kill('SIGTERM');
});

process.on('SIGINT', () => {
    log('Received SIGINT');
    serverProcess.kill('SIGINT');
});

process.on('uncaughtException', (err) => {
    log(`Uncaught exception: ${err.message}`);
    log(err.stack);
    process.exit(1);
});

log('Wrapper initialized, waiting for MCP communication...');
DEBUGWRAPPER

chmod +x n8n-shopify-mcp-debug.cjs

echo -e "\n3. Testing debug wrapper..."
rm -f mcp-debug.log
SHOPIFY_STORE_URL=vividwalls-2.myshopify.com \
SHOPIFY_ACCESS_TOKEN=***REMOVED*** \
SHOPIFY_API_VERSION=2024-01 \
timeout 3 node n8n-shopify-mcp-debug.cjs 2>&1 || true

echo -e "\n4. Checking debug log..."
if [ -f mcp-debug.log ]; then
    echo "=== Debug Log Contents ==="
    cat mcp-debug.log
fi

echo -e "\n5. Creating a simpler direct wrapper..."
cat > shopify-mcp-direct.cjs << 'DIRECTWRAPPER'
#!/usr/bin/env node

// Direct wrapper that just sets env and runs the server
process.env.MYSHOPIFY_DOMAIN = process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN || 'vividwalls-2.myshopify.com';

if (!process.env.SHOPIFY_ACCESS_TOKEN) {
    console.error('Error: SHOPIFY_ACCESS_TOKEN required');
    process.exit(1);
}

// Load and run the ESM module
require('child_process').spawn('node', ['build/index.js'], {
    stdio: 'inherit',
    env: process.env
});
DIRECTWRAPPER

chmod +x shopify-mcp-direct.cjs

echo -e "\n6. Testing n8n connection patterns..."
cat > test-n8n-patterns.cjs << 'N8NTEST'
const { spawn } = require('child_process');
const readline = require('readline');

console.log('Testing different stdio configurations...\n');

const configs = [
    { name: 'inherit', stdio: 'inherit' },
    { name: 'pipe', stdio: ['pipe', 'pipe', 'pipe'] },
    { name: 'mixed', stdio: ['pipe', 'pipe', 'inherit'] }
];

async function testConfig(config) {
    console.log(`Testing ${config.name} configuration...`);
    
    return new Promise((resolve) => {
        const child = spawn('node', ['build/index.js'], {
            env: {
                ...process.env,
                MYSHOPIFY_DOMAIN: 'vividwalls-2.myshopify.com',
                SHOPIFY_ACCESS_TOKEN: '***REMOVED***',
                SHOPIFY_API_VERSION: '2024-01'
            },
            stdio: config.stdio
        });

        let output = '';
        
        if (config.stdio === 'pipe' || config.stdio[0] === 'pipe') {
            const rl = readline.createInterface({ input: child.stdout });
            rl.on('line', (line) => {
                output += line + '\n';
            });
            
            // Send MCP init
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
                child.stdin.write(JSON.stringify(init) + '\n');
            }, 100);
        }

        setTimeout(() => {
            console.log(`Result: ${output ? 'Got response' : 'No response'}`);
            if (output) console.log(output);
            child.kill();
            resolve();
        }, 2000);
    });
}

(async () => {
    for (const config of configs) {
        await testConfig(config);
        console.log('---\n');
    }
})();
N8NTEST

echo -e "\n7. Running stdio tests..."
node test-n8n-patterns.cjs

echo -e "\n=== SUMMARY ==="
echo "Debug wrapper created: /opt/mcp-servers/shopify-mcp-server/n8n-shopify-mcp-debug.cjs"
echo "This will create detailed logs when n8n tries to connect."
echo ""
echo "Try updating your n8n credential to use:"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/n8n-shopify-mcp-debug.cjs"
echo ""
echo "After testing, check the log file:"
echo "ssh -i ~/.ssh/digitalocean root@157.230.13.13 'cat /opt/mcp-servers/shopify-mcp-server/mcp-debug.log'"

rm -f test-n8n-patterns.cjs
EOF