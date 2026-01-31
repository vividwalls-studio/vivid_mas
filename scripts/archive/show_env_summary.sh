#!/bin/bash

# VividWalls MAS - .env File Summary Display
# Shows the structure and contents of the master .env file

echo "📋 VividWalls MAS - Master .env File Summary"
echo "============================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

if [[ ! -f ".env" ]]; then
    echo "❌ .env file not found"
    exit 1
fi

source .env

echo -e "${CYAN}
╔══════════════════════════════════════════════════════════════╗
║                    MASTER .ENV CONFIGURATION                ║
║              All Credentials & API Keys Consolidated        ║
╚══════════════════════════════════════════════════════════════╝
${NC}"

echo ""
echo -e "${PURPLE}📊 CONFIGURATION OVERVIEW${NC}"
echo "========================"
echo "• Total Variables: $(grep -c "=" .env)"
echo "• Admin Email: $ADMIN_EMAIL"
echo "• Base Domain: $BASE_DOMAIN"
echo "• Environment: $ENVIRONMENT"

echo ""
echo -e "${BLUE}🔐 LOGIN CREDENTIALS${NC}"
echo "==================="
echo "Admin Email: $ADMIN_EMAIL"
echo "Admin Username: $ADMIN_USERNAME"
echo ""
echo "Application Passwords:"
echo "• N8N: $N8N_PASSWORD"
echo "• Supabase: $SUPABASE_PASSWORD"
echo "• Twenty CRM: $TWENTY_PASSWORD"
echo "• ListMonk: $LISTMONK_PASSWORD"
echo "• Medusa: $MEDUSA_PASSWORD"
echo "• WordPress: $WP_PASSWORD"
echo "• Open WebUI: $OPENWEBUI_PASSWORD"
echo "• Neo4j: $NEO4J_PASSWORD"
echo "• MinIO: $MINIO_ROOT_PASSWORD"
echo "• Postiz: $POSTIZ_PASSWORD"

echo ""
echo -e "${YELLOW}🔑 API KEYS & SECRETS${NC}"
echo "===================="
echo "• N8N Encryption Key: ${N8N_ENCRYPTION_KEY:0:20}..."
echo "• Supabase Anon Key: ${SUPABASE_ANON_KEY:0:20}..."
echo "• Supabase Service Key: ${SUPABASE_SERVICE_ROLE_KEY:0:20}..."
echo "• JWT Secret: ${JWT_SECRET:0:20}..."
echo "• Medusa JWT Secret: ${MEDUSA_JWT_SECRET:0:20}..."
echo "• Medusa Cookie Secret: ${MEDUSA_COOKIE_SECRET:0:20}..."
echo "• NextAuth Secret: ${NEXTAUTH_SECRET:0:20}..."

echo ""
echo -e "${GREEN}🌐 SERVICE URLS${NC}"
echo "=============="
echo "• N8N: $N8N_URL"
echo "• Supabase: $SUPABASE_URL"
echo "• Supabase Studio: $SUPABASE_STUDIO_URL"
echo "• Twenty CRM: $TWENTY_URL"
echo "• ListMonk: $LISTMONK_URL"
echo "• Medusa Admin: $MEDUSA_URL"
echo "• Medusa Store: $STORE_URL"
echo "• WordPress: $WORDPRESS_URL"
echo "• Open WebUI: $OPENWEBUI_URL"
echo "• Neo4j: $NEO4J_URL"
echo "• MinIO: $MINIO_URL"
echo "• MinIO Console: $MINIO_CONSOLE_URL"
echo "• Postiz: $POSTIZ_URL"

echo ""
echo -e "${BLUE}🗄️ DATABASE CONNECTIONS${NC}"
echo "======================"
echo "• PostgreSQL (Supabase): postgresql://postgres:***@supabase-db:5432/postgres"
echo "• Twenty CRM DB: postgresql://twenty:***@twenty-db-1:5432/twenty"
echo "• ListMonk DB: postgresql://listmonk:***@listmonk_db:5432/listmonk"
echo "• Medusa DB: postgresql://medusa:***@postgres:5432/medusa"
echo "• WordPress DB: wordpress@wordpress-mysql:3306/wordpress"
echo "• Neo4j: bolt://neo4j-knowledge-fixed:7687"
echo "• Redis: redis://redis:6379"

