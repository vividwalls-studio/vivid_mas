#!/bin/bash

# VividWalls MAS - Comprehensive Login Test Scripts
# Tests all application logins with their respective credentials

set -e

echo "🔐 VividWalls MAS - Login Test Suite"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Base domain
BASE_DOMAIN="vividwalls.blog"

# Function to test HTTP response
test_endpoint() {
    local url=$1
    local name=$2
    echo -e "${BLUE}Testing $name...${NC}"
    
    response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$url" || echo "000")
    
    if [[ $response == "200" ]]; then
        echo -e "${GREEN}✅ $name: HTTP $response (OK)${NC}"
        return 0
    elif [[ $response == "302" || $response == "301" ]]; then
        echo -e "${YELLOW}⚠️ $name: HTTP $response (Redirect - Login required)${NC}"
        return 0
    elif [[ $response == "401" || $response == "403" ]]; then
        echo -e "${YELLOW}🔐 $name: HTTP $response (Authentication required)${NC}"
        return 0
    else
        echo -e "${RED}❌ $name: HTTP $response (Error or unreachable)${NC}"
        return 1
    fi
}

echo -e "${PURPLE}Phase 1: Basic Connectivity Test${NC}"
echo "==============================="

# Test all endpoints first
endpoints=(
    "https://n8n.$BASE_DOMAIN:N8N Workflow Automation"
    "https://supabase.$BASE_DOMAIN:Supabase API Gateway"
    "https://studio.$BASE_DOMAIN:Supabase Studio"
    "https://analytics.$BASE_DOMAIN:Supabase Analytics"
    "https://openwebui.$BASE_DOMAIN:Open WebUI"
    "https://flowise.$BASE_DOMAIN:Flowise AI"
    "https://langfuse.$BASE_DOMAIN:Langfuse Observability"
    "https://crawl4ai.$BASE_DOMAIN:Crawl4AI Service"
    "https://ollama.$BASE_DOMAIN:Ollama LLM Server"
    "https://twenty.$BASE_DOMAIN:Twenty CRM"
    "https://crm.$BASE_DOMAIN:Twenty CRM (Alt)"
    "https://listmonk.$BASE_DOMAIN:ListMonk Email"
    "https://medusa.$BASE_DOMAIN:Medusa Admin"
    "https://store.$BASE_DOMAIN:Medusa Storefront"
    "https://postiz.$BASE_DOMAIN:Postiz Social"
    "https://wordpress.$BASE_DOMAIN:WordPress"
    "https://neo4j.$BASE_DOMAIN:Neo4j Knowledge"
    "https://searxng.$BASE_DOMAIN:SearXNG Search"
    "https://minio.$BASE_DOMAIN:MinIO Storage"
    "https://minio-console.$BASE_DOMAIN:MinIO Console"
    "https://qdrant.$BASE_DOMAIN:Qdrant Vector DB"
    "https://health.$BASE_DOMAIN:Health Check"
)

for endpoint in "${endpoints[@]}"; do
    url=$(echo "$endpoint" | cut -d: -f1-2)
    name=$(echo "$endpoint" | cut -d: -f3)
    test_endpoint "$url" "$name"
done

echo ""
echo -e "${PURPLE}Phase 2: Authentication Tests${NC}"
echo "============================"

# Create individual test scripts for each application
echo -e "${BLUE}Creating individual login test scripts...${NC}"

# N8N Login Test
cat > test_n8n_login.sh << 'EOF'
#!/bin/bash
echo "🤖 Testing N8N Login"
echo "==================="

# N8N typically uses email/password authentication
# Default credentials (if set up)
N8N_EMAIL="${N8N_EMAIL:-admin@vividwalls.blog}"
N8N_PASSWORD="${N8N_PASSWORD:-vividwalls123}"

echo "Testing N8N authentication..."
echo "URL: https://n8n.vividwalls.blog"
echo "Email: $N8N_EMAIL"

# Test login endpoint
response=$(curl -s -X POST \
  "https://n8n.vividwalls.blog/rest/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$N8N_EMAIL\",\"password\":\"$N8N_PASSWORD\"}" \
  -w "%{http_code}" -o /tmp/n8n_response.json)

