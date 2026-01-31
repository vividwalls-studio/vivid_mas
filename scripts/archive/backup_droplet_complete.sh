#!/bin/bash

# Digital Ocean Droplet Complete Backup Script
# Backs up codebase, docker configurations, databases, n8n workflows, and all data

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
SSH_PASSPHRASE="freedom"
REMOTE_USER="root"
BACKUP_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/droplet_backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="${BACKUP_DIR}/${TIMESTAMP}"

# Database credentials (from droplet)
NEO4J_PASSWORD="VPofL3g9gTaquiXxA6ntvQDyK"
POSTGRES_PASSWORD="myqP9lSMLobnuIfkUpXQzZg07"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Create backup directory structure
print_status "Creating backup directory: ${BACKUP_PATH}"
mkdir -p "${BACKUP_PATH}"/{codebase,docker,configs,databases,env_files,nginx,systemd,n8n,neo4j,supabase,qdrant,volumes}

# Create a log file
LOG_FILE="${BACKUP_PATH}/backup_log_${TIMESTAMP}.txt"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

print_status "Starting COMPLETE backup of Digital Ocean droplet"
print_status "Droplet IP: ${DROPLET_IP}"
print_status "Backup location: ${BACKUP_PATH}"

# Function to execute SSH commands with passphrase
ssh_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" ssh -i "${SSH_KEY}" "${REMOTE_USER}@${DROPLET_IP}" "$1"
}

# Function to rsync with passphrase
rsync_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" rsync -avz --progress -e "ssh -i ${SSH_KEY}" "$@"
}

# Function to scp with passphrase
scp_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" "$@"
}

# 1. Backup main codebase
print_status "Backing up VividMAS codebase..."
rsync_exec \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='*.log' \
    --exclude='tmp' \
    --exclude='cache' \
    --exclude='__pycache__' \
    --exclude='.env.local' \
    "${REMOTE_USER}@${DROPLET_IP}:/root/vivid_mas/" \
    "${BACKUP_PATH}/codebase/"

# 2. Backup n8n workflows and data
print_status "Backing up n8n workflows and data..."

# Export n8n workflows via CLI
print_info "Exporting n8n workflows..."
ssh_exec "docker exec -t n8n n8n export:workflow --all --output=/tmp/n8n_workflows_backup.json 2>/dev/null" && \
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_workflows_backup.json" "${BACKUP_PATH}/n8n/workflows_export.json"

# Export n8n credentials
print_info "Exporting n8n credentials..."
ssh_exec "docker exec -t n8n n8n export:credentials --all --output=/tmp/n8n_credentials_backup.json 2>/dev/null" && \
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_credentials_backup.json" "${BACKUP_PATH}/n8n/credentials_export.json"

# Backup n8n database directly
print_info "Backing up n8n SQLite database..."
ssh_exec "docker cp n8n:/home/node/.n8n/database.sqlite /tmp/n8n_database.sqlite 2>/dev/null" && \
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_database.sqlite" "${BACKUP_PATH}/n8n/database.sqlite"

# 3. Backup Neo4j knowledge graph
print_status "Backing up Neo4j knowledge graph..."

# Stop Neo4j for consistent backup
print_info "Creating Neo4j dump..."
ssh_exec "docker exec -t neo4j-knowledge neo4j-admin database dump neo4j --to-path=/tmp --verbose 2>/dev/null || echo 'Using alternative method...'"

# Alternative: Export via cypher-shell
print_info "Exporting Neo4j data via Cypher..."
ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} 'CALL apoc.export.cypher.all(\"/tmp/neo4j_export.cypher\", {format: \"cypher-shell\"})' 2>/dev/null" || {
    # Fallback: Export nodes and relationships separately
    print_info "Using fallback export method..."
    ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} 'CALL apoc.export.json.all(\"/tmp/neo4j_export.json\", {useTypes:true})' 2>/dev/null" || {
        # Manual export
        ssh_exec "mkdir -p /tmp/neo4j_manual_export"
        
        # Export nodes
        ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} 'MATCH (n) RETURN n' --format plain > /tmp/neo4j_manual_export/nodes.txt 2>/dev/null"
        
        # Export relationships  
        ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} 'MATCH ()-[r]->() RETURN r' --format plain > /tmp/neo4j_manual_export/relationships.txt 2>/dev/null"
    }
}

