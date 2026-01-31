#!/bin/bash

# Digital Ocean Droplet Backup Script
# Backs up codebase, docker configurations, and all config files

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
SSH_PASSPHRASE="freedom"
REMOTE_USER="root"
BACKUP_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/droplet_backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="${BACKUP_DIR}/${TIMESTAMP}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

# Create backup directory structure
print_status "Creating backup directory: ${BACKUP_PATH}"
mkdir -p "${BACKUP_PATH}"/{codebase,docker,configs,databases,env_files,nginx,systemd}

# Create a log file
LOG_FILE="${BACKUP_PATH}/backup_log_${TIMESTAMP}.txt"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

print_status "Starting backup of Digital Ocean droplet"
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

# 2. Backup Docker configurations
print_status "Backing up Docker configurations..."

# Docker Compose files
ssh_exec "find /root -name 'docker-compose*.yml' -o -name 'compose*.yml' 2>/dev/null" | while read -r compose_file; do
    if [ ! -z "$compose_file" ]; then
        print_status "  Copying: $compose_file"
        sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" \
            "${REMOTE_USER}@${DROPLET_IP}:${compose_file}" \
            "${BACKUP_PATH}/docker/$(basename $compose_file)"
    fi
done

# Dockerfile files
ssh_exec "find /root -name 'Dockerfile*' 2>/dev/null" | while read -r dockerfile; do
    if [ ! -z "$dockerfile" ]; then
        print_status "  Copying: $dockerfile"
        sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" \
            "${REMOTE_USER}@${DROPLET_IP}:${dockerfile}" \
            "${BACKUP_PATH}/docker/$(basename $dockerfile)"
    fi
done

# 3. Backup environment files
print_status "Backing up environment files..."
ssh_exec "find /root -name '.env*' -not -path '*/node_modules/*' 2>/dev/null" | while read -r env_file; do
    if [ ! -z "$env_file" ]; then
        print_status "  Copying: $env_file"
        # Create subdirectory structure
        rel_path=$(ssh_exec "echo $env_file | sed 's|/root/||'")
        mkdir -p "${BACKUP_PATH}/env_files/$(dirname $rel_path)"
        sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" \
            "${REMOTE_USER}@${DROPLET_IP}:${env_file}" \
            "${BACKUP_PATH}/env_files/${rel_path}"
    fi
done

# 4. Backup configuration files
print_status "Backing up configuration files..."

# Common config patterns
CONFIG_PATTERNS=(
    "*.json"
    "*.yaml"
    "*.yml"
    "*.toml"
    "*.ini"
    "*.conf"
    "*.config"
)

for pattern in "${CONFIG_PATTERNS[@]}"; do
    ssh_exec "find /root/vivid_mas -name '$pattern' -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null" | while read -r config_file; do
        if [ ! -z "$config_file" ]; then
            rel_path=$(ssh_exec "echo $config_file | sed 's|/root/vivid_mas/||'")
            mkdir -p "${BACKUP_PATH}/configs/$(dirname $rel_path)"
            sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" \
                "${REMOTE_USER}@${DROPLET_IP}:${config_file}" \
                "${BACKUP_PATH}/configs/${rel_path}" 2>/dev/null
        fi
    done
done

# 5. Backup Nginx configurations
print_status "Backing up Nginx configurations..."
rsync_exec \
    "${REMOTE_USER}@${DROPLET_IP}:/etc/nginx/" \
    "${BACKUP_PATH}/nginx/" 2>/dev/null || print_warning "No Nginx configs found"

# 6. Backup systemd service files
print_status "Backing up systemd service files..."
ssh_exec "find /etc/systemd/system -name 'vivid*' -o -name 'mas*' 2>/dev/null" | while read -r service_file; do
    if [ ! -z "$service_file" ]; then
        print_status "  Copying: $service_file"
        sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" \
            "${REMOTE_USER}@${DROPLET_IP}:${service_file}" \
            "${BACKUP_PATH}/systemd/$(basename $service_file)"
    fi
done

# 7. Export Docker container list and images
print_status "Exporting Docker container information..."
ssh_exec "docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'" > "${BACKUP_PATH}/docker/container_list.txt"
ssh_exec "docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}'" > "${BACKUP_PATH}/docker/image_list.txt"

# 8. Export Docker volumes
print_status "Listing Docker volumes..."
ssh_exec "docker volume ls" > "${BACKUP_PATH}/docker/volume_list.txt"

# 9. Backup database schemas (not data)
print_status "Backing up database schemas..."

# Neo4j schema
print_status "  Exporting Neo4j schema..."
ssh_exec "docker exec neo4j-knowledge cypher-shell -u neo4j -p VPofL3g9gTaquiXxA6ntvQDyK 'CALL db.schema.visualization()' 2>/dev/null || echo 'Neo4j schema export failed'" > "${BACKUP_PATH}/databases/neo4j_schema.txt"

# PostgreSQL/Supabase schema
print_status "  Exporting PostgreSQL schema..."
ssh_exec "docker exec supabase-db pg_dump -U postgres --schema-only 2>/dev/null || echo 'PostgreSQL schema export failed'" > "${BACKUP_PATH}/databases/postgresql_schema.sql"

