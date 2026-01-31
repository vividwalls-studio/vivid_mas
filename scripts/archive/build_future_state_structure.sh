#!/bin/bash

# VividWalls MAS Future State Architecture Builder
# This script creates the complete directory structure for the optimized deployment
# Target: /root/vivid_mas_build

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base build directory
BUILD_DIR="/root/vivid_mas_build"

echo -e "${BLUE}🏗️  VividWalls MAS Future State Architecture Builder${NC}"
echo -e "${BLUE}=================================================${NC}"
echo -e "Target directory: ${BUILD_DIR}"
echo ""

# Create base directory
echo -e "${YELLOW}Creating base directory structure...${NC}"
mkdir -p "${BUILD_DIR}"

# Create main project structure
directories=(
    # Service-specific configs
    "services/supabase/docker"
    "services/supabase/config"
    "services/n8n/docker"
    "services/n8n/agents/workflows/core"
    "services/n8n/agents/workflows/subagents"
    "services/n8n/agents/prompts"
    "services/caddy/docker"
    "services/twenty/docker"
    "services/listmonk/docker"
    "services/langfuse/docker"
    "services/ollama/docker"
    "services/wordpress/docker"
    "services/medusa/docker"
    "services/medusa/config"
    
    # MCP server containerized configs
    "services/mcp-servers/core"
    "services/mcp-servers/agents"
    "services/mcp-servers/analytics"
    "services/mcp-servers/social-media"
    "services/mcp-servers/creative"
    "services/mcp-servers/sales"
    "services/mcp-servers/research"
    "services/mcp-servers/dev"
    "services/mcp-servers/tools"
    
    # Caddy configurations
    "caddy/sites-enabled"
    
    # Data directory
    "data/exports"
    
    # N8N workflow data
    "n8n/backup/workflows"
    "n8n/workflows"
    
    # Scripts
    "scripts/deployment"
    "scripts/validation"
    "scripts/migration"
    
    # SQL chunks for agent system
    "sql_chunks"
    
    # Shared volumes
    "shared/files"
    "shared/logs"
    
    # Configuration management
    "configs/mcp/production"
    "configs/mcp/development"
    "configs/mcp/templates"
    "configs/environment"
)

for dir in "${directories[@]}"; do
    mkdir -p "${BUILD_DIR}/${dir}"
    echo -e "${GREEN}✓${NC} Created: ${dir}"
done

# Create placeholder files for critical configs
echo -e "\n${YELLOW}Creating placeholder configuration files...${NC}"

# Main files
touch "${BUILD_DIR}/docker-compose.yml"
touch "${BUILD_DIR}/.env"
touch "${BUILD_DIR}/Caddyfile"
touch "${BUILD_DIR}/README.md"

# Service-specific docker-compose files
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
)

for service in "${services[@]}"; do
    touch "${BUILD_DIR}/services/${service}/docker/docker-compose.yml"
    echo -e "${GREEN}✓${NC} Created: services/${service}/docker/docker-compose.yml"
done

# Caddy site configurations
caddy_sites=(
    "supabase"
    "n8n"
    "twenty"
    "openwebui"
    "flowise"
    "ollama"
    "listmonk"
    "postiz"
    "wordpress"
    "neo4j"
    "searxng"
    "crawl4ai"
    "langfuse"
    "medusa"
)

for site in "${caddy_sites[@]}"; do
    touch "${BUILD_DIR}/caddy/sites-enabled/${site}.caddy"
    echo -e "${GREEN}✓${NC} Created: caddy/sites-enabled/${site}.caddy"
done

# MCP configuration files
touch "${BUILD_DIR}/configs/mcp/production/n8n-mcp-config.json"
touch "${BUILD_DIR}/configs/mcp/development/n8n-mcp-config.json"
touch "${BUILD_DIR}/configs/mcp/templates/mcp-server.template.json"

# Environment configuration files
touch "${BUILD_DIR}/configs/environment/.env.production"
touch "${BUILD_DIR}/configs/environment/.env.development"
touch "${BUILD_DIR}/configs/environment/.env.example"

# Scripts
scripts=(
    "scripts/start-all.sh"
    "scripts/status.sh"
    "scripts/stop-all.sh"
    "scripts/deployment/deploy.sh"
    "scripts/deployment/rollback.sh"
    "scripts/validation/validate-environment.sh"
    "scripts/validation/validate-mcp-config.sh"
    "scripts/validation/verify-deployment.sh"
    "scripts/validation/verify-mcp-integration.sh"
    "scripts/migration/migrate_n8n_to_supabase.sh"
    "scripts/migration/standardize_compose_configs.sh"
)

for script in "${scripts[@]}"; do
    touch "${BUILD_DIR}/${script}"
    chmod +x "${BUILD_DIR}/${script}"
    echo -e "${GREEN}✓${NC} Created: ${script}"
done

# Data files (placeholders)
data_files=(
    "data/vividwalls_product_catalog-06-18-25.csv"
    "data/vividwalls_products_catalog-06-18-25_updated.csv"
    "data/vividwalls_knowledge_consolidated.csv"
)

for file in "${data_files[@]}"; do
    touch "${BUILD_DIR}/${file}"
    echo -e "${GREEN}✓${NC} Created: ${file}"
done

# SQL chunks
sql_chunks=(
    "sql_chunks/agent_data_chunk_1.sql"
    "sql_chunks/agent_data_chunk_2.sql"
    "sql_chunks/agent_data_chunk_3.sql"
    "sql_chunks/agent_data_chunk_4.sql"
)

for chunk in "${sql_chunks[@]}"; do
    touch "${BUILD_DIR}/${chunk}"
    echo -e "${GREEN}✓${NC} Created: ${chunk}"
done

# Create .gitkeep files for empty directories
find "${BUILD_DIR}" -type d -empty -exec touch {}/.gitkeep \;

echo -e "\n${GREEN}✅ Directory structure created successfully!${NC}"
echo -e "${BLUE}Total directories created:${NC} $(find ${BUILD_DIR} -type d | wc -l)"
echo -e "${BLUE}Total files created:${NC} $(find ${BUILD_DIR} -type f | wc -l)"

# Summary
echo -e "\n${BLUE}📁 Directory Structure Summary:${NC}"
tree -d -L 3 "${BUILD_DIR}" 2>/dev/null || {
    echo -e "${YELLOW}Note: Install 'tree' for a visual directory structure${NC}"
    echo "Main directories created:"
    ls -la "${BUILD_DIR}/"
}

echo -e "\n${GREEN}✅ Future state directory structure is ready at: ${BUILD_DIR}${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Generate docker-compose.yml with proper service definitions"
echo "2. Create environment configuration files"
echo "3. Set up Caddy site configurations"
echo "4. Configure MCP server definitions"