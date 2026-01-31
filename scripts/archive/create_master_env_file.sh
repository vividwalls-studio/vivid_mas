#!/bin/bash

# VividWalls MAS - Master .env File Creator
# Consolidates all credentials, API keys, and secrets into a single .env file

set -e

echo "🔧 VividWalls MAS - Master .env File Creation"
echo "============================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to generate secure password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Function to generate API key
generate_api_key() {
    openssl rand -hex 32
}

# Function to generate UUID
generate_uuid() {
    python3 -c "import uuid; print(str(uuid.uuid4()))"
}

echo -e "${BLUE}Generating comprehensive .env file with all credentials...${NC}"

# Load existing credentials if available
if [[ -f "secure_credentials.env" ]]; then
    source secure_credentials.env
    echo -e "${GREEN}✅ Loaded existing secure credentials${NC}"
else
    echo -e "${YELLOW}⚠️ Generating new credentials${NC}"
    # Generate new credentials
    ADMIN_EMAIL="admin@vividwalls.blog"
    ADMIN_USERNAME="admin"
    N8N_PASSWORD=$(generate_password)
    SUPABASE_PASSWORD=$(generate_password)
    TWENTY_PASSWORD=$(generate_password)
    LISTMONK_PASSWORD=$(generate_password)
    MEDUSA_PASSWORD=$(generate_password)
    WP_PASSWORD=$(generate_password)
    OPENWEBUI_PASSWORD=$(generate_password)
    NEO4J_PASSWORD=$(generate_password)
    MINIO_ROOT_PASSWORD=$(generate_password)
    POSTIZ_PASSWORD=$(generate_password)
fi

# Generate additional API keys and secrets
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-$(generate_api_key)}
SUPABASE_SERVICE_KEY=${SUPABASE_SERVICE_KEY:-$(generate_api_key)}
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY:-$(generate_api_key)}
JWT_SECRET=${JWT_SECRET:-$(generate_api_key)}
MEDUSA_JWT_SECRET=${MEDUSA_JWT_SECRET:-$(generate_api_key)}
MEDUSA_COOKIE_SECRET=${MEDUSA_COOKIE_SECRET:-$(generate_api_key)}
NEXTAUTH_SECRET=$(generate_api_key)
ENCRYPTION_KEY=$(generate_api_key)
WEBHOOK_SECRET=$(generate_api_key)

# Generate project IDs
SUPABASE_PROJECT_ID=${SUPABASE_PROJECT_ID:-$(generate_uuid)}
TWENTY_WORKSPACE_ID=${TWENTY_WORKSPACE_ID:-$(generate_uuid)}

echo -e "${BLUE}Creating comprehensive .env file...${NC}"

cat > .env << EOF
# =============================================================================
# VividWalls Multi-Agent System - Master Environment Configuration
# Generated: $(date)
# =============================================================================

# =============================================================================
# SYSTEM CONFIGURATION
# =============================================================================
NODE_ENV=production
ENVIRONMENT=production
BASE_DOMAIN=vividwalls.blog
FRONTEND_URL=https://vividwalls.blog

# Admin Configuration
ADMIN_EMAIL=$ADMIN_EMAIL
ADMIN_USERNAME=$ADMIN_USERNAME
ADMIN_FIRST_NAME=VividWalls
ADMIN_LAST_NAME=Admin

# =============================================================================
# N8N WORKFLOW AUTOMATION
# =============================================================================
N8N_EMAIL=$ADMIN_EMAIL
N8N_PASSWORD=$N8N_PASSWORD
N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY
N8N_USER_MANAGEMENT_DISABLED=false
N8N_BASIC_AUTH_ACTIVE=false
N8N_HOST=n8n.vividwalls.blog
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://n8n.vividwalls.blog
N8N_EDITOR_BASE_URL=https://n8n.vividwalls.blog

