#!/bin/bash

# Phase 1.1: Create Future-State Directory Structure
# This script creates the complete directory structure for VividWalls MAS restoration
# Target: /root/vivid_mas_build on the DigitalOcean droplet

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Phase 1.1: Creating Future-State Directory Structure ===${NC}"
echo -e "${YELLOW}Target directory: /root/vivid_mas_build${NC}"

# Base directory
BASE_DIR="/root/vivid_mas_build"

# Function to create directory with confirmation
create_dir() {
    local dir=$1
    if mkdir -p "$dir"; then
        echo -e "${GREEN}✓ Created: $dir${NC}"
    else
        echo -e "${RED}✗ Failed to create: $dir${NC}"
        exit 1
    fi
}

# Create base directory
echo -e "\n${BLUE}Creating base directory...${NC}"
create_dir "$BASE_DIR"

# Create top-level directories
echo -e "\n${BLUE}Creating top-level directories...${NC}"
create_dir "$BASE_DIR/services"
create_dir "$BASE_DIR/caddy"
create_dir "$BASE_DIR/caddy/sites-enabled"
create_dir "$BASE_DIR/data"
create_dir "$BASE_DIR/n8n"
create_dir "$BASE_DIR/n8n/backup"
create_dir "$BASE_DIR/n8n/workflows"
create_dir "$BASE_DIR/scripts"
create_dir "$BASE_DIR/sql_chunks"
create_dir "$BASE_DIR/shared"
create_dir "$BASE_DIR/shared/files"
create_dir "$BASE_DIR/shared/logs"

# Create service-specific directories
echo -e "\n${BLUE}Creating service directories...${NC}"
services=(
    "supabase"
    "n8n"
    "caddy"
    "twenty"
    "listmonk"
    "langfuse"
    "ollama"
    "wordpress"
    "medusa"
    "mcp-servers"
)

for service in "${services[@]}"; do
    create_dir "$BASE_DIR/services/$service"
    create_dir "$BASE_DIR/services/$service/docker"
    create_dir "$BASE_DIR/services/$service/config"
done

# Create MCP server category directories
echo -e "\n${BLUE}Creating MCP server directories...${NC}"
mcp_categories=(
    "core"
    "agents"
    "business"
    "social-media"
    "creative"
    "analytics"
    "research"
    "sales"
)

for category in "${mcp_categories[@]}"; do
    create_dir "$BASE_DIR/services/mcp-servers/$category"
done

# Create placeholder files
echo -e "\n${BLUE}Creating placeholder files...${NC}"

# Main configuration files
touch "$BASE_DIR/docker-compose.yml" && echo -e "${GREEN}✓ Created: docker-compose.yml${NC}"
touch "$BASE_DIR/.env" && echo -e "${GREEN}✓ Created: .env${NC}"
touch "$BASE_DIR/Caddyfile" && echo -e "${GREEN}✓ Created: Caddyfile${NC}"
touch "$BASE_DIR/README.md" && echo -e "${GREEN}✓ Created: README.md${NC}"

# Create .gitignore
cat > "$BASE_DIR/.gitignore" << 'EOF'
# Environment files
.env
.env.*
!.env.example

# Data files
data/
*.csv
*.json
*.sql

# Logs
logs/
*.log

# Backups
backup/
*.backup
*.bak

# Temporary files
*.tmp
*.temp
.DS_Store

# Docker volumes
volumes/

# Sensitive data
secrets/
credentials/
EOF
echo -e "${GREEN}✓ Created: .gitignore${NC}"

# Create directory listing for verification
echo -e "\n${BLUE}Generating directory structure report...${NC}"
tree_output="$BASE_DIR/directory_structure.txt"
if command -v tree &> /dev/null; then
    tree -d "$BASE_DIR" > "$tree_output"
else
    find "$BASE_DIR" -type d | sort > "$tree_output"
fi
echo -e "${GREEN}✓ Directory structure saved to: $tree_output${NC}"

# Summary
echo -e "\n${GREEN}=== Phase 1.1 Complete ===${NC}"
echo -e "${BLUE}Directory structure created successfully at: $BASE_DIR${NC}"
echo -e "${YELLOW}Total directories created: $(find "$BASE_DIR" -type d | wc -l)${NC}"

# Next steps
echo -e "\n${BLUE}Next Steps:${NC}"
echo "1. Phase 1.2: Create docker-compose.yml"
echo "2. Phase 1.3: Create Caddy configuration"
echo "3. Phase 1.4: Populate service configurations"

# Create phase status update
cat > "$BASE_DIR/phase1_status.json" << EOF
{
  "phase": 1,
  "task": "directory_structure",
  "status": "complete",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "directories_created": $(find "$BASE_DIR" -type d | wc -l),
  "base_path": "$BASE_DIR"
}
EOF

echo -e "${GREEN}✓ Phase status saved${NC}"