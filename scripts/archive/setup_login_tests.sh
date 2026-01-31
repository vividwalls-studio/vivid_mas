#!/bin/bash

# VividWalls MAS - Login Test Setup Script
# Sets up and executes comprehensive login tests

set -e

echo "🔧 VividWalls MAS - Login Test Setup"
echo "===================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Step 1: Making all scripts executable${NC}"
chmod +x test_all_logins.sh
chmod +x test_*.sh 2>/dev/null || true

echo -e "${GREEN}✅ Scripts made executable${NC}"

echo ""
echo -e "${BLUE}Step 2: Setting up credentials${NC}"

if [[ ! -f ".env" ]]; then
    echo "Creating .env file from template..."
    cp credentials_config.env .env
    echo -e "${YELLOW}⚠️ Please edit .env file with your actual credentials${NC}"
    echo "   nano .env"
else
    echo "✅ .env file already exists"
fi

echo ""
echo -e "${BLUE}Step 3: Loading environment variables${NC}"
if [[ -f ".env" ]]; then
    source .env
    echo "✅ Environment variables loaded"
else
    echo "⚠️ No .env file found, using defaults"
fi

echo ""
echo -e "${BLUE}Step 4: Testing basic connectivity${NC}"

# Test if we can reach the droplet
if ping -c 1 157.230.13.13 >/dev/null 2>&1; then
    echo "✅ Droplet is reachable"
else
    echo "❌ Cannot reach droplet at 157.230.13.13"
    exit 1
fi

# Test if Caddy is responding
if curl -s --connect-timeout 5 http://157.230.13.13 >/dev/null; then
    echo "✅ Caddy is responding"
else
    echo "❌ Caddy is not responding"
    exit 1
fi

echo ""
echo -e "${BLUE}Step 5: Running comprehensive login tests${NC}"
echo "================================================"

# Execute the main test suite
./test_all_logins.sh

echo ""
echo -e "${GREEN}🎉 Setup and testing complete!${NC}"
echo ""
echo "📝 Available test scripts:"
echo "   • test_all_logins.sh      - Run all login tests"
echo "   • test_n8n_login.sh       - Test N8N authentication"
echo "   • test_supabase_login.sh  - Test Supabase authentication"
echo "   • test_twenty_login.sh    - Test Twenty CRM authentication"
echo "   • test_listmonk_login.sh  - Test ListMonk authentication"
echo "   • test_medusa_login.sh    - Test Medusa authentication"
echo "   • test_wordpress_login.sh - Test WordPress authentication"
echo "   • test_openwebui_login.sh - Test Open WebUI authentication"
echo "   • test_neo4j_login.sh     - Test Neo4j authentication"
echo "   • test_minio_login.sh     - Test MinIO authentication"
echo "   • test_postiz_login.sh    - Test Postiz authentication"

echo ""
echo "💡 Tips:"
echo "   • Update credentials in .env file"
echo "   • Run individual tests: ./test_n8n_login.sh"
echo "   • Set custom credentials: N8N_EMAIL=user@domain.com ./test_n8n_login.sh"
echo "   • Check logs: tail -f /tmp/*_response.*"

echo ""
echo -e "${YELLOW}⚠️ Security Reminder:${NC}"
echo "   • Never commit .env files to version control"
echo "   • Use strong, unique passwords for each service"
echo "   • Regularly rotate API keys and passwords"
echo "   • Monitor login attempts and access logs"
