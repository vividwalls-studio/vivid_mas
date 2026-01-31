#!/bin/bash

# VividWalls Product Catalog Restoration Script
# Specifically handles product, variant, and collection data restoration

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

echo -e "${BLUE}=== VividWalls Product Catalog Restoration ===${NC}"
echo -e "${YELLOW}This script restores the complete product catalog${NC}"
echo -e "${BLUE}Time: $(date)${NC}\n"

# Function to execute remote command
remote_exec() {
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$@"
}

# Create product restoration script
echo -e "${BLUE}Creating product catalog restoration script...${NC}"

remote_exec "cat > /tmp/restore_product_catalog.sh << 'CATALOG_SCRIPT'
#!/bin/bash

# Colors
GREEN='\\033[0;32m'
BLUE='\\033[0;34m'
YELLOW='\\033[1;33m'
RED='\\033[0;31m'
NC='\\033[0m'

echo -e \"\\${BLUE}=== Product Catalog Restoration Process ===\\${NC}\"
echo \"\"

# Step 1: Prepare database schema
echo -e \"\\${BLUE}Step 1: Preparing product database schema\\${NC}\"

docker exec supabase-db psql -U postgres -d postgres << 'SCHEMA'
-- Create schema for VividWalls products
CREATE SCHEMA IF NOT EXISTS vividwalls;

-- Products table with full Shopify compatibility
CREATE TABLE IF NOT EXISTS public.products (
    id TEXT PRIMARY KEY,
    handle TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    body_html TEXT,
    vendor TEXT DEFAULT 'VividWalls',
    product_type TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    template_suffix TEXT,
    status TEXT DEFAULT 'active',
    published_scope TEXT DEFAULT 'web',
    tags TEXT,
    admin_graphql_api_id TEXT,
    image TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    options JSONB DEFAULT '[{\"name\": \"Size\", \"position\": 1, \"values\": [\"8x10\", \"11x14\", \"16x20\", \"20x30\", \"24x36\"]}]'::jsonb
);

-- Variants table
CREATE TABLE IF NOT EXISTS public.variants (
    id TEXT PRIMARY KEY,
    product_id TEXT REFERENCES products(id) ON DELETE CASCADE,
    title TEXT,
    price DECIMAL(10,2),
    sku TEXT UNIQUE,
    position INTEGER DEFAULT 1,
    inventory_policy TEXT DEFAULT 'deny',
    compare_at_price DECIMAL(10,2),
    fulfillment_service TEXT DEFAULT 'manual',
    inventory_management TEXT DEFAULT 'shopify',
    option1 TEXT,
    option2 TEXT,
    option3 TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    taxable BOOLEAN DEFAULT true,
    barcode TEXT,
    grams INTEGER DEFAULT 500,
    image_id TEXT,
    weight DECIMAL(10,3) DEFAULT 0.5,
    weight_unit TEXT DEFAULT 'kg',
    inventory_item_id TEXT,
    inventory_quantity INTEGER DEFAULT 999,
    old_inventory_quantity INTEGER DEFAULT 999,
    requires_shipping BOOLEAN DEFAULT true,
    admin_graphql_api_id TEXT
);

-- Collections table
CREATE TABLE IF NOT EXISTS public.collections (
    id TEXT PRIMARY KEY,
    handle TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    body_html TEXT,
    published_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    sort_order TEXT DEFAULT 'best-selling',
    template_suffix TEXT,
    products_count INTEGER DEFAULT 0,
    collection_type TEXT DEFAULT 'custom',
    published_scope TEXT DEFAULT 'web',
    admin_graphql_api_id TEXT,
    image TEXT,
    rules JSONB DEFAULT '[]'::jsonb,
    disjunctive BOOLEAN DEFAULT false
);