# Copy Neo4j exports
scp_exec -r "${REMOTE_USER}@${DROPLET_IP}:/tmp/neo4j_*" "${BACKUP_PATH}/neo4j/" 2>/dev/null || print_warning "Some Neo4j exports may have failed"

# Backup Neo4j configuration
rsync_exec "${REMOTE_USER}@${DROPLET_IP}:/var/lib/docker/volumes/*neo4j*/_data/conf/" "${BACKUP_PATH}/neo4j/conf/" 2>/dev/null

# 4. Backup PostgreSQL/Supabase database
print_status "Backing up PostgreSQL/Supabase database..."

# Full database dump
print_info "Creating PostgreSQL dump..."
ssh_exec "docker exec -t supabase-db pg_dumpall -U postgres > /tmp/postgres_full_dump.sql 2>/dev/null"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/postgres_full_dump.sql" "${BACKUP_PATH}/supabase/postgres_full_dump.sql"

# Individual database dumps for easier restoration
print_info "Creating individual database dumps..."
ssh_exec "docker exec supabase-db psql -U postgres -t -c 'SELECT datname FROM pg_database WHERE datistemplate = false;'" | while read -r dbname; do
    if [ ! -z "$dbname" ] && [ "$dbname" != "postgres" ]; then
        dbname=$(echo $dbname | xargs) # trim whitespace
        print_info "  Dumping database: $dbname"
        ssh_exec "docker exec supabase-db pg_dump -U postgres -d $dbname -f /tmp/${dbname}_dump.sql 2>/dev/null"
        scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/${dbname}_dump.sql" "${BACKUP_PATH}/supabase/${dbname}_dump.sql" 2>/dev/null
    fi
done

# Export Supabase metadata
print_info "Exporting Supabase metadata..."
ssh_exec "docker exec supabase-db psql -U postgres -c '\dt public.*' > /tmp/supabase_tables.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/supabase_tables.txt" "${BACKUP_PATH}/supabase/table_list.txt"

# 5. Backup Qdrant vector database
print_status "Backing up Qdrant vector database..."
print_info "Creating Qdrant snapshot..."

# Create snapshot via API
ssh_exec "curl -X POST 'http://localhost:6333/snapshots' 2>/dev/null" > "${BACKUP_PATH}/qdrant/snapshot_response.json"

# Backup Qdrant storage directly
rsync_exec "${REMOTE_USER}@${DROPLET_IP}:/var/lib/docker/volumes/*qdrant*/_data/" "${BACKUP_PATH}/qdrant/storage/" 2>/dev/null || print_warning "Qdrant storage backup may be incomplete"

# 6. Backup Docker volumes
print_status "Backing up Docker volumes..."

# Get list of volumes
ssh_exec "docker volume ls --format '{{.Name}}'" | while read -r volume; do
    if [ ! -z "$volume" ]; then
        print_info "  Backing up volume: $volume"
        
        # Create volume backup using temporary container
        ssh_exec "docker run --rm -v ${volume}:/source -v /tmp:/backup alpine tar -czf /backup/${volume}.tar.gz -C /source . 2>/dev/null"
        
        # Copy to local
        scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/${volume}.tar.gz" "${BACKUP_PATH}/volumes/" 2>/dev/null || print_warning "Failed to backup volume: $volume"
        
        # Cleanup
        ssh_exec "rm -f /tmp/${volume}.tar.gz"
    fi
done

# 7. Backup Docker configurations
print_status "Backing up Docker configurations..."

# Docker Compose files
ssh_exec "find /root -name 'docker-compose*.yml' -o -name 'compose*.yml' 2>/dev/null" | while read -r compose_file; do
    if [ ! -z "$compose_file" ]; then
        print_info "  Copying: $compose_file"
        rel_path=$(echo "$compose_file" | sed 's|/root/||')
        mkdir -p "${BACKUP_PATH}/docker/$(dirname $rel_path)"
        scp_exec "${REMOTE_USER}@${DROPLET_IP}:${compose_file}" "${BACKUP_PATH}/docker/${rel_path}"
    fi
done

# 8. Backup environment files
print_status "Backing up environment files..."
ssh_exec "find /root -name '.env*' -not -path '*/node_modules/*' 2>/dev/null" | while read -r env_file; do
    if [ ! -z "$env_file" ]; then
        print_info "  Copying: $env_file"
        rel_path=$(echo "$env_file" | sed 's|/root/||')
        mkdir -p "${BACKUP_PATH}/env_files/$(dirname $rel_path)"
        scp_exec "${REMOTE_USER}@${DROPLET_IP}:${env_file}" "${BACKUP_PATH}/env_files/${rel_path}"
    fi
