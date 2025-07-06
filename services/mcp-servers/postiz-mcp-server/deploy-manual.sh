#!/bin/bash

# Manual deployment steps for Postiz MCP Server

echo "📋 Manual Deployment Steps for Postiz MCP Server"
echo "================================================"
echo ""
echo "1. First, build the project locally:"
echo "   cd /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/postiz-mcp-server"
echo "   npm run build"
echo ""
echo "2. Create a tarball of the built project:"
echo "   tar -czf postiz-mcp-server.tar.gz --exclude=node_modules --exclude=.env --exclude=.git dist/ src/ package*.json tsconfig.json README.md"
echo ""
echo "3. Copy the tarball to the droplet:"
echo "   scp -i ~/.ssh/digitalocean postiz-mcp-server.tar.gz root@157.230.13.13:/tmp/"
echo ""
echo "4. SSH into the droplet:"
echo "   ssh -i ~/.ssh/digitalocean root@157.230.13.13"
echo ""
echo "5. On the droplet, run these commands:"
cat << 'REMOTE_COMMANDS'
   # Create directory
   mkdir -p /opt/mcp-servers/postiz-mcp-server
   
   # Extract files
   cd /opt/mcp-servers/postiz-mcp-server
   tar -xzf /tmp/postiz-mcp-server.tar.gz
   
   # Install dependencies
   npm install --production
   
   # Update n8n MCP configuration
   cd /opt/mcp-servers
   
   # Add Postiz MCP to config (using jq)
   jq '.mcpServers["postiz-mcp"] = {
       "command": "node",
       "args": ["dist/index.js"],
       "cwd": "/opt/mcp-servers/postiz-mcp-server",
       "env": {
           "POSTIZ_API_KEY": "8895d94a-8d76-4d69-a212-23f248a7f78d"
       }
   }' n8n-mcp-config.json > /tmp/updated-config.json
   
   mv /tmp/updated-config.json n8n-mcp-config.json
   
   # Restart n8n
   docker restart n8n
   
   # Check logs
   docker logs n8n --tail 50
REMOTE_COMMANDS