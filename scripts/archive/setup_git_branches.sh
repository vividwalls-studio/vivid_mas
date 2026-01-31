#!/bin/bash

# VividWalls MAS Git Branch Setup Script
# This script creates all the branches needed for the restoration project

set -e

echo "🌳 Setting up Git branches for VividWalls MAS Restoration..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create branch
create_branch() {
    local parent=$1
    local branch=$2
    local description=$3
    
    echo -e "${BLUE}Creating branch: ${branch}${NC}"
    git checkout $parent
    git checkout -b $branch
    echo -e "${GREEN}✓ Created: ${branch} - ${description}${NC}"
}

# Ensure we're on main and up to date
echo -e "${YELLOW}Updating main branch...${NC}"
git checkout main
git pull origin main

# Create base restoration branch
create_branch "main" "restoration/base" "Parent branch for all restoration work"

# Phase 0: Credential Consolidation
create_branch "restoration/base" "restoration/phase0-credential-consolidation" "Master credentials file creation"

# Phase 1: Architecture Building
create_branch "restoration/base" "restoration/phase1-architecture" "Architecture and configuration setup"
create_branch "restoration/phase1-architecture" "restoration/phase1-directory-structure" "Future-state directory creation"
create_branch "restoration/phase1-architecture" "restoration/phase1-docker-compose" "Main docker-compose.yml creation"
create_branch "restoration/phase1-architecture" "restoration/phase1-caddy-config" "Caddy reverse proxy configuration"
create_branch "restoration/phase1-architecture" "restoration/phase1-service-configs" "Service-specific configurations"

# Phase 2: Data Migration
create_branch "restoration/base" "restoration/phase2-data-migration" "Data migration from backup"
create_branch "restoration/phase2-data-migration" "restoration/phase2-secrets-n8n" "Secrets and n8n data migration"
create_branch "restoration/phase2-data-migration" "restoration/phase2-database-volumes" "Database volume migration"
create_branch "restoration/phase2-data-migration" "restoration/phase2-service-startup" "Service startup verification"

# Phase 3: System Validation
create_branch "restoration/base" "restoration/phase3-validation" "System validation and testing"
create_branch "restoration/phase3-validation" "restoration/phase3-container-health" "Container health checks"
create_branch "restoration/phase3-validation" "restoration/phase3-endpoint-testing" "Caddy endpoint verification"
create_branch "restoration/phase3-validation" "restoration/phase3-data-integrity" "Data integrity validation"

# Phase 4: Production Cutover
create_branch "restoration/base" "restoration/phase4-cutover" "Production cutover and cleanup"
create_branch "restoration/phase4-cutover" "restoration/phase4-service-stop" "Stop all services"
create_branch "restoration/phase4-cutover" "restoration/phase4-directory-swap" "Directory archive and promotion"
create_branch "restoration/phase4-cutover" "restoration/phase4-service-restart" "Restart from production directory"
create_branch "restoration/phase4-cutover" "restoration/phase4-cleanup" "Legacy file cleanup"

# Return to restoration/base
git checkout restoration/base

echo -e "${GREEN}✅ All branches created successfully!${NC}"
echo -e "${YELLOW}Current branch structure:${NC}"
git branch --list 'restoration/*' | sort

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Start with Phase 0: git checkout restoration/phase0-credential-consolidation"
echo "2. Make changes and commit"
echo "3. Create PR to merge back to restoration/phase1-architecture or restoration/base"
echo "4. After testing, merge to restoration/base"

# Create a visual representation of the branch structure
echo -e "\n${YELLOW}Branch hierarchy:${NC}"
cat << 'EOF'
main
└── restoration/base
    ├── restoration/phase0-credential-consolidation
    ├── restoration/phase1-architecture
    │   ├── restoration/phase1-directory-structure
    │   ├── restoration/phase1-docker-compose
    │   ├── restoration/phase1-caddy-config
    │   └── restoration/phase1-service-configs
    ├── restoration/phase2-data-migration
    │   ├── restoration/phase2-secrets-n8n
    │   ├── restoration/phase2-database-volumes
    │   └── restoration/phase2-service-startup
    ├── restoration/phase3-validation
    │   ├── restoration/phase3-container-health
    │   ├── restoration/phase3-endpoint-testing
    │   └── restoration/phase3-data-integrity
    └── restoration/phase4-cutover
        ├── restoration/phase4-service-stop
        ├── restoration/phase4-directory-swap
        ├── restoration/phase4-service-restart
        └── restoration/phase4-cleanup
EOF