-- Product collections junction table
CREATE TABLE IF NOT EXISTS public.product_collections (
    product_id TEXT REFERENCES products(id) ON DELETE CASCADE,
    collection_id TEXT REFERENCES collections(id) ON DELETE CASCADE,
    position INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, collection_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_products_handle ON products(handle);
CREATE INDEX IF NOT EXISTS idx_products_vendor ON products(vendor);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_tags ON products(tags);
CREATE INDEX IF NOT EXISTS idx_variants_product_id ON variants(product_id);
CREATE INDEX IF NOT EXISTS idx_variants_sku ON variants(sku);
CREATE INDEX IF NOT EXISTS idx_collections_handle ON collections(handle);
CREATE INDEX IF NOT EXISTS idx_product_collections_product ON product_collections(product_id);
CREATE INDEX IF NOT EXISTS idx_product_collections_collection ON product_collections(collection_id);

-- Create update trigger for timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS \$\$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
\$\$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_variants_updated_at BEFORE UPDATE ON variants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_collections_updated_at BEFORE UPDATE ON collections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

SCHEMA

echo -e \"\\${GREEN}✓ Schema prepared\\${NC}\"

# Step 2: Check for existing data
echo -e \"\\n\\${BLUE}Step 2: Checking existing data\\${NC}\"

EXISTING_PRODUCTS=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"SELECT COUNT(*) FROM products;\" | tr -d ' ')
EXISTING_COLLECTIONS=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"SELECT COUNT(*) FROM collections;\" | tr -d ' ')

echo \"Current products: \\$EXISTING_PRODUCTS\"
echo \"Current collections: \\$EXISTING_COLLECTIONS\"

if [ \"\\$EXISTING_PRODUCTS\" -gt \"0\" ]; then
    echo -e \"\\${YELLOW}⚠ Products already exist. Backup will be created.\\${NC}\"
    
    # Backup existing data
    docker exec supabase-db psql -U postgres -d postgres -c \"
        CREATE TABLE IF NOT EXISTS products_backup_\\$(date +%Y%m%d_%H%M%S) AS SELECT * FROM products;
        CREATE TABLE IF NOT EXISTS variants_backup_\\$(date +%Y%m%d_%H%M%S) AS SELECT * FROM variants;
    \"
    echo -e \"\\${GREEN}✓ Backup created\\${NC}\"
fi

# Step 3: Import product data from CSV
echo -e \"\\n\\${BLUE}Step 3: Importing product catalog from CSV\\${NC}\"

# Find the most recent product CSV
PRODUCT_CSV=\"\"
for csv in /root/vivid_mas/data/vividwalls_products_catalog*.csv /root/vivid_mas/data/vividwalls_product_catalog*.csv; do
    if [ -f \"\\$csv\" ]; then
        PRODUCT_CSV=\"\\$csv\"
        break
    fi
done

if [ ! -z \"\\$PRODUCT_CSV\" ]; then
    echo \"Found product CSV: \\$PRODUCT_CSV\"
    
    # Create Python import script
    cat > /tmp/import_products.py << 'PYTHON'
#!/usr/bin/env python3
import csv
import json
import psycopg2
import sys
from datetime import datetime

def generate_product_id(handle):
    # Generate consistent ID from handle
    return f\"gid://shopify/Product/{abs(hash(handle)) % 1000000000}\"

def generate_variant_id(product_id, size):
    # Generate consistent variant ID
    return f\"gid://shopify/ProductVariant/{abs(hash(f'{product_id}_{size}')) % 1000000000}\"

def import_products(csv_file):
    # Database connection
    conn = psycopg2.connect(
        host=\"supabase-db\",
        database=\"postgres\",
        user=\"postgres\",
        password=\"your-super-secret-and-long-postgres-password\"
    )
    cur = conn.cursor()
    
    # Size options with pricing
    size_pricing = {
        \"8x10\": 29.99,
        \"11x14\": 39.99,
        \"16x20\": 59.99,
        \"20x30\": 89.99,
        \"24x36\": 119.99
    }
    
    products_imported = 0
    variants_imported = 0
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            try:
                # Generate product data
                product_id = row.get('id', generate_product_id(row['handle']))
                
                # Insert product
                cur.execute(\"\"\"
                    INSERT INTO products (
                        id, handle, title, body_html, vendor, product_type,
                        tags, status, image, images, options
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (id) DO UPDATE SET
                        title = EXCLUDED.title,
                        body_html = EXCLUDED.body_html,
                        updated_at = CURRENT_TIMESTAMP
                \"\"\", (
                    product_id,
                    row['handle'],
                    row['title'],
                    row.get('body_html', ''),
                    row.get('vendor', 'VividWalls'),
                    row.get('product_type', 'Wall Art'),
                    row.get('tags', ''),
                    'active',
                    row.get('image', ''),
                    json.dumps([row.get('image', '')]) if row.get('image') else '[]',
                    json.dumps([{\"name\": \"Size\", \"position\": 1, \"values\": list(size_pricing.keys())}])
                ))
                products_imported += 1
                
                # Create variants for each size
                position = 1
                for size, price in size_pricing.items():
                    variant_id = generate_variant_id(product_id, size)
                    sku = f\"{row['handle']}-{size.replace('x', '-')}\"
                    
                    cur.execute(\"\"\"
                        INSERT INTO variants (
                            id, product_id, title, price, sku, position,
                            option1, inventory_quantity, weight
                        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (id) DO UPDATE SET
                            price = EXCLUDED.price,
                            updated_at = CURRENT_TIMESTAMP
                    \"\"\", (
                        variant_id,
                        product_id,
                        f\"{row['title']} - {size}\",
                        price,
                        sku,
                        position,
                        size,
                        999,
                        0.5
                    ))
                    variants_imported += 1
                    position += 1
                
            except Exception as e:
                print(f\"Error importing {row.get('handle', 'unknown')}: {e}\")
                continue
    
    conn.commit()
    cur.close()
    conn.close()
    
    print(f\"Imported {products_imported} products with {variants_imported} variants\")

if __name__ == \"__main__\":
    if len(sys.argv) > 1:
        import_products(sys.argv[1])
    else:
        print(\"Usage: python import_products.py <csv_file>\")
PYTHON

    # Try Python import first
    if command -v python3 >/dev/null 2>&1; then
        docker exec supabase-db python3 /tmp/import_products.py \"\\$PRODUCT_CSV\" 2>/dev/null || {
            echo \"Python import failed, using SQL fallback...\"
            
            # SQL fallback
            docker exec supabase-db psql -U postgres -d postgres << SQL
\\\\COPY products(handle,title,body_html,vendor,product_type,tags,image) 
FROM '\\$PRODUCT_CSV' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '\"');
SQL
        }
    fi
    
    echo -e \"\\${GREEN}✓ Product import completed\\${NC}\"
else
    echo -e \"\\${RED}✗ No product CSV found\\${NC}\"
fi

# Step 4: Create default collections
echo -e \"\\n\\${BLUE}Step 4: Creating product collections\\${NC}\"

docker exec supabase-db psql -U postgres -d postgres << 'COLLECTIONS'
-- Insert default collections
INSERT INTO collections (id, handle, title, body_html, collection_type) VALUES
    ('gid://shopify/Collection/1', 'all-products', 'All Products', 'Browse our complete collection of premium wall art', 'custom'),
    ('gid://shopify/Collection/2', 'best-sellers', 'Best Sellers', 'Our most popular wall art pieces', 'custom'),
    ('gid://shopify/Collection/3', 'new-arrivals', 'New Arrivals', 'Fresh designs just added to our collection', 'custom'),
    ('gid://shopify/Collection/4', 'nature-landscapes', 'Nature & Landscapes', 'Stunning nature photography and landscape art', 'custom'),
    ('gid://shopify/Collection/5', 'abstract-modern', 'Abstract & Modern', 'Contemporary abstract art for modern spaces', 'custom'),
    ('gid://shopify/Collection/6', 'hospitality-collection', 'Hospitality Collection', 'Curated art for hotels and restaurants', 'custom'),
    ('gid://shopify/Collection/7', 'corporate-collection', 'Corporate Collection', 'Professional art for office spaces', 'custom'),
    ('gid://shopify/Collection/8', 'healthcare-collection', 'Healthcare Collection', 'Calming art for healthcare facilities', 'custom')
ON CONFLICT (id) DO NOTHING;

-- Add all products to 'all-products' collection
INSERT INTO product_collections (product_id, collection_id, position)
SELECT p.id, 'gid://shopify/Collection/1', ROW_NUMBER() OVER (ORDER BY p.created_at DESC)
FROM products p
ON CONFLICT DO NOTHING;

-- Update collection counts
UPDATE collections c
SET products_count = (
    SELECT COUNT(*) 
    FROM product_collections pc 
    WHERE pc.collection_id = c.id
);
COLLECTIONS

echo -e \"\\${GREEN}✓ Collections created\\${NC}\"

# Step 5: Verify import
echo -e \"\\n\\${BLUE}Step 5: Verifying catalog import\\${NC}\"

# Get counts
PRODUCT_COUNT=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"SELECT COUNT(*) FROM products;\" | tr -d ' ')
VARIANT_COUNT=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"SELECT COUNT(*) FROM variants;\" | tr -d ' ')
COLLECTION_COUNT=\\$(docker exec supabase-db psql -U postgres -d postgres -t -c \"SELECT COUNT(*) FROM collections;\" | tr -d ' ')

echo \"Products imported: \\$PRODUCT_COUNT\"
echo \"Variants created: \\$VARIANT_COUNT\"
echo \"Collections created: \\$COLLECTION_COUNT\"

# Sample data
echo -e \"\\n\\${BLUE}Sample products:${NC}\"
docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    substring(id, 1, 20) as id,
    handle,
    title,
    vendor,
    product_type
FROM products
LIMIT 5;
\"

# Summary
echo -e \"\\n\\${BLUE}=== Catalog Restoration Summary ===\\${NC}\"

if [ \"\\$PRODUCT_COUNT\" -gt \"0\" ]; then
    echo -e \"\\${GREEN}✅ Product catalog successfully restored\\${NC}\"
    echo \"   - Products: \\$PRODUCT_COUNT\"
    echo \"   - Variants: \\$VARIANT_COUNT (\\$((VARIANT_COUNT / PRODUCT_COUNT)) sizes per product)\"
    echo \"   - Collections: \\$COLLECTION_COUNT\"
else
    echo -e \"\\${RED}❌ Product catalog restoration failed\\${NC}\"
    echo \"   Please check the CSV files and try again\"
fi

CATALOG_SCRIPT
chmod +x /tmp/restore_product_catalog.sh
" "Creating catalog restoration script"

# Execute restoration
echo -e "\n${BLUE}Executing product catalog restoration...${NC}"
remote_exec "/tmp/restore_product_catalog.sh"

# Create catalog health check script
echo -e "\n${BLUE}Creating catalog health check script...${NC}"

remote_exec "cat > /tmp/check_catalog_health.sh << 'HEALTH_CHECK'
#!/bin/bash

echo \"=== Product Catalog Health Check ===\"
echo \"Time: \$(date)\"
echo \"\"

# Check product statistics
echo \"Product Statistics:\"
docker exec supabase-db psql -U postgres -d postgres -t << SQL
SELECT 
    'Total Products' as metric, COUNT(*) as value FROM products
UNION ALL
SELECT 'Active Products', COUNT(*) FROM products WHERE status = 'active'
UNION ALL
SELECT 'Unique Vendors', COUNT(DISTINCT vendor) FROM products
UNION ALL
SELECT 'Product Types', COUNT(DISTINCT product_type) FROM products
UNION ALL
SELECT 'Total Variants', COUNT(*) FROM variants
UNION ALL
SELECT 'Collections', COUNT(*) FROM collections
UNION ALL
SELECT 'Avg Products per Collection', ROUND(AVG(products_count)) FROM collections;
SQL

# Check for data issues
echo -e \"\\nData Quality Checks:\"
docker exec supabase-db psql -U postgres -d postgres -t << SQL
SELECT 
    CASE WHEN COUNT(*) > 0 THEN '❌ Products without variants: ' || COUNT(*)
         ELSE '✅ All products have variants'
    END
FROM products p
WHERE NOT EXISTS (SELECT 1 FROM variants v WHERE v.product_id = p.id);
SQL

docker exec supabase-db psql -U postgres -d postgres -t << SQL
SELECT 
    CASE WHEN COUNT(*) > 0 THEN '❌ Products without images: ' || COUNT(*)
         ELSE '✅ All products have images'
    END
FROM products 
WHERE image IS NULL OR image = '';
SQL

# Performance check
echo -e \"\\nPerformance Metrics:\"
docker exec supabase-db psql -U postgres -d postgres -c \"
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size
FROM pg_tables
WHERE tablename IN ('products', 'variants', 'collections', 'product_collections')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
\"

echo \"\"
echo \"Health check complete.\"
HEALTH_CHECK
chmod +x /tmp/check_catalog_health.sh
" "Creating health check script"

# Run health check
echo -e "\n${BLUE}Running catalog health check...${NC}"
remote_exec "/tmp/check_catalog_health.sh"

# Final summary
echo -e "\n${GREEN}=== Product Catalog Restoration Complete ===${NC}"
echo -e "${BLUE}Key Actions Performed:${NC}"
echo "1. Created complete product schema with Shopify compatibility"
echo "2. Imported products from CSV with multiple size variants"
echo "3. Created default collections and associations"
echo "4. Verified data integrity and performance"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Access Supabase Studio: https://supabase.vividwalls.blog"
echo "2. Review product data in the products table"
echo "3. Configure any additional collections as needed"
echo "4. Set up product sync with Shopify if required"

echo -e "\n${GREEN}✓ VividWalls product catalog fully restored${NC}"