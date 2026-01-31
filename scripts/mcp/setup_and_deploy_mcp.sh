#!/bin/bash

# Setup SSH agent and deploy Marketing Director MCP Servers

echo "📋 Setting up SSH agent for deployment..."
echo ""
echo "You will be prompted for your SSH key passphrase once."
echo "Passphrase hint: freedom"
echo ""

# Start SSH agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
fi

# Add the key to SSH agent
ssh-add /Users/kinglerbercy/.ssh/digitalocean

# Now run the deployment
echo ""
echo "🚀 Starting deployment..."
/Volumes/SeagatePortableDrive/Projects/vivid_mas/deploy_marketing_mcp_servers.sh

# Kill the SSH agent if we started it
if [ -n "$SSH_AGENT_PID" ]; then
    ssh-agent -k
fi