# =============================================================================
# SUPABASE BACKEND SERVICES
# =============================================================================
SUPABASE_EMAIL=$ADMIN_EMAIL
SUPABASE_PASSWORD=$SUPABASE_PASSWORD
SUPABASE_PROJECT_ID=$SUPABASE_PROJECT_ID
SUPABASE_URL=https://supabase.vividwalls.blog
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=$SUPABASE_SERVICE_KEY
SUPABASE_JWT_SECRET=$JWT_SECRET

# Supabase Database
POSTGRES_HOST=supabase-db
POSTGRES_PORT=5432
POSTGRES_DB=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=$SUPABASE_PASSWORD
DATABASE_URL=postgresql://postgres:$SUPABASE_PASSWORD@supabase-db:5432/postgres

# Supabase Auth
GOTRUE_SITE_URL=https://studio.vividwalls.blog
GOTRUE_URI_ALLOW_LIST=https://studio.vividwalls.blog,https://supabase.vividwalls.blog
GOTRUE_DISABLE_SIGNUP=false
GOTRUE_JWT_SECRET=$JWT_SECRET
GOTRUE_JWT_EXP=3600

# =============================================================================
# TWENTY CRM
# =============================================================================
TWENTY_EMAIL=$ADMIN_EMAIL
TWENTY_PASSWORD=$TWENTY_PASSWORD
TWENTY_WORKSPACE_ID=$TWENTY_WORKSPACE_ID
TWENTY_API_KEY=$(generate_api_key)
TWENTY_DATABASE_URL=postgresql://twenty:twenty@twenty-db-1:5432/twenty
TWENTY_REDIS_URL=redis://twenty-redis-1:6379
TWENTY_FRONTEND_URL=https://twenty.vividwalls.blog
TWENTY_SERVER_URL=https://twenty.vividwalls.blog

# =============================================================================
# LISTMONK EMAIL MARKETING
# =============================================================================
LISTMONK_USERNAME=$ADMIN_USERNAME
LISTMONK_PASSWORD=$LISTMONK_PASSWORD
LISTMONK_API_KEY=$(generate_api_key)
LISTMONK_DATABASE_URL=postgresql://listmonk:listmonk@listmonk_db:5432/listmonk
LISTMONK_APP_ADDRESS=0.0.0.0:9000
LISTMONK_APP_ADMIN_USERNAME=$ADMIN_USERNAME
LISTMONK_APP_ADMIN_PASSWORD=$LISTMONK_PASSWORD

# =============================================================================
# MEDUSA E-COMMERCE PLATFORM
# =============================================================================
MEDUSA_EMAIL=$ADMIN_EMAIL
MEDUSA_PASSWORD=$MEDUSA_PASSWORD
MEDUSA_JWT_SECRET=$MEDUSA_JWT_SECRET
MEDUSA_COOKIE_SECRET=$MEDUSA_COOKIE_SECRET
MEDUSA_DATABASE_URL=postgresql://medusa:medusa@postgres:5432/medusa
MEDUSA_REDIS_URL=redis://redis:6379
MEDUSA_ADMIN_URL=https://medusa.vividwalls.blog
MEDUSA_STORE_URL=https://store.vividwalls.blog
MEDUSA_BACKEND_URL=https://medusa.vividwalls.blog

# Stripe Integration
STRIPE_API_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# =============================================================================
# WORDPRESS CONTENT MANAGEMENT
# =============================================================================
WP_USERNAME=$ADMIN_USERNAME
WP_PASSWORD=$WP_PASSWORD
WP_EMAIL=$ADMIN_EMAIL
WORDPRESS_DB_HOST=wordpress-mysql
WORDPRESS_DB_USER=wordpress
WORDPRESS_DB_PASSWORD=$WP_PASSWORD
WORDPRESS_DB_NAME=wordpress
WORDPRESS_TABLE_PREFIX=wp_
WORDPRESS_AUTH_KEY=$(generate_api_key)
WORDPRESS_SECURE_AUTH_KEY=$(generate_api_key)
WORDPRESS_LOGGED_IN_KEY=$(generate_api_key)
WORDPRESS_NONCE_KEY=$(generate_api_key)

