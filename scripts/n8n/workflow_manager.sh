#!/bin/bash

# N8N Workflow Management Script for VividWalls MAS
# Manage workflows, credentials, and executions

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

# Function to execute remote command
remote_exec() {
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$@"
}

# Function to show menu
show_menu() {
    echo -e "${BLUE}=== N8N Workflow Manager ===${NC}"
    echo "1. List all workflows"
    echo "2. Export workflows backup"
    echo "3. Import workflows from backup"
    echo "4. Show workflow execution history"
    echo "5. Clear old executions"
    echo "6. Test MCP server access"
    echo "7. Show workflow statistics"
    echo "8. Activate/Deactivate workflow"
    echo "9. Check credentials"
    echo "0. Exit"
    echo ""
    read -p "Select option: " choice
}

# List workflows
list_workflows() {
    echo -e "\n${BLUE}Listing all workflows...${NC}"
    remote_exec "docker exec postgres psql -U postgres -d postgres -c \"
        SELECT id, name, active, 
               CASE WHEN active = true THEN 'Active' ELSE 'Inactive' END as status,
               created_at::date as created,
               updated_at::date as updated
        FROM workflow_entity 
        ORDER BY active DESC, name;
    \""
}

# Export workflows
export_workflows() {
    echo -e "\n${BLUE}Exporting workflows...${NC}"
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="n8n_workflows_backup_$TIMESTAMP.json"
    
    # Create backup on remote
    remote_exec "
        cd /root/vivid_mas
        docker exec n8n n8n export:workflow --backup --output=/backup/temp_export.json
        docker exec n8n n8n export:credentials --backup --output=/backup/temp_creds.json
        
        # Combine into single backup file
        docker exec n8n sh -c 'cat /backup/temp_export.json /backup/temp_creds.json > /backup/$BACKUP_FILE'
        
        # Clean temp files
        docker exec n8n rm /backup/temp_export.json /backup/temp_creds.json
        
        echo '✓ Backup created: /root/vivid_mas/n8n/backup/$BACKUP_FILE'
    "
    
    # Option to download
    read -p "Download backup to local machine? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        scp -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP:/root/vivid_mas/n8n/backup/$BACKUP_FILE" "./$BACKUP_FILE"
        echo -e "${GREEN}✓ Backup downloaded: $BACKUP_FILE${NC}"
    fi
}

# Import workflows
import_workflows() {
    echo -e "\n${BLUE}Available backups:${NC}"
    remote_exec "ls -la /root/vivid_mas/n8n/backup/*.json | tail -10"
    
    read -p "Enter backup filename to import: " backup_file
    
    if [ -z "$backup_file" ]; then
        echo -e "${RED}No file specified${NC}"
        return
    fi
    
    echo -e "${YELLOW}⚠ WARNING: This will overwrite existing workflows${NC}"
    read -p "Continue? (yes/no): " -r
    if [[ ! $REPLY == "yes" ]]; then
        echo "Import cancelled"
        return
    fi
    
    remote_exec "
        cd /root/vivid_mas
        docker exec n8n n8n import:workflow --input=/backup/$backup_file
        echo '✓ Workflows imported from $backup_file'
    "
}

# Show execution history
show_executions() {
    echo -e "\n${BLUE}Recent workflow executions...${NC}"
    remote_exec "docker exec postgres psql -U postgres -d postgres -c \"
        SELECT 
            we.name as workflow,
            ee.mode,
            ee.status,
            ee.started_at::timestamp(0) as started,
            ee.stopped_at::timestamp(0) as stopped,
            CASE 
                WHEN ee.finished = true THEN 'Finished'
                ELSE 'Running'
            END as state
        FROM execution_entity ee
        JOIN workflow_entity we ON ee.workflow_id = we.id
        ORDER BY ee.started_at DESC
        LIMIT 20;
    \""
}

