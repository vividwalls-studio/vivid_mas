#!/bin/bash

# N8N Workflow Tagging System Deployment Script

echo "==================================================="
echo "N8N Workflow Tagging System Deployment"
echo "==================================================="

# Check if running locally or need to deploy to droplet
if [ "$1" == "remote" ]; then
    echo "Deploying to remote droplet..."
    
    # Copy files to droplet
    scp -i ~/.ssh/digitalocean \
        scripts/n8n_workflow_tagging_system.js \
        root@157.230.13.13:/tmp/
    
    # SSH and execute
    ssh -i ~/.ssh/digitalocean root@157.230.13.13 << 'REMOTE_SCRIPT'
    
    # Check if node is installed
    if ! command -v node &> /dev/null; then
        echo "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        apt-get install -y nodejs
    fi
    
    # Install axios if needed
    cd /tmp
    if [ ! -f package.json ]; then
        npm init -y
    fi
    npm install axios
    
    # Run the tagging script
    echo ""
    echo "Running tagging system..."
    node n8n_workflow_tagging_system.js
    
    echo ""
    echo "Tagging system deployed successfully!"
    
REMOTE_SCRIPT
    
else
    echo "Running locally..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo "Error: Node.js is not installed"
        exit 1
    fi
    
    # Install dependencies
    if [ ! -f package.json ]; then
        npm init -y
    fi
    
    # Check if axios is installed
    if [ ! -d "node_modules/axios" ]; then
        echo "Installing axios..."
        npm install axios
    fi
    
    # Run the tagging script
    echo ""
    echo "Running tagging system..."
    node scripts/n8n_workflow_tagging_system.js
    
fi

echo ""
echo "==================================================="
echo "Deployment Complete!"
echo "==================================================="
echo ""
echo "Next steps:"
echo "1. Open n8n UI at https://n8n.vividwalls.blog"
echo "2. Review workflows with new tags"
echo "3. Use tag filters to organize workflows"
echo "4. Manually adjust any incorrect tags"
echo ""
echo "Tag Categories Created:"
echo "- Primary: VividWalls-MAS, DesignThru-AI, N8N-Course-Demo"
echo "- Classification: Production, Development, Template, Archive"
echo "- Functional: Data-Processing, API-Integration, Automation, etc."
echo "- Departments: Business-Manager, Marketing, Sales, etc."
echo ""