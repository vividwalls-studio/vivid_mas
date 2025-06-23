#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "=== Debugging Shopify MCP Protocol ==="
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Checking the actual MCP server implementation..."
echo "Looking for protocol version in source:"
grep -r "protocolVersion\|protocol_version\|initialize" src/index.ts | head -10

echo -e "\n2. Creating a comprehensive protocol test..."
cat > debug-protocol.mjs << 'DEBUGSCRIPT'
import { spawn } from 'child_process';
import { createInterface } from 'readline';

const testProtocols = async () => {
    const protocols = [
        "2024-11-05",
        "0.1.0", 
        "1.0.0",
        "2024-01-01"
    ];
    
    for (const protocol of protocols) {
        console.log(`\n=== Testing protocol version: ${protocol} ===`);
        await testProtocol(protocol);
    }
};

const testProtocol = (protocolVersion) => {
    return new Promise((resolve) => {
        const env = {
            ...process.env,
            MYSHOPIFY_DOMAIN: 'vividwalls-2.myshopify.com',
            SHOPIFY_ACCESS_TOKEN: '***REMOVED***',
            SHOPIFY_API_VERSION: '2024-01'
        };

        const mcpProcess = spawn('node', ['build/index.js'], {
            env: env,
            stdio: ['pipe', 'pipe', 'pipe']
        });

        const rl = createInterface({ input: mcpProcess.stdout });
        const errRl = createInterface({ input: mcpProcess.stderr });
        
        let responseReceived = false;

        // Different initialization formats to try
        const initRequests = [
            {
                jsonrpc: "2.0",
                method: "initialize",
                params: {
                    protocolVersion: protocolVersion,
                    capabilities: {},
                    clientInfo: { name: "n8n", version: "1.0.0" }
                },
                id: 1
            },
            {
                jsonrpc: "2.0",
                method: "initialize",
                params: {
                    protocol_version: protocolVersion,
                    capabilities: {}
                },
                id: 1
            }
        ];

        rl.on('line', (line) => {
            console.log('STDOUT:', line);
            responseReceived = true;
            try {
                const parsed = JSON.parse(line);
                console.log('Parsed response:', JSON.stringify(parsed, null, 2));
            } catch (e) {
                // Not JSON
            }
        });

        errRl.on('line', (line) => {
            console.log('STDERR:', line);
        });

        mcpProcess.on('exit', (code) => {
            console.log(`Process exited with code: ${code}`);
            resolve();
        });

        // Try different request formats
        setTimeout(() => {
            console.log('Sending request format 1...');
            mcpProcess.stdin.write(JSON.stringify(initRequests[0]) + '\n');
        }, 100);

        setTimeout(() => {
            if (!responseReceived) {
                console.log('Sending request format 2...');
                mcpProcess.stdin.write(JSON.stringify(initRequests[1]) + '\n');
            }
        }, 1000);

        setTimeout(() => {
            mcpProcess.kill();
            resolve();
        }, 3000);
    });
};

testProtocols().then(() => console.log('\nAll tests complete'));
DEBUGSCRIPT

echo -e "\n3. Running protocol debug..."
node debug-protocol.mjs

echo -e "\n4. Checking if it's using the MCP SDK..."
grep -r "@modelcontextprotocol/sdk" package.json

echo -e "\n5. Looking at the actual server startup code..."
head -50 src/index.ts

echo -e "\n6. Checking build output for clues..."
head -100 build/index.js | grep -E "initialize|protocol|stdio|Server"

echo -e "\n7. Looking for example usage or tests..."
find . -name "*.test.*" -o -name "*example*" -o -name "*test*" | grep -v node_modules | head -10

rm -f debug-protocol.mjs
EOF