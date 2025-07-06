#!/bin/bash

# Deploy Postiz MCP Server to DigitalOcean Droplet

echo "🚀 Deploying Postiz MCP Server to DigitalOcean Droplet..."

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_PATH="/opt/mcp-servers/postiz-mcp-server"
LOCAL_PATH="."

# Change to script directory
cd "$(dirname "$0")"

# Build the project locally first
echo "📦 Building project..."
npm run build

# Create remote directory if it doesn't exist
echo "📁 Creating remote directory..."
ssh -i "$SSH_KEY" root@$DROPLET_IP "mkdir -p $REMOTE_PATH"

# Copy files to droplet
echo "📤 Copying files to droplet..."
rsync -avz --delete \
  -e "ssh -i $SSH_KEY" \
  --exclude 'node_modules' \
  --exclude '.env' \
  --exclude '.git' \
  --exclude '*.log' \
  --exclude 'deploy.sh' \
  ./ root@$DROPLET_IP:$REMOTE_PATH/

# Install dependencies on droplet
echo "📦 Installing dependencies on droplet..."
ssh -i "$SSH_KEY" root@$DROPLET_IP "cd $REMOTE_PATH && npm install --production"

# Update n8n MCP configuration
echo "🔧 Updating n8n MCP configuration..."
ssh -i "$SSH_KEY" root@$DROPLET_IP << 'REMOTE_SCRIPT'
cd /opt/mcp-servers

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    apt-get update && apt-get install -y jq
fi

# Update the n8n MCP config
if [ -f "n8n-mcp-config.json" ]; then
    # Backup existing config
    cp n8n-mcp-config.json n8n-mcp-config.json.backup
    
    # Add or update postiz-mcp configuration
    jq '.mcpServers["postiz-mcp"] = {
        "command": "node",
        "args": ["dist/index.js"],
        "cwd": "/opt/mcp-servers/postiz-mcp-server",
        "env": {
            "POSTIZ_API_KEY": "8895d94a-8d76-4d69-a212-23f248a7f78d"
        }
    }' n8n-mcp-config.json > /tmp/updated-config.json
    
    mv /tmp/updated-config.json n8n-mcp-config.json
    echo "✅ Updated n8n MCP configuration"
else
    echo "❌ n8n-mcp-config.json not found!"
fi

# Show the updated configuration
echo "📄 Current MCP configuration:"
cat n8n-mcp-config.json | jq .

# Restart n8n to pick up the new MCP server
echo "🔄 Restarting n8n..."
docker restart n8n

echo "✅ Deployment complete!"
echo "🔍 Checking n8n status..."
docker ps | grep n8n
REMOTE_SCRIPT

echo ""
echo "✅ Postiz MCP Server deployed successfully!"
echo "📝 Next steps:"
echo "   1. SSH into droplet: ssh -i ~/.ssh/digitalocean root@157.230.13.13"
echo "   2. Check logs: docker logs n8n --tail 50"
echo "   3. Verify MCP server is available in n8n workflows"
echo "   4. Update the API key if needed in /opt/mcp-servers/n8n-mcp-config.json"