# Clear old executions
clear_executions() {
    echo -e "\n${YELLOW}This will delete execution history older than 30 days${NC}"
    read -p "Continue? (yes/no): " -r
    if [[ ! $REPLY == "yes" ]]; then
        echo "Cleanup cancelled"
        return
    fi
    
    remote_exec "docker exec postgres psql -U postgres -d postgres -c \"
        DELETE FROM execution_entity 
        WHERE stopped_at < NOW() - INTERVAL '30 days';
    \""
    
    echo -e "${GREEN}✓ Old executions cleared${NC}"
}

# Test MCP servers
test_mcp_servers() {
    echo -e "\n${BLUE}Testing MCP server access...${NC}"
    
    remote_exec "
        echo 'Checking MCP server mount...'
        docker exec n8n ls -la /opt/mcp-servers | head -10
        
        echo -e '\nMCP server count:'
        docker exec n8n find /opt/mcp-servers -name 'package.json' -type f | wc -l
        
        echo -e '\nTesting specific MCP servers:'
        docker exec n8n ls /opt/mcp-servers/shopify-mcp-server 2>/dev/null && echo '✓ Shopify MCP server found' || echo '✗ Shopify MCP server missing'
        docker exec n8n ls /opt/mcp-servers/n8n-mcp-server 2>/dev/null && echo '✓ N8N MCP server found' || echo '✗ N8N MCP server missing'
        docker exec n8n ls /opt/mcp-servers/supabase-mcp-server 2>/dev/null && echo '✓ Supabase MCP server found' || echo '✗ Supabase MCP server missing'
    "
}

# Show statistics
show_statistics() {
    echo -e "\n${BLUE}Workflow Statistics${NC}"
    
    remote_exec "docker exec postgres psql -U postgres -d postgres -c \"
        SELECT 
            'Total Workflows' as metric,
            COUNT(*) as count
        FROM workflow_entity
        UNION ALL
        SELECT 
            'Active Workflows',
            COUNT(*)
        FROM workflow_entity
        WHERE active = true
        UNION ALL
        SELECT 
            'Total Executions',
            COUNT(*)
        FROM execution_entity
        UNION ALL
        SELECT 
            'Successful Executions (24h)',
            COUNT(*)
        FROM execution_entity
        WHERE status = 'success'
        AND started_at > NOW() - INTERVAL '24 hours'
        UNION ALL
        SELECT 
            'Failed Executions (24h)',
            COUNT(*)
        FROM execution_entity
        WHERE status = 'error'
        AND started_at > NOW() - INTERVAL '24 hours';
    \""
}

# Toggle workflow active status
toggle_workflow() {
    list_workflows
    
    read -p "Enter workflow ID to toggle: " workflow_id
    
    if [ -z "$workflow_id" ]; then
        echo -e "${RED}No workflow ID specified${NC}"
        return
    fi
    
    remote_exec "docker exec postgres psql -U postgres -d postgres -c \"
        UPDATE workflow_entity 
        SET active = NOT active,
            updated_at = NOW()
        WHERE id = '$workflow_id'
        RETURNING id, name, active;
    \""
    
    echo -e "${GREEN}✓ Workflow status updated${NC}"
}

# Check credentials
check_credentials() {
    echo -e "\n${BLUE}Checking credentials...${NC}"
    
    remote_exec "
        echo 'Encryption key status:'
        docker exec n8n printenv | grep -q N8N_ENCRYPTION_KEY && echo '✓ Encryption key is set' || echo '✗ Encryption key missing'
        
        echo -e '\nCredentials in database:'
        docker exec postgres psql -U postgres -d postgres -c \"
            SELECT type, name, 
                   created_at::date as created,
                   updated_at::date as updated
            FROM credentials_entity
            ORDER BY type, name;
        \"
    "
}

# Main loop
while true; do
    show_menu
    
    case $choice in
        1) list_workflows ;;
        2) export_workflows ;;
        3) import_workflows ;;
        4) show_executions ;;
        5) clear_executions ;;
        6) test_mcp_servers ;;
        7) show_statistics ;;
        8) toggle_workflow ;;
        9) check_credentials ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done