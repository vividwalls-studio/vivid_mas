#!/bin/bash

# VividWalls MAS - Secure Credential Setup
# Generates secure passwords and configures all applications

set -e

echo "🔐 VividWalls MAS - Secure Credential Setup"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to generate secure password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to generate API key
generate_api_key() {
    openssl rand -hex 32
}

echo -e "${BLUE}Generating secure credentials...${NC}"

# Generate secure passwords for each service
N8N_PASSWORD=$(generate_password)
SUPABASE_PASSWORD=$(generate_password)
TWENTY_PASSWORD=$(generate_password)
LISTMONK_PASSWORD=$(generate_password)
MEDUSA_PASSWORD=$(generate_password)
WORDPRESS_PASSWORD=$(generate_password)
OPENWEBUI_PASSWORD=$(generate_password)
NEO4J_PASSWORD=$(generate_password)
MINIO_PASSWORD=$(generate_password)
POSTIZ_PASSWORD=$(generate_password)

# Generate API keys
SUPABASE_ANON_KEY=$(generate_api_key)
SUPABASE_SERVICE_KEY=$(generate_api_key)
N8N_ENCRYPTION_KEY=$(generate_api_key)
JWT_SECRET=$(generate_api_key)
MEDUSA_JWT_SECRET=$(generate_api_key)
MEDUSA_COOKIE_SECRET=$(generate_api_key)

# Common email and username
ADMIN_EMAIL="admin@vividwalls.blog"
ADMIN_USERNAME="admin"

echo -e "${GREEN}✅ Secure credentials generated${NC}"

echo ""
echo -e "${BLUE}Creating secure credentials file...${NC}"

cat > secure_credentials.env << EOF
# VividWalls MAS - Secure Credentials
# Generated: $(date)
# WARNING: Keep this file secure and never commit to version control

# =============================================================================
# ADMIN CREDENTIALS
# =============================================================================
ADMIN_EMAIL="$ADMIN_EMAIL"
ADMIN_USERNAME="$ADMIN_USERNAME"

# =============================================================================
# APPLICATION PASSWORDS
# =============================================================================

# N8N Workflow Automation
N8N_EMAIL="$ADMIN_EMAIL"
N8N_PASSWORD="$N8N_PASSWORD"
N8N_ENCRYPTION_KEY="$N8N_ENCRYPTION_KEY"

# Supabase Backend Services
SUPABASE_EMAIL="$ADMIN_EMAIL"
SUPABASE_PASSWORD="$SUPABASE_PASSWORD"
SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
SUPABASE_SERVICE_ROLE_KEY="$SUPABASE_SERVICE_KEY"

# Twenty CRM
TWENTY_EMAIL="$ADMIN_EMAIL"
TWENTY_PASSWORD="$TWENTY_PASSWORD"

# ListMonk Email Marketing
LISTMONK_USERNAME="$ADMIN_USERNAME"
LISTMONK_PASSWORD="$LISTMONK_PASSWORD"

# Medusa E-commerce Platform
MEDUSA_EMAIL="$ADMIN_EMAIL"
MEDUSA_PASSWORD="$MEDUSA_PASSWORD"
MEDUSA_JWT_SECRET="$MEDUSA_JWT_SECRET"
MEDUSA_COOKIE_SECRET="$MEDUSA_COOKIE_SECRET"

# WordPress Content Management
WP_USERNAME="$ADMIN_USERNAME"
WP_PASSWORD="$WORDPRESS_PASSWORD"
WP_EMAIL="$ADMIN_EMAIL"

# Open WebUI (ChatGPT Interface)
OPENWEBUI_EMAIL="$ADMIN_EMAIL"
OPENWEBUI_PASSWORD="$OPENWEBUI_PASSWORD"

# Neo4j Knowledge Graph
NEO4J_USERNAME="neo4j"
NEO4J_PASSWORD="$NEO4J_PASSWORD"

# MinIO Object Storage
MINIO_ROOT_USER="$ADMIN_USERNAME"
MINIO_ROOT_PASSWORD="$MINIO_PASSWORD"
MINIO_ACCESS_KEY="$ADMIN_USERNAME"
MINIO_SECRET_KEY="$MINIO_PASSWORD"

# Postiz Social Media Management
POSTIZ_EMAIL="$ADMIN_EMAIL"
POSTIZ_PASSWORD="$POSTIZ_PASSWORD"

