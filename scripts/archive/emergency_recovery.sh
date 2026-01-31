#!/bin/bash

# Emergency Recovery Script for VividWalls MAS
# Use this when the system is experiencing critical issues

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

echo -e "${RED}=== VividWalls MAS Emergency Recovery ===${NC}"
echo -e "${YELLOW}⚠ WARNING: This script is for emergency use only${NC}"
echo ""

# Function to execute remote command
remote_exec() {
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$@"
}

# Show recovery menu
show_menu() {
    echo -e "${BLUE}Select recovery option:${NC}"
    echo "1. Diagnose system issues"
    echo "2. Fix n8n encryption key mismatch"
    echo "3. Fix database connection issues"
    echo "4. Fix MCP server mount"
    echo "5. Restart all services"
    echo "6. Rollback to previous version"
    echo "7. Emergency data export"
    echo "8. Fix network issues"
    echo "9. Clear all logs and temp files"
    echo "0. Exit"
    echo ""
    read -p "Select option: " choice
}

# Diagnose issues
diagnose_issues() {
    echo -e "\n${BLUE}Running system diagnostics...${NC}"
    
    remote_exec "
        cd /root/vivid_mas
        
        echo '=== Container Status ==='
        docker-compose ps
        
        echo -e '\n=== Failed Containers ==='
        docker ps -a | grep -E '(Exit|Restarting)' || echo 'No failed containers'
        
        echo -e '\n=== Recent Docker Logs (errors only) ==='
        for container in \$(docker ps -a --format '{{.Names}}'); do
            echo \"--- \$container ---\"
            docker logs \$container --tail 20 2>&1 | grep -iE '(error|fail|crash|fatal)' | head -5 || echo 'No errors'
        done
        
        echo -e '\n=== Disk Space ==='
        df -h /
        
        echo -e '\n=== Memory Usage ==='
        free -h
        
        echo -e '\n=== Network Status ==='
        docker network ls | grep vivid_mas || echo 'Network missing!'
        
        echo -e '\n=== Critical File Checks ==='
        test -f .env && echo '✓ .env exists' || echo '✗ .env missing'
        test -f docker-compose.yml && echo '✓ docker-compose.yml exists' || echo '✗ docker-compose.yml missing'
        test -f Caddyfile && echo '✓ Caddyfile exists' || echo '✗ Caddyfile missing'
    "
}

# Fix encryption key
fix_encryption_key() {
    echo -e "\n${BLUE}Fixing n8n encryption key...${NC}"
    
    # Get current key
    echo "Current encryption key in container:"
    remote_exec "docker exec n8n printenv | grep N8N_ENCRYPTION_KEY || echo 'Not set'"
    
    echo -e "\n${YELLOW}The correct production key should be:${NC}"
    echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs"
    
    read -p "Fix encryption key now? (yes/no): " -r
    if [[ ! $REPLY == "yes" ]]; then
        return
    fi
    
    remote_exec "
        cd /root/vivid_mas
        
        # Backup current .env
        cp .env .env.backup.\$(date +%Y%m%d_%H%M%S)
        
        # Update encryption key
        sed -i 's|^N8N_ENCRYPTION_KEY=.*|N8N_ENCRYPTION_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs|' .env
        
        # Remove n8n config that might have wrong key
        docker run --rm -v vivid_mas_n8n_storage:/data alpine rm -rf /data/.n8n/config
        
        # Restart n8n
        docker-compose restart n8n
        
        echo '✓ Encryption key fixed and n8n restarted'
    "
}

# Fix database connection
fix_database_connection() {
    echo -e "\n${BLUE}Fixing database connection...${NC}"
    
    remote_exec "
        cd /root/vivid_mas
        
        echo 'Current database configuration:'
        docker exec n8n printenv | grep DB_POSTGRESDB
        
        # Check if using wrong host
        if docker exec n8n printenv | grep -q 'DB_POSTGRESDB_HOST=db'; then
            echo '✗ Wrong database host detected (using \"db\" instead of \"postgres\")'
            
            # Fix in docker-compose.yml
            sed -i 's/DB_POSTGRESDB_HOST=db/DB_POSTGRESDB_HOST=postgres/g' docker-compose.yml
            
            # Recreate n8n container
            docker-compose up -d --force-recreate n8n
            
            echo '✓ Database host fixed'
        else
            echo '✓ Database host is correct'
        fi
        
        # Test connection
        sleep 5
        docker exec n8n pg_isready -h postgres -U postgres && echo '✓ Database connection successful' || echo '✗ Database connection failed'
    "
}

# Fix MCP server mount
fix_mcp_mount() {
    echo -e "\n${BLUE}Fixing MCP server mount...${NC}"
    
    remote_exec "
        cd /root/vivid_mas
        
        echo 'Checking MCP server location...'
        if [ -d /opt/mcp-servers ]; then
            echo '✓ MCP servers found at /opt/mcp-servers'
            ls -la /opt/mcp-servers | head -5
            
            # Check if volume is mounted
            if docker exec n8n ls /opt/mcp-servers 2>/dev/null; then
                echo '✓ MCP servers already accessible from n8n'
            else
                echo '✗ MCP servers not mounted in n8n'
                
                # Add volume mount to docker-compose.yml if missing
                if ! grep -q '/opt/mcp-servers:/opt/mcp-servers' docker-compose.yml; then
                    echo 'Adding MCP server volume mount...'
                    # This is simplified - in production you'd want more careful editing
                    sed -i '/n8n:/,/^[^ ]/{/volumes:/,/^[^ ]/{/n8n_storage/a\      - /opt/mcp-servers:/opt/mcp-servers:ro}}' docker-compose.yml
                fi
                
                # Recreate n8n
                docker-compose up -d --force-recreate n8n
                echo '✓ MCP server mount added'
            fi
        else
            echo '✗ MCP servers not found at /opt/mcp-servers'
            echo 'Searching for MCP servers...'
            find / -name 'shopify-mcp-server' -type d 2>/dev/null | head -5
        fi
    "
}

