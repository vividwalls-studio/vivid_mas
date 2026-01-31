#!/bin/bash
# Direct PostgREST insertion via HTTP API
# This script uses curl to insert data through PostgREST endpoints

# Configuration
SUPABASE_URL="${SUPABASE_URL:-https://supabase.vividwalls.blog}"
SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if API key is set
if [ -z "$SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}Error: SUPABASE_ANON_KEY not set${NC}"
    echo "Please run: export SUPABASE_ANON_KEY='your-anon-key-here'"
    exit 1
fi

echo "PostgREST Direct Insertion Script"
echo "================================="
echo "Supabase URL: $SUPABASE_URL"
echo ""

# Function to insert data via PostgREST
insert_table_data() {
    local table=$1
    local json_file=$2
    
    echo -e "${YELLOW}Inserting into $table...${NC}"
    
    # PostgREST accepts arrays for bulk insert
    response=$(curl -s -w "\n%{http_code}" -X POST \
        "${SUPABASE_URL}/rest/v1/${table}" \
        -H "apikey: ${SUPABASE_ANON_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=minimal" \
        -d @"${json_file}")
    
    # Extract HTTP status code
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
        echo -e "${GREEN}✓ Successfully inserted into $table${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to insert into $table (HTTP $http_code)${NC}"
        if [ ! -z "$body" ]; then
            echo "Error: $body"
        fi
        return 1
    fi
}

# Function to check if table exists and has data
check_table() {
    local table=$1
    
    echo -e "Checking $table..."
    
    response=$(curl -s -w "\n%{http_code}" -X GET \
        "${SUPABASE_URL}/rest/v1/${table}?select=count" \
        -H "apikey: ${SUPABASE_ANON_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
        -H "Prefer: count=exact" \
        -H "Range: 0-0")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ]; then
        # Extract count from Content-Range header
        count=$(echo "$response" | grep -i "content-range:" | sed 's/.*\///' | tr -d '\r')
        echo "  Current records: ${count:-0}"
    else
        echo "  Unable to check table"
    fi
}

# Main insertion process
echo "Starting data insertion..."
echo ""

# Define insertion order (respects foreign keys)
declare -a tables=(
    "agents"
    "agent_beliefs"
    "agent_desires"
    "agent_intentions"
    "agent_heuristic_imperatives"
    "agent_domain_knowledge"
    "agent_personalities"
    "agent_goals"
    "agent_llm_config"
    "agent_voice_config"
)

# Check current state
echo "Current database state:"
echo "-----------------------"
for table in "${tables[@]}"; do
    check_table "$table"
done
echo ""

# Ask for confirmation
read -p "Do you want to proceed with insertion? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Insertion cancelled."
    exit 0
fi
echo ""

# Insert data
success_count=0
total_count=${#tables[@]}

for table in "${tables[@]}"; do
    json_file="mcp_conversion/${table}.json"
    
    if [ -f "$json_file" ]; then
        if insert_table_data "$table" "$json_file"; then
            ((success_count++))
        fi
    else
        echo -e "${YELLOW}⚠ Skipping $table - file not found${NC}"
    fi
    
    # Small delay to avoid rate limiting
    sleep 0.5
done

echo ""
echo "================================="
echo "Insertion complete!"
echo "Success: $success_count/$total_count tables"
echo ""

# Verify final state
echo "Final database state:"
echo "--------------------"
check_table "agents"

# Show sample query
echo ""
echo "Test query command:"
echo "curl -X GET \\"
echo "  '${SUPABASE_URL}/rest/v1/agents?select=id,name,role&limit=5' \\"
echo "  -H 'apikey: ${SUPABASE_ANON_KEY}' \\"
echo "  -H 'Authorization: Bearer ${SUPABASE_ANON_KEY}'"