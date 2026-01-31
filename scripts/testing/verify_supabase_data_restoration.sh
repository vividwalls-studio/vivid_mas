#!/bin/bash

# Supabase Data Restoration Verification Script
# This script confirms all VividWalls database tables and records are properly restored

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== VividWalls Supabase Data Restoration Verification ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"
echo -e "${BLUE}Time: $(date)${NC}\n"

# Function to execute remote command
remote_exec() {
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$@"
}

# Create verification script on remote
remote_exec "cat > /tmp/verify_supabase_data.sh << 'SCRIPT'
#!/bin/bash

# Colors
GREEN='\\033[0;32m'
BLUE='\\033[0;34m'
YELLOW='\\033[1;33m'
RED='\\033[0;31m'
NC='\\033[0m'

echo -e \"\\${BLUE}=== Supabase Data Verification Report ===\\${NC}\"
echo \"Generated: \\$(date)\"
echo \"\"

# Check if Supabase is running
echo -e \"\\${BLUE}1. Supabase Container Status\\${NC}\"
if docker ps | grep -q supabase-db; then
    echo -e \"\\${GREEN}✓ Supabase database container is running\\${NC}\"
    
    # Get container details
    docker ps | grep supabase | while read line; do
        echo \"  \\$line\"
    done
else
    echo -e \"\\${RED}✗ Supabase database container not found\\${NC}\"
    echo \"Checking for external Supabase deployment...\"
    
    # Check if Supabase is in separate location
    if [ -d /home/vivid/vivid_mas/supabase/docker ]; then
        echo -e \"\\${YELLOW}⚠ Supabase found at: /home/vivid/vivid_mas/supabase/docker\\${NC}\"
        cd /home/vivid/vivid_mas/supabase/docker
        docker-compose ps
    fi
fi

# Database connection test
echo -e \"\\n\\${BLUE}2. Database Connection Test\\${NC}\"

# Try to connect to Supabase database
if docker exec supabase-db psql -U postgres -c '\\l' > /dev/null 2>&1; then
    echo -e \"\\${GREEN}✓ Successfully connected to Supabase PostgreSQL\\${NC}\"
else
    echo -e \"\\${RED}✗ Cannot connect to Supabase database\\${NC}\"
fi

# Check for VividWalls database
echo -e \"\\n\\${BLUE}3. VividWalls Database Check\\${NC}\"

