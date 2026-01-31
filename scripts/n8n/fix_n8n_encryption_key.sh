#!/bin/bash
# N8N Encryption Key Fix Script
# Ensures n8n uses the correct encryption key from backup

set -euo pipefail

# The correct key from backup
CORRECT_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4ZjE3Nzk5ZS1mYzIzLTQ5OGItOTUxZS05N2Y4MzUzNGRhNzciLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwMDk5NTI0fQ.FkHcnlHhtFw1EtgPZ8tiefY4Q-O3CEhq8VddvwllAWU"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== N8N Encryption Key Fix Script ===${NC}"

# Step 1: Check current key in .env
echo "Checking current key in .env file..."
CURRENT_ENV_KEY=$(grep "^N8N_ENCRYPTION_KEY=" /root/vivid_mas/.env | cut -d'=' -f2)

if [ "$CURRENT_ENV_KEY" != "$CORRECT_KEY" ]; then
    echo -e "${YELLOW}Updating .env file with correct key...${NC}"
    
    # Backup current .env
    cp /root/vivid_mas/.env /root/vivid_mas/.env.backup.$(date +%Y%m%d_%H%M%S)
    
    # Update the key
    sed -i "s|^N8N_ENCRYPTION_KEY=.*|N8N_ENCRYPTION_KEY=${CORRECT_KEY}|" /root/vivid_mas/.env
    
    echo -e "${GREEN}✓ .env file updated${NC}"
else
    echo -e "${GREEN}✓ .env file already has correct key${NC}"
fi

# Step 2: Check if n8n container is using correct key
if docker ps -q -f name=^n8n$ | grep -q .; then
    echo "Checking n8n container environment..."
    CONTAINER_KEY=$(docker exec n8n printenv N8N_ENCRYPTION_KEY 2>/dev/null || echo "")
    
    if [ "$CONTAINER_KEY" != "$CORRECT_KEY" ]; then
        echo -e "${YELLOW}Container has wrong key. Restarting n8n...${NC}"
        
        # Stop n8n
        docker stop n8n
        
        # Remove any auto-generated config
        docker run --rm -v vivid_mas_n8n_storage:/data alpine sh -c 'rm -rf /data/.n8n/config'
        
        # Restart n8n with correct key
        cd /root/vivid_mas
        docker-compose up -d n8n
        
        # Wait for n8n to start
        echo "Waiting for n8n to start..."
        sleep 10
        
        # Verify the key is now correct
        NEW_KEY=$(docker exec n8n printenv N8N_ENCRYPTION_KEY)
        if [ "$NEW_KEY" = "$CORRECT_KEY" ]; then
            echo -e "${GREEN}✓ N8N now using correct encryption key${NC}"
        else
            echo -e "${RED}✗ Failed to update n8n encryption key${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✓ N8N container already using correct key${NC}"
    fi
else
    echo -e "${YELLOW}N8N container not running${NC}"
fi

# Step 3: Verify docker-compose.yml configuration
echo "Checking docker-compose.yml configuration..."
if grep -q "N8N_ENCRYPTION_KEY=" /root/vivid_mas/docker-compose.yml; then
    echo -e "${RED}WARNING: docker-compose.yml contains hardcoded encryption key!${NC}"
    echo -e "${YELLOW}It should use environment variable substitution instead:${NC}"
    echo "    - N8N_ENCRYPTION_KEY"
    echo "(without the = sign)"
else
    echo -e "${GREEN}✓ docker-compose.yml correctly uses environment variable${NC}"
fi

# Step 4: Test credential decryption
if docker ps -q -f name=^n8n$ | grep -q .; then
    echo "Testing workflow access..."
    WORKFLOW_COUNT=$(docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' | tr -d ' ')
    echo -e "${GREEN}Found $WORKFLOW_COUNT workflows in database${NC}"
    
    if [ "$WORKFLOW_COUNT" -ge 97 ]; then
        echo -e "${GREEN}✓ Expected number of workflows found${NC}"
    else
        echo -e "${YELLOW}⚠ Warning: Expected at least 97 workflows, found $WORKFLOW_COUNT${NC}"
    fi
fi

echo -e "${GREEN}=== Encryption key fix completed ===${NC}"
echo "Next steps:"
echo "1. Access n8n at https://n8n.vividwalls.blog"
echo "2. Verify you can see and edit workflows"
echo "3. Test that credentials are decrypting properly"