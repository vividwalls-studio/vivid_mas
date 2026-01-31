#!/bin/bash

# Final Product Import Script
# Imports VividWalls products from CSV into Supabase

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"
CSV_FILE="/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/exports/vividwalls_products_catalog-06-18-25_updated.csv"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== VividWalls Final Product Import ===${NC}"
echo -e "${YELLOW}Importing 366 products from CSV${NC}"
echo -e "${BLUE}Time: $(date)${NC}\n"

# Function to execute remote command
remote_exec() {
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$@"
}

# Copy CSV to droplet
echo -e "${BLUE}Copying CSV to droplet...${NC}"
scp -i "$SSH_KEY" "$CSV_FILE" "$REMOTE_USER@$DROPLET_IP:/tmp/products_final.csv"

# Create import script on droplet
echo -e "${BLUE}Creating import script...${NC}"

remote_exec "cat > /tmp/import_final_products.sh << 'IMPORT_SCRIPT'
#!/bin/bash

# Copy CSV into container
docker cp /tmp/products_final.csv supabase-db:/tmp/

# Create temporary table for CSV import
docker exec supabase-db psql -U postgres -d vividwalls << 'SQL'
-- Create temporary table matching CSV structure
CREATE TEMP TABLE products_import (
    handle TEXT,
    title TEXT,
    body_html TEXT,
    vendor TEXT,
    product_category TEXT,
    product_type TEXT,
    tags TEXT,
    published TEXT,
    option1_name TEXT,
    option1_value TEXT,
    option1_linked_to TEXT,
    option2_name TEXT,
    option2_value TEXT,
    option2_linked_to TEXT,
    option3_name TEXT,
    option3_value TEXT,
    option3_linked_to TEXT,
    variant_sku TEXT,
    variant_grams TEXT,
    variant_inventory_tracker TEXT,
    variant_inventory_policy TEXT,
    variant_fulfillment_service TEXT,
    variant_price TEXT,
    variant_compare_at_price TEXT,
    variant_requires_shipping TEXT,
    variant_taxable TEXT,
    variant_barcode TEXT,
    image_src TEXT,
    image_position TEXT,
    image_alt_text TEXT,
    gift_card TEXT,
    seo_title TEXT,
    seo_description TEXT,
    google_shopping_category TEXT,
    google_shopping_gender TEXT,
    google_shopping_age_group TEXT,
    google_shopping_mpn TEXT,
    google_shopping_condition TEXT,
    google_shopping_custom_product TEXT,
    google_shopping_custom_label_0 TEXT,
    google_shopping_custom_label_1 TEXT,
    google_shopping_custom_label_2 TEXT,
    google_shopping_custom_label_3 TEXT,
    google_shopping_custom_label_4 TEXT,
    google_custom_product TEXT,
    color TEXT,
    frame_style TEXT,
    theme TEXT,
    variant_image TEXT,
    variant_weight_unit TEXT,
    variant_tax_code TEXT,
    cost_per_item TEXT,
    status TEXT
);

-- Import CSV
\\COPY products_import FROM '/tmp/products_final.csv' WITH CSV HEADER;

-- Insert unique products
INSERT INTO products (handle, title, body_html, vendor, product_type, tags, status, image)
SELECT DISTINCT ON (handle)
    handle,
    title,
    body_html,
    COALESCE(vendor, 'VividWalls'),
    COALESCE(product_type, 'Artwork'),
    tags,
    COALESCE(status, 'active'),
    image_src
FROM products_import
WHERE handle IS NOT NULL
ON CONFLICT (handle) DO UPDATE SET
    title = EXCLUDED.title,
    body_html = EXCLUDED.body_html,
    tags = EXCLUDED.tags,
    image = EXCLUDED.image,
    updated_at = CURRENT_TIMESTAMP;

-- Count results
SELECT COUNT(*) as imported_products FROM products;
SQL

echo \"Product import complete!\"
IMPORT_SCRIPT
chmod +x /tmp/import_final_products.sh
" "Creating import script"

# Execute import
echo -e "\n${BLUE}Executing product import...${NC}"
remote_exec "/tmp/import_final_products.sh"

# Verify import
echo -e "\n${BLUE}Verifying import...${NC}"
PRODUCT_COUNT=$(remote_exec "docker exec supabase-db psql -U postgres -d vividwalls -t -c 'SELECT COUNT(*) FROM products;' | tr -d ' '")

echo -e "${GREEN}✓ Successfully imported $PRODUCT_COUNT products${NC}"

# Show sample products
echo -e "\n${BLUE}Sample products:${NC}"
remote_exec "docker exec supabase-db psql -U postgres -d vividwalls -c 'SELECT handle, title, vendor FROM products LIMIT 5;'"

echo -e "\n${GREEN}✓ Product import complete!${NC}"