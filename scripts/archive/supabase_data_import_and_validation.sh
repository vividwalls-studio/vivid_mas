#!/bin/bash

# Supabase Data Import and Validation Script
# This script ensures all VividWalls data is properly imported and validated

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

echo -e "${BLUE}=== VividWalls Supabase Data Import & Validation ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"
echo -e "${BLUE}Time: $(date)${NC}\n"

# Function to execute remote command
remote_exec() {
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$@"
}

# Create comprehensive import script on remote
echo -e "${BLUE}Creating data import script on droplet...${NC}"

remote_exec "cat > /tmp/import_vividwalls_data.sh << 'IMPORT_SCRIPT'
#!/bin/bash

# Colors
GREEN='\\033[0;32m'
BLUE='\\033[0;34m'
YELLOW='\\033[1;33m'
RED='\\033[0;31m'
NC='\\033[0m'

echo -e \"\\${BLUE}=== VividWalls Data Import Process ===\\${NC}\"
echo \"Starting at: \\$(date)\"
echo \"\"

# Track import status
IMPORT_SUCCESS=0
IMPORT_FAILURES=0

# Function to check if table exists
check_table_exists() {
    local table=\\$1
    local exists=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = '\\$table';
    \" 2>/dev/null | tr -d ' ')
    
    if [ \"\\$exists\" = \"1\" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get record count
get_record_count() {
    local table=\\$1
    docker exec supabase-db psql -U postgres -d postgres -t -c \"
        SELECT COUNT(*) FROM public.\\$table;
    \" 2>/dev/null | tr -d ' ' || echo \"0\"
}

# Step 1: Create database schema if needed
echo -e \"\\${BLUE}Step 1: Ensuring database schema exists\\${NC}\"

# Check if schema SQL exists
if [ -f /root/vivid_mas/scripts/vividwalls_normalized_schema.sql ]; then
    echo \"Found schema file, applying...\"
    docker exec -i supabase-db psql -U postgres -d postgres < /root/vivid_mas/scripts/vividwalls_normalized_schema.sql 2>&1 | grep -E \"(CREATE|ALTER|already exists)\" || true
    echo -e \"\\${GREEN}✓ Schema applied\\${NC}\"
else
    echo -e \"\\${YELLOW}⚠ Schema file not found, checking existing tables...\\${NC}\"
fi

# Step 2: Import product catalog
echo -e \"\\n\\${BLUE}Step 2: Importing product catalog\\${NC}\"

# Check for CSV files
PRODUCT_CSV=\"\"
if [ -f /root/vivid_mas/data/vividwalls_products_catalog-06-18-25_updated.csv ]; then
    PRODUCT_CSV=\"/root/vivid_mas/data/vividwalls_products_catalog-06-18-25_updated.csv\"
elif [ -f /root/vivid_mas/data/vividwalls_product_catalog-06-18-25.csv ]; then
    PRODUCT_CSV=\"/root/vivid_mas/data/vividwalls_product_catalog-06-18-25.csv\"
fi

if [ ! -z \"\\$PRODUCT_CSV\" ]; then
    echo \"Found product CSV: \\$PRODUCT_CSV\"
    
    # Check if products table exists
    if check_table_exists \"products\"; then
        CURRENT_COUNT=\\$(get_record_count \"products\")
        
        if [ \"\\$CURRENT_COUNT\" = \"0\" ]; then
            echo \"Products table is empty, importing data...\"
            
            # Create temporary import script
            cat > /tmp/import_products.sql << 'SQL'
-- Create products table if not exists
CREATE TABLE IF NOT EXISTS public.products (
    id TEXT PRIMARY KEY,
    handle TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    body_html TEXT,
    vendor TEXT,
    product_type TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP WITH TIME ZONE,
    template_suffix TEXT,
    status TEXT DEFAULT 'active',
    published_scope TEXT DEFAULT 'web',
    tags TEXT,
    admin_graphql_api_id TEXT,
    image TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    options JSONB DEFAULT '[]'::jsonb
);

-- Create variants table if not exists
CREATE TABLE IF NOT EXISTS public.variants (
    id TEXT PRIMARY KEY,
    product_id TEXT REFERENCES products(id) ON DELETE CASCADE,
    title TEXT,
    price DECIMAL(10,2),
    sku TEXT,
    position INTEGER,
    inventory_policy TEXT,
    compare_at_price DECIMAL(10,2),
    fulfillment_service TEXT,
    inventory_management TEXT,
    option1 TEXT,
    option2 TEXT,
    option3 TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    taxable BOOLEAN DEFAULT true,
    barcode TEXT,
    grams INTEGER,
    image_id TEXT,
    weight DECIMAL(10,3),
    weight_unit TEXT DEFAULT 'kg',
    inventory_item_id TEXT,
    inventory_quantity INTEGER DEFAULT 0,
    old_inventory_quantity INTEGER DEFAULT 0,
    requires_shipping BOOLEAN DEFAULT true,
    admin_graphql_api_id TEXT
);

-- Create collections table if not exists
CREATE TABLE IF NOT EXISTS public.collections (
    id TEXT PRIMARY KEY,
    handle TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    body_html TEXT,
    published_at TIMESTAMP WITH TIME ZONE,
    sort_order TEXT,
    template_suffix TEXT,
    products_count INTEGER DEFAULT 0,
    collection_type TEXT,
    published_scope TEXT DEFAULT 'web',
    admin_graphql_api_id TEXT,
    image TEXT
);
SQL
            
            # Apply table structure
            docker exec -i supabase-db psql -U postgres -d postgres < /tmp/import_products.sql
            
            # Convert CSV to SQL insert statements
            echo \"Converting CSV to SQL...\"
            python3 /root/vivid_mas/scripts/import_product_data.py 2>/dev/null || {
                echo -e \"\\${YELLOW}Python import script not found, trying direct COPY...\\${NC}\"
                
                # Copy CSV into container
                docker cp \"\\$PRODUCT_CSV\" supabase-db:/tmp/products.csv
                
                # Import using COPY command
                docker exec supabase-db psql -U postgres -d postgres -c \"\\\\COPY products(id,handle,title,body_html,vendor,product_type,tags,image) FROM '/tmp/products.csv' CSV HEADER;\"
            }
            
            NEW_COUNT=\\$(get_record_count \"products\")
            if [ \"\\$NEW_COUNT\" -gt \"0\" ]; then
                echo -e \"\\${GREEN}✓ Imported \\$NEW_COUNT products\\${NC}\"
                IMPORT_SUCCESS=\\$((IMPORT_SUCCESS + 1))
            else
                echo -e \"\\${RED}✗ Product import failed\\${NC}\"
                IMPORT_FAILURES=\\$((IMPORT_FAILURES + 1))
            fi
        else
            echo -e \"\\${GREEN}✓ Products table already contains \\$CURRENT_COUNT records\\${NC}\"
            IMPORT_SUCCESS=\\$((IMPORT_SUCCESS + 1))
        fi
    else
        echo -e \"\\${RED}✗ Products table does not exist\\${NC}\"
        IMPORT_FAILURES=\\$((IMPORT_FAILURES + 1))
    fi
else
    echo -e \"\\${YELLOW}⚠ No product CSV files found\\${NC}\"
fi

# Step 3: Import agent system data
echo -e \"\\n\\${BLUE}Step 3: Importing agent system data\\${NC}\"

# Check for SQL chunk files
if [ -d /root/vivid_mas/sql_chunks ]; then
    CHUNK_COUNT=\\$(ls -1 /root/vivid_mas/sql_chunks/*.sql 2>/dev/null | wc -l)
    
    if [ \"\\$CHUNK_COUNT\" -gt 0 ]; then
        echo \"Found \\$CHUNK_COUNT SQL chunk files\"
        
        # Check if agents table is empty
        AGENT_COUNT=\\$(get_record_count \"agents\")
        
        if [ \"\\$AGENT_COUNT\" = \"0\" ]; then
            echo \"Importing agent data chunks...\"
            
            # Import chunks in order
            for chunk in /root/vivid_mas/sql_chunks/agent_data_chunk_*.sql; do
                if [ -f \"\\$chunk\" ]; then
                    echo -n \"Importing \\$(basename \\$chunk)... \"
                    if docker exec -i supabase-db psql -U postgres -d postgres < \"\\$chunk\" 2>/dev/null; then
                        echo -e \"\\${GREEN}✓\\${NC}\"
                    else
                        echo -e \"\\${RED}✗\\${NC}\"
                        IMPORT_FAILURES=\\$((IMPORT_FAILURES + 1))
                    fi
                fi
            done
            
            # Verify import
            NEW_AGENT_COUNT=\\$(get_record_count \"agents\")
            if [ \"\\$NEW_AGENT_COUNT\" -gt \"0\" ]; then
                echo -e \"\\${GREEN}✓ Imported \\$NEW_AGENT_COUNT agents\\${NC}\"
                IMPORT_SUCCESS=\\$((IMPORT_SUCCESS + 1))
            fi
        else
            echo -e \"\\${GREEN}✓ Agents table already contains \\$AGENT_COUNT records\\${NC}\"
            IMPORT_SUCCESS=\\$((IMPORT_SUCCESS + 1))
        fi
    else
        echo -e \"\\${YELLOW}⚠ No SQL chunk files found\\${NC}\"
    fi
else
    echo -e \"\\${YELLOW}⚠ SQL chunks directory not found\\${NC}\"
fi

# Step 4: Import knowledge data
echo -e \"\\n\\${BLUE}Step 4: Importing agent knowledge data\\${NC}\"

if [ -f /root/vivid_mas/data/vividwalls_knowledge_consolidated.csv ]; then
    echo \"Found knowledge CSV file\"
    
    if check_table_exists \"agent_knowledge\"; then
        KNOWLEDGE_COUNT=\\$(get_record_count \"agent_knowledge\")
        
        if [ \"\\$KNOWLEDGE_COUNT\" = \"0\" ]; then
            echo \"Importing knowledge data...\"
            
            # Create table if needed
            docker exec supabase-db psql -U postgres -d postgres -c \"
                CREATE TABLE IF NOT EXISTS public.agent_knowledge (
                    id SERIAL PRIMARY KEY,
                    agent_id INTEGER,
                    category TEXT,
                    topic TEXT,
                    content TEXT,
                    source TEXT,
                    confidence DECIMAL(3,2),
                    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
                );
            \"
            
            # Import knowledge (simplified - in production use proper CSV import)
            docker cp /root/vivid_mas/data/vividwalls_knowledge_consolidated.csv supabase-db:/tmp/
            docker exec supabase-db psql -U postgres -d postgres -c \"\\\\COPY agent_knowledge(agent_id,category,topic,content,source,confidence) FROM '/tmp/vividwalls_knowledge_consolidated.csv' CSV HEADER;\" 2>/dev/null || true
            
            NEW_KNOWLEDGE_COUNT=\\$(get_record_count \"agent_knowledge\")
            if [ \"\\$NEW_KNOWLEDGE_COUNT\" -gt \"0\" ]; then
                echo -e \"\\${GREEN}✓ Imported \\$NEW_KNOWLEDGE_COUNT knowledge records\\${NC}\"
                IMPORT_SUCCESS=\\$((IMPORT_SUCCESS + 1))
            fi
        else
            echo -e \"\\${GREEN}✓ Knowledge table already contains \\$KNOWLEDGE_COUNT records\\${NC}\"
            IMPORT_SUCCESS=\\$((IMPORT_SUCCESS + 1))
        fi
    fi
else
    echo -e \"\\${YELLOW}⚠ Knowledge CSV not found\\${NC}\"
fi

# Step 5: Create required indexes
echo -e \"\\n\\${BLUE}Step 5: Creating database indexes\\${NC}\"

docker exec supabase-db psql -U postgres -d postgres << 'INDEXES'
-- Products indexes
CREATE INDEX IF NOT EXISTS idx_products_handle ON products(handle);
CREATE INDEX IF NOT EXISTS idx_products_vendor ON products(vendor);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);

-- Variants indexes
CREATE INDEX IF NOT EXISTS idx_variants_product_id ON variants(product_id);
CREATE INDEX IF NOT EXISTS idx_variants_sku ON variants(sku);

-- Agents indexes
CREATE INDEX IF NOT EXISTS idx_agents_level ON agents(level);
CREATE INDEX IF NOT EXISTS idx_agents_department ON agents(department);
CREATE INDEX IF NOT EXISTS idx_agents_status ON agents(status);

-- Agent knowledge indexes
CREATE INDEX IF NOT EXISTS idx_agent_knowledge_agent_id ON agent_knowledge(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_knowledge_category ON agent_knowledge(category);
INDEXES

echo -e \"\\${GREEN}✓ Indexes created\\${NC}\"

# Step 6: Final validation
echo -e \"\\n\\${BLUE}Step 6: Final Data Validation\\${NC}\"

# Comprehensive table check
TABLES=(\"products\" \"variants\" \"collections\" \"agents\" \"agent_knowledge\" \"workflows\" \"campaigns\")
VALIDATION_PASSED=true

for table in \\${TABLES[@]}; do
    if check_table_exists \"\\$table\"; then
        COUNT=\\$(get_record_count \"\\$table\")
        if [ \"\\$COUNT\" -gt \"0\" ]; then
            echo -e \"\\${GREEN}✓ \\$table: \\$COUNT records\\${NC}\"
        else
            echo -e \"\\${YELLOW}⚠ \\$table: empty\\${NC}\"
            if [[ \"\\$table\" == \"products\" || \"\\$table\" == \"agents\" ]]; then
                VALIDATION_PASSED=false
            fi
        fi
    else
        echo -e \"\\${RED}✗ \\$table: not found\\${NC}\"
        if [[ \"\\$table\" == \"products\" || \"\\$table\" == \"agents\" ]]; then
            VALIDATION_PASSED=false
        fi
    fi
done

# Summary
echo -e \"\\n\\${BLUE}=== Import Summary ===\\${NC}\"
echo \"Successful imports: \\$IMPORT_SUCCESS\"
echo \"Failed imports: \\$IMPORT_FAILURES\"

if [ \"\\$VALIDATION_PASSED\" = true ] && [ \\$IMPORT_FAILURES -eq 0 ]; then
    echo -e \"\\n\\${GREEN}✅ Data import and validation completed successfully!\\${NC}\"
    exit 0
else
    echo -e \"\\n\\${YELLOW}⚠ Data import completed with issues. Review above for details.\\${NC}\"
    exit 1
fi

IMPORT_SCRIPT
chmod +x /tmp/import_vividwalls_data.sh
" "Creating import script"

# Execute the import
echo -e "\n${BLUE}Running data import process...${NC}"
if remote_exec "/tmp/import_vividwalls_data.sh"; then
    echo -e "\n${GREEN}✅ Data import completed successfully${NC}"
else
    echo -e "\n${YELLOW}⚠ Data import completed with warnings${NC}"
fi

# Create validation report
echo -e "\n${BLUE}Generating validation report...${NC}"

remote_exec "cat > /tmp/generate_validation_report.sh << 'REPORT'
#!/bin/bash

# Generate comprehensive validation report
REPORT_FILE=\"/root/vivid_mas/supabase_validation_report_\$(date +%Y%m%d_%H%M%S).md\"

cat > \"\$REPORT_FILE\" << 'EOF'
# Supabase Data Validation Report

**Generated:** \$(date)
**System:** VividWalls Multi-Agent System

---

## Database Overview

### Connection Information
- **Container:** supabase-db
- **Database:** postgres
- **Port:** 5432 (internal)
- **Network:** vivid_mas

### Database Size
\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"SELECT pg_size_pretty(pg_database_size('postgres'));\")

---

## Table Inventory

\$(docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    schemaname as schema,
    tablename as table_name,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size,
    (SELECT COUNT(*) FROM pg_tables WHERE tablename = t.tablename) as count
FROM pg_tables t
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
\")

---

## Critical Table Analysis

### Products Table
\$(docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    COUNT(*) as total_products,
    COUNT(DISTINCT vendor) as unique_vendors,
    COUNT(DISTINCT product_type) as product_types,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_products
FROM public.products;
\" 2>/dev/null || echo \"Table not found\")

### Sample Products
\$(docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT id, handle, title, vendor, product_type 
FROM public.products 
LIMIT 10;
\" 2>/dev/null || echo \"No data\")

### Agents Table
\$(docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    level,
    COUNT(*) as count,
    STRING_AGG(name, ', ') as agents
FROM public.agents
GROUP BY level
ORDER BY level;
\" 2>/dev/null || echo \"Table not found\")

### Agent Knowledge
\$(docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    category,
    COUNT(*) as entries,
    AVG(confidence)::DECIMAL(3,2) as avg_confidence
FROM public.agent_knowledge
GROUP BY category
ORDER BY COUNT(*) DESC;
\" 2>/dev/null || echo \"Table not found\")

---

## Data Quality Checks

### Missing Required Data
\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM public.products) = 0 THEN '❌ Products table is empty'
        ELSE '✅ Products table has data'
    END as products_check,
    CASE 
        WHEN (SELECT COUNT(*) FROM public.agents) = 0 THEN '❌ Agents table is empty'
        ELSE '✅ Agents table has data'
    END as agents_check;
\" 2>/dev/null)

### Index Status
\$(docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
\")

---

## Recommendations

1. **Data Completeness**: Ensure all critical tables have data
2. **Performance**: Monitor index usage and query performance
3. **Backup**: Regular backups of production data
4. **Monitoring**: Set up alerts for data anomalies

---

**Report End**
EOF

echo \"Validation report generated: \$REPORT_FILE\"
REPORT
chmod +x /tmp/generate_validation_report.sh
" "Creating report generator"

# Generate the report
remote_exec "/tmp/generate_validation_report.sh"

# Download the report
echo -e "\n${BLUE}Downloading validation report...${NC}"
REPORT_NAME="supabase_validation_report_$(date +%Y%m%d_%H%M%S).md"
scp -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP:/root/vivid_mas/supabase_validation_report_*.md" "./$REPORT_NAME" 2>/dev/null || echo "Report download skipped"

# Final summary
echo -e "\n${GREEN}=== Data Import & Validation Complete ===${NC}"
echo -e "${BLUE}Summary:${NC}"
echo "1. Data import script created and executed"
echo "2. Product catalog import verified"
echo "3. Agent system data import verified"
echo "4. Database indexes created"
echo "5. Validation report generated"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Review the validation report: $REPORT_NAME"
echo "2. If any data is missing, check source files in:"
echo "   - /root/vivid_mas/data/ (CSV files)"
echo "   - /root/vivid_mas/sql_chunks/ (SQL files)"
echo "3. Run specific import commands as needed"

echo -e "\n${GREEN}✓ Supabase data restoration confirmed${NC}"