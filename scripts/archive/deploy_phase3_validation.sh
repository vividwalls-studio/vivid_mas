#!/bin/bash

# Phase 3: System Validation for VividWalls MAS
# This script validates the restored system functionality

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== VividWalls MAS Phase 3: System Validation ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"

# Function to execute remote command
remote_exec() {
    local command=$1
    local description=$2
    
    echo -e "\n${BLUE}$description${NC}"
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$command"
}

# Phase 3.1: Container Health Checks
echo -e "\n${GREEN}=== Phase 3.1: Verifying Container Health ===${NC}"

remote_exec "cat > /tmp/check_containers.sh << 'SCRIPT'
#!/bin/bash

cd /root/vivid_mas_build

echo '=== Container Health Status ==='

# Get all running containers
docker-compose ps --format 'table {{.Name}}\t{{.Status}}\t{{.Service}}'

echo -e '\n=== Detailed Health Checks ==='

# Critical services to check
services=(
    'postgres:5432:PostgreSQL Database'
    'n8n:5678:N8N Workflow Engine'
    'redis:6379:Redis Cache'
    'caddy:80:Caddy Reverse Proxy'
    'open-webui:8080:Open WebUI'
    'ollama:11434:Ollama LLM'
    'neo4j-knowledge:7474:Neo4j Knowledge Graph'
)

for service in \"\${services[@]}\"; do
    IFS=':' read -r container port description <<< \"\$service\"
    echo -n \"Checking \$description (\$container)... \"
    
    if docker-compose ps \$container | grep -q 'Up'; then
        echo -e '${GREEN}✓ Running${NC}'
        
        # Port check
        if docker exec \$container netstat -tln 2>/dev/null | grep -q \":\$port\"; then
            echo \"  Port \$port: Open\"
        else
            echo \"  Port \$port: Not listening\"
        fi
    else
        echo -e '${RED}✗ Not running${NC}'
    fi
done

# Check for restart loops
echo -e '\n=== Checking for Restart Loops ==='
docker-compose ps | grep -E '(Restarting|Exit)' || echo 'No containers in restart loops'

# Memory usage
echo -e '\n=== Memory Usage ==='
docker stats --no-stream --format 'table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}'

SCRIPT
chmod +x /tmp/check_containers.sh
/tmp/check_containers.sh
" "Container health verification"

# Phase 3.2: Endpoint Testing
echo -e "\n${GREEN}=== Phase 3.2: Verifying Caddy Endpoints ===${NC}"

remote_exec "cat > /tmp/check_endpoints.sh << 'SCRIPT'
#!/bin/bash

echo '=== Endpoint Accessibility Tests ==='

# Define endpoints to test
endpoints=(
    'https://n8n.vividwalls.blog:n8n'
    'https://openwebui.vividwalls.blog:Open WebUI'
    'https://langfuse.vividwalls.blog:Langfuse'
    'https://supabase.vividwalls.blog:Supabase'
    'https://studio.vividwalls.blog:Supabase Studio'
    'https://neo4j.vividwalls.blog:Neo4j'
    'https://crawl4ai.vividwalls.blog:Crawl4AI'
    'https://searxng.vividwalls.blog:SearxNG'
)

# Test each endpoint
for endpoint in \"\${endpoints[@]}\"; do
    IFS=':' read -r url service <<< \"\$endpoint\"
    echo -n \"Testing \$service (\$url)... \"
    
    # Use curl to test
    if curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 \$url | grep -qE '^(200|301|302|401|403)'; then
        STATUS=\\$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 \$url)
        echo -e '${GREEN}✓ Accessible${NC} (HTTP \$STATUS)'
    else
        echo -e '${RED}✗ Not accessible${NC}'
    fi
done

# Test internal connectivity
echo -e '\n=== Internal Service Connectivity ==='

# Test n8n to postgres
echo -n 'n8n → PostgreSQL... '
docker exec n8n pg_isready -h postgres -U postgres > /dev/null 2>&1 && echo -e '${GREEN}✓ Connected${NC}' || echo -e '${RED}✗ Failed${NC}'

# Test n8n to MCP servers
echo -n 'n8n → MCP Servers... '
docker exec n8n ls /opt/mcp-servers > /dev/null 2>&1 && echo -e '${GREEN}✓ Accessible${NC}' || echo -e '${RED}✗ Not mounted${NC}'

SCRIPT
chmod +x /tmp/check_endpoints.sh
/tmp/check_endpoints.sh
" "Endpoint accessibility tests"

# Phase 3.3: Data Integrity Checks
echo -e "\n${GREEN}=== Phase 3.3: Data Integrity Validation ===${NC}"

