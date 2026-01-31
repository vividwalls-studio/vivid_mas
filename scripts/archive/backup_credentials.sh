#!/bin/bash

# Backup all authentication credentials and secrets
# This creates an encrypted backup of sensitive data

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"
SSH_PASSPHRASE="freedom"
REMOTE_USER="root"
BACKUP_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/droplet_backup/credentials"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
CRED_BACKUP_PATH="${BACKUP_DIR}/${TIMESTAMP}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory
mkdir -p "${CRED_BACKUP_PATH}"/{env_files,n8n,supabase,docker,secrets,jwt_keys,api_keys}

print_status "Starting credential backup..."
print_warning "This backup contains SENSITIVE authentication data!"

# Function to execute SSH
ssh_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" ssh -i "${SSH_KEY}" "${REMOTE_USER}@${DROPLET_IP}" "$1"
}

# Function to scp files
scp_exec() {
    sshpass -p "${SSH_PASSPHRASE}" -P "passphrase" scp -i "${SSH_KEY}" "$@"
}

# 1. Backup all .env files (contains all service credentials)
print_status "Backing up environment files..."
ssh_exec "find /root -name '.env*' -type f 2>/dev/null | grep -v node_modules" | while read -r env_file; do
    if [ ! -z "$env_file" ]; then
        rel_path=$(echo "$env_file" | sed 's|/root/||')
        mkdir -p "${CRED_BACKUP_PATH}/env_files/$(dirname $rel_path)"
        print_status "  Copying: $env_file"
        scp_exec "${REMOTE_USER}@${DROPLET_IP}:${env_file}" "${CRED_BACKUP_PATH}/env_files/${rel_path}" 2>/dev/null
    fi
done

# 2. Backup Supabase authentication secrets
print_status "Backing up Supabase credentials..."

# Get Supabase JWT secret and other auth keys
ssh_exec "docker exec supabase-auth env | grep -E 'JWT|SECRET|KEY|PASSWORD' > /tmp/supabase_auth_env.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/supabase_auth_env.txt" "${CRED_BACKUP_PATH}/supabase/auth_environment.txt"

# Get Supabase service role key and anon key from Kong
ssh_exec "docker exec supabase-kong cat /home/kong/kong.yml 2>/dev/null | grep -A 50 'consumers:' > /tmp/supabase_kong_keys.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/supabase_kong_keys.txt" "${CRED_BACKUP_PATH}/supabase/kong_api_keys.txt"

# Get Supabase database passwords
ssh_exec "docker exec supabase-db psql -U postgres -c \"SELECT rolname, rolpassword FROM pg_authid WHERE rolpassword IS NOT NULL;\" > /tmp/supabase_db_passwords.txt 2>/dev/null"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/supabase_db_passwords.txt" "${CRED_BACKUP_PATH}/supabase/database_passwords.txt"

# 3. Backup n8n credentials
print_status "Backing up n8n credentials..."

# Export n8n encryption key
ssh_exec "docker exec n8n printenv N8N_ENCRYPTION_KEY > /tmp/n8n_encryption_key.txt 2>/dev/null"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_encryption_key.txt" "${CRED_BACKUP_PATH}/n8n/encryption_key.txt"

# Export all n8n credentials (encrypted)
ssh_exec "docker exec -t n8n n8n export:credentials --all --output=/tmp/n8n_all_credentials.json 2>/dev/null"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_all_credentials.json" "${CRED_BACKUP_PATH}/n8n/all_credentials_encrypted.json"

# Get n8n webhook URLs and API endpoints
ssh_exec "docker exec n8n sqlite3 /home/node/.n8n/database.sqlite \"SELECT name, value FROM webhook_entity;\" > /tmp/n8n_webhooks.txt 2>/dev/null || echo 'No webhooks found'"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_webhooks.txt" "${CRED_BACKUP_PATH}/n8n/webhook_urls.txt"

# Get n8n basic auth credentials if configured
ssh_exec "docker exec n8n printenv | grep -E 'N8N_BASIC_AUTH|N8N_JWT' > /tmp/n8n_auth_config.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/n8n_auth_config.txt" "${CRED_BACKUP_PATH}/n8n/auth_config.txt"

# 4. Backup JWT keys and certificates
print_status "Backing up JWT keys and certificates..."

# Find and backup JWT keys
ssh_exec "find /root -name '*.key' -o -name '*.pem' -o -name '*.crt' 2>/dev/null | grep -E 'jwt|auth|private|public' | head -20" | while read -r key_file; do
    if [ ! -z "$key_file" ]; then
        print_status "  Copying: $key_file"
        scp_exec "${REMOTE_USER}@${DROPLET_IP}:${key_file}" "${CRED_BACKUP_PATH}/jwt_keys/$(basename $key_file)" 2>/dev/null
    fi
done

# 5. Extract API keys from running containers
print_status "Extracting API keys from containers..."

# Get all container environment variables containing keys/secrets
ssh_exec "docker ps --format '{{.Names}}' | while read container; do
    echo \"=== Container: \$container ===\" >> /tmp/all_api_keys.txt
    docker exec \$container printenv | grep -E 'API|KEY|SECRET|TOKEN|PASSWORD|JWT|AUTH' | grep -v 'PATH' >> /tmp/all_api_keys.txt 2>/dev/null
    echo '' >> /tmp/all_api_keys.txt
done"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/all_api_keys.txt" "${CRED_BACKUP_PATH}/api_keys/all_container_keys.txt"

# 6. Backup OAuth configurations
print_status "Backing up OAuth configurations..."

# Supabase OAuth providers
ssh_exec "docker exec supabase-auth printenv | grep -E 'OAUTH|GITHUB|GOOGLE|APPLE' > /tmp/oauth_providers.txt"
scp_exec "${REMOTE_USER}@${DROPLET_IP}:/tmp/oauth_providers.txt" "${CRED_BACKUP_PATH}/supabase/oauth_providers.txt"

