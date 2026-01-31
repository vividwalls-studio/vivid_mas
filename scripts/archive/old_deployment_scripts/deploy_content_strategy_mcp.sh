#!/bin/bash
set -e

echo "🚀 Deploying Content Strategy Prompts MCP Server to DigitalOcean droplet..."

DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
LOCAL_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents/content-strategy-prompts"
REMOTE_PATH="/opt/mcp-servers/content-strategy-prompts"

echo "📁 Creating directory structure on droplet..."
ssh -i $SSH_KEY root@$DROPLET_IP "mkdir -p $REMOTE_PATH"

echo "📦 Preparing files for upload..."
cd $LOCAL_PATH

# Create a temporary tar file excluding node_modules
tar -czf /tmp/content-strategy-prompts.tar.gz \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='*.log' \
  .

echo "⬆️ Uploading MCP server files..."
scp -i $SSH_KEY /tmp/content-strategy-prompts.tar.gz root@$DROPLET_IP:/tmp/

echo "📂 Extracting files on droplet..."
ssh -i $SSH_KEY root@$DROPLET_IP "
  cd $REMOTE_PATH
  tar -xzf /tmp/content-strategy-prompts.tar.gz
  rm /tmp/content-strategy-prompts.tar.gz
"

echo "🔧 Installing dependencies on droplet..."
ssh -i $SSH_KEY root@$DROPLET_IP "
  cd $REMOTE_PATH
  # Install all dependencies first for building
  npm install
  # Build the project
  npm run build
  # Remove dev dependencies to save space
  npm prune --production
"

echo "✅ Content Strategy Prompts MCP Server deployed successfully!"
echo "📍 Location: $REMOTE_PATH"

# Clean up
rm /tmp/content-strategy-prompts.tar.gz

echo "🎉 Deployment complete!"