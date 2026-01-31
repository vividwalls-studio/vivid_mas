#!/bin/bash
# Rollback Migration Script
# Restores system to pre-migration state

set -euo pipefail

# Configuration
BACKUP_DIR="${1:-}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging function
log() {
    echo -e "${2:-}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

# Error handler
error_exit() {
    log "ERROR: $1" "${RED}"
    exit 1
}

# Check if backup directory provided
if [ -z "$BACKUP_DIR" ]; then
    # Find most recent backup
    BACKUP_DIR=$(ls -d /root/volume_backups_* 2>/dev/null | sort -r | head -1)
    if [ -z "$BACKUP_DIR" ]; then
        error_exit "No backup directory found. Usage: $0 <backup_directory>"
    fi
    log "Using most recent backup: $BACKUP_DIR" "${YELLOW}"
fi

# Verify backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    error_exit "Backup directory $BACKUP_DIR not found"
fi

log "=== Starting Rollback Process ===" "${GREEN}"
log "Backup source: $BACKUP_DIR"

# Confirm rollback
read -p "This will restore volumes from backup. All current data will be lost. Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    log "Rollback cancelled by user" "${YELLOW}"
    exit 0
fi

# Step 1: Stop all containers
log "Stopping all containers..."
cd /root/vivid_mas
docker-compose down

# Step 2: Restore volumes from backup
restore_volume() {
    local volume_name=$1
    local backup_file="$BACKUP_DIR/${volume_name}.tar.gz"
    
    if [ ! -f "$backup_file" ]; then
        log "Backup file for $volume_name not found, skipping" "${YELLOW}"
        return
    fi
    
    log "Restoring volume: $volume_name"
    
    # Remove existing volume
    docker volume rm "$volume_name" 2>/dev/null || true
    
    # Create new volume
    docker volume create "$volume_name"
    
    # Restore from backup
    docker run --rm -v "$volume_name:/target" -v "$BACKUP_DIR:/backup:ro" \
        alpine tar xzf "/backup/${volume_name}.tar.gz" -C /target
    
    log "✓ Restored $volume_name" "${GREEN}"
}

# List of volumes to restore
volumes=(
    "vivid_mas_postgres_data"
    "vivid_mas_supabase_db_data"
    "vivid_mas_wordpress_db_data"
    "vivid_mas_neo4j_data"
    "vivid_mas_n8n_storage"
)

for volume in "${volumes[@]}"; do
    restore_volume "$volume"
done

# Step 3: Restore encryption key
if [ -f "$BACKUP_DIR/.env.backup" ]; then
    log "Restoring original .env file..."
    cp "$BACKUP_DIR/.env.backup" /root/vivid_mas/.env
    log "✓ .env file restored" "${GREEN}"
fi

# Step 4: Start services
log "Starting services..."
docker-compose up -d

log "=== Rollback completed ===" "${GREEN}"
log "Services have been restored to their pre-migration state"
log "Please verify all services are functioning correctly"