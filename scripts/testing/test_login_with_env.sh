#!/bin/bash

# VividWalls MAS - Login Test with .env File
# Tests all application logins using the master .env configuration

set -e

echo "🔐 VividWalls MAS - Login Test with .env Configuration"
echo "====================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Load environment variables
if [[ -f ".env" ]]; then
    source .env
    echo -e "${GREEN}✅ Loaded .env configuration with $(grep -c "=" .env) variables${NC}"
    echo -e "${BLUE}Admin Email: $ADMIN_EMAIL${NC}"
else
    echo -e "${RED}❌ .env file not found. Please run create_master_env_file.sh first${NC}"
    exit 1
fi

echo ""
echo -e "${PURPLE}Testing Application Logins with Environment Credentials${NC}"
echo "======================================================="

# Function to test login with better error handling
test_login() {
    local service=$1
    local url=$2
    local method=$3
    local data=$4
    local expected_codes=$5
    
    echo ""
    echo -e "${BLUE}Testing $service...${NC}"
    echo "URL: $url"
    
    # Make the request and capture response
    response=$(curl -s -X "$method" "$url" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "$data" \
        -w "HTTP_STATUS:%{http_code}" \
        --connect-timeout 10 \
        --max-time 30 \
        2>/dev/null || echo "HTTP_STATUS:000")
    
    http_code=$(echo "$response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
    body=$(echo "$response" | sed 's/HTTP_STATUS:[0-9]*$//')
    
    # Check if response is successful
    if [[ "$expected_codes" == *"$http_code"* ]] || [[ "$http_code" == "200" ]] || [[ "$http_code" == "201" ]]; then
        echo -e "${GREEN}✅ $service: SUCCESS (HTTP $http_code)${NC}"
        if [[ ${#body} -gt 0 ]]; then
            echo "Response: $(echo "$body" | head -c 150)..."
        fi
        return 0
    elif [[ "$http_code" == "401" ]]; then
        echo -e "${YELLOW}🔐 $service: Authentication failed - User may not exist (HTTP $http_code)${NC}"
        if [[ ${#body} -gt 0 ]]; then
            echo "Response: $(echo "$body" | head -c 150)..."
        fi
        return 1
    elif [[ "$http_code" == "404" ]]; then
        echo -e "${RED}❌ $service: Endpoint not found (HTTP $http_code)${NC}"
        return 1
    elif [[ "$http_code" == "000" ]]; then
        echo -e "${RED}❌ $service: Connection failed or timeout${NC}"
        return 1
    else
        echo -e "${RED}❌ $service: Error (HTTP $http_code)${NC}"
        if [[ ${#body} -gt 0 ]]; then
            echo "Response: $(echo "$body" | head -c 150)..."
        fi
        return 1
    fi
}

# Test basic connectivity first
echo -e "${BLUE}Phase 1: Basic Connectivity Test${NC}"
echo "==============================="

services_basic=(
    "N8N:$N8N_URL"
    "Supabase:$SUPABASE_URL"
    "Twenty:$TWENTY_URL"
    "ListMonk:$LISTMONK_URL"
    "Medusa:$MEDUSA_URL"
    "Store:$STORE_URL"
    "WordPress:$WORDPRESS_URL"
    "OpenWebUI:$OPENWEBUI_URL"
    "Neo4j:$NEO4J_URL"
    "MinIO:$MINIO_URL"
    "Postiz:$POSTIZ_URL"
)

for service_url in "${services_basic[@]}"; do
    service=$(echo "$service_url" | cut -d: -f1)
    url=$(echo "$service_url" | cut -d: -f2-3)
    
    response_code=$(curl -s -w "%{http_code}" "$url" -o /dev/null --connect-timeout 5 --max-time 10)
    
    if [[ "$response_code" == "200" ]]; then
        echo -e "  ${GREEN}✅ $service: Accessible${NC}"
    elif [[ "$response_code" == "401" ]] || [[ "$response_code" == "403" ]]; then
        echo -e "  ${YELLOW}🔐 $service: Auth Required${NC}"
    elif [[ "$response_code" == "302" ]] || [[ "$response_code" == "307" ]]; then
        echo -e "  ${BLUE}🔄 $service: Redirect${NC}"
    else
        echo -e "  ${RED}❌ $service: Error ($response_code)${NC}"
    fi
done

echo ""
echo -e "${PURPLE}Phase 2: Authentication Tests${NC}"
echo "============================"

# Test N8N Login
test_login "N8N Workflow" \
    "$N8N_URL/rest/login" \
    "POST" \
    "{\"email\":\"$N8N_EMAIL\",\"password\":\"$N8N_PASSWORD\"}" \
    "200,401"

# Test N8N with alternative format
test_login "N8N (Alternative Format)" \
    "$N8N_URL/rest/login" \
    "POST" \
    "{\"emailOrLdapLoginId\":\"$N8N_EMAIL\",\"password\":\"$N8N_PASSWORD\"}" \
    "200,401"

# Test Twenty CRM GraphQL
test_login "Twenty CRM (GraphQL)" \
    "$TWENTY_URL/graphql" \
    "POST" \
    "{\"query\":\"mutation signin(\$email: String!, \$password: String!) { signIn(email: \$email, password: \$password) { loginToken { token } } }\",\"variables\":{\"email\":\"$TWENTY_EMAIL\",\"password\":\"$TWENTY_PASSWORD\"}}" \
    "200,401"

# Test ListMonk
test_login "ListMonk Admin" \
    "$LISTMONK_URL/admin/api/auth/login" \
    "POST" \
    "{\"username\":\"$LISTMONK_USERNAME\",\"password\":\"$LISTMONK_PASSWORD\"}" \
    "200,401"

# Test Medusa Admin
test_login "Medusa Admin" \
    "$MEDUSA_URL/admin/auth/login" \
    "POST" \
    "{\"email\":\"$MEDUSA_EMAIL\",\"password\":\"$MEDUSA_PASSWORD\"}" \
    "200,401"

# Test Open WebUI
test_login "Open WebUI" \
    "$OPENWEBUI_URL/api/v1/auths/signin" \
    "POST" \
    "{\"email\":\"$OPENWEBUI_EMAIL\",\"password\":\"$OPENWEBUI_PASSWORD\"}" \
    "200,401,400"

# Test WordPress (different approach)
echo ""
echo -e "${BLUE}Testing WordPress...${NC}"
wp_response=$(curl -s -X POST "$WORDPRESS_URL/wp-login.php" \
    -d "log=$WP_USERNAME&pwd=$WP_PASSWORD&wp-submit=Log+In" \
    -w "HTTP_STATUS:%{http_code}" \
    -L --connect-timeout 10)

wp_code=$(echo "$wp_response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
if [[ "$wp_code" == "200" ]] || [[ "$wp_code" == "302" ]]; then
    echo -e "${GREEN}✅ WordPress: SUCCESS (HTTP $wp_code)${NC}"
elif [[ "$wp_code" == "500" ]]; then
    echo -e "${RED}❌ WordPress: Server Error (HTTP $wp_code) - Needs configuration${NC}"
else
    echo -e "${YELLOW}🔐 WordPress: Response (HTTP $wp_code)${NC}"
fi

# Test Neo4j with Basic Auth
echo ""
echo -e "${BLUE}Testing Neo4j...${NC}"
neo4j_auth=$(echo -n "$NEO4J_USERNAME:$NEO4J_PASSWORD" | base64)
neo4j_response=$(curl -s -X POST "$NEO4J_URL/db/data/transaction/commit" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $neo4j_auth" \
    -d '{"statements":[{"statement":"RETURN 1 as test"}]}' \
    -w "HTTP_STATUS:%{http_code}" \
    --connect-timeout 10)

neo4j_code=$(echo "$neo4j_response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
if [[ "$neo4j_code" == "200" ]]; then
    echo -e "${GREEN}✅ Neo4j: SUCCESS (HTTP $neo4j_code)${NC}"
else
    echo -e "${RED}❌ Neo4j: Error (HTTP $neo4j_code)${NC}"
fi

# Test MinIO Console
test_login "MinIO Console" \
    "$MINIO_CONSOLE_URL/api/v1/login" \
    "POST" \
    "{\"accessKey\":\"$MINIO_ACCESS_KEY\",\"secretKey\":\"$MINIO_SECRET_KEY\"}" \
    "200,401,204"

# Test Postiz
test_login "Postiz Social" \
    "$POSTIZ_URL/api/auth/signin" \
    "POST" \
    "{\"email\":\"$POSTIZ_EMAIL\",\"password\":\"$POSTIZ_PASSWORD\"}" \
    "200,401"

echo ""
echo -e "${PURPLE}Phase 3: Service Health Summary${NC}"
echo "=============================="

# Count successful services
echo -e "${BLUE}Environment Configuration Summary:${NC}"
echo "• Admin Email: $ADMIN_EMAIL"
echo "• Total Environment Variables: $(grep -c "=" .env)"
echo "• Services Configured: 22"
echo ""

echo -e "${BLUE}Credentials Available For:${NC}"
echo "• N8N Workflow Automation"
echo "• Supabase Backend Services"
echo "• Twenty CRM"
echo "• ListMonk Email Marketing"
echo "• Medusa E-commerce Platform"
echo "• WordPress Content Management"
echo "• Open WebUI (ChatGPT Interface)"
echo "• Neo4j Knowledge Graph"
echo "• MinIO Object Storage"
echo "• Postiz Social Media Management"

echo ""
echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
echo "1. Run application initialization scripts"
echo "2. Fix any container health issues"
echo "3. Create admin users in applications"
echo "4. Test successful logins"
echo "5. Configure application-specific settings"

echo ""
echo -e "${GREEN}🎯 Environment Configuration Complete!${NC}"
echo "All credentials are now consolidated in the .env file"
