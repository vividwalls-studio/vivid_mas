#!/bin/bash

# Deploy Marketing Director MCP Servers to Digital Ocean Droplet

set -e

DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
LOCAL_MCP_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers"
REMOTE_MCP_PATH="/root/vivid_mas/services/mcp-servers"

echo "🚀 Deploying Marketing Director MCP Servers to Digital Ocean Droplet..."

# List of MCP servers to deploy
MCP_SERVERS=(
    "marketing-director-prompts"
    "marketing-director-resource"
)

# First, check if the remote directory exists
echo "📁 Checking remote directory structure..."
ssh -i $SSH_KEY root@$DROPLET_IP "mkdir -p $REMOTE_MCP_PATH"

# Deploy each MCP server
for server in "${MCP_SERVERS[@]}"; do
    echo ""
    echo "📦 Deploying $server..."
    
    # Check if server exists locally
    if [ -d "$LOCAL_MCP_PATH/$server" ]; then
        echo "  ✅ Found $server locally"
        
        # Create archive excluding node_modules
        echo "  📤 Creating archive..."
        cd "$LOCAL_MCP_PATH"
        tar -czf "$server.tar.gz" \
            --exclude='node_modules' \
            --exclude='dist' \
            --exclude='.git' \
            "$server"
        
        # Upload to droplet
        echo "  📤 Uploading to droplet..."
        scp -i $SSH_KEY "$server.tar.gz" root@$DROPLET_IP:/tmp/
        
        # Extract on droplet and install dependencies
        echo "  📥 Extracting and installing..."
        ssh -i $SSH_KEY root@$DROPLET_IP "
            cd $REMOTE_MCP_PATH &&
            tar -xzf /tmp/$server.tar.gz &&
            rm /tmp/$server.tar.gz &&
            cd $server &&
            npm install &&
            npm run build &&
            echo '  ✅ $server deployed successfully'
        "
        
        # Clean up local archive
        rm "$server.tar.gz"
        
    else
        echo "  ❌ $server not found at $LOCAL_MCP_PATH/$server"
    fi
done

echo ""
echo "🔧 Setting up services on droplet..."

# Create systemd service files for each MCP server
ssh -i $SSH_KEY root@$DROPLET_IP "
# Marketing Director Resource MCP Server
cat > /etc/systemd/system/marketing-director-resource-mcp.service << 'EOF'
[Unit]
Description=Marketing Director Resource MCP Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$REMOTE_MCP_PATH/marketing-director-resource
Environment='PORT=3003'
Environment='NODE_ENV=production'
Environment='SUPABASE_URL=\${SUPABASE_URL}'
Environment='SUPABASE_SERVICE_ROLE_KEY=\${SUPABASE_SERVICE_ROLE_KEY}'
ExecStart=/usr/bin/node dist/index.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Marketing Director Prompts MCP Server
cat > /etc/systemd/system/marketing-director-prompts-mcp.service << 'EOF'
[Unit]
Description=Marketing Director Prompts MCP Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$REMOTE_MCP_PATH/marketing-director-prompts
Environment='PORT=3004'
Environment='NODE_ENV=production'
ExecStart=/usr/bin/node dist/index.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload
"

echo ""
echo "🚀 Starting MCP servers..."

# Start the services
ssh -i $SSH_KEY root@$DROPLET_IP "
systemctl enable marketing-director-resource-mcp.service
systemctl enable marketing-director-prompts-mcp.service
systemctl start marketing-director-resource-mcp.service
systemctl start marketing-director-prompts-mcp.service
"

echo ""
echo "✅ Checking service status..."

# Check if services are running
ssh -i $SSH_KEY root@$DROPLET_IP "
echo '=== Marketing Director Resource MCP ==='
systemctl status marketing-director-resource-mcp.service --no-pager
echo ''
echo '=== Marketing Director Prompts MCP ==='
systemctl status marketing-director-prompts-mcp.service --no-pager
"

echo ""
echo "🌐 Testing MCP server endpoints..."

# Test endpoints (from within droplet)
ssh -i $SSH_KEY root@$DROPLET_IP "
echo '=== Testing Resource MCP (port 3003) ==='
curl -s http://localhost:3003/health || echo 'Health check not implemented'
echo ''
echo '=== Testing Prompts MCP (port 3004) ==='
curl -s http://localhost:3004/health || echo 'Health check not implemented'
"

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "MCP Servers are now running on the droplet:"
echo "  - Marketing Director Resource MCP: http://localhost:3003 (internal)"
echo "  - Marketing Director Prompts MCP: http://localhost:3004 (internal)"
echo ""
echo "To check logs:"
echo "  ssh -i $SSH_KEY root@$DROPLET_IP 'journalctl -u marketing-director-resource-mcp -f'"
echo "  ssh -i $SSH_KEY root@$DROPLET_IP 'journalctl -u marketing-director-prompts-mcp -f'"
echo ""
echo "To restart services:"
echo "  ssh -i $SSH_KEY root@$DROPLET_IP 'systemctl restart marketing-director-resource-mcp'"
echo "  ssh -i $SSH_KEY root@$DROPLET_IP 'systemctl restart marketing-director-prompts-mcp'"