if [[ $response == "200" ]]; then
    echo "✅ N8N Login: SUCCESS"
    echo "Response: $(cat /tmp/n8n_response.json | head -c 200)..."
else
    echo "❌ N8N Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/n8n_response.json)"
fi

# Test if N8N is accessible without auth (first-time setup)
setup_response=$(curl -s -w "%{http_code}" "https://n8n.vividwalls.blog/rest/login" -o /dev/null)
if [[ $setup_response == "200" ]]; then
    echo "ℹ️ N8N may require initial setup"
fi
EOF

chmod +x test_n8n_login.sh

echo "✅ Created test_n8n_login.sh"

# Supabase Studio Login Test
cat > test_supabase_login.sh << 'EOF'
#!/bin/bash
echo "🗄️ Testing Supabase Studio Login"
echo "==============================="

# Supabase Studio credentials
SUPABASE_EMAIL="${SUPABASE_EMAIL:-admin@vividwalls.blog}"
SUPABASE_PASSWORD="${SUPABASE_PASSWORD:-vividwalls123}"
SUPABASE_PROJECT_REF="${SUPABASE_PROJECT_REF:-your-project-ref}"

echo "Testing Supabase Studio authentication..."
echo "URL: https://studio.vividwalls.blog"
echo "Email: $SUPABASE_EMAIL"

# Test Supabase Studio access
response=$(curl -s -w "%{http_code}" "https://studio.vividwalls.blog" -o /tmp/supabase_response.html)

if [[ $response == "200" ]]; then
    echo "✅ Supabase Studio: Accessible"
    if grep -q "login" /tmp/supabase_response.html; then
        echo "🔐 Login form detected"
    fi
else
    echo "❌ Supabase Studio: FAILED (HTTP $response)"
fi

# Test Supabase API
api_response=$(curl -s -w "%{http_code}" \
  "https://supabase.vividwalls.blog/rest/v1/" \
  -H "apikey: your-anon-key" \
  -o /tmp/supabase_api_response.json)

echo "Supabase API Response: HTTP $api_response"
EOF

chmod +x test_supabase_login.sh
echo "✅ Created test_supabase_login.sh"

# Twenty CRM Login Test
cat > test_twenty_login.sh << 'EOF'
#!/bin/bash
echo "💼 Testing Twenty CRM Login"
echo "=========================="

# Twenty CRM credentials
TWENTY_EMAIL="${TWENTY_EMAIL:-admin@vividwalls.blog}"
TWENTY_PASSWORD="${TWENTY_PASSWORD:-vividwalls123}"

echo "Testing Twenty CRM authentication..."
echo "URL: https://twenty.vividwalls.blog"
echo "Email: $TWENTY_EMAIL"

# Test Twenty CRM login
response=$(curl -s -X POST \
  "https://twenty.vividwalls.blog/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$TWENTY_EMAIL\",\"password\":\"$TWENTY_PASSWORD\"}" \
  -w "%{http_code}" -o /tmp/twenty_response.json)

if [[ $response == "200" || $response == "201" ]]; then
    echo "✅ Twenty CRM Login: SUCCESS"
    echo "Response: $(cat /tmp/twenty_response.json | head -c 200)..."
else
    echo "❌ Twenty CRM Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/twenty_response.json)"
fi

# Test GraphQL endpoint
graphql_response=$(curl -s -w "%{http_code}" \
  "https://twenty.vividwalls.blog/graphql" \
  -H "Content-Type: application/json" \
  -d '{"query":"query { checkUserExists { __typename } }"}' \
  -o /tmp/twenty_graphql.json)

echo "Twenty GraphQL Response: HTTP $graphql_response"
EOF

chmod +x test_twenty_login.sh
echo "✅ Created test_twenty_login.sh"

# ListMonk Login Test
cat > test_listmonk_login.sh << 'EOF'
#!/bin/bash
echo "📧 Testing ListMonk Login"
echo "======================="

# ListMonk credentials
LISTMONK_USERNAME="${LISTMONK_USERNAME:-admin}"
LISTMONK_PASSWORD="${LISTMONK_PASSWORD:-listmonk}"

echo "Testing ListMonk authentication..."
echo "URL: https://listmonk.vividwalls.blog"
echo "Username: $LISTMONK_USERNAME"