# =============================================================================
# OPEN WEBUI (CHATGPT INTERFACE)
# =============================================================================
OPENWEBUI_EMAIL=$ADMIN_EMAIL
OPENWEBUI_PASSWORD=$OPENWEBUI_PASSWORD
OPENWEBUI_SECRET_KEY=$(generate_api_key)
OPENAI_API_KEY=sk-your-openai-api-key
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key

# =============================================================================
# NEO4J KNOWLEDGE GRAPH
# =============================================================================
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=$NEO4J_PASSWORD
NEO4J_AUTH=neo4j/$NEO4J_PASSWORD
NEO4J_URI=bolt://neo4j-knowledge-fixed:7687
NEO4J_DATABASE=neo4j

# =============================================================================
# MINIO OBJECT STORAGE
# =============================================================================
MINIO_ROOT_USER=$ADMIN_USERNAME
MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD
MINIO_ACCESS_KEY=$ADMIN_USERNAME
MINIO_SECRET_KEY=$MINIO_ROOT_PASSWORD
MINIO_ENDPOINT=https://minio.vividwalls.blog
MINIO_CONSOLE_ADDRESS=:9090
MINIO_BROWSER_REDIRECT_URL=https://minio-console.vividwalls.blog

# =============================================================================
# POSTIZ SOCIAL MEDIA MANAGEMENT
# =============================================================================
POSTIZ_EMAIL=$ADMIN_EMAIL
POSTIZ_PASSWORD=$POSTIZ_PASSWORD
POSTIZ_DATABASE_URL=postgresql://postiz:postiz@postiz-postgres:5432/postiz
POSTIZ_REDIS_URL=redis://postiz-redis:6379
POSTIZ_JWT_SECRET=$(generate_api_key)

# =============================================================================
# AI & ML SERVICES
# =============================================================================

# Flowise AI
FLOWISE_USERNAME=$ADMIN_USERNAME
FLOWISE_PASSWORD=$(generate_password)
FLOWISE_SECRETKEY_OVERWRITE=$(generate_api_key)

# Langfuse Observability
LANGFUSE_SECRET_KEY=$(generate_api_key)
LANGFUSE_PUBLIC_KEY=$(generate_api_key)
LANGFUSE_DATABASE_URL=postgresql://langfuse:langfuse@langfuse-db:5432/langfuse

# Ollama
OLLAMA_HOST=0.0.0.0:11434
OLLAMA_API_KEY=$(generate_api_key)

# Qdrant Vector Database
QDRANT_API_KEY=$(generate_api_key)
QDRANT_URL=https://qdrant.vividwalls.blog

# =============================================================================
# REDIS CACHE
# =============================================================================
REDIS_PASSWORD=$(generate_api_key)
REDIS_URL=redis://redis:6379

# =============================================================================
# SECURITY & ENCRYPTION
# =============================================================================
JWT_SECRET=$JWT_SECRET
NEXTAUTH_SECRET=$NEXTAUTH_SECRET
ENCRYPTION_KEY=$ENCRYPTION_KEY
COOKIE_SECRET=$MEDUSA_COOKIE_SECRET
WEBHOOK_SECRET=$WEBHOOK_SECRET
SESSION_SECRET=$(generate_api_key)

# =============================================================================
# SSL/TLS CONFIGURATION
# =============================================================================
SSL_EMAIL=$ADMIN_EMAIL
ACME_EMAIL=$ADMIN_EMAIL

# =============================================================================
# EXTERNAL API KEYS
# =============================================================================

# OpenAI
OPENAI_API_KEY=sk-your-openai-api-key
OPENAI_ORGANIZATION=org-your-organization-id

# Anthropic Claude
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key

# Google APIs
GOOGLE_API_KEY=your-google-api-key
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret

# Social Media APIs
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
TWITTER_API_KEY=your-twitter-api-key
TWITTER_API_SECRET=your-twitter-api-secret
TWITTER_BEARER_TOKEN=your-twitter-bearer-token
INSTAGRAM_ACCESS_TOKEN=your-instagram-token
PINTEREST_ACCESS_TOKEN=your-pinterest-token
LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret

# Email Services
SENDGRID_API_KEY=SG.your-sendgrid-api-key
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=$ADMIN_EMAIL
SMTP_PASSWORD=your-app-password
SMTP_SECURE=true

# =============================================================================
# SERVICE URLS
# =============================================================================
N8N_URL=https://n8n.vividwalls.blog
SUPABASE_URL=https://supabase.vividwalls.blog
SUPABASE_STUDIO_URL=https://studio.vividwalls.blog
TWENTY_URL=https://twenty.vividwalls.blog
CRM_URL=https://crm.vividwalls.blog
LISTMONK_URL=https://listmonk.vividwalls.blog
MEDUSA_URL=https://medusa.vividwalls.blog
STORE_URL=https://store.vividwalls.blog
WORDPRESS_URL=https://wordpress.vividwalls.blog
OPENWEBUI_URL=https://openwebui.vividwalls.blog
FLOWISE_URL=https://flowise.vividwalls.blog
LANGFUSE_URL=https://langfuse.vividwalls.blog
CRAWL4AI_URL=https://crawl4ai.vividwalls.blog
OLLAMA_URL=https://ollama.vividwalls.blog
NEO4J_URL=https://neo4j.vividwalls.blog
SEARXNG_URL=https://searxng.vividwalls.blog
MINIO_URL=https://minio.vividwalls.blog
MINIO_CONSOLE_URL=https://minio-console.vividwalls.blog
QDRANT_URL=https://qdrant.vividwalls.blog
POSTIZ_URL=https://postiz.vividwalls.blog
ANALYTICS_URL=https://analytics.vividwalls.blog
HEALTH_URL=https://health.vividwalls.blog

# =============================================================================
# DEVELOPMENT & DEBUGGING
# =============================================================================
DEBUG=false
LOG_LEVEL=info
ENABLE_METRICS=true
ENABLE_TELEMETRY=false

EOF

echo -e "${GREEN}✅ Master .env file created successfully${NC}"

# Set secure permissions
chmod 600 .env

echo ""
echo -e "${BLUE}Creating environment validation script...${NC}"

cat > validate_env.sh << 'EOF'
#!/bin/bash

# Validate .env file completeness
echo "🔍 Validating .env file..."

if [[ ! -f ".env" ]]; then
    echo "❌ .env file not found"
    exit 1
fi

source .env

# Check critical variables
critical_vars=(
    "ADMIN_EMAIL"
    "N8N_PASSWORD"
    "SUPABASE_PASSWORD"
    "TWENTY_PASSWORD"
    "MEDUSA_PASSWORD"
    "JWT_SECRET"
    "N8N_ENCRYPTION_KEY"
)

missing_vars=()

for var in "${critical_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -eq 0 ]]; then
    echo "✅ All critical environment variables are set"
    echo "📊 Total variables: $(grep -c "=" .env)"
    echo "🔐 Admin email: $ADMIN_EMAIL"
    echo "🔑 Passwords generated for all services"
else
    echo "❌ Missing critical variables:"
    printf '%s\n' "${missing_vars[@]}"
    exit 1
fi
EOF

chmod +x validate_env.sh

echo ""
echo -e "${BLUE}Running validation...${NC}"
./validate_env.sh

echo ""
echo -e "${GREEN}🎉 Master .env file creation complete!${NC}"
echo ""
echo -e "${YELLOW}📋 SUMMARY:${NC}"
echo "• ✅ Comprehensive .env file created"
echo "• 🔐 All login credentials included"
echo "• 🔑 API keys and secrets generated"
echo "• 🌐 Service URLs configured"
echo "• 📊 $(grep -c "=" .env) environment variables set"
echo "• 🛡️ Secure file permissions applied"

echo ""
echo -e "${BLUE}📁 Files created:${NC}"
echo "• .env - Master environment configuration"
echo "• validate_env.sh - Environment validation script"

echo ""
echo -e "${RED}⚠️ SECURITY REMINDER:${NC}"
echo "• Never commit .env files to version control"
echo "• Store securely and backup safely"
echo "• Update API keys with real values"
echo "• Change passwords after first login"