remote_exec "cat > /tmp/check_data_integrity.sh << 'SCRIPT'
#!/bin/bash

echo '=== Data Integrity Checks ==='

# Check n8n workflows
echo -e '\n--- N8N Workflows ---'
if docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) as workflow_count FROM workflow_entity;' 2>/dev/null; then
    WORKFLOW_COUNT=\\$(docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' 2>/dev/null | tr -d ' ')
    echo \"✓ Workflows in database: \\$WORKFLOW_COUNT\"
    
    # Expected count is 102 based on documentation
    if [ \"\\$WORKFLOW_COUNT\" -ge 97 ]; then
        echo -e '${GREEN}✓ Workflow count meets expectations${NC}'
    else
        echo -e '${YELLOW}⚠ Workflow count lower than expected (97+)${NC}'
    fi
else
    echo -e '${RED}✗ Cannot access workflow data${NC}'
fi

# Check n8n credentials encryption
echo -e '\n--- N8N Encryption ---'
docker exec n8n printenv | grep -q N8N_ENCRYPTION_KEY && echo '✓ Encryption key is set' || echo '✗ Encryption key missing'

# Check Supabase if available
echo -e '\n--- Supabase Database ---'
if docker ps | grep -q supabase-db; then
    docker exec supabase-db psql -U postgres -c '\\l' | grep -q vividwalls && echo '✓ VividWalls database exists' || echo '✗ VividWalls database missing'
else
    echo '⚠ Supabase not running in build directory (may be external)'
fi

# Check data files
echo -e '\n--- Data Files ---'
echo 'Product catalogs:'
ls -la /root/vivid_mas_build/data/*.csv 2>/dev/null | wc -l | xargs -I {} echo '  {} CSV files found'

echo 'SQL chunks:'
ls -la /root/vivid_mas_build/sql_chunks/*.sql 2>/dev/null | wc -l | xargs -I {} echo '  {} SQL files found'

# Check MCP servers
echo -e '\n--- MCP Servers ---'
if [ -d /opt/mcp-servers ]; then
    MCP_COUNT=\\$(find /opt/mcp-servers -name 'package.json' -type f | wc -l)
    echo \"✓ MCP servers found: \\$MCP_COUNT\"
else
    echo '✗ MCP servers directory not found at /opt/mcp-servers'
fi

SCRIPT
chmod +x /tmp/check_data_integrity.sh
/tmp/check_data_integrity.sh
" "Data integrity validation"

# Create comprehensive validation report
echo -e "\n${BLUE}Creating validation report...${NC}"

remote_exec "cat > /root/vivid_mas_build/phase3_validation_report.txt << 'REPORT'
VividWalls MAS Validation Report
================================
Generated: $(date)
Build Directory: /root/vivid_mas_build

Phase 3 Validation Summary
-------------------------

3.1 Container Health:
[ ] All critical containers running
[ ] No restart loops detected
[ ] Adequate memory allocation

3.2 Endpoint Accessibility:
[ ] n8n accessible at https://n8n.vividwalls.blog
[ ] Caddy reverse proxy functioning
[ ] All service endpoints responding

3.3 Data Integrity:
[ ] N8N workflows migrated (97+ expected)
[ ] Encryption key properly set
[ ] MCP servers accessible to n8n
[ ] Database connections established

Critical Issues to Resolve:
- Check any failed endpoints
- Verify MCP server volume mount
- Ensure all services on vivid_mas network

Next Steps:
- If all checks pass: Proceed to Phase 4 (Cutover)
- If issues found: Resolve before continuing

REPORT
" "Creating validation report"

# Summary
echo -e "\n${GREEN}=== Phase 3 Validation Complete ===${NC}"
echo -e "${BLUE}Validation performed for:${NC}"
echo -e "  ✓ Container health status"
echo -e "  ✓ Endpoint accessibility"
echo -e "  ✓ Data integrity"
echo -e "\n${YELLOW}Review the validation report at:${NC}"
echo -e "/root/vivid_mas_build/phase3_validation_report.txt"

# Update context
cat > .context/phase_status/phase3_status.json << EOF
{
  "phase": 3,
  "status": "validation_complete",
  "start_time": "$(date -u -Iseconds)",
  "end_time": "$(date -u -Iseconds)",
  "tasks": {
    "container_health": "complete",
    "endpoint_testing": "complete",
    "data_integrity": "complete"
  },
  "validation_performed": [
    "Container health checks",
    "Endpoint accessibility tests",
    "Database workflow counts",
    "MCP server verification",
    "Encryption key validation"
  ],
  "notes": "Validation complete. Review report before proceeding to Phase 4."
}
EOF

echo -e "${GREEN}✓ Context updated${NC}"