# =============================================================================
# SECURITY KEYS
# =============================================================================
JWT_SECRET="$JWT_SECRET"
ENCRYPTION_KEY="$N8N_ENCRYPTION_KEY"
COOKIE_SECRET="$MEDUSA_COOKIE_SECRET"

# =============================================================================
# DATABASE CREDENTIALS
# =============================================================================
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="$SUPABASE_PASSWORD"
POSTGRES_DB="vividwalls"

REDIS_PASSWORD="$MEDUSA_COOKIE_SECRET"

# =============================================================================
# DOMAIN CONFIGURATION
# =============================================================================
BASE_DOMAIN="vividwalls.blog"
FRONTEND_URL="https://vividwalls.blog"

# Service URLs
N8N_URL="https://n8n.vividwalls.blog"
SUPABASE_URL="https://supabase.vividwalls.blog"
TWENTY_URL="https://twenty.vividwalls.blog"
MEDUSA_URL="https://medusa.vividwalls.blog"
STORE_URL="https://store.vividwalls.blog"
WORDPRESS_URL="https://wordpress.vividwalls.blog"
OPENWEBUI_URL="https://openwebui.vividwalls.blog"
NEO4J_URL="https://neo4j.vividwalls.blog"
MINIO_URL="https://minio.vividwalls.blog"
POSTIZ_URL="https://postiz.vividwalls.blog"

EOF

echo -e "${GREEN}✅ Secure credentials file created: secure_credentials.env${NC}"

echo ""
echo -e "${BLUE}Creating credential summary...${NC}"

cat > credential_summary.txt << EOF
VividWalls MAS - Credential Summary
Generated: $(date)

ADMIN ACCESS:
=============
Email: $ADMIN_EMAIL
Username: $ADMIN_USERNAME

APPLICATION PASSWORDS:
=====================
N8N: $N8N_PASSWORD
Supabase: $SUPABASE_PASSWORD
Twenty CRM: $TWENTY_PASSWORD
ListMonk: $LISTMONK_PASSWORD
Medusa: $MEDUSA_PASSWORD
WordPress: $WORDPRESS_PASSWORD
Open WebUI: $OPENWEBUI_PASSWORD
Neo4j: $NEO4J_PASSWORD
MinIO: $MINIO_PASSWORD
Postiz: $POSTIZ_PASSWORD

IMPORTANT SECURITY NOTES:
========================
1. Store these credentials securely
2. Change passwords after first login
3. Enable 2FA where available
4. Never share or commit these credentials
5. Use a password manager for storage

APPLICATION URLS:
================
N8N: https://n8n.vividwalls.blog
Supabase: https://studio.vividwalls.blog
Twenty CRM: https://twenty.vividwalls.blog
ListMonk: https://listmonk.vividwalls.blog
Medusa Admin: https://medusa.vividwalls.blog
Medusa Store: https://store.vividwalls.blog
WordPress: https://wordpress.vividwalls.blog
Open WebUI: https://openwebui.vividwalls.blog
Neo4j: https://neo4j.vividwalls.blog
MinIO Console: https://minio-console.vividwalls.blog
Postiz: https://postiz.vividwalls.blog

EOF

echo -e "${GREEN}✅ Credential summary created: credential_summary.txt${NC}"

echo ""
echo -e "${BLUE}Setting secure file permissions...${NC}"
chmod 600 secure_credentials.env
chmod 600 credential_summary.txt

echo ""
echo -e "${YELLOW}📋 CREDENTIAL SETUP COMPLETE${NC}"
echo "============================"
echo ""
echo -e "${GREEN}Files created:${NC}"
echo "• secure_credentials.env (secure environment variables)"
echo "• credential_summary.txt (human-readable summary)"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Review generated credentials"
echo "2. Run application initialization scripts"
echo "3. Test login with new credentials"
echo "4. Store credentials in secure password manager"
echo "5. Delete credential files after secure storage"
echo ""
echo -e "${RED}⚠️ SECURITY WARNING:${NC}"
echo "• These files contain sensitive credentials"
echo "• Store them securely and delete after use"
echo "• Never commit these files to version control"
echo "• Change default passwords after first login"

echo ""
echo -e "${PURPLE}To use these credentials:${NC}"
echo "source secure_credentials.env"
echo "./initialize_all_applications.sh"
echo "./initialize_advanced_applications.sh"
