#!/bin/bash
# Database Volume Migration Script
# Safely migrates database volumes from backup to production

set -euo pipefail

# Configuration
BACKUP_PATH="${1:-/root/backup}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="migration_${TIMESTAMP}.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${2:-}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

# Error handler
error_exit() {
    log "ERROR: $1" "${RED}"
    exit 1
}

# Success message
success() {
    log "SUCCESS: $1" "${GREEN}"
}

# Warning message
warning() {
    log "WARNING: $1" "${YELLOW}"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error_exit "This script must be run as root"
fi

# Verify backup path exists
if [ ! -d "$BACKUP_PATH" ]; then
    error_exit "Backup path $BACKUP_PATH does not exist"
fi

log "Starting database volume migration from $BACKUP_PATH"

# Step 1: Create safety backups of current volumes
create_volume_backups() {
    log "Creating safety backups of current volumes..."
    
    local backup_dir="/root/volume_backups_${TIMESTAMP}"
    mkdir -p "$backup_dir"
    
    # List of critical volumes to backup
    local volumes=(
        "vivid_mas_postgres_data"
        "vivid_mas_supabase_db_data"
        "vivid_mas_wordpress_db_data"
        "vivid_mas_neo4j_data"
        "vivid_mas_n8n_storage"
    )
    
    for volume in "${volumes[@]}"; do
        if docker volume inspect "$volume" &>/dev/null; then
            log "Backing up volume: $volume"
            docker run --rm -v "$volume:/source:ro" -v "$backup_dir:/backup" \
                alpine tar czf "/backup/${volume}.tar.gz" -C /source .
            success "Backed up $volume"
        else
            warning "Volume $volume not found, skipping"
        fi
    done
    
    success "Volume backups created in $backup_dir"
}

# Step 2: Stop containers safely
stop_containers() {
    log "Stopping containers to ensure data consistency..."
    
    # Stop containers in dependency order
    local containers=(
        "n8n"
        "wordpress"
        "wordpress-mysql"
        "supabase-studio"
        "supabase-kong"
        "supabase-auth"
        "supabase-rest"
        "supabase-realtime"
        "supabase-db"
        "postgres"
        "neo4j-knowledge"
    )
    
    for container in "${containers[@]}"; do
        if docker ps -q -f name="^${container}$" | grep -q .; then
            log "Stopping container: $container"
            docker stop "$container" || warning "Failed to stop $container"
        fi
    done
    
    success "All containers stopped"
}

# Step 3: Migrate PostgreSQL data (n8n workflows)
migrate_postgres_data() {
    log "Migrating PostgreSQL data for n8n..."
    
    local backup_sql="$BACKUP_PATH/vividwalls_data_backups/20250708_030001/database_backup.sql"
    
    if [ ! -f "$backup_sql" ]; then
        error_exit "PostgreSQL backup not found at $backup_sql"
    fi
    
    # Start postgres container alone
    docker-compose up -d postgres
    sleep 10  # Wait for postgres to be ready
    
    # Import the backup
    log "Importing PostgreSQL backup..."
    docker exec -i postgres psql -U postgres -d postgres < "$backup_sql"
    
    # Verify workflow count
    local workflow_count=$(docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' | tr -d ' ')
    success "Imported $workflow_count workflows"
    
    if [ "$workflow_count" -lt 97 ]; then
        warning "Expected at least 97 workflows, found $workflow_count"
    fi
}

# Step 4: Migrate Supabase data
migrate_supabase_data() {
    log "Migrating Supabase data..."
    
    local supabase_backup="$BACKUP_PATH/supabase_data"
    
    if [ ! -d "$supabase_backup" ]; then
        warning "Supabase backup directory not found, skipping"
        return
    fi
    
    # Start supabase-db container
    docker-compose up -d supabase-db
    sleep 15  # Wait for database to be ready
    
    # Import agent data if exists
    if [ -f "$supabase_backup/agents_backup.sql" ]; then
        log "Importing agent configurations..."
        docker exec -i supabase-db psql -U postgres -d postgres < "$supabase_backup/agents_backup.sql"
        success "Agent data imported"
    fi
    
    # Import knowledge data if exists
    if [ -f "$supabase_backup/knowledge_backup.sql" ]; then
        log "Importing agent knowledge..."
        docker exec -i supabase-db psql -U postgres -d postgres < "$supabase_backup/knowledge_backup.sql"
        success "Knowledge data imported"
    fi
}

# Step 5: Migrate WordPress data
migrate_wordpress_data() {
    log "Migrating WordPress data..."
    
    local wp_backup="$BACKUP_PATH/wordpress"
    
    if [ ! -d "$wp_backup" ]; then
        warning "WordPress backup directory not found, skipping"
        return
    fi
    
    # Start wordpress-mysql container
    docker-compose up -d wordpress-mysql
    sleep 10
    
    # Import WordPress database if exists
    if [ -f "$wp_backup/wordpress_db.sql" ]; then
        log "Importing WordPress database..."
        docker exec -i wordpress-mysql mysql -u root -p'${MYSQL_ROOT_PASSWORD}' wordpress < "$wp_backup/wordpress_db.sql"
        success "WordPress database imported"
    fi
    
    # Sync media files
    if [ -d "$wp_backup/wp-content/uploads" ]; then
        log "Syncing WordPress media files..."
        docker run --rm -v vivid_mas_wordpress_data:/target -v "$wp_backup/wp-content:/source:ro" \
            alpine sh -c "cp -r /source/uploads/* /target/wp-content/uploads/"
        success "WordPress media files synced"
    fi
}

# Step 6: Verify migrations
verify_migrations() {
    log "Verifying migrations..."
    
    # Start minimal services for verification
    docker-compose up -d postgres supabase-db wordpress-mysql neo4j-knowledge
    sleep 20
    
    # Check n8n workflows
    local workflow_count=$(docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' 2>/dev/null | tr -d ' ')
    log "N8N workflows: $workflow_count"
    
    # Check Supabase agents
    local agent_count=$(docker exec supabase-db psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM agents;' 2>/dev/null | tr -d ' ' || echo "0")
    log "Supabase agents: $agent_count"
    
    # Check WordPress posts
    local post_count=$(docker exec wordpress-mysql mysql -u root -p'${MYSQL_ROOT_PASSWORD}' wordpress -sN -e 'SELECT COUNT(*) FROM wp_posts;' 2>/dev/null || echo "0")
    log "WordPress posts: $post_count"
    
    success "Migration verification completed"
}

# Step 7: Start all services
start_services() {
    log "Starting all services..."
    
    cd /root/vivid_mas
    docker-compose up -d
    
    success "All services started"
}

# Main migration flow
main() {
    log "=== VividWalls Database Migration Script ==="
    log "Backup source: $BACKUP_PATH"
    log "Log file: $LOG_FILE"
    
    # Confirm before proceeding
    read -p "This will migrate data from backup. Continue? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        error_exit "Migration cancelled by user"
    fi
    
    # Execute migration steps
    create_volume_backups
    stop_containers
    
    # Migrate databases
    migrate_postgres_data
    migrate_supabase_data
    migrate_wordpress_data
    
    # Verify and restart
    verify_migrations
    start_services
    
    success "=== Migration completed successfully ==="
    log "Please verify all services are working correctly"
    log "Backup of original volumes saved in: /root/volume_backups_${TIMESTAMP}"
}

# Run main function
main "$@"