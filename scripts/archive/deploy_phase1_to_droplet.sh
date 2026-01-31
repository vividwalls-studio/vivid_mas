#!/bin/bash

# Phase 1: Deploy Future-State Architecture to DigitalOcean Droplet
# This script executes all Phase 1 tasks on the remote droplet

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"
LOCAL_MASTER_ENV="/Volumes/SeagatePortableDrive/Projects/vivid_mas/master.env"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== VividWalls MAS Phase 1 Deployment ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"

# Function to execute remote command
remote_exec() {
    local command=$1
    local description=$2
    
    echo -e "\n${BLUE}Executing: $description${NC}"
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$command"
}

# Function to copy file to remote
copy_to_remote() {
    local source=$1
    local dest=$2
    local description=$3
    
    echo -e "\n${BLUE}Copying: $description${NC}"
    scp -i "$SSH_KEY" "$source" "$REMOTE_USER@$DROPLET_IP:$dest"
}

# Phase 1.1: Create Directory Structure
echo -e "\n${GREEN}=== Phase 1.1: Creating Directory Structure ===${NC}"

# Copy and execute directory creation script
copy_to_remote "scripts/phase1_create_directory_structure.sh" "/tmp/create_dirs.sh" "Directory creation script"
remote_exec "chmod +x /tmp/create_dirs.sh && /tmp/create_dirs.sh" "Creating future-state directories"

# Phase 1.2: Deploy Docker Compose
echo -e "\n${GREEN}=== Phase 1.2: Creating Docker Compose Configuration ===${NC}"

# Copy docker-compose.yml
copy_to_remote "scripts/phase1_docker_compose.yml" "/root/vivid_mas_build/docker-compose.yml" "Main docker-compose.yml"

# Phase 1.3: Deploy Caddy Configuration
echo -e "\n${GREEN}=== Phase 1.3: Creating Caddy Configuration ===${NC}"

# Copy main Caddyfile
copy_to_remote "scripts/phase1_caddyfile.txt" "/root/vivid_mas_build/Caddyfile" "Main Caddyfile"

# Copy and execute Caddy sites creation
copy_to_remote "scripts/phase1_caddy_sites.sh" "/tmp/create_caddy_sites.sh" "Caddy sites script"
remote_exec "chmod +x /tmp/create_caddy_sites.sh && /tmp/create_caddy_sites.sh" "Creating Caddy site configs"

# Phase 1.4: Deploy Environment Configuration
echo -e "\n${GREEN}=== Phase 1.4: Deploying Environment Configuration ===${NC}"

# Check if master.env exists
if [ ! -f "$LOCAL_MASTER_ENV" ]; then
    echo -e "${RED}ERROR: master.env not found at $LOCAL_MASTER_ENV${NC}"
    echo -e "${YELLOW}Please run Phase 0 first to create master.env${NC}"
    exit 1
fi

# Copy master.env as .env
copy_to_remote "$LOCAL_MASTER_ENV" "/root/vivid_mas_build/.env" "Environment configuration"

# Create additional service configurations
echo -e "\n${BLUE}Creating service-specific configurations...${NC}"

# Create Supabase include file
remote_exec "cat > /root/vivid_mas_build/services/supabase/docker/docker-compose.yml << 'EOF'
# Supabase services are managed by the main Supabase deployment
# This file exists for future containerization of Supabase stack
# Current location: /home/vivid/vivid_mas/supabase/docker/
EOF" "Creating Supabase placeholder"

# Create network if it doesn't exist
echo -e "\n${BLUE}Ensuring Docker network exists...${NC}"
remote_exec "docker network ls | grep -q vivid_mas || docker network create vivid_mas" "Creating vivid_mas network"

# Verify deployment
echo -e "\n${GREEN}=== Verifying Phase 1 Deployment ===${NC}"

# Check directory structure
remote_exec "ls -la /root/vivid_mas_build/" "Listing main directory"
remote_exec "find /root/vivid_mas_build -type d | wc -l" "Counting directories created"

# Check key files
remote_exec "test -f /root/vivid_mas_build/docker-compose.yml && echo '✓ docker-compose.yml exists' || echo '✗ docker-compose.yml missing'" "Checking docker-compose.yml"
remote_exec "test -f /root/vivid_mas_build/.env && echo '✓ .env exists' || echo '✗ .env missing'" "Checking .env"
remote_exec "test -f /root/vivid_mas_build/Caddyfile && echo '✓ Caddyfile exists' || echo '✗ Caddyfile missing'" "Checking Caddyfile"

# Create deployment summary
echo -e "\n${BLUE}Creating deployment summary...${NC}"
remote_exec "cat > /root/vivid_mas_build/phase1_deployment_summary.txt << 'EOF'
Phase 1 Deployment Summary
========================

Deployment Time: $(date)
Target Directory: /root/vivid_mas_build

Components Deployed:
1. Directory Structure - Complete
2. Docker Compose Configuration - Complete
3. Caddy Configuration - Complete
4. Environment Variables - Complete

Key Features:
- Fixed n8n volume mount for MCP servers (/opt/mcp-servers)
- Fixed n8n database host (postgres not db)
- All services on vivid_mas network
- Modular Caddy configuration
- Complete environment variables from master.env

Next Steps:
- Phase 2: Data Migration
  - Migrate n8n workflows and credentials
  - Migrate database volumes
  - Copy MCP servers to /opt/mcp-servers

Verification Commands:
- cd /root/vivid_mas_build
- docker-compose config (validate configuration)
- docker network ls (verify vivid_mas network)
EOF" "Creating summary"

# Clean up temporary files
echo -e "\n${BLUE}Cleaning up temporary files...${NC}"
remote_exec "rm -f /tmp/create_dirs.sh /tmp/create_caddy_sites.sh" "Removing temp scripts"

# Final status
echo -e "\n${GREEN}=== Phase 1 Deployment Complete ===${NC}"
echo -e "${BLUE}Summary:${NC}"
echo -e "  ✓ Directory structure created"
echo -e "  ✓ Docker Compose deployed with critical fixes"
echo -e "  ✓ Caddy configuration with all service endpoints"
echo -e "  ✓ Environment variables from master.env"
echo -e "\n${YELLOW}Build directory: /root/vivid_mas_build${NC}"
echo -e "${YELLOW}Ready for Phase 2: Data Migration${NC}"

# Update local context
echo -e "\n${BLUE}Updating local context...${NC}"
cat > .context/phase_status/phase1_status.json << EOF
{
  "phase": 1,
  "status": "complete",
  "start_time": "$(date -u -Iseconds)",
  "end_time": "$(date -u -Iseconds)",
  "tasks": {
    "directory_structure": "complete",
    "docker_compose": "complete",
    "caddy_config": "complete",
    "service_configs": "complete"
  },
  "deployment": {
    "target": "$DROPLET_IP",
    "directory": "/root/vivid_mas_build",
    "files_created": [
      "docker-compose.yml",
      ".env",
      "Caddyfile",
      "caddy/sites-enabled/*.caddy"
    ]
  },
  "notes": "Phase 1 complete. Critical fixes applied: n8n MCP volume mount, postgres host, vivid_mas network"
}
EOF

echo -e "${GREEN}✓ Context updated${NC}"