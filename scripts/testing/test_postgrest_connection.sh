#!/bin/bash
# Test PostgREST connection and endpoints

SUPABASE_URL="${SUPABASE_URL:-https://supabase.vividwalls.blog}"
SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

echo "PostgREST Connection Test"
echo "========================"
echo ""

if [ -z "$SUPABASE_ANON_KEY" ]; then
    echo "❌ SUPABASE_ANON_KEY not set"
    echo ""
    echo "To get your key:"
    echo "1. Go to https://supabase.vividwalls.blog"
    echo "2. Navigate to Settings > API"
    echo "3. Copy the 'anon' public key"
    echo "4. Run: export SUPABASE_ANON_KEY='your-key-here'"
    exit 1
fi

echo "Testing endpoints..."
echo ""

# Test 1: Basic connection
echo "1. Testing PostgREST root endpoint:"
curl -s -o /dev/null -w "   HTTP Status: %{http_code}\n" \
    "${SUPABASE_URL}/rest/v1/" \
    -H "apikey: ${SUPABASE_ANON_KEY}"

# Test 2: OpenAPI spec
echo ""
echo "2. Testing OpenAPI spec endpoint:"
curl -s -o /dev/null -w "   HTTP Status: %{http_code}\n" \
    "${SUPABASE_URL}/rest/v1/" \
    -H "Accept: application/openapi+json" \
    -H "apikey: ${SUPABASE_ANON_KEY}"

# Test 3: Query agents table
echo ""
echo "3. Testing agents table query:"
response=$(curl -s -w "\n%{http_code}" \
    "${SUPABASE_URL}/rest/v1/agents?limit=1" \
    -H "apikey: ${SUPABASE_ANON_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_ANON_KEY}")

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

echo "   HTTP Status: $http_code"
if [ "$http_code" = "200" ]; then
    echo "   ✅ Table accessible"
elif [ "$http_code" = "404" ]; then
    echo "   ⚠️  Table not found (may need to create schema)"
else
    echo "   ❌ Error accessing table"
    if [ ! -z "$body" ]; then
        echo "   Response: $body"
    fi
fi

# Test 4: Test insert capability (dry run)
echo ""
echo "4. Testing insert capability:"
echo "   Would insert to: ${SUPABASE_URL}/rest/v1/agents"
echo "   With headers:"
echo "     - apikey: [SET]"
echo "     - Authorization: Bearer [SET]"
echo "     - Content-Type: application/json"
echo "     - Prefer: return=minimal"

echo ""
echo "========================"
echo "Connection test complete!"
echo ""
echo "If all tests passed, you can run:"
echo "  ./scripts/postgrest_direct_insert.sh"
echo ""
echo "Or use Python:"
echo "  python scripts/postgrest_http_insert.py"