# Test ListMonk login
response=$(curl -s -X POST \
  "https://listmonk.vividwalls.blog/admin/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$LISTMONK_USERNAME\",\"password\":\"$LISTMONK_PASSWORD\"}" \
  -w "%{http_code}" -o /tmp/listmonk_response.json)

if [[ $response == "200" ]]; then
    echo "✅ ListMonk Login: SUCCESS"
    echo "Response: $(cat /tmp/listmonk_response.json | head -c 200)..."
else
    echo "❌ ListMonk Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/listmonk_response.json)"
fi

# Test admin interface
admin_response=$(curl -s -w "%{http_code}" "https://listmonk.vividwalls.blog/admin" -o /dev/null)
echo "ListMonk Admin Interface: HTTP $admin_response"
EOF

chmod +x test_listmonk_login.sh
echo "✅ Created test_listmonk_login.sh"

# Medusa Admin Login Test
cat > test_medusa_login.sh << 'EOF'
#!/bin/bash
echo "🛒 Testing Medusa Admin Login"
echo "============================"

# Medusa admin credentials
MEDUSA_EMAIL="${MEDUSA_EMAIL:-admin@vividwalls.blog}"
MEDUSA_PASSWORD="${MEDUSA_PASSWORD:-vividwalls123}"

echo "Testing Medusa Admin authentication..."
echo "URL: https://medusa.vividwalls.blog"
echo "Email: $MEDUSA_EMAIL"

# Test Medusa admin login
response=$(curl -s -X POST \
  "https://medusa.vividwalls.blog/admin/auth" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$MEDUSA_EMAIL\",\"password\":\"$MEDUSA_PASSWORD\"}" \
  -w "%{http_code}" -o /tmp/medusa_response.json)

if [[ $response == "200" ]]; then
    echo "✅ Medusa Admin Login: SUCCESS"
    echo "Response: $(cat /tmp/medusa_response.json | head -c 200)..."
else
    echo "❌ Medusa Admin Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/medusa_response.json)"
fi

# Test Medusa store API
store_response=$(curl -s -w "%{http_code}" "https://store.vividwalls.blog/store/products" -o /tmp/medusa_store.json)
echo "Medusa Store API: HTTP $store_response"
if [[ $store_response == "200" ]]; then
    echo "Store products: $(cat /tmp/medusa_store.json | head -c 100)..."
fi
EOF

chmod +x test_medusa_login.sh
echo "✅ Created test_medusa_login.sh"

# WordPress Login Test
cat > test_wordpress_login.sh << 'EOF'
#!/bin/bash
echo "📝 Testing WordPress Login"
echo "========================"

# WordPress credentials
WP_USERNAME="${WP_USERNAME:-admin}"
WP_PASSWORD="${WP_PASSWORD:-vividwalls123}"

echo "Testing WordPress authentication..."
echo "URL: https://wordpress.vividwalls.blog"
echo "Username: $WP_USERNAME"

# Test WordPress login
response=$(curl -s -X POST \
  "https://wordpress.vividwalls.blog/wp-login.php" \
  -d "log=$WP_USERNAME&pwd=$WP_PASSWORD&wp-submit=Log+In" \
  -w "%{http_code}" -o /tmp/wp_response.html \
  -c /tmp/wp_cookies.txt)

if [[ $response == "302" ]]; then
    echo "✅ WordPress Login: SUCCESS (Redirect)"
elif [[ $response == "200" ]]; then
    if grep -q "dashboard" /tmp/wp_response.html; then
        echo "✅ WordPress Login: SUCCESS"
    else
        echo "❌ WordPress Login: FAILED (Invalid credentials)"
    fi
else
    echo "❌ WordPress Login: FAILED (HTTP $response)"
fi

# Test WordPress admin access
admin_response=$(curl -s -w "%{http_code}" \
  "https://wordpress.vividwalls.blog/wp-admin/" \
  -b /tmp/wp_cookies.txt \
  -o /dev/null)
echo "WordPress Admin Access: HTTP $admin_response"
EOF

chmod +x test_wordpress_login.sh
echo "✅ Created test_wordpress_login.sh"