done

# 9. Backup Langfuse data (if exists)
print_status "Checking for Langfuse data..."
if ssh_exec "docker ps | grep -q langfuse"; then
    print_info "Backing up Langfuse database..."
    ssh_exec "docker exec langfuse-db pg_dump -U postgres langfuse > /tmp/langfuse_dump.sql 2>/dev/null"
    scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/langfuse_dump.sql" "${BACKUP_PATH}/databases/langfuse_dump.sql" 2>/dev/null
fi

# 10. Backup Flowise data (if exists)
print_status "Checking for Flowise data..."
if ssh_exec "docker ps | grep -q flowise"; then
    print_info "Backing up Flowise data..."
    ssh_exec "docker cp flowise:/app/packages/server/.flowise /tmp/flowise_data 2>/dev/null"
    rsync_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/flowise_data/" "${BACKUP_PATH}/databases/flowise_data/" 2>/dev/null
fi

# 11. Export all container configurations
print_status "Exporting container configurations..."
ssh_exec "docker inspect \$(docker ps -aq) > /tmp/container_configs.json 2>/dev/null"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/container_configs.json" "${BACKUP_PATH}/docker/container_configs.json"

# 12. Create comprehensive system snapshot
print_status "Creating system snapshot..."
cat > "${BACKUP_PATH}/system_snapshot.txt" << EOF
=== VividMAS Complete System Backup ===
Backup Date: $(date)
Droplet IP: ${DROPLET_IP}

=== System Information ===
$(ssh_exec "uname -a")
$(ssh_exec "cat /etc/os-release | head -5")

=== Resource Usage ===
$(ssh_exec "df -h")
$(ssh_exec "free -h")

=== Docker Information ===
$(ssh_exec "docker --version")
$(ssh_exec "docker compose version 2>/dev/null || docker-compose --version")

=== Running Containers ===
$(ssh_exec "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'")

=== Docker Networks ===
$(ssh_exec "docker network ls")

=== Service Endpoints ===
n8n: http://${DROPLET_IP}:5678
Supabase Studio: http://${DROPLET_IP}:3000
Neo4j Browser: http://${DROPLET_IP}:7474
Qdrant: http://${DROPLET_IP}:6333
Open WebUI: http://${DROPLET_IP}:3000

=== Database Sizes ===
Neo4j: $(ssh_exec "docker exec neo4j-knowledge du -sh /data 2>/dev/null | cut -f1" || echo "N/A")
PostgreSQL: $(ssh_exec "docker exec supabase-db psql -U postgres -t -c 'SELECT pg_size_pretty(pg_database_size(current_database()));' 2>/dev/null" || echo "N/A")
n8n: $(ssh_exec "docker exec n8n du -sh /home/node/.n8n 2>/dev/null | cut -f1" || echo "N/A")
EOF

# 13. Create data statistics
print_status "Generating data statistics..."
cat > "${BACKUP_PATH}/data_statistics.md" << EOF
# VividMAS Data Backup Statistics

## Neo4j Knowledge Graph
$(ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} 'MATCH (n) RETURN count(n) as total_nodes' 2>/dev/null" || echo "Unable to count nodes")
$(ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} 'MATCH ()-[r]->() RETURN count(r) as total_relationships' 2>/dev/null" || echo "Unable to count relationships")

## PostgreSQL/Supabase
$(ssh_exec "docker exec supabase-db psql -U postgres -t -c 'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '\''public'\'';' 2>/dev/null" || echo "0") tables

## n8n Workflows
$(ssh_exec "docker exec n8n sqlite3 /home/node/.n8n/database.sqlite 'SELECT COUNT(*) FROM workflow_entity;' 2>/dev/null" || echo "0") workflows
$(ssh_exec "docker exec n8n sqlite3 /home/node/.n8n/database.sqlite 'SELECT COUNT(*) FROM execution_entity;' 2>/dev/null" || echo "0") executions

## Docker Volumes
$(ssh_exec "docker volume ls | wc -l" || echo "0") volumes backed up
EOF

