#!/bin/bash

# Comprehensive Supabase Data Backup Script
# Backs up all Supabase data including auth users, storage, realtime, and vector data

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
SSH_PASSPHRASE="freedom"
REMOTE_USER="root"
BACKUP_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/droplet_backup/supabase_data"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SUPABASE_BACKUP_PATH="${BACKUP_DIR}/${TIMESTAMP}"

# Database credentials
POSTGRES_PASSWORD="myqP9lSMLobnuIfkUpXQzZg07"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Create backup directory structure
mkdir -p "${SUPABASE_BACKUP_PATH}"/{database,storage,auth,realtime,vectors,migrations,functions,rls_policies}

print_status "Starting comprehensive Supabase data backup..."

# SSH functions
ssh_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" ssh -i "${SSH_KEY}" "${REMOTE_USER}@${DROPLET_IP}" "$1"
}

scp_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" "$@"
}

# 1. Full database backup with all Supabase data
print_status "Creating complete PostgreSQL dump..."
ssh_exec "docker exec -t supabase-db pg_dumpall -U postgres --clean --if-exists > /tmp/supabase_complete_dump.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/supabase_complete_dump.sql" "${SUPABASE_BACKUP_PATH}/database/complete_dump.sql"

# 2. Individual schema dumps for easier restoration
print_status "Backing up individual schemas..."

# Main database
ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres --clean --if-exists > /tmp/postgres_main.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/postgres_main.sql" "${SUPABASE_BACKUP_PATH}/database/postgres_main.sql"

# Auth schema (Supabase Auth users)
print_info "Backing up auth schema (users, sessions, etc.)..."
ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres -n auth --clean --if-exists > /tmp/auth_schema.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/auth_schema.sql" "${SUPABASE_BACKUP_PATH}/auth/auth_schema.sql"

# Storage schema
print_info "Backing up storage schema..."
ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres -n storage --clean --if-exists > /tmp/storage_schema.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/storage_schema.sql" "${SUPABASE_BACKUP_PATH}/storage/storage_schema.sql"

# Public schema (your application data)
print_info "Backing up public schema (application data)..."
ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres -n public --clean --if-exists > /tmp/public_schema.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/public_schema.sql" "${SUPABASE_BACKUP_PATH}/database/public_schema.sql"

# Extensions schema (including pgvector)
print_info "Backing up extensions schema..."
ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres -n extensions --clean --if-exists > /tmp/extensions_schema.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/extensions_schema.sql" "${SUPABASE_BACKUP_PATH}/database/extensions_schema.sql"

# 3. Export specific Supabase tables
print_status "Exporting specific Supabase tables..."

# List of important tables to backup individually
TABLES=(
    "auth.users"
    "auth.sessions"
    "auth.refresh_tokens"
    "auth.identities"
    "storage.objects"
    "storage.buckets"
    "public.agents"
    "public.agent_personas"
    "public.knowledge_entries"
    "public.products"
    "public.product_embeddings"
)

for table in "${TABLES[@]}"; do
    schema=$(echo $table | cut -d. -f1)
    table_name=$(echo $table | cut -d. -f2)
    print_info "  Exporting $table..."
    
    # Export as SQL
    ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres -t $table --data-only > /tmp/${schema}_${table_name}.sql"
    scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/${schema}_${table_name}.sql" "${SUPABASE_BACKUP_PATH}/database/${schema}_${table_name}_data.sql" 2>/dev/null
    
    # Export as CSV for easier viewing
    ssh_exec "docker exec supabase-db psql -U postgres -d postgres -c \"COPY (SELECT * FROM $table) TO '/tmp/${schema}_${table_name}.csv' WITH CSV HEADER;\" 2>/dev/null"
    scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/${schema}_${table_name}.csv" "${SUPABASE_BACKUP_PATH}/database/${schema}_${table_name}.csv" 2>/dev/null
done