# Open WebUI Login Test
cat > test_openwebui_login.sh << 'EOF'
#!/bin/bash
echo "🤖 Testing Open WebUI Login"
echo "=========================="

# Open WebUI credentials (usually email/password)
OPENWEBUI_EMAIL="${OPENWEBUI_EMAIL:-admin@vividwalls.blog}"
OPENWEBUI_PASSWORD="${OPENWEBUI_PASSWORD:-vividwalls123}"

echo "Testing Open WebUI authentication..."
echo "URL: https://openwebui.vividwalls.blog"
echo "Email: $OPENWEBUI_EMAIL"

# Test Open WebUI login
response=$(curl -s -X POST \
  "https://openwebui.vividwalls.blog/api/v1/auths/signin" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$OPENWEBUI_EMAIL\",\"password\":\"$OPENWEBUI_PASSWORD\"}" \
  -w "%{http_code}" -o /tmp/openwebui_response.json)

if [[ $response == "200" ]]; then
    echo "✅ Open WebUI Login: SUCCESS"
    echo "Response: $(cat /tmp/openwebui_response.json | head -c 200)..."
else
    echo "❌ Open WebUI Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/openwebui_response.json)"
fi

# Test if signup is available
signup_response=$(curl -s -w "%{http_code}" "https://openwebui.vividwalls.blog/api/v1/auths/signup" -o /dev/null)
echo "Open WebUI Signup Available: HTTP $signup_response"
EOF

chmod +x test_openwebui_login.sh
echo "✅ Created test_openwebui_login.sh"

# Neo4j Login Test
cat > test_neo4j_login.sh << 'EOF'
#!/bin/bash
echo "🧠 Testing Neo4j Login"
echo "===================="

# Neo4j credentials
NEO4J_USERNAME="${NEO4J_USERNAME:-neo4j}"
NEO4J_PASSWORD="${NEO4J_PASSWORD:-password}"

echo "Testing Neo4j authentication..."
echo "URL: https://neo4j.vividwalls.blog"
echo "Username: $NEO4J_USERNAME"

# Test Neo4j authentication
response=$(curl -s -X POST \
  "https://neo4j.vividwalls.blog/db/data/transaction/commit" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n "$NEO4J_USERNAME:$NEO4J_PASSWORD" | base64)" \
  -d '{"statements":[{"statement":"RETURN 1 as test"}]}' \
  -w "%{http_code}" -o /tmp/neo4j_response.json)

if [[ $response == "200" ]]; then
    echo "✅ Neo4j Login: SUCCESS"
    echo "Response: $(cat /tmp/neo4j_response.json | head -c 200)..."
else
    echo "❌ Neo4j Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/neo4j_response.json)"
fi

# Test Neo4j browser interface
browser_response=$(curl -s -w "%{http_code}" "https://neo4j.vividwalls.blog" -o /dev/null)
echo "Neo4j Browser Interface: HTTP $browser_response"
EOF

chmod +x test_neo4j_login.sh
echo "✅ Created test_neo4j_login.sh"

# MinIO Login Test
cat > test_minio_login.sh << 'EOF'
#!/bin/bash
echo "💾 Testing MinIO Login"
echo "===================="

# MinIO credentials
MINIO_ACCESS_KEY="${MINIO_ACCESS_KEY:-minioadmin}"
MINIO_SECRET_KEY="${MINIO_SECRET_KEY:-minioadmin}"

echo "Testing MinIO authentication..."
echo "URL: https://minio-console.vividwalls.blog"
echo "Access Key: $MINIO_ACCESS_KEY"

# Test MinIO console login
response=$(curl -s -X POST \
  "https://minio-console.vividwalls.blog/api/v1/login" \
  -H "Content-Type: application/json" \
  -d "{\"accessKey\":\"$MINIO_ACCESS_KEY\",\"secretKey\":\"$MINIO_SECRET_KEY\"}" \
  -w "%{http_code}" -o /tmp/minio_response.json)

if [[ $response == "200" || $response == "204" ]]; then
    echo "✅ MinIO Login: SUCCESS"
    echo "Response: $(cat /tmp/minio_response.json | head -c 200)..."
else
    echo "❌ MinIO Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/minio_response.json)"
fi