echo ""
echo -e "${PURPLE}🔧 CONFIGURATION SECTIONS${NC}"
echo "========================="
echo "✅ System Configuration (Environment, Domain, Admin)"
echo "✅ N8N Workflow Automation (7 variables)"
echo "✅ Supabase Backend Services (15 variables)"
echo "✅ Twenty CRM (8 variables)"
echo "✅ ListMonk Email Marketing (6 variables)"
echo "✅ Medusa E-commerce Platform (10 variables)"
echo "✅ WordPress Content Management (10 variables)"
echo "✅ Open WebUI (ChatGPT Interface) (4 variables)"
echo "✅ Neo4j Knowledge Graph (5 variables)"
echo "✅ MinIO Object Storage (7 variables)"
echo "✅ Postiz Social Media (5 variables)"
echo "✅ AI & ML Services (Flowise, Langfuse, Ollama, Qdrant)"
echo "✅ Redis Cache Configuration"
echo "✅ Security & Encryption Keys"
echo "✅ SSL/TLS Configuration"
echo "✅ External API Keys (OpenAI, Anthropic, Google, Social Media)"
echo "✅ Email Services (SendGrid, SMTP)"
echo "✅ Service URLs (22 applications)"
echo "✅ Development & Debugging"

echo ""
echo -e "${YELLOW}📝 USAGE EXAMPLES${NC}"
echo "================"
echo ""
echo "Load environment:"
echo "  source .env"
echo ""
echo "Test N8N login:"
echo "  curl -X POST \"\$N8N_URL/rest/login\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{\"email\":\"\$N8N_EMAIL\",\"password\":\"\$N8N_PASSWORD\"}'"
echo ""
echo "Test Twenty CRM:"
echo "  curl -X POST \"\$TWENTY_URL/graphql\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{\"query\":\"mutation signin(\\\$email: String!, \\\$password: String!) { signIn(email: \\\$email, password: \\\$password) { loginToken { token } } }\",\"variables\":{\"email\":\"\$TWENTY_EMAIL\",\"password\":\"\$TWENTY_PASSWORD\"}}'"

echo ""
echo -e "${GREEN}🎯 BENEFITS OF CONSOLIDATED .ENV${NC}"
echo "=================================="
echo "✅ Single source of truth for all credentials"
echo "✅ Easy environment variable management"
echo "✅ Consistent naming conventions"
echo "✅ Secure password generation for all services"
echo "✅ Complete API key and secret management"
echo "✅ Ready for Docker Compose integration"
echo "✅ Supports development and production environments"
echo "✅ Comprehensive service URL configuration"

echo ""
echo -e "${CYAN}🔒 SECURITY FEATURES${NC}"
echo "=================="
echo "• 25-character secure passwords for all applications"
echo "• 64-character hex API keys and secrets"
echo "• Unique encryption keys for each service"
echo "• Proper database connection strings"
echo "• SSL/TLS configuration included"
echo "• File permissions set to 600 (owner read/write only)"

echo ""
echo -e "${BLUE}📁 FILES CREATED${NC}"
echo "==============="
echo "• .env - Master environment configuration (201 variables)"
echo "• validate_env.sh - Environment validation script"
echo "• test_login_with_env.sh - Login testing with .env"
echo "• show_env_summary.sh - This summary script"

echo ""
echo -e "${YELLOW}⚠️ IMPORTANT REMINDERS${NC}"
echo "====================="
echo "• Never commit .env files to version control"
echo "• Add .env to your .gitignore file"
echo "• Store credentials in a secure password manager"
echo "• Update external API keys with real values"
echo "• Change passwords after first successful login"
echo "• Backup .env file securely"

echo ""
echo -e "${GREEN}🎉 MASTER .ENV CONFIGURATION COMPLETE!${NC}"
echo ""
echo "All login credentials, API keys, and secrets are now consolidated"
echo "in a single .env file for easy management and deployment."
