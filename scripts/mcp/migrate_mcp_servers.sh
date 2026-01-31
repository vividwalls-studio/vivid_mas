#!/bin/bash
# MCP Server Migration Script
# Migrates MCP server configurations from backup to /opt/mcp-servers

set -euo pipefail

# Configuration
BACKUP_PATH="${1:-/root/backup}"
TARGET_PATH="/opt/mcp-servers"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== MCP Server Migration Script ===${NC}"

# Find MCP servers in backup
find_mcp_backup() {
    local mcp_dirs=(
        "$BACKUP_PATH/vividwalls_data_backups/20250708_030001/mcp-servers"
        "$BACKUP_PATH/20250626_180723/codebase/services/mcp-servers"
        "$BACKUP_PATH/mcp-servers"
    )
    
    for dir in "${mcp_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "$dir"
            return 0
        fi
    done
    
    return 1
}

# Backup current MCP servers
backup_current() {
    if [ -d "$TARGET_PATH" ]; then
        echo -e "${YELLOW}Backing up current MCP servers...${NC}"
        tar czf "/root/mcp-servers-backup-${TIMESTAMP}.tar.gz" -C /opt mcp-servers
        echo -e "${GREEN}✓ Backup created${NC}"
    fi
}

# Migrate MCP servers
migrate_servers() {
    local source_path=$1
    
    echo "Migrating from: $source_path"
    echo "Target: $TARGET_PATH"
    
    # Create target directory if not exists
    mkdir -p "$TARGET_PATH"
    
    # List of core MCP servers to migrate
    local servers=(
        "core/shopify-mcp-server"
        "core/n8n-mcp-server"
        "core/supabase-mcp-server"
        "core/stripe-mcp-server"
        "core/sendgrid-mcp-server"
        "core/neo4j-mcp-server"
        "analytics/kpi-dashboard"
        "agents/business-manager-prompts"
        "agents/business-manager-resource"
        "agents/marketing-director-prompts"
        "agents/marketing-director-resource"
    )
    
    for server in "${servers[@]}"; do
        if [ -d "$source_path/$server" ]; then
            echo "Migrating $server..."
            
            # Create target directory
            mkdir -p "$TARGET_PATH/$(dirname "$server")"
            
            # Copy server files, excluding node_modules
            rsync -av --exclude='node_modules' --exclude='dist' --exclude='build' \
                "$source_path/$server/" "$TARGET_PATH/$server/"
            
            # Fix permissions
            chown -R root:root "$TARGET_PATH/$server"
            
            echo -e "${GREEN}✓ Migrated $server${NC}"
        else
            echo -e "${YELLOW}⚠ Server $server not found in backup${NC}"
        fi
    done
}

# Build TypeScript servers
build_servers() {
    echo -e "${YELLOW}Building TypeScript MCP servers...${NC}"
    
    # Find all package.json files
    find "$TARGET_PATH" -name "package.json" -type f | while read pkg; do
        dir=$(dirname "$pkg")
        
        # Skip if no TypeScript files
        if ! find "$dir" -name "*.ts" -type f | grep -q .; then
            continue
        fi
        
        echo "Building $dir..."
        cd "$dir"
        
        # Install dependencies
        if [ -f "package-lock.json" ]; then
            npm ci --silent
        else
            npm install --silent
        fi
        
        # Build if build script exists
        if grep -q '"build"' package.json; then
            npm run build
            echo -e "${GREEN}✓ Built $(basename "$dir")${NC}"
        fi
    done
}

# Verify MCP server setup
verify_setup() {
    echo -e "${YELLOW}Verifying MCP server setup...${NC}"
    
    # Check if n8n can access MCP servers
    if docker exec n8n ls /opt/mcp-servers >/dev/null 2>&1; then
        echo -e "${GREEN}✓ N8N can access MCP servers${NC}"
        
        # List available servers
        echo "Available MCP servers:"
        docker exec n8n find /opt/mcp-servers -name "package.json" -type f | \
            sed 's|/opt/mcp-servers/||' | sed 's|/package.json||' | sort
    else
        echo -e "${RED}✗ N8N cannot access MCP servers${NC}"
        echo "Check volume mount in docker-compose.yml"
    fi
}

# Main execution
main() {
    # Find MCP backup directory
    MCP_BACKUP=$(find_mcp_backup)
    if [ $? -ne 0 ]; then
        echo -e "${RED}No MCP server backup found${NC}"
        exit 1
    fi
    
    echo "Found MCP backup at: $MCP_BACKUP"
    
    # Confirm migration
    read -p "Migrate MCP servers to $TARGET_PATH? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Migration cancelled"
        exit 0
    fi
    
    # Execute migration
    backup_current
    migrate_servers "$MCP_BACKUP"
    build_servers
    verify_setup
    
    echo -e "${GREEN}=== MCP Server migration completed ===${NC}"
}

# Run main function
main