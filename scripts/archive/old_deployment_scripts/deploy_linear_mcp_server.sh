#!/bin/bash

# Deploy Linear MCP Server to DigitalOcean droplet

echo "Starting Linear MCP server deployment..."

# Server details
SERVER_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
REMOTE_PATH="/opt/mcp-servers/linear-mcp-server"
LOCAL_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/core/linear-mcp-server"

# Create the directory structure on remote server
echo "Creating directory structure on remote server..."
ssh -i $SSH_KEY root@$SERVER_IP "mkdir -p /opt/mcp-servers"

# Copy the Linear MCP server files
echo "Copying Linear MCP server files..."
scp -i $SSH_KEY -r $LOCAL_PATH root@$SERVER_IP:/opt/mcp-servers/

# Install dependencies and build on remote server
echo "Installing dependencies and building on remote server..."
ssh -i $SSH_KEY root@$SERVER_IP << 'EOF'
cd /opt/mcp-servers/linear-mcp-server
npm install
npm run build

# Create a systemd service for the Linear MCP server (optional, for standalone use)
cat > /etc/systemd/system/linear-mcp-server.service << 'SERVICEEOF'
[Unit]
Description=Linear MCP Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/mcp-servers/linear-mcp-server
Environment="LINEAR_API_KEY=lin_oauth_8f06487d693f3fee7eaaf0a440af72aae4c2305b4d9fa369524eed8acea9aa12"
ExecStart=/usr/bin/node /opt/mcp-servers/linear-mcp-server/build/index.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Don't start the service yet as it will be used by n8n
# systemctl daemon-reload
# systemctl enable linear-mcp-server

echo "Linear MCP server deployed successfully!"
echo "Server location: /opt/mcp-servers/linear-mcp-server"
echo "Build output: /opt/mcp-servers/linear-mcp-server/build/index.js"
EOF

echo "Deployment complete!"