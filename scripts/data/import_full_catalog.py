#!/usr/bin/env python3
"""Import full VividWalls product catalog and inventory data."""

import csv
import subprocess
import re
import json
from datetime import datetime

def execute_sql(sql):
    """Execute SQL via docker exec."""
    cmd = [
        'ssh', '-i', '~/.ssh/digitalocean', 'root@157.230.13.13',
        f"docker exec -i supabase-db psql -U postgres -d vividwalls -c \"{sql}\""
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, shell=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
    return result

def escape_sql(text):
    """Escape single quotes for SQL."""
    if text is None:
        return ''
    return str(text).replace("'", "''")

def create_slug(name):
    """Create URL-friendly slug from name."""
    return re.sub(r'[^a-z0-9-]', '', name.lower().replace(' ', '-'))

def import_products_catalog(catalog_path):
    """Import products from CSV catalog."""
    print(f"Reading catalog: {catalog_path}")
    
    # First, clear existing data
    print("Clearing existing product data...")
    execute_sql("DELETE FROM inventory_movements;")
    execute_sql("DELETE FROM inventory_levels;")
    execute_sql("DELETE FROM product_images;")
    execute_sql("DELETE FROM product_variants;")
    execute_sql("DELETE FROM products;")
    
    products = {}
    variants = []
    
    with open(catalog_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            handle = row.get('Handle', '').strip()
            title = row.get('Title', '').strip()
            
            if handle and title:
                # New product
                if handle not in products:
                    products[handle] = {
                        'title': title,
                        'description': row.get('Body (HTML)', ''),
                        'vendor': row.get('Vendor', 'VividWalls'),
                        'type': row.get('Type', 'Wall Art'),
                        'tags': row.get('Tags', ''),
                        'collection': row.get('Product Category', ''),
                        'image_src': row.get('Image Src', ''),
                        'image_alt': row.get('Image Alt Text', ''),
                        'variants': []
                    }
                
                # Add variant if it has SKU
                if row.get('Variant SKU'):
                    variant = {
                        'sku': row['Variant SKU'],
                        'option1': row.get('Option1 Value', ''),
                        'price': float(row.get('Variant Price', 0) or 0),
                        'compare_price': float(row.get('Variant Compare At Price', 0) or 0) if row.get('Variant Compare At Price') else None,
                        'weight': int(row.get('Variant Grams', 0) or 0),
                        'inventory_qty': int(row.get('Variant Inventory Qty', 0) or 0),
                        'barcode': row.get('Variant Barcode', '')
                    }
                    products[handle]['variants'].append(variant)
    
    print(f"Found {len(products)} unique products")
    
    # Create collections from unique values
    collections = set()
    for p in products.values():
        if p['collection']:
            collections.add(p['collection'])
    
    print(f"Creating {len(collections)} collections...")
    for collection in collections:
        sql = f"""
            INSERT INTO collections (name, slug, description)
            VALUES ('{escape_sql(collection)}', '{create_slug(collection)}', 'The {escape_sql(collection)} collection')
            ON CONFLICT (name) DO NOTHING;
        """
        execute_sql(sql)
    
    # Insert products
    print("Inserting products...")
    for handle, product in products.items():
        collection_clause = "NULL"
        if product['collection']:
            collection_clause = f"(SELECT id FROM collections WHERE name = '{escape_sql(product['collection'])}')"
        
        sql = f"""
            INSERT INTO products (handle, title, description, collection_id, vendor, product_type, status, tags)
            VALUES (
                '{escape_sql(handle)}',
                '{escape_sql(product['title'])}',
                '{escape_sql(product['description'])}',
                {collection_clause},
                '{escape_sql(product['vendor'])}',
                '{escape_sql(product['type'])}',
                'active',
                ARRAY[{','.join([f"'{escape_sql(tag.strip())}'" for tag in product['tags'].split(',') if tag.strip()])}]
            )
            ON CONFLICT (handle) DO UPDATE
            SET title = EXCLUDED.title,
                description = EXCLUDED.description,
                collection_id = EXCLUDED.collection_id,
                updated_at = NOW();
        """
        execute_sql(sql)
        
        # Add image
        if product['image_src']:
            sql = f"""
                INSERT INTO product_images (product_id, src, alt_text, is_primary, position)
                SELECT id, '{escape_sql(product['image_src'])}', '{escape_sql(product['image_alt'] or product['title'])}', true, 0
                FROM products WHERE handle = '{escape_sql(handle)}'
                ON CONFLICT DO NOTHING;
            """
            execute_sql(sql)
        
        # Add variants
        for variant in product['variants']:
            # Parse size from option1 (e.g., "24x36" or "24x36 Limited Edition Canvas")
            size_match = re.search(r'(\d+)x(\d+)', variant['option1'])
            if size_match:
                size_name = size_match.group(0)
                print_type = 'Limited Edition Canvas' if 'Limited Edition' in variant['option1'] else 'Canvas'
                
                sql = f"""
                    INSERT INTO product_variants (product_id, size_id, print_type_id, sku, price, compare_at_price, weight_grams, barcode)
                    SELECT 
                        p.id,
                        s.id,
                        pt.id,
                        '{escape_sql(variant['sku'])}',
                        {variant['price']},
                        {variant['compare_price'] if variant['compare_price'] else 'NULL'},
                        {variant['weight']},
                        {f"'{escape_sql(variant['barcode'])}'" if variant['barcode'] else 'NULL'}
                    FROM products p, sizes s, print_types pt
                    WHERE p.handle = '{escape_sql(handle)}'
                    AND s.name = '{size_name}'
                    AND pt.name = '{print_type}'
                    ON CONFLICT (sku) DO UPDATE
                    SET price = EXCLUDED.price,
                        compare_at_price = EXCLUDED.compare_at_price,
                        updated_at = NOW();
                """
                execute_sql(sql)
    
    print("Product catalog import complete!")
    return products

def import_inventory_data(inventory_path, products):
    """Import inventory levels from CSV."""
    print(f"\nReading inventory data: {inventory_path}")
    
    with open(inventory_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        inventory_count = 0
        
        for row in reader:
            sku = row.get('SKU', '').strip()
            qty = int(row.get('Available', 0) or 0)
            location = row.get('Location', 'AVE-F').strip()
            
            if sku and qty > 0:
                # Determine location code
                location_code = 'AVE-F' if 'Avenue' in location else 'PRINTFUL'
                
                sql = f"""
                    INSERT INTO inventory_levels (variant_id, location_id, available, on_hand)
                    SELECT 
                        pv.id,
                        l.id,
                        {qty},
                        {qty}
                    FROM product_variants pv, locations l
                    WHERE pv.sku = '{escape_sql(sku)}'
                    AND l.code = '{location_code}'
                    ON CONFLICT (variant_id, location_id) DO UPDATE
                    SET available = EXCLUDED.available,
                        on_hand = EXCLUDED.on_hand,
                        updated_at = NOW();
                """
                result = execute_sql(sql)
                inventory_count += 1
    
    print(f"Updated inventory for {inventory_count} SKUs")

def verify_import():
    """Verify the import results."""
    print("\nVerifying import...")
    
    # Check counts
    result = execute_sql("""
        SELECT 
            (SELECT COUNT(*) FROM products) as products,
            (SELECT COUNT(*) FROM product_variants) as variants,
            (SELECT COUNT(*) FROM collections) as collections,
            (SELECT COUNT(*) FROM inventory_levels WHERE available > 0) as inventory_records;
    """)
    
    print("\nImport complete! Run verification queries on the server to confirm.")

if __name__ == "__main__":
    # Import product catalog
    catalog_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/exports/vividwalls_product_catalog-07-06-25.csv"
    inventory_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/exports/inventory_export_canvas_limited_edition.csv"
    
    products = import_products_catalog(catalog_file)
    import_inventory_data(inventory_file, products)
    verify_import()