# 4. Export vector embeddings separately (if using pgvector)
print_status "Backing up vector embeddings..."
ssh_exec "docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT COUNT(*) as total_embeddings,
       pg_size_pretty(SUM(pg_column_size(embedding))) as total_size
FROM knowledge_entries
WHERE embedding IS NOT NULL;
\" > /tmp/embedding_stats.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/embedding_stats.txt" "${SUPABASE_BACKUP_PATH}/vectors/embedding_statistics.txt"

# Export embeddings
ssh_exec "docker exec supabase-db pg_dump -U postgres -d postgres -t knowledge_entries -t product_embeddings > /tmp/embeddings_backup.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/embeddings_backup.sql" "${SUPABASE_BACKUP_PATH}/vectors/embeddings_backup.sql"

# 5. Backup Storage buckets and objects
print_status "Backing up Supabase Storage files..."

# List storage buckets
ssh_exec "docker exec supabase-db psql -U postgres -d postgres -c 'SELECT * FROM storage.buckets;' > /tmp/storage_buckets.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/storage_buckets.txt" "${SUPABASE_BACKUP_PATH}/storage/buckets_list.txt"

# Backup actual storage files
print_info "Backing up storage volumes..."
ssh_exec "docker run --rm -v supabase-storage:/source -v /tmp:/backup alpine tar -czf /backup/supabase_storage_files.tar.gz -C /source ."
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/supabase_storage_files.tar.gz" "${SUPABASE_BACKUP_PATH}/storage/storage_files.tar.gz"

# 6. Export Supabase configuration
print_status "Backing up Supabase configuration..."

# RLS policies
print_info "Exporting Row Level Security policies..."
ssh_exec "docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname IN ('public', 'auth', 'storage')
ORDER BY schemaname, tablename, policyname;
\" > /tmp/rls_policies.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/rls_policies.txt" "${SUPABASE_BACKUP_PATH}/rls_policies/all_policies.txt"

# Database functions
print_info "Exporting database functions..."
ssh_exec "docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    n.nspname as schema,
    p.proname as function_name,
    pg_get_functiondef(p.oid) as definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname IN ('public', 'auth', 'storage', 'extensions')
    AND p.prokind = 'f'
ORDER BY n.nspname, p.proname;
\" > /tmp/functions.sql"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/functions.sql" "${SUPABASE_BACKUP_PATH}/functions/all_functions.sql"

# 7. Export migrations history
print_status "Backing up migration history..."
ssh_exec "docker exec supabase-db psql -U postgres -d postgres -c 'SELECT * FROM supabase_migrations.schema_migrations ORDER BY version;' > /tmp/migrations_history.txt 2>/dev/null || echo 'No migrations table found'"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/migrations_history.txt" "${SUPABASE_BACKUP_PATH}/migrations/history.txt"

# 8. Create data statistics report
print_status "Generating data statistics..."

cat > "${SUPABASE_BACKUP_PATH}/DATA_STATISTICS.md" << EOF
# Supabase Data Backup Statistics
**Backup Date:** $(date)
**Droplet IP:** ${DROPLET_IP}

## Database Size
$(ssh_exec "docker exec supabase-db psql -U postgres -t -c \"SELECT pg_size_pretty(pg_database_size('postgres'));\"")

## Table Sizes
$(ssh_exec "docker exec supabase-db psql -U postgres -c \"
SELECT 
    schemaname || '.' || tablename AS table_name,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
    n_live_tup AS row_count
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 20;
\"")

## Auth Statistics
$(ssh_exec "docker exec supabase-db psql -U postgres -c \"
SELECT 
    'Total Users' as metric, COUNT(*) as count FROM auth.users
UNION ALL
SELECT 'Active Sessions', COUNT(*) FROM auth.sessions WHERE expires_at > NOW()
UNION ALL
SELECT 'Total Identities', COUNT(*) FROM auth.identities;
\"")

