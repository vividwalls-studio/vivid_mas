#!/bin/bash

# Fix n8n-import Container Issues
# This script addresses the n8n command not found errors and fixes workflow import

set -e

echo "🔧 Fixing n8n-import container issues..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# SSH connection details
SSH_KEY="~/.ssh/digitalocean"
DROPLET_IP="157.230.13.13"
SSH_USER="root"

# Function to execute commands on remote droplet
remote_exec() {
    ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "$1"
}

echo -e "${BLUE}Step 1: Stopping problematic n8n-import container${NC}"
remote_exec "cd /root/vivid_mas && docker-compose stop n8n-import"

echo -e "${BLUE}Step 2: Removing failed n8n-import container${NC}"
remote_exec "cd /root/vivid_mas && docker-compose rm -f n8n-import"

echo -e "${BLUE}Step 3: Checking available workflow files${NC}"
remote_exec "ls -la /root/vivid_mas/n8n/backup/ | head -10"

echo -e "${BLUE}Step 4: Creating fixed import script${NC}"
remote_exec "cat > /tmp/import_workflows_fixed.sh << 'EOF'
#!/bin/bash
set -e

echo \"Starting workflow import process...\"

# Change to the correct directory
cd /root/vivid_mas

# Check if backup directory exists
if [ ! -d \"n8n/backup\" ]; then
    echo \"Creating backup directory...\"
    mkdir -p n8n/backup
fi

# List available workflow files
echo \"Available workflow files:\"
find . -name \"*.json\" -path \"*/workflow*\" -o -name \"*workflow*.json\" | head -10

# Import workflows using the main n8n container
echo \"Importing workflows...\"
for workflow_file in \$(find . -name \"*.json\" -path \"*/workflow*\" -o -name \"*workflow*.json\" | head -5); do
    if [ -f \"\$workflow_file\" ]; then
        echo \"Importing: \$workflow_file\"
        docker exec n8n n8n import:workflow --input=\"/data/\$(basename \$workflow_file)\" || echo \"Failed to import \$workflow_file\"
    fi
done

echo \"Workflow import process completed\"
EOF"

echo -e "${BLUE}Step 5: Making import script executable${NC}"
remote_exec "chmod +x /tmp/import_workflows_fixed.sh"

echo -e "${BLUE}Step 6: Executing workflow import${NC}"
remote_exec "/tmp/import_workflows_fixed.sh"

echo -e "${BLUE}Step 7: Verifying workflow import${NC}"
remote_exec "docker exec postgres psql -U postgres -d postgres -c \"SELECT COUNT(*) as total_workflows FROM workflow_entity;\""

echo -e "${GREEN}✅ n8n-import container issues fixed and workflows imported${NC}"

# Update docker-compose.yml to remove the problematic n8n-import service
echo -e "${BLUE}Step 8: Updating docker-compose.yml to remove n8n-import service${NC}"
remote_exec "cd /root/vivid_mas && sed -i '/n8n-import:/,/^[[:space:]]*$/d' docker-compose.yml"

echo -e "${GREEN}✅ n8n-import service removed from docker-compose.yml${NC}"
echo -e "${YELLOW}Note: Workflow imports will now be handled through the main n8n container${NC}"
