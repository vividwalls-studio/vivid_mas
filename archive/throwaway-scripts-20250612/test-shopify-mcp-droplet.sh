#!/bin/bash

# Script to test Shopify MCP server on Digital Ocean droplet
# Usage: ./test-shopify-mcp-droplet.sh

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
SSH_USER="root"
MCP_SERVER_PATH="/opt/mcp-servers/shopify-mcp-server"

echo "=== Shopify MCP Server Droplet Test ==="
echo "Testing droplet at: $DROPLET_IP"
echo "Using SSH key: $SSH_KEY"
echo ""

# Function to run SSH commands with passphrase
run_ssh_command() {
    local command=$1
    sshpass -p "freedom" ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$DROPLET_IP" "$command"
}

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "Error: sshpass is required but not installed."
    echo "Install it with: brew install hudochenkov/sshpass/sshpass"
    exit 1
fi

echo "1. Checking if Shopify MCP server directory exists..."
if run_ssh_command "test -d $MCP_SERVER_PATH && echo 'Directory exists' || echo 'Directory NOT found'"; then
    echo "✓ Directory check completed"
else
    echo "✗ Failed to check directory"
fi
echo ""

echo "2. Checking for dist/index.js file..."
if run_ssh_command "test -f $MCP_SERVER_PATH/dist/index.js && echo 'dist/index.js exists' || echo 'dist/index.js NOT found'"; then
    echo "✓ File check completed"
else
    echo "✗ Failed to check file"
fi
echo ""

echo "3. Checking Node.js installation..."
run_ssh_command "node --version || echo 'Node.js NOT installed'"
echo ""

echo "4. Checking npm installation..."
run_ssh_command "npm --version || echo 'npm NOT installed'"
echo ""

echo "5. Showing Shopify MCP server directory structure..."
run_ssh_command "ls -la $MCP_SERVER_PATH/ 2>/dev/null || echo 'Cannot list directory'"
echo ""

echo "6. Checking package.json..."
run_ssh_command "test -f $MCP_SERVER_PATH/package.json && cat $MCP_SERVER_PATH/package.json | head -20 || echo 'package.json NOT found'"
echo ""

echo "7. Checking if node_modules exists..."
run_ssh_command "test -d $MCP_SERVER_PATH/node_modules && echo 'node_modules exists' || echo 'node_modules NOT found'"
echo ""

echo "8. Checking dist directory contents..."
run_ssh_command "ls -la $MCP_SERVER_PATH/dist/ 2>/dev/null || echo 'No dist directory'"
echo ""

echo "9. Checking file permissions..."
run_ssh_command "ls -la $MCP_SERVER_PATH/dist/index.js 2>/dev/null || echo 'Cannot check permissions'"
echo ""

echo "10. Checking environment variables for Shopify..."
run_ssh_command "env | grep -i shopify || echo 'No Shopify environment variables found'"
echo ""

echo "11. Attempting to run the MCP server manually..."
echo "Running: node $MCP_SERVER_PATH/dist/index.js"
run_ssh_command "cd $MCP_SERVER_PATH && timeout 5 node dist/index.js 2>&1 || true"
echo ""

echo "12. Checking for TypeScript compilation..."
run_ssh_command "test -f $MCP_SERVER_PATH/tsconfig.json && echo 'tsconfig.json exists' || echo 'tsconfig.json NOT found'"
echo ""

echo "13. Checking source files..."
run_ssh_command "ls -la $MCP_SERVER_PATH/src/ 2>/dev/null || echo 'No src directory'"
echo ""

echo "14. Checking for any error logs..."
run_ssh_command "tail -20 /var/log/mcp-shopify.log 2>/dev/null || echo 'No log file found'"
echo ""

echo "15. Checking systemd service (if exists)..."
run_ssh_command "systemctl status shopify-mcp 2>/dev/null || echo 'No systemd service found'"
echo ""

echo "=== Test Complete ==="
echo ""
echo "Summary:"
echo "- Check the output above for any missing files or errors"
echo "- If dist/index.js is missing, the TypeScript needs to be compiled"
echo "- If node_modules is missing, npm install needs to be run"
echo "- If environment variables are missing, they need to be configured"