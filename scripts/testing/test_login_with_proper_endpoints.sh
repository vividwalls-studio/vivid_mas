#!/bin/bash

# VividWalls MAS - Login Test with Proper API Endpoints
# Tests login with correct API endpoints and credentials

set -e

echo "🔐 VividWalls MAS - Proper Login Testing"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load credentials if available
if [[ -f "secure_credentials.env" ]]; then
    source secure_credentials.env
    echo -e "${GREEN}✅ Loaded secure credentials${NC}"
else
    echo -e "${YELLOW}⚠️ Using default credentials${NC}"
    ADMIN_EMAIL="admin@vividwalls.blog"
    N8N_PASSWORD="VividWalls2024!"
    TWENTY_PASSWORD="VividWalls2024!"
    LISTMONK_PASSWORD="VividWalls2024!"
    MEDUSA_PASSWORD="VividWalls2024!"
    WP_PASSWORD="VividWalls2024!"
    OPENWEBUI_PASSWORD="VividWalls2024!"
    NEO4J_PASSWORD="VividWalls2024!"
    MINIO_ROOT_PASSWORD="VividWalls2024!"
    POSTIZ_PASSWORD="VividWalls2024!"
fi

echo ""
echo -e "${BLUE}Testing login endpoints with proper API calls...${NC}"

