#!/bin/bash
# VividWalls MAS System Validation Script - Phase 3
# Tests all services, endpoints, and data integrity

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
PASSPHRASE="freedom"
RESULTS_DIR="/tmp/vividwalls_validation_$(date +%Y%m%d_%H%M%S)"

# Create results directory
mkdir -p "$RESULTS_DIR"

echo -e "${BLUE}=== VividWalls MAS System Validation ===${NC}"
echo -e "${BLUE}Results will be saved to: ${RESULTS_DIR}${NC}\n"

# Function to test SSH connection
test_ssh_connection() {
    echo -e "${YELLOW}Testing SSH connection...${NC}"
    if ssh-add -l | grep -q "digitalocean"; then
        echo -e "${GREEN}✓ SSH key already loaded${NC}"
    else
        echo -e "${YELLOW}Adding SSH key...${NC}"
        ssh-add "$SSH_KEY" <<< "$PASSPHRASE"
    fi
    
    if ssh -o ConnectTimeout=5 -i "$SSH_KEY" root@"$DROPLET_IP" "echo 'SSH connection successful'" &> /dev/null; then
        echo -e "${GREEN}✓ SSH connection successful${NC}\n"
        return 0
    else
        echo -e "${RED}✗ SSH connection failed${NC}\n"
        return 1
    fi
}

# Function to check container health
check_container_health() {
    echo -e "${YELLOW}=== Checking Container Health ===${NC}"
    
    ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF' > "$RESULTS_DIR/container_health.txt" 2>&1
    echo "=== Docker Container Status ==="
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}" | tee /tmp/container_status.txt
    
    echo -e "\n=== Unhealthy Containers ==="
    docker ps --filter "health=unhealthy" --format "table {{.Names}}\t{{.Status}}"
    
    echo -e "\n=== Container Resource Usage ==="
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    
    echo -e "\n=== Network Verification ==="
    echo "Containers NOT on vivid_mas network:"
    docker ps --format '{{.Names}}\t{{.Networks}}' | grep -v "vivid_mas" || echo "All containers on correct network"
EOF
    
    # Analyze results
    if grep -q "unhealthy" "$RESULTS_DIR/container_health.txt"; then
        echo -e "${RED}✗ Some containers are unhealthy${NC}"
    else
        echo -e "${GREEN}✓ All containers healthy${NC}"
    fi
}

# Function to test Caddy endpoints
test_caddy_endpoints() {
    echo -e "\n${YELLOW}=== Testing Caddy Endpoints ===${NC}"
    
    # Define all endpoints to test
    declare -A endpoints=(
        ["n8n"]="https://n8n.vividwalls.blog/healthz"
        ["supabase"]="https://supabase.vividwalls.blog/rest/v1/"
        ["studio"]="https://studio.vividwalls.blog"
        ["twenty"]="https://twenty.vividwalls.blog"
        ["openwebui"]="https://openwebui.vividwalls.blog"
        ["flowise"]="https://flowise.vividwalls.blog"
        ["langfuse"]="https://langfuse.vividwalls.blog"
        ["ollama"]="https://ollama.vividwalls.blog/api/tags"
        ["listmonk"]="https://listmonk.vividwalls.blog/api/health"
        ["wordpress"]="https://wordpress.vividwalls.blog"
        ["neo4j"]="https://neo4j.vividwalls.blog"
        ["crawl4ai"]="https://crawl4ai.vividwalls.blog/health"
        ["searxng"]="https://searxng.vividwalls.blog"
        ["postiz"]="https://postiz.vividwalls.blog"
    )
    
    echo "Testing endpoints..." > "$RESULTS_DIR/endpoint_tests.txt"
    
    for service in "${!endpoints[@]}"; do
        url="${endpoints[$service]}"
        echo -n "Testing $service... "
        
        response=$(curl -s -o /dev/null -w "%{http_code}" -L "$url" --max-time 10 2>/dev/null || echo "000")
        
        if [[ "$response" =~ ^(200|301|302|401)$ ]]; then
            echo -e "${GREEN}✓ $service ($response)${NC}"
            echo "✓ $service: $url - HTTP $response" >> "$RESULTS_DIR/endpoint_tests.txt"
        else
            echo -e "${RED}✗ $service ($response)${NC}"
            echo "✗ $service: $url - HTTP $response" >> "$RESULTS_DIR/endpoint_tests.txt"
        fi
    done
}

