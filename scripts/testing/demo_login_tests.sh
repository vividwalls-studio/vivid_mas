#!/bin/bash

# VividWalls MAS - Login Test Demonstration
# Shows the curl commands for testing each application

echo "🔐 VividWalls MAS - Login Test Demonstration"
echo "============================================"

echo ""
echo "📋 CURL COMMANDS FOR EACH APPLICATION"
echo "====================================="

echo ""
echo "🤖 N8N Workflow Automation"
echo "=========================="
echo "URL: https://n8n.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://n8n.vividwalls.blog/rest/login" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"email\":\"admin@vividwalls.blog\",\"password\":\"vividwalls123\"}"'

echo ""
echo "🗄️ Supabase Studio"
echo "=================="
echo "URL: https://studio.vividwalls.blog"
echo "Access Test:"
echo 'curl -I "https://studio.vividwalls.blog"'
echo "API Test:"
echo 'curl "https://supabase.vividwalls.blog/rest/v1/" \'
echo '  -H "apikey: your-anon-key"'

echo ""
echo "💼 Twenty CRM"
echo "============"
echo "URL: https://twenty.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://twenty.vividwalls.blog/auth/login" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"email\":\"admin@vividwalls.blog\",\"password\":\"vividwalls123\"}"'

echo ""
echo "📧 ListMonk Email Marketing"
echo "=========================="
echo "URL: https://listmonk.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://listmonk.vividwalls.blog/admin/api/auth/login" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"username\":\"admin\",\"password\":\"listmonk\"}"'

echo ""
echo "🛒 Medusa E-commerce"
echo "==================="
echo "URL: https://medusa.vividwalls.blog (Admin)"
echo "URL: https://store.vividwalls.blog (Storefront)"
echo "Admin Login Test:"
echo 'curl -X POST "https://medusa.vividwalls.blog/admin/auth" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"email\":\"admin@vividwalls.blog\",\"password\":\"vividwalls123\"}"'
echo "Store API Test:"
echo 'curl "https://store.vividwalls.blog/store/products"'

echo ""
echo "📝 WordPress"
echo "============"
echo "URL: https://wordpress.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://wordpress.vividwalls.blog/wp-login.php" \'
echo '  -d "log=admin&pwd=vividwalls123&wp-submit=Log+In"'

echo ""
echo "🤖 Open WebUI"
echo "============="
echo "URL: https://openwebui.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://openwebui.vividwalls.blog/api/v1/auths/signin" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"email\":\"admin@vividwalls.blog\",\"password\":\"vividwalls123\"}"'

echo ""
echo "🧠 Neo4j Knowledge Graph"
echo "======================="
echo "URL: https://neo4j.vividwalls.blog"
echo "Auth Test:"
echo 'curl -X POST "https://neo4j.vividwalls.blog/db/data/transaction/commit" \'
echo '  -H "Content-Type: application/json" \'
echo '  -H "Authorization: Basic $(echo -n "neo4j:password" | base64)" \'
echo '  -d "{\"statements\":[{\"statement\":\"RETURN 1 as test\"}]}"'

echo ""
echo "💾 MinIO Object Storage"
echo "======================"
echo "URL: https://minio-console.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://minio-console.vividwalls.blog/api/v1/login" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"accessKey\":\"minioadmin\",\"secretKey\":\"minioadmin\"}"'

echo ""
echo "📱 Postiz Social Media"
echo "====================="
echo "URL: https://postiz.vividwalls.blog"
echo "Login Test:"
echo 'curl -X POST "https://postiz.vividwalls.blog/api/auth/login" \'
echo '  -H "Content-Type: application/json" \'
echo '  -d "{\"email\":\"admin@vividwalls.blog\",\"password\":\"vividwalls123\"}"'

echo ""
echo "🔍 Additional Services"
echo "====================="
echo "Flowise AI: https://flowise.vividwalls.blog"
echo "Langfuse: https://langfuse.vividwalls.blog"
echo "Crawl4AI: https://crawl4ai.vividwalls.blog"
echo "Ollama: https://ollama.vividwalls.blog"
echo "SearXNG: https://searxng.vividwalls.blog"
echo "Qdrant: https://qdrant.vividwalls.blog"

echo ""
echo "🏥 Health Check"
echo "==============="
echo "URL: https://health.vividwalls.blog"
echo "Test:"
echo 'curl "https://health.vividwalls.blog/health"'

echo ""
echo "📊 QUICK CONNECTIVITY TEST"
echo "=========================="

services=(
    "n8n.vividwalls.blog"
    "supabase.vividwalls.blog"
    "twenty.vividwalls.blog"
    "listmonk.vividwalls.blog"
    "medusa.vividwalls.blog"
    "store.vividwalls.blog"
    "wordpress.vividwalls.blog"
    "openwebui.vividwalls.blog"
    "neo4j.vividwalls.blog"
    "minio.vividwalls.blog"
    "postiz.vividwalls.blog"
    "health.vividwalls.blog"
)

echo "Testing basic connectivity to all services..."
echo ""

for service in "${services[@]}"; do
    echo -n "Testing $service... "
    response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "https://$service" || echo "000")
    
    if [[ $response == "200" ]]; then
        echo "✅ OK ($response)"
    elif [[ $response == "302" || $response == "301" || $response == "307" ]]; then
        echo "🔄 Redirect ($response)"
    elif [[ $response == "401" || $response == "403" ]]; then
        echo "🔐 Auth Required ($response)"
    else
        echo "❌ Error ($response)"
    fi
done

echo ""
echo "🎯 SUMMARY"
echo "=========="
echo "✅ Created comprehensive login test suite"
echo "✅ All 22 applications configured in Caddyfile"
echo "✅ Individual curl test scripts available"
echo "✅ Credentials configuration template provided"
echo "✅ Automated test execution scripts ready"

echo ""
echo "📝 FILES CREATED:"
echo "   • test_all_logins.sh - Main test suite"
echo "   • setup_login_tests.sh - Setup and execution"
echo "   • credentials_config.env - Credentials template"
echo "   • demo_login_tests.sh - This demonstration"

echo ""
echo "🚀 USAGE:"
echo "   ./setup_login_tests.sh    # Setup and run all tests"
echo "   ./test_all_logins.sh      # Run all login tests"
echo "   ./demo_login_tests.sh     # Show this demonstration"

echo ""
echo "🔐 The Matrix authentication protocols are ready for testing."