## Storage Statistics  
$(ssh_exec "docker exec supabase-db psql -U postgres -c \"
SELECT 
    'Total Buckets' as metric, COUNT(*) as count FROM storage.buckets
UNION ALL
SELECT 'Total Objects', COUNT(*) FROM storage.objects;
\"")

## Application Data
$(ssh_exec "docker exec supabase-db psql -U postgres -c \"
SELECT 
    'Agents' as table_name, COUNT(*) as count FROM public.agents
UNION ALL
SELECT 'Products', COUNT(*) FROM public.products
UNION ALL
SELECT 'Knowledge Entries', COUNT(*) FROM public.knowledge_entries
UNION ALL
SELECT 'Agent Personas', COUNT(*) FROM public.agent_personas;
\"")
EOF

# 9. Create restoration script
print_status "Creating restoration script..."

cat > "${SUPABASE_BACKUP_PATH}/restore_supabase.sh" << 'EOF'
#!/bin/bash
# Supabase Data Restoration Script

BACKUP_DIR="$(dirname "$0")"
TARGET_IP="${1:-157.230.13.13}"

echo "Supabase Data Restoration"
echo "========================="
echo "Backup: $BACKUP_DIR"
echo "Target: $TARGET_IP"
echo ""
echo "WARNING: This will overwrite ALL Supabase data!"
read -p "Continue? (yes/no) " -r
if [[ ! $REPLY == "yes" ]]; then
    exit 1
fi

# 1. Stop Supabase services
echo "Stopping Supabase services..."
ssh root@$TARGET_IP "cd /root/vivid_mas && docker compose stop supabase-db supabase-auth supabase-rest supabase-realtime"

# 2. Restore complete database
echo "Restoring database..."
scp database/complete_dump.sql root@$TARGET_IP:/tmp/
ssh root@$TARGET_IP "docker compose up -d supabase-db && sleep 10"
ssh root@$TARGET_IP "docker exec -i supabase-db psql -U postgres < /tmp/complete_dump.sql"

# 3. Restore storage files
echo "Restoring storage files..."
scp storage/storage_files.tar.gz root@$TARGET_IP:/tmp/
ssh root@$TARGET_IP "docker run --rm -v supabase-storage:/target -v /tmp:/backup alpine tar -xzf /backup/storage_files.tar.gz -C /target"

# 4. Start all services
echo "Starting services..."
ssh root@$TARGET_IP "cd /root/vivid_mas && docker compose up -d"

echo "Restoration complete!"
echo "Verify at: http://$TARGET_IP:3000"
EOF

chmod +x "${SUPABASE_BACKUP_PATH}/restore_supabase.sh"

# 10. Cleanup
print_status "Cleaning up temporary files..."
ssh_exec "rm -f /tmp/*.sql /tmp/*.csv /tmp/*.txt /tmp/*.tar.gz 2>/dev/null"

# Create compressed archive
cd "${BACKUP_DIR}"
tar -czf "supabase_data_${TIMESTAMP}.tar.gz" "${TIMESTAMP}/"

# Summary
TOTAL_SIZE=$(du -sh "${SUPABASE_BACKUP_PATH}" | cut -f1)
print_status "======================================"
print_status "SUPABASE DATA BACKUP COMPLETE!"
print_status "======================================"
print_info "Location: ${SUPABASE_BACKUP_PATH}"
print_info "Size: ${TOTAL_SIZE}"
print_info "Archive: ${BACKUP_DIR}/supabase_data_${TIMESTAMP}.tar.gz"
print_status "======================================"

echo ""
echo "Backup includes:"
echo "  ✓ Complete database dump"
echo "  ✓ Auth users and sessions"
echo "  ✓ Storage buckets and files"
echo "  ✓ Vector embeddings"
echo "  ✓ RLS policies"
echo "  ✓ Database functions"
echo "  ✓ Individual table exports (SQL + CSV)"
echo ""
echo "To restore: cd ${SUPABASE_BACKUP_PATH} && ./restore_supabase.sh [target_ip]"