#!/bin/bash

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
MCP_PATH="/opt/mcp-servers/shopify-mcp-server"

echo "=== Shopify MCP Server Check ==="
echo "Droplet: $DROPLET_IP"
echo "You'll be prompted for SSH passphrase (freedom)"
echo ""

# Single SSH command to check everything
ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
echo "1. Checking if Shopify MCP directory exists..."
if [ -d "/opt/mcp-servers/shopify-mcp-server" ]; then
    echo "✅ Directory exists"
    
    echo -e "\n2. Directory contents:"
    ls -la /opt/mcp-servers/shopify-mcp-server/
    
    echo -e "\n3. Checking for dist/index.js..."
    if [ -f "/opt/mcp-servers/shopify-mcp-server/dist/index.js" ]; then
        echo "✅ dist/index.js exists"
    else
        echo "❌ dist/index.js NOT FOUND - needs compilation"
        
        echo -e "\n4. Checking for source files..."
        ls -la /opt/mcp-servers/shopify-mcp-server/src/ 2>/dev/null || echo "No src directory"
        
        echo -e "\n5. Checking package.json..."
        if [ -f "/opt/mcp-servers/shopify-mcp-server/package.json" ]; then
            cat /opt/mcp-servers/shopify-mcp-server/package.json
        fi
    fi
    
    echo -e "\n6. Checking Node.js version..."
    node --version || echo "Node.js not installed"
    
    echo -e "\n7. Checking for node_modules..."
    if [ -d "/opt/mcp-servers/shopify-mcp-server/node_modules" ]; then
        echo "✅ node_modules exists"
    else
        echo "❌ node_modules NOT FOUND - needs npm install"
    fi
    
    echo -e "\n8. Trying to build if needed..."
    cd /opt/mcp-servers/shopify-mcp-server
    if [ ! -f "dist/index.js" ] && [ -f "package.json" ]; then
        echo "Installing dependencies..."
        npm install
        echo "Building TypeScript..."
        npm run build
    fi
    
    echo -e "\n9. Testing MCP server startup..."
    SHOPIFY_STORE_URL=vividwalls-2.myshopify.com \
    SHOPIFY_ACCESS_TOKEN=***REMOVED*** \
    SHOPIFY_API_VERSION=2024-01 \
    timeout 5 node dist/index.js 2>&1 || echo "Server test complete"
    
else
    echo "❌ Directory /opt/mcp-servers/shopify-mcp-server does NOT exist!"
    
    echo -e "\n Checking /opt/mcp-servers contents:"
    ls -la /opt/mcp-servers/ 2>/dev/null || echo "/opt/mcp-servers does not exist"
    
    echo -e "\n Checking root directory for mcp-servers:"
    find /root -name "shopify-mcp-server" -type d 2>/dev/null | head -10
fi
EOF