# Function to test login
test_login() {
    local service=$1
    local url=$2
    local method=$3
    local data=$4
    local expected_success=$5
    
    echo ""
    echo -e "${BLUE}Testing $service...${NC}"
    echo "URL: $url"
    
    response=$(curl -s -X "$method" "$url" \
        -H "Content-Type: application/json" \
        -d "$data" \
        -w "HTTP_STATUS:%{http_code}" \
        2>/dev/null)
    
    http_code=$(echo "$response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
    body=$(echo "$response" | sed 's/HTTP_STATUS:[0-9]*$//')
    
    if [[ "$http_code" == "$expected_success" ]] || [[ "$http_code" == "200" ]] || [[ "$http_code" == "201" ]]; then
        echo -e "${GREEN}✅ $service: SUCCESS (HTTP $http_code)${NC}"
        echo "Response: $(echo "$body" | head -c 100)..."
    elif [[ "$http_code" == "401" ]]; then
        echo -e "${YELLOW}🔐 $service: Authentication failed (HTTP $http_code)${NC}"
        echo "Response: $(echo "$body" | head -c 100)..."
    elif [[ "$http_code" == "404" ]]; then
        echo -e "${RED}❌ $service: Endpoint not found (HTTP $http_code)${NC}"
    else
        echo -e "${RED}❌ $service: Error (HTTP $http_code)${NC}"
        echo "Response: $(echo "$body" | head -c 100)..."
    fi
}

# Test N8N with correct endpoint
test_login "N8N Workflow" \
    "https://n8n.vividwalls.blog/rest/login" \
    "POST" \
    "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$N8N_PASSWORD\"}" \
    "200"

# Test N8N with alternative endpoint format
test_login "N8N (Alternative)" \
    "https://n8n.vividwalls.blog/rest/login" \
    "POST" \
    "{\"emailOrLdapLoginId\":\"$ADMIN_EMAIL\",\"password\":\"$N8N_PASSWORD\"}" \
    "200"

# Test Twenty CRM with GraphQL
test_login "Twenty CRM (GraphQL)" \
    "https://twenty.vividwalls.blog/graphql" \
    "POST" \
    "{\"query\":\"mutation signin(\$email: String!, \$password: String!) { signIn(email: \$email, password: \$password) { loginToken { token } } }\",\"variables\":{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$TWENTY_PASSWORD\"}}" \
    "200"

# Test Twenty CRM with REST API
test_login "Twenty CRM (REST)" \
    "https://twenty.vividwalls.blog/rest/auth/login" \
    "POST" \
    "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$TWENTY_PASSWORD\"}" \
    "200"

# Test ListMonk with correct admin endpoint
test_login "ListMonk Admin" \
    "https://listmonk.vividwalls.blog/admin/login" \
    "POST" \
    "{\"username\":\"admin\",\"password\":\"$LISTMONK_PASSWORD\"}" \
    "200"

# Test Medusa admin login
test_login "Medusa Admin" \
    "https://medusa.vividwalls.blog/admin/auth/login" \
    "POST" \
    "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$MEDUSA_PASSWORD\"}" \
    "200"

# Test WordPress login
echo ""
echo -e "${BLUE}Testing WordPress...${NC}"
wp_response=$(curl -s -X POST "https://wordpress.vividwalls.blog/wp-login.php" \
    -d "log=admin&pwd=$WP_PASSWORD&wp-submit=Log+In&redirect_to=https://wordpress.vividwalls.blog/wp-admin/" \
    -w "HTTP_STATUS:%{http_code}" \
    -L)

wp_code=$(echo "$wp_response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
if [[ "$wp_code" == "200" ]] || [[ "$wp_code" == "302" ]]; then
    echo -e "${GREEN}✅ WordPress: SUCCESS (HTTP $wp_code)${NC}"
else
    echo -e "${RED}❌ WordPress: Error (HTTP $wp_code)${NC}"
fi

# Test Open WebUI
test_login "Open WebUI" \
    "https://openwebui.vividwalls.blog/api/v1/auths/signin" \
    "POST" \
    "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$OPENWEBUI_PASSWORD\"}" \
    "200"

# Test Neo4j with basic auth
echo ""
echo -e "${BLUE}Testing Neo4j...${NC}"
neo4j_auth=$(echo -n "neo4j:$NEO4J_PASSWORD" | base64)
neo4j_response=$(curl -s -X POST "https://neo4j.vividwalls.blog/db/data/transaction/commit" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $neo4j_auth" \
    -d '{"statements":[{"statement":"RETURN 1 as test"}]}' \
    -w "HTTP_STATUS:%{http_code}")

neo4j_code=$(echo "$neo4j_response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
if [[ "$neo4j_code" == "200" ]]; then
    echo -e "${GREEN}✅ Neo4j: SUCCESS (HTTP $neo4j_code)${NC}"
else
    echo -e "${RED}❌ Neo4j: Error (HTTP $neo4j_code)${NC}"
fi

# Test MinIO console
test_login "MinIO Console" \
    "https://minio-console.vividwalls.blog/api/v1/login" \
    "POST" \
    "{\"accessKey\":\"admin\",\"secretKey\":\"$MINIO_ROOT_PASSWORD\"}" \
    "200"

# Test Postiz
test_login "Postiz Social" \
    "https://postiz.vividwalls.blog/api/auth/signin" \
    "POST" \
    "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$POSTIZ_PASSWORD\"}" \
    "200"

echo ""
echo -e "${BLUE}Testing additional service accessibility...${NC}"

# Test services that don't require authentication
services_no_auth=(
    "Flowise:https://flowise.vividwalls.blog"
    "Langfuse:https://langfuse.vividwalls.blog"
    "Crawl4AI:https://crawl4ai.vividwalls.blog"
    "Ollama:https://ollama.vividwalls.blog"
    "SearXNG:https://searxng.vividwalls.blog"
    "Qdrant:https://qdrant.vividwalls.blog"
    "Health Check:https://health.vividwalls.blog"
)

for service_url in "${services_no_auth[@]}"; do
    service=$(echo "$service_url" | cut -d: -f1)
    url=$(echo "$service_url" | cut -d: -f2-3)
    
    response_code=$(curl -s -w "%{http_code}" "$url" -o /dev/null --connect-timeout 5)
    
    if [[ "$response_code" == "200" ]]; then
        echo -e "${GREEN}✅ $service: Accessible (HTTP $response_code)${NC}"
    elif [[ "$response_code" == "401" ]] || [[ "$response_code" == "403" ]]; then
        echo -e "${YELLOW}🔐 $service: Authentication required (HTTP $response_code)${NC}"
    else
        echo -e "${RED}❌ $service: Error or unreachable (HTTP $response_code)${NC}"
    fi
done

echo ""
echo -e "${BLUE}📊 LOGIN TEST SUMMARY${NC}"
echo "===================="
echo ""
echo "✅ Tests completed with proper API endpoints"
echo "🔐 Authentication status checked for all services"
echo "📝 Results show which services need initialization"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Run initialization scripts for failed logins"
echo "2. Verify credentials are correctly set"
echo "3. Check application logs for errors"
echo "4. Update API endpoints if needed"
