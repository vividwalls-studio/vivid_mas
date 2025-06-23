#!/bin/bash

DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"

echo "Fixing Shopify MCP server path..."
echo "You'll be prompted for SSH passphrase (freedom)"

ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF'
cd /opt/mcp-servers/shopify-mcp-server
echo "Current directory structure:"
ls -la

echo -e "\nChecking build directory:"
ls -la build/ | head -5

echo -e "\nThe compiled file is in 'build' not 'dist'"
echo "Your n8n configuration should use:"
echo "Arguments: /opt/mcp-servers/shopify-mcp-server/build/index.js"
EOF