# Function to verify database integrity
verify_database_integrity() {
    echo -e "\n${YELLOW}=== Verifying Database Integrity ===${NC}"
    
    ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF' > "$RESULTS_DIR/database_integrity.txt" 2>&1
    echo "=== PostgreSQL Main Database (n8n) ==="
    docker exec postgres psql -U postgres -d postgres -c "
        SELECT 'Workflows' as type, COUNT(*) as count FROM workflow_entity
        UNION ALL
        SELECT 'Credentials', COUNT(*) FROM credentials_entity
        UNION ALL
        SELECT 'Executions', COUNT(*) FROM execution_entity
        UNION ALL
        SELECT 'Tags', COUNT(*) FROM tag_entity;"
    
    echo -e "\n=== Supabase Database ==="
    docker exec supabase-db psql -U postgres -d postgres -c "
        SELECT schemaname, tablename, n_live_tup as row_count 
        FROM pg_stat_user_tables 
        WHERE schemaname = 'public' 
        ORDER BY n_live_tup DESC 
        LIMIT 10;"
    
    echo -e "\n=== Twenty CRM Database ==="
    docker exec twenty-db-1 psql -U twenty -d default -c "
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema') 
        LIMIT 10;" 2>/dev/null || echo "Twenty DB not accessible"
    
    echo -e "\n=== Neo4j Knowledge Graph ==="
    docker exec neo4j-knowledge cypher-shell -u neo4j -p vividwalls2024 "
        MATCH (n) RETURN labels(n)[0] as label, count(n) as count 
        ORDER BY count DESC LIMIT 10;" 2>/dev/null || echo "Neo4j not accessible"
EOF
    
    # Check workflow count
    workflow_count=$(grep -A1 "Workflows" "$RESULTS_DIR/database_integrity.txt" | tail -1 | awk '{print $NF}' || echo "0")
    if [[ "$workflow_count" -ge 97 ]]; then
        echo -e "${GREEN}✓ N8N workflows verified: $workflow_count workflows${NC}"
    else
        echo -e "${RED}✗ N8N workflow count mismatch: $workflow_count (expected 97+)${NC}"
    fi
}

# Function to test n8n MCP server access
test_n8n_mcp_access() {
    echo -e "\n${YELLOW}=== Testing N8N MCP Server Access ===${NC}"
    
    ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF' > "$RESULTS_DIR/mcp_access.txt" 2>&1
    echo "=== MCP Server Volume Mount ==="
    docker exec n8n ls -la /opt/mcp-servers/ | head -20
    
    echo -e "\n=== MCP Server Count ==="
    docker exec n8n find /opt/mcp-servers -name "package.json" -type f | wc -l
    
    echo -e "\n=== Test MCP Server Execution ==="
    # Test a simple MCP server
    docker exec n8n node /opt/mcp-servers/n8n-mcp-server/build/index.js --version 2>/dev/null || echo "Direct execution test failed"
EOF
    
    mcp_count=$(grep -A1 "MCP Server Count" "$RESULTS_DIR/mcp_access.txt" | tail -1 || echo "0")
    if [[ "$mcp_count" -gt 10 ]]; then
        echo -e "${GREEN}✓ MCP servers accessible: $mcp_count servers found${NC}"
    else
        echo -e "${RED}✗ MCP server access issue: only $mcp_count servers found${NC}"
    fi
}

# Function to test agent communication
test_agent_communication() {
    echo -e "\n${YELLOW}=== Testing Agent Communication Pathways ===${NC}"
    
    # Test n8n webhook endpoints
    echo "Testing n8n webhook endpoints..." > "$RESULTS_DIR/agent_communication.txt"
    
    # Get n8n API key
    n8n_api_key=$(ssh -i "$SSH_KEY" root@"$DROPLET_IP" 'grep N8N_API_KEY /root/vivid_mas/.env | cut -d= -f2' 2>/dev/null || echo "")
    
    if [[ -n "$n8n_api_key" ]]; then
        # Test workflow list API
        response=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "X-N8N-API-KEY: $n8n_api_key" \
            "https://n8n.vividwalls.blog/api/v1/workflows" 2>/dev/null || echo "000")
        
        if [[ "$response" == "200" ]]; then
            echo -e "${GREEN}✓ N8N API accessible${NC}"
            echo "✓ N8N API test successful" >> "$RESULTS_DIR/agent_communication.txt"
        else
            echo -e "${RED}✗ N8N API test failed ($response)${NC}"
            echo "✗ N8N API test failed: HTTP $response" >> "$RESULTS_DIR/agent_communication.txt"
        fi
    else
        echo -e "${YELLOW}⚠ N8N API key not found${NC}"
    fi
}