# Test MinIO API
api_response=$(curl -s -w "%{http_code}" "https://minio.vividwalls.blog/minio/health/live" -o /dev/null)
echo "MinIO API Health: HTTP $api_response"
EOF

chmod +x test_minio_login.sh
echo "✅ Created test_minio_login.sh"

# Postiz Login Test
cat > test_postiz_login.sh << 'EOF'
#!/bin/bash
echo "📱 Testing Postiz Login"
echo "====================="

# Postiz credentials
POSTIZ_EMAIL="${POSTIZ_EMAIL:-admin@vividwalls.blog}"
POSTIZ_PASSWORD="${POSTIZ_PASSWORD:-vividwalls123}"

echo "Testing Postiz authentication..."
echo "URL: https://postiz.vividwalls.blog"
echo "Email: $POSTIZ_EMAIL"

# Test Postiz login
response=$(curl -s -X POST \
  "https://postiz.vividwalls.blog/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$POSTIZ_EMAIL\",\"password\":\"$POSTIZ_PASSWORD\"}" \
  -w "%{http_code}" -o /tmp/postiz_response.json)

if [[ $response == "200" ]]; then
    echo "✅ Postiz Login: SUCCESS"
    echo "Response: $(cat /tmp/postiz_response.json | head -c 200)..."
else
    echo "❌ Postiz Login: FAILED (HTTP $response)"
    echo "Response: $(cat /tmp/postiz_response.json)"
fi

# Test Postiz interface
interface_response=$(curl -s -w "%{http_code}" "https://postiz.vividwalls.blog" -o /dev/null)
echo "Postiz Interface: HTTP $interface_response"
EOF

chmod +x test_postiz_login.sh
echo "✅ Created test_postiz_login.sh"

echo ""
echo -e "${PURPLE}Phase 3: Execute All Login Tests${NC}"
echo "==============================="

# Array of test scripts
test_scripts=(
    "test_n8n_login.sh"
    "test_supabase_login.sh"
    "test_twenty_login.sh"
    "test_listmonk_login.sh"
    "test_medusa_login.sh"
    "test_wordpress_login.sh"
    "test_openwebui_login.sh"
    "test_neo4j_login.sh"
    "test_minio_login.sh"
    "test_postiz_login.sh"
)

# Execute all tests
for script in "${test_scripts[@]}"; do
    if [[ -f "$script" ]]; then
        echo ""
        echo -e "${BLUE}Executing $script...${NC}"
        echo "----------------------------------------"
        ./"$script"
        echo "----------------------------------------"
    else
        echo -e "${RED}❌ Script $script not found${NC}"
    fi
done

echo ""
echo -e "${PURPLE}Phase 4: Summary Report${NC}"
echo "====================="

# Create summary report
echo "📊 VividWalls MAS Login Test Summary"
echo "Generated: $(date)"
echo ""
echo "Test Results:"
echo "============"

# Count successful tests
success_count=0
total_count=${#test_scripts[@]}

for script in "${test_scripts[@]}"; do
    if [[ -f "/tmp/${script%.*}_response.json" ]] || [[ -f "/tmp/${script%.*}_response.html" ]]; then
        echo "✅ ${script%.*}: Test executed"
        ((success_count++))
    else
        echo "❌ ${script%.*}: Test failed or not executed"
    fi
done

echo ""
echo "Summary: $success_count/$total_count tests executed"
echo ""

# Cleanup temporary files
echo "🧹 Cleaning up temporary files..."
rm -f /tmp/*_response.* /tmp/wp_cookies.txt

echo ""
echo -e "${GREEN}🎉 Login test suite completed!${NC}"
echo ""
echo "📝 Individual test scripts created:"
for script in "${test_scripts[@]}"; do
    echo "   • $script"
done

echo ""
echo "💡 Usage:"
echo "   • Run all tests: ./test_all_logins.sh"
echo "   • Run individual test: ./test_n8n_login.sh"
echo "   • Set custom credentials: TWENTY_EMAIL=user@domain.com ./test_twenty_login.sh"

echo ""
echo -e "${YELLOW}⚠️ Note: Update credentials in each script or use environment variables${NC}"
echo "   Example: export N8N_EMAIL='your-email@domain.com'"
echo "           export N8N_PASSWORD='your-password'"