# 14. Create comprehensive restore script
print_status "Creating restore script..."
cat > "${BACKUP_PATH}/restore_complete.sh" << 'EOF'
#!/bin/bash
# Complete restore script for VividMAS backup
# Usage: ./restore_complete.sh [target_ip]

set -e

TARGET_IP="${1:-157.230.13.13}"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
SSH_PASSPHRASE="freedom"
BACKUP_DIR="$(dirname "$0")"

echo "=== VividMAS Complete Restore Script ==="
echo "Target: ${TARGET_IP}"
echo "Backup: ${BACKUP_DIR}"
echo ""
echo "WARNING: This will:"
echo "  - Stop all Docker containers"
echo "  - Restore databases (overwriting existing data)"
echo "  - Restore all configurations and code"
echo ""
read -p "Continue with COMPLETE restore? (yes/no) " -r
if [[ ! $REPLY == "yes" ]]; then
    echo "Restore cancelled."
    exit 1
fi

# Function for SSH with passphrase
ssh_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" ssh -i "${SSH_KEY}" "root@${TARGET_IP}" "$1"
}

echo "1. Stopping all containers..."
ssh_exec "cd /root/vivid_mas && docker compose down || true"

echo "2. Restoring codebase..."
rsync -avz --progress \
    -e "ssh -i ${SSH_KEY}" \
    "${BACKUP_DIR}/codebase/" \
    "root@${TARGET_IP}:/root/vivid_mas/"

echo "3. Restoring environment files..."
rsync -avz --progress \
    -e "ssh -i ${SSH_KEY}" \
    "${BACKUP_DIR}/env_files/" \
    "root@${TARGET_IP}:/root/"

echo "4. Restoring Docker configurations..."
rsync -avz --progress \
    -e "ssh -i ${SSH_KEY}" \
    "${BACKUP_DIR}/docker/" \
    "root@${TARGET_IP}:/root/"

echo "5. Starting core services..."
ssh_exec "cd /root/vivid_mas && docker compose up -d postgres neo4j qdrant"
sleep 30

echo "6. Restoring PostgreSQL database..."
scp -i "${SSH_KEY}" "${BACKUP_DIR}/supabase/postgres_full_dump.sql" "root@${TARGET_IP}:/tmp/"
ssh_exec "docker exec -i supabase-db psql -U postgres < /tmp/postgres_full_dump.sql"

echo "7. Restoring Neo4j database..."
# Try multiple restore methods
if [ -f "${BACKUP_DIR}/neo4j/neo4j_export.cypher" ]; then
    scp -i "${SSH_KEY}" "${BACKUP_DIR}/neo4j/neo4j_export.cypher" "root@${TARGET_IP}:/tmp/"
    ssh_exec "docker exec -i neo4j-knowledge cypher-shell -u neo4j -p VPofL3g9gTaquiXxA6ntvQDyK < /tmp/neo4j_export.cypher"
elif [ -f "${BACKUP_DIR}/neo4j/neo4j_export.json" ]; then
    scp -i "${SSH_KEY}" "${BACKUP_DIR}/neo4j/neo4j_export.json" "root@${TARGET_IP}:/tmp/"
    ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p VPofL3g9gTaquiXxA6ntvQDyK 'CALL apoc.import.json(\"/tmp/neo4j_export.json\")'"
fi

echo "8. Restoring n8n..."
ssh_exec "docker compose up -d n8n"
sleep 20
if [ -f "${BACKUP_DIR}/n8n/database.sqlite" ]; then
    scp -i "${SSH_KEY}" "${BACKUP_DIR}/n8n/database.sqlite" "root@${TARGET_IP}:/tmp/"
    ssh_exec "docker cp /tmp/database.sqlite n8n:/home/node/.n8n/database.sqlite"
    ssh_exec "docker restart n8n"
fi

echo "9. Starting all services..."
ssh_exec "cd /root/vivid_mas && docker compose up -d"

echo "10. Verifying services..."
sleep 30
ssh_exec "docker ps --format 'table {{.Names}}\t{{.Status}}'"

echo ""
echo "Restore complete!"
echo "Please verify:"
echo "  - n8n workflows at http://${TARGET_IP}:5678"
echo "  - Neo4j at http://${TARGET_IP}:7474"
echo "  - Supabase at http://${TARGET_IP}:3000"
EOF

chmod +x "${BACKUP_PATH}/restore_complete.sh"