# 7. Backup database connection strings
print_status "Backing up database connection strings..."

cat > "${CRED_BACKUP_PATH}/secrets/database_connections.txt" << 'EOF'
# Database Connection Strings (from droplet)
# WARNING: Contains passwords - handle with care!

EOF

# Get all database URLs from env files
ssh_exec "grep -h 'DATABASE_URL\|DB_URL\|POSTGRES\|SUPABASE_URL' /root/vivid_mas/.env* 2>/dev/null | sort -u" >> "${CRED_BACKUP_PATH}/secrets/database_connections.txt"

# 8. Create credential inventory
print_status "Creating credential inventory..."

cat > "${CRED_BACKUP_PATH}/CREDENTIAL_INVENTORY.md" << EOF
# Credential Backup Inventory
**Backup Date:** $(date)
**Droplet IP:** ${DROPLET_IP}

## Contents

### 1. Environment Files (.env)
- Main application .env
- Service-specific .env files
- Contains: API keys, database passwords, service URLs

### 2. Supabase Credentials
- **JWT Secret**: Used for token generation
- **Service Role Key**: Admin access to Supabase
- **Anon Key**: Public client access
- **Database Passwords**: PostgreSQL user passwords
- **OAuth Providers**: Social login configurations

### 3. n8n Credentials
- **Encryption Key**: For credential storage
- **All Credentials**: Exported (encrypted)
- **Webhook URLs**: Active webhook endpoints
- **Basic Auth**: Admin panel access

### 4. API Keys
- Container environment variables
- Third-party service keys
- Internal service tokens

### 5. JWT Keys & Certificates
- Private/public key pairs
- SSL certificates
- Auth signing keys

## Critical Items to Update After Restore

1. **Supabase JWT Secret**
   - Location: supabase/.env -> JWT_SECRET
   - Used by: All Supabase services

2. **n8n Encryption Key**
   - Location: n8n/encryption_key.txt
   - Required for: Decrypting stored credentials

3. **Database Passwords**
   - PostgreSQL: POSTGRES_PASSWORD
   - Supabase: Various service passwords

4. **API Endpoints**
   - Update if domain/IP changes
   - Webhook URLs in n8n

## Security Notes
⚠️ **EXTREME CAUTION REQUIRED**
- This backup contains ALL authentication secrets
- Store in encrypted location only
- Never commit to version control
- Limit access to authorized personnel only

## Restoration Steps

1. Copy .env files to appropriate locations
2. Update container environment variables
3. Import n8n credentials with encryption key
4. Update Supabase JWT configuration
5. Restart all services
EOF

# 9. Extract specific critical values
print_status "Extracting critical credential values..."

cat > "${CRED_BACKUP_PATH}/CRITICAL_CREDENTIALS.txt" << EOF
# CRITICAL CREDENTIALS - MEMORIZE OR STORE SEPARATELY
# Generated: $(date)

## Supabase
$(ssh_exec "grep -E '^SUPABASE_URL|^SUPABASE_ANON_KEY|^SUPABASE_SERVICE_ROLE_KEY|^JWT_SECRET' /root/vivid_mas/.env 2>/dev/null")

## PostgreSQL
$(ssh_exec "grep -E '^POSTGRES_PASSWORD|^DATABASE_URL' /root/vivid_mas/.env 2>/dev/null")

## n8n
$(ssh_exec "docker exec n8n printenv N8N_ENCRYPTION_KEY 2>/dev/null | sed 's/^/N8N_ENCRYPTION_KEY=/'")
$(ssh_exec "grep -E '^N8N_BASIC_AUTH_USER|^N8N_BASIC_AUTH_PASSWORD' /root/vivid_mas/.env 2>/dev/null")

## Neo4j
$(ssh_exec "grep -E '^NEO4J_PASSWORD|^NEO4J_AUTH' /root/vivid_mas/.env 2>/dev/null")

## API Keys
$(ssh_exec "grep -E '^OPENAI_API_KEY|^ANTHROPIC_API_KEY' /root/vivid_mas/.env 2>/dev/null | sed 's/=.*/=REDACTED/'")
EOF

# 10. Create encrypted archive
print_status "Creating encrypted archive..."
cd "${BACKUP_DIR}"
tar -czf "credentials_${TIMESTAMP}.tar.gz" "${TIMESTAMP}/"

print_status "Encrypting archive (you'll be prompted for password)..."
openssl enc -aes-256-cbc -salt -in "credentials_${TIMESTAMP}.tar.gz" -out "credentials_${TIMESTAMP}.tar.gz.enc" -pbkdf2

# Cleanup unencrypted archive
rm -f "credentials_${TIMESTAMP}.tar.gz"

# 11. Cleanup temp files on droplet
print_status "Cleaning up temporary files..."
ssh_exec "rm -f /tmp/supabase_* /tmp/n8n_* /tmp/oauth_* /tmp/all_api_keys.txt 2>/dev/null"

# Final summary
print_status "======================================"
print_status "CREDENTIAL BACKUP COMPLETE!"
print_status "======================================"
print_warning "Location: ${CRED_BACKUP_PATH}"
print_warning "Encrypted: ${BACKUP_DIR}/credentials_${TIMESTAMP}.tar.gz.enc"
print_error "IMPORTANT: Store this backup securely!"
print_error "Contains ALL authentication secrets!"
print_status "======================================"

echo ""
echo "To decrypt later:"
echo "openssl enc -aes-256-cbc -d -in credentials_${TIMESTAMP}.tar.gz.enc -out credentials_${TIMESTAMP}.tar.gz -pbkdf2"