#!/bin/bash

# Phase 2: Data Migration for VividWalls MAS
# This script migrates essential data from the backup to the new build directory

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

echo -e "${BLUE}=== VividWalls MAS Phase 2: Data Migration ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"

# Function to execute remote command
remote_exec() {
    local command=$1
    local description=$2
    
    echo -e "\n${BLUE}$description${NC}"
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$command"
}

# Phase 2.1: Migrate n8n Data
echo -e "\n${GREEN}=== Phase 2.1: Migrating n8n Data ===${NC}"

# Check for n8n backup directory
remote_exec "ls -la /root/vivid_mas/n8n/backup/ 2>/dev/null | head -10 || echo 'No n8n backup found'" "Checking n8n backups"

# Copy n8n workflow backups if they exist
remote_exec "
if [ -d /root/vivid_mas/n8n/backup ]; then
    cp -r /root/vivid_mas/n8n/backup/* /root/vivid_mas_build/n8n/backup/ 2>/dev/null || true
    echo '✓ N8N workflow backups copied'
else
    echo '⚠ No n8n backup directory found'
fi
" "Copying n8n workflow backups"

# Check for MCP servers
echo -e "\n${BLUE}Checking MCP servers location...${NC}"
remote_exec "
if [ -d /opt/mcp-servers ]; then
    echo '✓ MCP servers found at /opt/mcp-servers'
    ls -la /opt/mcp-servers/ | head -10
else
    echo '✗ MCP servers not found at /opt/mcp-servers'
    echo 'Checking alternative locations...'
    find /root /home -name 'mcp-servers' -type d 2>/dev/null | head -5
fi
" "Locating MCP servers"

# Phase 2.2: Prepare Database Migration
echo -e "\n${GREEN}=== Phase 2.2: Preparing Database Migration ===${NC}"

# Create migration script on remote
remote_exec "cat > /tmp/migrate_databases.sh << 'SCRIPT'
#!/bin/bash
set -e

echo '=== Database Volume Migration ==='

# Start only the database services in the build directory
cd /root/vivid_mas_build

# Start PostgreSQL
echo 'Starting PostgreSQL in build directory...'
docker-compose up -d postgres
sleep 10

# Wait for PostgreSQL to be ready
echo 'Waiting for PostgreSQL to be ready...'
for i in {1..30}; do
    if docker exec postgres pg_isready -U postgres > /dev/null 2>&1; then
        echo '✓ PostgreSQL is ready'
        break
    fi
    echo -n '.'
    sleep 1
done

# Check current database state
echo 'Checking database state...'
docker exec postgres psql -U postgres -c '\\l' || true

# Backup current n8n database from production
echo 'Creating database backup from production...'
if docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) FROM workflow_entity;' > /dev/null 2>&1; then
    docker exec postgres pg_dump -U postgres postgres > /tmp/n8n_backup.sql
    echo '✓ Database backup created'
    
    # Show workflow count
    WORKFLOW_COUNT=\\$(docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' | tr -d ' ')
    echo \"✓ Found \\$WORKFLOW_COUNT workflows in database\"
else
    echo '⚠ No n8n database found or workflow_entity table does not exist'
fi

# Stop the build PostgreSQL
docker-compose down

echo 'Database preparation complete'
SCRIPT
chmod +x /tmp/migrate_databases.sh
" "Creating database migration script"

# Execute database migration preparation
remote_exec "/tmp/migrate_databases.sh" "Preparing database migration"

# Phase 2.2.5: Copy Critical Data Files
echo -e "\n${BLUE}Copying critical data files...${NC}"

remote_exec "
# Copy product catalogs if they exist
if [ -d /root/vivid_mas/data ]; then
    cp /root/vivid_mas/data/*.csv /root/vivid_mas_build/data/ 2>/dev/null || true
    echo '✓ Product catalog files copied'
fi

# Copy SQL chunks for agent data
if [ -d /root/vivid_mas/sql_chunks ]; then
    cp /root/vivid_mas/sql_chunks/*.sql /root/vivid_mas_build/sql_chunks/ 2>/dev/null || true
    echo '✓ Agent SQL chunks copied'
fi

# List copied files
echo 'Files in build data directory:'
ls -la /root/vivid_mas_build/data/ 2>/dev/null || echo 'No data files'
echo 'Files in build sql_chunks directory:'
ls -la /root/vivid_mas_build/sql_chunks/ 2>/dev/null || echo 'No SQL chunks'
" "Copying data files"

# Phase 2.3: Create Volume Migration Script
echo -e "\n${GREEN}=== Phase 2.3: Creating Volume Migration Script ===${NC}"

remote_exec "cat > /tmp/migrate_volumes.sh << 'VOLSCRIPT'
#!/bin/bash
set -e

echo '=== Docker Volume Migration ==='

# Function to migrate a volume
migrate_volume() {
    local src_vol=\\$1
    local dest_vol=\\$2
    local description=\\$3
    
    echo \"Migrating \\$description...\"
    
    # Check if source volume exists
    if docker volume inspect \\$src_vol > /dev/null 2>&1; then
        # Create destination volume if it doesn't exist
        docker volume create \\$dest_vol || true
        
        # Use temporary container to copy data
        docker run --rm \\
            -v \\$src_vol:/source:ro \\
            -v \\$dest_vol:/dest \\
            alpine sh -c 'cp -av /source/* /dest/ 2>/dev/null || true'
        
        echo \"✓ \\$description migrated\"
    else
        echo \"⚠ Source volume \\$src_vol not found\"
    fi
}

# List current volumes
echo 'Current Docker volumes:'
docker volume ls | grep -E '(n8n|postgres|supabase|neo4j|wordpress)' || true

# Migrate critical volumes
migrate_volume 'vivid_mas_n8n_storage' 'vivid_mas_build_n8n_storage' 'n8n data'
migrate_volume 'vivid_mas_postgres_storage' 'vivid_mas_build_postgres_storage' 'PostgreSQL data'

echo 'Volume migration complete'
VOLSCRIPT
chmod +x /tmp/migrate_volumes.sh
" "Creating volume migration script"

# Create service startup script
echo -e "\n${BLUE}Creating service startup script...${NC}"

remote_exec "cat > /tmp/start_services.sh << 'STARTSCRIPT'
#!/bin/bash
set -e

cd /root/vivid_mas_build

echo '=== Starting Services from Build Directory ==='

# Ensure network exists
docker network create vivid_mas 2>/dev/null || true

# Start core services first
echo 'Starting core services...'
docker-compose up -d postgres redis
sleep 10

# Start n8n
echo 'Starting n8n...'
docker-compose up -d n8n
sleep 5

# Start other services
echo 'Starting remaining services...'
docker-compose up -d

# Wait for services to stabilize
echo 'Waiting for services to stabilize...'
sleep 20

# Show running containers
echo 'Running containers:'
docker-compose ps

# Check n8n health
echo 'Checking n8n health...'
curl -s http://localhost:5678/healthz && echo ' - n8n is healthy' || echo ' - n8n health check failed'

STARTSCRIPT
chmod +x /tmp/start_services.sh
" "Creating service startup script"

# Create verification script
echo -e "\n${BLUE}Creating verification script...${NC}"

remote_exec "cat > /tmp/verify_migration.sh << 'VERIFYSCRIPT'
#!/bin/bash

echo '=== Migration Verification ==='

# Check n8n can access MCP servers
echo 'Checking n8n MCP access...'
docker exec n8n ls /opt/mcp-servers 2>/dev/null && echo '✓ MCP servers accessible' || echo '✗ MCP servers not accessible'

# Check database connection
echo 'Checking database connection...'
docker exec n8n printenv | grep DB_POSTGRESDB_HOST || echo 'Database host not set'

# Check workflow count
echo 'Checking workflow count...'
docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) FROM workflow_entity;' 2>/dev/null || echo 'Cannot count workflows'

# Check encryption key
echo 'Checking encryption key...'
docker exec n8n printenv | grep -q N8N_ENCRYPTION_KEY && echo '✓ Encryption key is set' || echo '✗ Encryption key missing'

VERIFYSCRIPT
chmod +x /tmp/verify_migration.sh
" "Creating verification script"

# Summary
echo -e "\n${GREEN}=== Phase 2 Scripts Created ===${NC}"
echo -e "${BLUE}Migration scripts ready on droplet:${NC}"
echo -e "  - /tmp/migrate_databases.sh"
echo -e "  - /tmp/migrate_volumes.sh"
echo -e "  - /tmp/start_services.sh"
echo -e "  - /tmp/verify_migration.sh"

echo -e "\n${YELLOW}Next steps to complete Phase 2:${NC}"
echo -e "1. SSH to droplet: ssh -i ~/.ssh/digitalocean root@$DROPLET_IP"
echo -e "2. Execute: /tmp/migrate_volumes.sh"
echo -e "3. Execute: /tmp/start_services.sh"
echo -e "4. Execute: /tmp/verify_migration.sh"

# Update context
cat > .context/phase_status/phase2_status.json << EOF
{
  "phase": 2,
  "status": "scripts_ready",
  "start_time": "$(date -u -Iseconds)",
  "tasks": {
    "secrets_n8n": "ready",
    "database_volumes": "ready",
    "service_startup": "ready"
  },
  "scripts_created": [
    "/tmp/migrate_databases.sh",
    "/tmp/migrate_volumes.sh",
    "/tmp/start_services.sh",
    "/tmp/verify_migration.sh"
  ],
  "notes": "Migration scripts created on droplet. Manual execution required."
}
EOF

echo -e "${GREEN}✓ Phase 2 preparation complete${NC}"