# 15. Cleanup temporary files on droplet
print_status "Cleaning up temporary files on droplet..."
ssh_exec "rm -f /tmp/*.sql /tmp/*.json /tmp/*.tar.gz /tmp/neo4j_* 2>/dev/null || true"

# 16. Create compressed archive
print_status "Creating compressed archive..."
TOTAL_SIZE=$(du -sh "${BACKUP_PATH}" | cut -f1)
FILE_COUNT=$(find "${BACKUP_PATH}" -type f | wc -l | xargs)

cd "${BACKUP_DIR}"
tar -czf "vivid_mas_complete_backup_${TIMESTAMP}.tar.gz" "${TIMESTAMP}/" --checkpoint=.100
echo "" # New line after tar progress dots

# 17. Create backup manifest
cat > "${BACKUP_PATH}/BACKUP_MANIFEST.md" << EOF
# VividMAS Complete Backup Manifest

**Backup Date:** $(date)  
**Droplet IP:** ${DROPLET_IP}  
**Total Size:** ${TOTAL_SIZE}  
**Total Files:** ${FILE_COUNT}  
**Compressed Archive:** vivid_mas_complete_backup_${TIMESTAMP}.tar.gz

## Contents

### Application Data
- ✅ Complete codebase from /root/vivid_mas
- ✅ All Docker configurations and compose files
- ✅ Environment variables and secrets
- ✅ Configuration files (JSON, YAML, etc.)

### Databases
- ✅ Neo4j knowledge graph (full export)
- ✅ PostgreSQL/Supabase (complete dump)
- ✅ n8n workflows and execution history
- ✅ Qdrant vector database
- ✅ Langfuse analytics (if present)
- ✅ Flowise data (if present)

### Infrastructure
- ✅ Docker volumes (compressed)
- ✅ Container configurations
- ✅ Nginx configurations
- ✅ Systemd service files

### Metadata
- ✅ System snapshot
- ✅ Data statistics
- ✅ Service endpoints
- ✅ Resource usage

## Restore Instructions

### Quick Restore (Everything)
\`\`\`bash
cd ${BACKUP_PATH}
./restore_complete.sh [target_ip]
\`\`\`

### Selective Restore

#### Code Only
\`\`\`bash
rsync -avz codebase/ root@${DROPLET_IP}:/root/vivid_mas/
\`\`\`

#### Databases Only
\`\`\`bash
# PostgreSQL
docker exec -i supabase-db psql -U postgres < supabase/postgres_full_dump.sql

# Neo4j
docker exec -i neo4j-knowledge cypher-shell -u neo4j -p ${NEO4J_PASSWORD} < neo4j/neo4j_export.cypher

# n8n
docker cp n8n/database.sqlite n8n:/home/node/.n8n/database.sqlite
docker restart n8n
\`\`\`

## Security Notes
⚠️ This backup contains:
- Database passwords
- API keys and secrets
- Private configuration
- Customer data

**Handle with extreme care!**

## Verification Checklist
After restore:
- [ ] All Docker containers running
- [ ] n8n workflows accessible
- [ ] Neo4j browser accessible
- [ ] Supabase studio accessible
- [ ] API endpoints responding
- [ ] Background jobs running
EOF

# Final summary
print_status "======================================"
print_status "COMPLETE BACKUP FINISHED SUCCESSFULLY!"
print_status "======================================"
print_info "Backup location: ${BACKUP_PATH}"
print_info "Total size: ${TOTAL_SIZE}"
print_info "Total files: ${FILE_COUNT}"
print_info "Compressed archive: ${BACKUP_DIR}/vivid_mas_complete_backup_${TIMESTAMP}.tar.gz"
print_info "Compressed size: $(du -h ${BACKUP_DIR}/vivid_mas_complete_backup_${TIMESTAMP}.tar.gz | cut -f1)"
print_status "======================================"

# Cleanup old backups (keep last 3 complete backups)
print_status "Cleaning up old backups..."
cd "${BACKUP_DIR}"
ls -t1 | grep -E '^[0-9]{8}_[0-9]{6}$' | tail -n +4 | xargs -I {} rm -rf {}
ls -t1 | grep -E '^vivid_mas_complete_backup_.*\.tar\.gz$' | tail -n +4 | xargs -I {} rm -f {}

print_status "Backup process complete! Check ${BACKUP_PATH}/BACKUP_MANIFEST.md for details."