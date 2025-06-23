#!/bin/bash
# Quick insertion script for Digital Ocean Supabase

# Direct SSH command to run the insertion
ssh -i ~/.ssh/digitalocean root@157.230.13.13 << 'EOF'
cd /root/vivid_mas

# Check if files exist
if [ ! -d "mcp_conversion" ]; then
    echo "Error: mcp_conversion directory not found!"
    echo "Please upload the files first."
    exit 1
fi

# Set environment variables
export SUPABASE_URL="https://supabase.vividwalls.blog"
echo "Enter SUPABASE_ANON_KEY:"
read -s SUPABASE_ANON_KEY
export SUPABASE_ANON_KEY

# Run the insertion script
echo "Starting data insertion..."
bash scripts/postgrest_direct_insert.sh

# Quick verification
echo ""
echo "Quick verification - checking agents table:"
curl -s -X GET \
    "${SUPABASE_URL}/rest/v1/agents?select=id,name,role&limit=5" \
    -H "apikey: ${SUPABASE_ANON_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" | jq '.'
EOF