DB_EXISTS=\\$(docker exec supabase-db psql -U postgres -t -c \"SELECT 1 FROM pg_database WHERE datname='vividwalls';\" 2>/dev/null | tr -d ' ')

if [ \"\\$DB_EXISTS\" = \"1\" ]; then
    echo -e \"\\${GREEN}✓ VividWalls database exists\\${NC}\"
    
    # Get database size
    DB_SIZE=\\$(docker exec supabase-db psql -U postgres -d vividwalls -t -c \"SELECT pg_size_pretty(pg_database_size('vividwalls'));\" 2>/dev/null | tr -d ' ')
    echo \"  Database size: \\$DB_SIZE\"
else
    echo -e \"\\${YELLOW}⚠ VividWalls database not found, checking default 'postgres' database\\${NC}\"
fi

# List all tables
echo -e \"\\n\\${BLUE}4. Database Tables Inventory\\${NC}\"

docker exec supabase-db psql -U postgres -d postgres -c \"
    SELECT 
        schemaname as schema,
        tablename as table_name,
        pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
    FROM pg_tables 
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
    ORDER BY schemaname, tablename;
\" 2>/dev/null || echo \"Cannot list tables\"

# Check for critical VividWalls tables
echo -e \"\\n\\${BLUE}5. Critical VividWalls Tables\\${NC}\"

# Expected tables based on e-commerce system
CRITICAL_TABLES=(
    \"products\"
    \"collections\"
    \"agents\"
    \"agent_knowledge\"
    \"customers\"
    \"orders\"
    \"workflows\"
    \"campaigns\"
)

for table in \"\\${CRITICAL_TABLES[@]}\"; do
    echo -n \"Checking table '\\$table': \"
    
    COUNT=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_name = '\\$table' 
        AND table_schema = 'public';
    \" 2>/dev/null | tr -d ' ')
    
    if [ \"\\$COUNT\" = \"1\" ]; then
        # Get record count
        RECORDS=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"
            SELECT COUNT(*) FROM public.\\$table;
        \" 2>/dev/null | tr -d ' ')
        echo -e \"\\${GREEN}✓ Found (\\$RECORDS records)\\${NC}\"
    else
        echo -e \"\\${YELLOW}⚠ Not found\\${NC}\"
    fi
done

# Check product catalog specifically
echo -e \"\\n\\${BLUE}6. Product Catalog Verification\\${NC}\"

PRODUCT_COUNT=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"
    SELECT COUNT(*) FROM public.products;
\" 2>/dev/null | tr -d ' ')

if [ ! -z \"\\$PRODUCT_COUNT\" ] && [ \"\\$PRODUCT_COUNT\" -gt 0 ]; then
    echo -e \"\\${GREEN}✓ Product catalog contains \\$PRODUCT_COUNT products\\${NC}\"
    
    # Sample product data
    echo -e \"\\nSample products:\"
    docker exec supabase-db psql -U postgres -d postgres -c \"
        SELECT id, handle, title, vendor 
        FROM public.products 
        LIMIT 5;
    \" 2>/dev/null || echo \"Cannot fetch sample products\"
else
    echo -e \"\\${YELLOW}⚠ No products found in database\\${NC}\"
fi

# Check agent system tables
echo -e \"\\n\\${BLUE}7. Agent System Tables\\${NC}\"

# Check agents table
AGENT_COUNT=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"
    SELECT COUNT(*) FROM public.agents;
\" 2>/dev/null | tr -d ' ')

if [ ! -z \"\\$AGENT_COUNT\" ] && [ \"\\$AGENT_COUNT\" -gt 0 ]; then
    echo -e \"\\${GREEN}✓ Agent system contains \\$AGENT_COUNT agents\\${NC}\"
    
    # List agent types
    echo -e \"\\nAgent hierarchy:\"
    docker exec supabase-db psql -U postgres -d postgres -c \"
        SELECT level, COUNT(*) as count 
        FROM public.agents 
        GROUP BY level 
        ORDER BY level;
    \" 2>/dev/null || echo \"Cannot fetch agent hierarchy\"
else
    echo -e \"\\${YELLOW}⚠ No agents found in database\\${NC}\"
fi

# Check for CSV data files
echo -e \"\\n\\${BLUE}8. Data File Verification\\${NC}\"

echo \"Checking for product catalog CSV files:\"
ls -la /root/vivid_mas/data/*.csv 2>/dev/null | grep -E \"(product|catalog)\" || echo \"  No product CSV files found\"

echo -e \"\\nChecking for SQL chunk files:\"
ls -la /root/vivid_mas/sql_chunks/*.sql 2>/dev/null | wc -l | xargs -I {} echo \"  Found {} SQL chunk files\"

# Check if data needs to be imported
echo -e \"\\n\\${BLUE}9. Data Import Status\\${NC}\"

if [ \"\\$PRODUCT_COUNT\" = \"0\" ] || [ -z \"\\$PRODUCT_COUNT\" ]; then
    echo -e \"\\${YELLOW}⚠ Product data needs to be imported\\${NC}\"
    echo \"  Import command: docker exec -i supabase-db psql -U postgres < /path/to/products.sql\"
fi

if [ \"\\$AGENT_COUNT\" = \"0\" ] || [ -z \"\\$AGENT_COUNT\" ]; then
    echo -e \"\\${YELLOW}⚠ Agent data needs to be imported\\${NC}\"
    echo \"  SQL chunks available in: /root/vivid_mas/sql_chunks/\"
fi

# Generate summary
echo -e \"\\n\\${BLUE}=== Data Restoration Summary ===\\${NC}\"

ISSUES=0

# Check key metrics
if [ \"\\$PRODUCT_COUNT\" -gt 0 ] 2>/dev/null; then
    echo -e \"\\${GREEN}✓ Products: \\$PRODUCT_COUNT records\\${NC}\"
else
    echo -e \"\\${RED}✗ Products: No data\\${NC}\"
    ISSUES=\\$((ISSUES + 1))
fi

if [ \"\\$AGENT_COUNT\" -gt 0 ] 2>/dev/null; then
    echo -e \"\\${GREEN}✓ Agents: \\$AGENT_COUNT records\\${NC}\"
else
    echo -e \"\\${RED}✗ Agents: No data\\${NC}\"
    ISSUES=\\$((ISSUES + 1))
fi

if [ \\$ISSUES -eq 0 ]; then
    echo -e \"\\n\\${GREEN}✅ Supabase data restoration verified successfully\\${NC}\"
else
    echo -e \"\\n\\${YELLOW}⚠ \\$ISSUES data restoration issues detected\\${NC}\"
    echo \"Run data import scripts to complete restoration\"
fi

SCRIPT
chmod +x /tmp/verify_supabase_data.sh
" "Creating Supabase verification script"

# Execute verification
echo -e "\n${BLUE}Running Supabase data verification...${NC}"
remote_exec "/tmp/verify_supabase_data.sh"

# Create data import helper script
echo -e "\n${BLUE}Creating data import helper script...${NC}"

remote_exec "cat > /tmp/import_supabase_data.sh << 'IMPORT'
#!/bin/bash

# Supabase Data Import Helper Script

echo '=== Supabase Data Import Helper ==='
echo ''

# Check for SQL files
echo 'Available SQL files for import:'
ls -la /root/vivid_mas/sql_chunks/*.sql 2>/dev/null || echo 'No SQL chunks found'
ls -la /root/vivid_mas/scripts/*schema*.sql 2>/dev/null || echo 'No schema files found'

echo -e '\nTo import agent data:'
echo 'for file in /root/vivid_mas/sql_chunks/*.sql; do'
echo '    echo \"Importing \\$file...\"'
echo '    docker exec -i supabase-db psql -U postgres -d postgres < \"\\$file\"'
echo 'done'

echo -e '\nTo import product data from CSV:'
echo '1. First, create the products table schema if needed'
echo '2. Use COPY command or conversion script'
echo '3. Example:'
echo '   docker exec -i supabase-db psql -U postgres -d postgres -c \"\\COPY products FROM '/data/products.csv' CSV HEADER;\"'

echo -e '\nTo verify import:'
echo 'docker exec supabase-db psql -U postgres -d postgres -c \"SELECT COUNT(*) FROM products;\"'
echo 'docker exec supabase-db psql -U postgres -d postgres -c \"SELECT COUNT(*) FROM agents;\"'

IMPORT
chmod +x /tmp/import_supabase_data.sh
" "Creating import helper script"

# Provide recommendations
echo -e "\n${BLUE}=== Restoration Recommendations ===${NC}"
echo -e "${YELLOW}Based on the verification results:${NC}"
echo ""
echo "1. If products table is empty:"
echo "   - Import from CSV files in /root/vivid_mas/data/"
echo "   - Or restore from SQL backup"
echo ""
echo "2. If agents table is empty:"
echo "   - Import SQL chunks from /root/vivid_mas/sql_chunks/"
echo "   - Files should be imported in order (1-4)"
echo ""
echo "3. To run import helper:"
echo "   ssh -i ~/.ssh/digitalocean root@$DROPLET_IP '/tmp/import_supabase_data.sh'"
echo ""
echo -e "${GREEN}✓ Supabase data verification complete${NC}"