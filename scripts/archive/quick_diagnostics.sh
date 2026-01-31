#!/bin/bash

# Quick Diagnostics Script for VividWalls MAS
# Run this for rapid system assessment

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== VividWalls MAS Quick Diagnostics ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"
echo -e "${BLUE}Time: $(date)${NC}\n"

# Function to check remote status
check_remote() {
    local check_name=$1
    local command=$2
    local expected=$3
    
    echo -n "Checking $check_name... "
    
    result=$(ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$command" 2>&1)
    
    if echo "$result" | grep -q "$expected"; then
        echo -e "${GREEN}✓ PASS${NC}"
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo -e "${YELLOW}  Result: $result${NC}"
        return 1
    fi
}

# Critical checks
echo -e "${BLUE}1. Critical Infrastructure Checks${NC}"
check_remote "Docker Service" "systemctl is-active docker" "active"
check_remote "Network exists" "docker network ls | grep vivid_mas" "vivid_mas"
check_remote "Production directory" "test -d /root/vivid_mas && echo exists" "exists"

echo -e "\n${BLUE}2. Core Service Checks${NC}"
check_remote "PostgreSQL running" "docker ps | grep postgres" "postgres"
check_remote "N8N running" "docker ps | grep 'n8n'" "n8n"
check_remote "Caddy running" "docker ps | grep caddy" "caddy"

echo -e "\n${BLUE}3. Critical Configuration Checks${NC}"
check_remote "N8N encryption key" "docker exec n8n printenv | grep N8N_ENCRYPTION_KEY" "eyJhbGc"
check_remote "Database host correct" "docker exec n8n printenv | grep DB_POSTGRESDB_HOST=postgres" "postgres"
check_remote "MCP servers mounted" "docker exec n8n ls /opt/mcp-servers 2>/dev/null && echo mounted" "mounted"

echo -e "\n${BLUE}4. Data Integrity Checks${NC}"
# Get workflow count
ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' 2>/dev/null || echo 0" | while read count; do
    count=$(echo $count | tr -d ' ')
    echo -n "Workflow count: $count "
    if [ "$count" -ge 97 ]; then
        echo -e "${GREEN}✓ PASS${NC}"
    else
        echo -e "${RED}✗ FAIL (expected 97+)${NC}"
    fi
done

echo -e "\n${BLUE}5. Endpoint Accessibility${NC}"
# Test key endpoints
endpoints=("n8n.vividwalls.blog" "supabase.vividwalls.blog" "openwebui.vividwalls.blog")
for endpoint in "${endpoints[@]}"; do
    echo -n "https://$endpoint: "
    
    status=$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 "https://$endpoint" 2>/dev/null)
    if [[ "$status" =~ ^(200|301|302|401|403)$ ]]; then
        echo -e "${GREEN}✓ HTTP $status${NC}"
    else
        echo -e "${RED}✗ HTTP $status${NC}"
    fi
done

echo -e "\n${BLUE}6. Resource Usage${NC}"
ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "
echo 'Memory Usage:'
free -h | grep Mem | awk '{print \"  Total: \" \$2 \", Used: \" \$3 \", Free: \" \$4}'

echo -e '\nDisk Usage:'
df -h / | tail -1 | awk '{print \"  Total: \" \$2 \", Used: \" \$3 \", Available: \" \$4 \", Use%: \" \$5}'

echo -e '\nDocker Disk Usage:'
docker system df | grep -E '(TYPE|Images|Containers|Volumes)' | head -4
"

# Generate summary
echo -e "\n${BLUE}=== Diagnostics Summary ===${NC}"

# Count passes and fails
total_checks=0
failed_checks=0

# Simple summary (you could make this more sophisticated)
echo -e "${GREEN}✓ Quick diagnostics complete${NC}"
echo -e "${YELLOW}Review any failures above and run full monitoring for details${NC}"

echo -e "\n${BLUE}For detailed monitoring, run:${NC}"
echo "./scripts/post_restoration_monitor.sh"