# Function to check disk usage
check_disk_usage() {
    echo -e "\n${YELLOW}=== Checking Disk Usage ===${NC}"
    
    ssh -i "$SSH_KEY" root@"$DROPLET_IP" << 'EOF' > "$RESULTS_DIR/disk_usage.txt" 2>&1
    echo "=== Overall Disk Usage ==="
    df -h | grep -E "^/dev|Filesystem"
    
    echo -e "\n=== Docker Volume Usage ==="
    docker system df
    
    echo -e "\n=== Large Directories ==="
    du -sh /root/vivid_mas/* 2>/dev/null | sort -hr | head -10
    du -sh /home/vivid/* 2>/dev/null | sort -hr | head -10
    du -sh /opt/* 2>/dev/null | sort -hr | head -10
    
    echo -e "\n=== Docker Images ==="
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | head -20
EOF
    
    echo -e "${GREEN}✓ Disk usage report generated${NC}"
}

# Function to generate validation summary
generate_summary() {
    echo -e "\n${YELLOW}=== Generating Validation Summary ===${NC}"
    
    cat > "$RESULTS_DIR/validation_summary.md" << EOF
# VividWalls MAS System Validation Report
Generated: $(date)

## Container Health
$(grep -E "(✓|✗|All containers)" "$RESULTS_DIR/container_health.txt" | head -5 || echo "Check container_health.txt for details")

## Endpoint Tests
$(grep -c "✓" "$RESULTS_DIR/endpoint_tests.txt" || echo "0") services accessible
$(grep -c "✗" "$RESULTS_DIR/endpoint_tests.txt" || echo "0") services failed

## Database Status
- N8N Workflows: $(grep -A1 "Workflows" "$RESULTS_DIR/database_integrity.txt" | tail -1 | awk '{print $NF}' || echo "Unknown")
- MCP Servers: $(grep -A1 "MCP Server Count" "$RESULTS_DIR/mcp_access.txt" | tail -1 || echo "Unknown")

## Disk Usage
$(grep "/dev/vda1" "$RESULTS_DIR/disk_usage.txt" || echo "Disk usage data not available")

## Failed Services
$(grep "✗" "$RESULTS_DIR/endpoint_tests.txt" || echo "None")

## Recommendations
1. Review any failed services in endpoint_tests.txt
2. Check container_health.txt for unhealthy containers
3. Verify database counts match expected values
4. Consider cleanup if disk usage > 80%
EOF
    
    echo -e "${GREEN}✓ Validation complete! Results saved to: ${RESULTS_DIR}${NC}"
    echo -e "${BLUE}Summary: ${RESULTS_DIR}/validation_summary.md${NC}"
}

# Main execution
main() {
    echo "Starting VividWalls MAS validation..."
    
    # Test SSH connection first
    if ! test_ssh_connection; then
        echo -e "${RED}Cannot proceed without SSH connection${NC}"
        exit 1
    fi
    
    # Run all validation tests
    check_container_health
    test_caddy_endpoints
    verify_database_integrity
    test_n8n_mcp_access
    test_agent_communication
    check_disk_usage
    
    # Generate summary
    generate_summary
    
    echo -e "\n${GREEN}=== Validation Complete ===${NC}"
    echo "All results saved to: $RESULTS_DIR"
    
    # Offer to copy results locally
    echo -e "\nCopy results to local machine? (y/n)"
    read -r response
    if [[ "$response" == "y" ]]; then
        scp -r -i "$SSH_KEY" root@"$DROPLET_IP":"$RESULTS_DIR" .
        echo -e "${GREEN}Results copied to: $(basename "$RESULTS_DIR")${NC}"
    fi
}

# Run main function
main "$@"