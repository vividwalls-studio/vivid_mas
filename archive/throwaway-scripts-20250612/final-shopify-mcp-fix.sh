#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "Final Shopify MCP configuration..."
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server

echo "1. Checking current environment setup..."
echo "Current .env file:"
cat .env

echo -e "\n2. Updating .env file with correct variable names..."
cat > .env << 'ENVFILE'
MYSHOPIFY_DOMAIN=vividwalls-2.myshopify.com
SHOPIFY_ACCESS_TOKEN=***REMOVED***
SHOPIFY_API_VERSION=2024-01
SHOPIFY_STORE_URL=vividwalls-2.myshopify.com
ENVFILE

echo -e "\n3. Testing direct execution..."
source .env
timeout 3 node build/index.js 2>&1 || true

echo -e "\n4. Creating a better wrapper that handles both variable names..."
cat > mcp-wrapper.cjs << 'WRAPPER'
#!/usr/bin/env node

// CommonJS wrapper for ESM module
const { spawn } = require('child_process');

// Map environment variables
const env = {
    ...process.env,
    MYSHOPIFY_DOMAIN: process.env.SHOPIFY_STORE_URL || process.env.MYSHOPIFY_DOMAIN || 'vividwalls-2.myshopify.com',
    SHOPIFY_ACCESS_TOKEN: process.env.SHOPIFY_ACCESS_TOKEN,
    SHOPIFY_API_VERSION: process.env.SHOPIFY_API_VERSION || '2024-01'
};

// Spawn the actual MCP server
const child = spawn('node', ['build/index.js'], {
    env: env,
    stdio: 'inherit'
});

child.on('error', (err) => {
    console.error('Failed to start MCP server:', err);
    process.exit(1);
});

child.on('exit', (code) => {
    process.exit(code);
});
WRAPPER

chmod +x mcp-wrapper.cjs

echo -e "\n5. Testing the CommonJS wrapper..."
SHOPIFY_STORE_URL=vividwalls-2.myshopify.com \
SHOPIFY_ACCESS_TOKEN=***REMOVED*** \
timeout 3 node mcp-wrapper.cjs 2>&1 || true

echo -e "\n=== CONFIGURATION SUMMARY ==="
echo "✅ Environment variables updated in .env"
echo "✅ Created mcp-wrapper.cjs for n8n compatibility"
echo ""
echo "UPDATE YOUR N8N CONFIGURATION TO:"
echo "Command: node"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/mcp-wrapper.cjs"
echo ""
echo "Environment Variables (keep as is):"
echo "- SHOPIFY_STORE_URL = vividwalls-2.myshopify.com"
echo "- SHOPIFY_ACCESS_TOKEN = ***REMOVED***" 
echo "- SHOPIFY_API_VERSION = 2024-01"
EOF