# Restart all services
restart_all_services() {
    echo -e "\n${BLUE}Restarting all services...${NC}"
    
    read -p "This will cause downtime. Continue? (yes/no): " -r
    if [[ ! $REPLY == "yes" ]]; then
        return
    fi
    
    remote_exec "
        cd /root/vivid_mas
        
        echo 'Stopping all services...'
        docker-compose down
        
        echo 'Starting services...'
        docker-compose up -d
        
        echo 'Waiting for services to start...'
        sleep 30
        
        echo 'Service status:'
        docker-compose ps
    "
}

# Rollback to previous version
rollback_system() {
    echo -e "\n${RED}⚠ EMERGENCY ROLLBACK${NC}"
    echo "This will restore the previous system version"
    
    # Check for backups
    echo -e "\n${BLUE}Available backups:${NC}"
    remote_exec "ls -la /root/vivid_mas_DEPRECATED_* 2>/dev/null | tail -5 || echo 'No backups found'"
    
    read -p "Enter backup directory name (or 'cancel'): " backup_dir
    
    if [ "$backup_dir" == "cancel" ] || [ -z "$backup_dir" ]; then
        echo "Rollback cancelled"
        return
    fi
    
    read -p "This will replace the current system. Continue? (yes/no): " -r
    if [[ ! $REPLY == "yes" ]]; then
        return
    fi
    
    remote_exec "
        cd /root
        
        # Stop current system
        cd vivid_mas
        docker-compose down
        
        # Backup current (failed) system
        cd ..
        mv vivid_mas vivid_mas_failed_\$(date +%Y%m%d_%H%M%S)
        
        # Restore backup
        mv $backup_dir vivid_mas
        
        # Start restored system
        cd vivid_mas
        docker-compose up -d
        
        echo '✓ System rolled back to $backup_dir'
    "
}

# Emergency data export
emergency_export() {
    echo -e "\n${BLUE}Emergency data export...${NC}"
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    
    remote_exec "
        cd /root/vivid_mas
        mkdir -p emergency_export_$TIMESTAMP
        
        echo 'Exporting n8n workflows...'
        docker exec n8n n8n export:workflow --backup --output=/backup/emergency_workflows_$TIMESTAMP.json || echo 'Workflow export failed'
        
        echo 'Exporting database...'
        docker exec postgres pg_dumpall -U postgres > emergency_export_$TIMESTAMP/database_$TIMESTAMP.sql || echo 'Database export failed'
        
        echo 'Copying configuration files...'
        cp .env emergency_export_$TIMESTAMP/
        cp docker-compose.yml emergency_export_$TIMESTAMP/
        cp Caddyfile emergency_export_$TIMESTAMP/
        
        echo 'Creating archive...'
        tar -czf emergency_export_$TIMESTAMP.tar.gz emergency_export_$TIMESTAMP/
        
        echo \"✓ Emergency export created: /root/vivid_mas/emergency_export_$TIMESTAMP.tar.gz\"
    "
    
    read -p "Download export to local machine? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        scp -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP:/root/vivid_mas/emergency_export_$TIMESTAMP.tar.gz" "./emergency_export_$TIMESTAMP.tar.gz"
        echo -e "${GREEN}✓ Export downloaded${NC}"
    fi
}

# Fix network issues
fix_network_issues() {
    echo -e "\n${BLUE}Fixing network issues...${NC}"
    
    remote_exec "
        # Check if network exists
        if ! docker network ls | grep -q vivid_mas; then
            echo '✗ Network vivid_mas not found'
            docker network create vivid_mas
            echo '✓ Network created'
        else
            echo '✓ Network exists'
        fi
        
        # Check containers on wrong network
        echo -e '\nContainers not on vivid_mas network:'
        docker ps --format '{{.Names}}' | while read container; do
            if ! docker inspect \$container | grep -q vivid_mas; then
                echo \"✗ \$container is on wrong network\"
                docker network connect vivid_mas \$container 2>/dev/null && echo \"  ✓ Connected to vivid_mas\" || echo \"  ✗ Failed to connect\"
            fi
        done
        
        # Remove unused networks
        docker network prune -f
        echo '✓ Unused networks removed'
    "
}

# Clear logs and temp files
clear_logs_temp() {
    echo -e "\n${BLUE}Clearing logs and temporary files...${NC}"
    
    remote_exec "
        echo 'Disk usage before:'
        df -h /
        
        # Clear Docker logs
        find /var/lib/docker/containers -name '*.log' -exec truncate -s 0 {} \;
        echo '✓ Docker logs cleared'
        
        # Clear system logs
        journalctl --vacuum-time=1d
        echo '✓ System logs cleaned'
        
        # Clear apt cache
        apt-get clean
        echo '✓ APT cache cleared'
        
        # Clear old backups
        find /root -name '*.backup.*' -mtime +7 -delete 2>/dev/null || true
        echo '✓ Old backups removed'
        
        # Docker cleanup
        docker system prune -af --volumes
        echo '✓ Docker cleanup complete'
        
        echo -e '\nDisk usage after:'
        df -h /
    "
}

# Main loop
while true; do
    show_menu
    
    case $choice in
        1) diagnose_issues ;;
        2) fix_encryption_key ;;
        3) fix_database_connection ;;
        4) fix_mcp_mount ;;
        5) restart_all_services ;;
        6) rollback_system ;;
        7) emergency_export ;;
        8) fix_network_issues ;;
        9) clear_logs_temp ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done