# 10. Create system information file
print_status "Gathering system information..."
cat > "${BACKUP_PATH}/system_info.txt" << EOF
Backup Date: $(date)
Droplet IP: ${DROPLET_IP}
Backup Location: ${BACKUP_PATH}

=== System Information ===
$(ssh_exec "uname -a")

=== Disk Usage ===
$(ssh_exec "df -h")

=== Memory Usage ===
$(ssh_exec "free -h")

=== Docker Version ===
$(ssh_exec "docker --version")

=== Docker Compose Version ===
$(ssh_exec "docker compose version 2>/dev/null || docker-compose --version")

=== Running Services ===
$(ssh_exec "docker ps --format 'table {{.Names}}\t{{.Status}}'")
EOF

# 11. Create restore script
print_status "Creating restore script..."
cat > "${BACKUP_PATH}/restore_to_droplet.sh" << 'EOF'
#!/bin/bash
# Restore script for VividMAS backup
# Usage: ./restore_to_droplet.sh [target_ip]

TARGET_IP="${1:-157.230.13.13}"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
BACKUP_DIR="$(dirname "$0")"

echo "This will restore the backup to ${TARGET_IP}"
echo "WARNING: This will overwrite existing files!"
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Restore codebase
echo "Restoring codebase..."
rsync -avz --progress \
    -e "ssh -i ${SSH_KEY}" \
    "${BACKUP_DIR}/codebase/" \
    "root@${TARGET_IP}:/root/vivid_mas/"

# Restore environment files
echo "Restoring environment files..."
rsync -avz --progress \
    -e "ssh -i ${SSH_KEY}" \
    "${BACKUP_DIR}/env_files/" \
    "root@${TARGET_IP}:/root/"

echo "Restore complete!"
echo "Remember to:"
echo "1. Restart Docker containers"
echo "2. Verify environment variables"
echo "3. Check service connections"
EOF

chmod +x "${BACKUP_PATH}/restore_to_droplet.sh"

# 12. Create backup summary
TOTAL_SIZE=$(du -sh "${BACKUP_PATH}" | cut -f1)
FILE_COUNT=$(find "${BACKUP_PATH}" -type f | wc -l | xargs)

cat > "${BACKUP_PATH}/backup_summary.md" << EOF
# VividMAS Droplet Backup Summary

**Backup Date:** $(date)  
**Droplet IP:** ${DROPLET_IP}  
**Total Size:** ${TOTAL_SIZE}  
**Total Files:** ${FILE_COUNT}  

## Backup Contents

### 1. Codebase
- Main application code from /root/vivid_mas
- Excludes: node_modules, .git, logs, cache files

### 2. Docker Configurations
- All docker-compose files
- Dockerfile definitions
- Container and image lists

### 3. Environment Files
- All .env files (contains secrets - handle with care!)
- Organized by original directory structure

### 4. Configuration Files
- JSON, YAML, TOML, INI, CONF files
- Application configurations
- Service configurations

### 5. Infrastructure
- Nginx configurations (if present)
- Systemd service files
- Database schemas (structure only, no data)

### 6. System Information
- System details at time of backup
- Running services list
- Resource usage snapshot

## Restore Instructions

To restore this backup to a droplet:
\`\`\`bash
cd ${BACKUP_PATH}
./restore_to_droplet.sh [target_ip]
\`\`\`

## Security Notes
- This backup contains sensitive environment variables
- Store securely and limit access
- Do not commit to version control

## File Organization
\`\`\`
${TIMESTAMP}/
├── codebase/          # Application code
├── docker/            # Docker configurations
├── configs/           # Configuration files
├── databases/         # Database schemas
├── env_files/         # Environment variables (SENSITIVE!)
├── nginx/             # Nginx configs
├── systemd/           # Service definitions
├── backup_log_*.txt   # Detailed backup log
├── system_info.txt    # System snapshot
├── backup_summary.md  # This file
└── restore_to_droplet.sh  # Restore script
\`\`\`
EOF

# 13. Compress the backup (optional)
print_status "Creating compressed archive..."
cd "${BACKUP_DIR}"
tar -czf "vivid_mas_backup_${TIMESTAMP}.tar.gz" "${TIMESTAMP}/"
print_status "Compressed backup: ${BACKUP_DIR}/vivid_mas_backup_${TIMESTAMP}.tar.gz"

# Final summary
print_status "Backup completed successfully!"
print_status "Backup location: ${BACKUP_PATH}"
print_status "Total size: ${TOTAL_SIZE}"
print_status "Total files: ${FILE_COUNT}"
print_status "Compressed archive: vivid_mas_backup_${TIMESTAMP}.tar.gz"

# Cleanup old backups (keep last 5)
print_status "Cleaning up old backups..."
cd "${BACKUP_DIR}"
ls -t1 | grep -E '^[0-9]{8}_[0-9]{6}$' | tail -n +6 | xargs -I {} rm -rf {}
ls -t1 | grep -E '^vivid_mas_backup_.*\.tar\.gz$' | tail -n +6 | xargs -I {} rm -f {}

print_status "Backup process complete!"