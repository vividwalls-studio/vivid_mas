#!/bin/bash

echo "=== Importing Full VividWalls Product Catalog ==="

# First, copy the CSV files to the server
echo "Copying CSV files to server..."
scp -i ~/.ssh/digitalocean /Volumes/SeagatePortableDrive/Projects/vivid_mas/data/exports/vividwalls_product_catalog-07-06-25.csv root@157.230.13.13:/tmp/
scp -i ~/.ssh/digitalocean /Volumes/SeagatePortableDrive/Projects/vivid_mas/data/exports/inventory_export_canvas_limited_edition.csv root@157.230.13.13:/tmp/

# Create import script on server
ssh -i ~/.ssh/digitalocean root@157.230.13.13 << 'REMOTE_SCRIPT'

# Clear existing data
echo "Clearing existing product data..."
docker exec -i supabase-db psql -U postgres -d vividwalls << 'SQL'
BEGIN;
DELETE FROM inventory_movements;
DELETE FROM inventory_levels;
DELETE FROM product_images;
DELETE FROM product_variants;
DELETE FROM products;
COMMIT;
SQL

# Create temporary import script
cat > /tmp/import_products.sql << 'IMPORT_SQL'
BEGIN;

-- Process CSV data to extract unique collections
CREATE TEMP TABLE temp_products AS
SELECT DISTINCT 
    handle,
    title,
    body_html,
    vendor,
    product_category,
    type,
    tags,
    image_src,
    image_alt_text
FROM (
    SELECT 
        split_part(line, ',', 1) as handle,
        split_part(line, ',', 2) as title,
        split_part(line, ',', 3) as body_html,
        split_part(line, ',', 4) as vendor,
        split_part(line, ',', 5) as product_category,
        split_part(line, ',', 6) as type,
        split_part(line, ',', 7) as tags,
        split_part(line, ',', 22) as image_src,
        split_part(line, ',', 23) as image_alt_text
    FROM (
        SELECT unnest(string_to_array(pg_read_file('/tmp/vividwalls_product_catalog-07-06-25.csv'), E'\n')) as line
    ) t
    WHERE line NOT LIKE 'Handle,%'
    AND split_part(line, ',', 1) != ''
    AND split_part(line, ',', 2) != ''
) raw_data;

-- Insert collections
INSERT INTO collections (name, slug, description)
SELECT DISTINCT 
    product_category,
    lower(replace(product_category, ' ', '-')),
    'The ' || product_category || ' collection'
FROM temp_products
WHERE product_category != ''
ON CONFLICT (name) DO NOTHING;

-- Insert products
INSERT INTO products (handle, title, description, collection_id, vendor, product_type, status)
SELECT 
    handle,
    title,
    body_html,
    (SELECT id FROM collections WHERE name = product_category),
    COALESCE(vendor, 'VividWalls'),
    COALESCE(type, 'Wall Art'),
    'active'
FROM temp_products
ON CONFLICT (handle) DO UPDATE
SET title = EXCLUDED.title,
    description = EXCLUDED.description,
    updated_at = NOW();

-- Clean up
DROP TABLE temp_products;

COMMIT;
IMPORT_SQL

# Import products
echo "Importing products..."
docker exec -i supabase-db psql -U postgres -d vividwalls < /tmp/import_products.sql

# Import product variants and inventory
echo "Creating product variants..."
docker exec -i supabase-db psql -U postgres -d vividwalls << 'VARIANTS_SQL'
BEGIN;

-- Create all size/print type combinations for each product
INSERT INTO product_variants (product_id, size_id, print_type_id, sku, price)
SELECT 
    p.id,
    s.id,
    pt.id,
    p.handle || '-' || s.name || '-' || LOWER(REPLACE(pt.name, ' ', '-')),
    CASE 
        WHEN s.name IN ('8x10', '11x14') THEN 149
        WHEN s.name IN ('16x20', '20x24') THEN 299
        WHEN s.name IN ('24x30', '24x36') THEN 499
        WHEN s.name IN ('30x40', '36x48') THEN 799
        WHEN s.name IN ('40x60', '48x72') THEN 1299
        ELSE 399
    END * CASE WHEN pt.name = 'Limited Edition Canvas' THEN 1.5 ELSE 1 END
FROM products p
CROSS JOIN sizes s
CROSS JOIN print_types pt
WHERE pt.name IN ('Canvas', 'Limited Edition Canvas')
ON CONFLICT (product_id, size_id, print_type_id) DO UPDATE
SET price = EXCLUDED.price;

-- Set initial inventory levels
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand)
SELECT 
    pv.id,
    l.id,
    CASE 
        WHEN l.code = 'PRINTFUL' THEN 9999
        ELSE 100
    END,
    CASE 
        WHEN l.code = 'PRINTFUL' THEN 0
        ELSE 100
    END
FROM product_variants pv
CROSS JOIN locations l
ON CONFLICT (variant_id, location_id) DO UPDATE
SET available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand;

COMMIT;
VARIANTS_SQL

# Verify import
echo -e "\n=== Import Results ==="
docker exec -i supabase-db psql -U postgres -d vividwalls << 'VERIFY_SQL'
SELECT 
    'Products' as entity,
    COUNT(*) as count
FROM products
UNION ALL
SELECT 
    'Collections',
    COUNT(*)
FROM collections
UNION ALL
SELECT 
    'Product Variants',
    COUNT(*)
FROM product_variants
UNION ALL
SELECT 
    'Inventory Records',
    COUNT(*)
FROM inventory_levels
WHERE available > 0;
VERIFY_SQL

echo -e "\nImport complete!"
REMOTE_SCRIPT