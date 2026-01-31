#!/bin/bash
# Configure Medusa MCP Server with n8n

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
REMOTE_USER="root"

echo "🔧 Configuring Medusa MCP Server with n8n..."
echo ""

# Function to get Medusa API token instructions
show_api_token_instructions() {
    echo "📝 To generate a Medusa API token:"
    echo "1. Visit https://medusa.vividwalls.blog/app"
    echo "2. Login with your admin credentials"
    echo "3. Go to Settings → API Keys"
    echo "4. Create a new API key with full permissions"
    echo "5. Copy the generated token"
    echo ""
    read -p "Enter your Medusa API token: " MEDUSA_API_TOKEN
    
    if [ -z "$MEDUSA_API_TOKEN" ]; then
        echo "❌ API token is required. Exiting."
        exit 1
    fi
}

# Get API token
show_api_token_instructions

# Update MCP configuration on droplet
echo "📤 Updating MCP configuration..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << EOF
cd /root/vivid_mas

# Update the MCP server environment
cat > /opt/mcp-servers/medusa-mcp-server/.env << 'EOC'
MEDUSA_BASE_URL=http://medusa:9000
MEDUSA_API_TOKEN=$MEDUSA_API_TOKEN
NODE_ENV=production
EOC

# Update n8n's MCP configuration
if [ -f n8n_mcp_config.json ]; then
    # Backup existing config
    cp n8n_mcp_config.json n8n_mcp_config.backup-$(date +%Y%m%d_%H%M%S).json
    
    # Add Medusa MCP to existing config using jq
    jq '.mcpServers.medusa = {
        "command": "node",
        "args": ["/opt/mcp-servers/medusa-mcp-server/build/index.js"],
        "env": {
            "MEDUSA_BASE_URL": "http://medusa:9000",
            "MEDUSA_API_TOKEN": "'$MEDUSA_API_TOKEN'"
        }
    }' n8n_mcp_config.json > n8n_mcp_config_new.json
    mv n8n_mcp_config_new.json n8n_mcp_config.json
else
    # Create new MCP config
    cat > n8n_mcp_config.json << EOC
{
    "mcpServers": {
        "medusa": {
            "command": "node",
            "args": ["/opt/mcp-servers/medusa-mcp-server/build/index.js"],
            "env": {
                "MEDUSA_BASE_URL": "http://medusa:9000",
                "MEDUSA_API_TOKEN": "$MEDUSA_API_TOKEN"
            }
        }
    }
}
EOC
fi

echo "✅ MCP configuration updated"
EOF

# Test MCP server
echo ""
echo "🧪 Testing MCP server..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
cd /opt/mcp-servers/medusa-mcp-server

# Test the server can start
timeout 5s node build/index.js 2>&1 | head -20 || true

echo ""
echo "✅ MCP server test completed"
EOF

# Update Business Manager agent workflow
echo ""
echo "📝 Next steps for n8n integration:"
echo ""
echo "1. Login to n8n at https://n8n.vividwalls.blog"
echo "2. Go to Settings → Community Nodes"
echo "3. Install @modelcontextprotocol/n8n-nodes if not already installed"
echo "4. Edit the Business Manager Agent workflow"
echo "5. Add MCP node and configure with 'medusa' server"
echo "6. Available tools:"
echo "   - list-orders"
echo "   - get-order"
echo "   - get-sales-analytics"
echo "   - get-revenue-report"
echo "   - sync-products-with-shopify"
echo "   - get-inventory-levels"
echo "   - list-customers"
echo "   - get-customer-analytics"
echo "   - list-discounts"
echo "   - create-discount"
echo "   - get-tax-report"
echo ""
echo "✅ Configuration complete!"