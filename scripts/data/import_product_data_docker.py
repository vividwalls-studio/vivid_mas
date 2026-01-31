#!/usr/bin/env python3
"""Import VividWalls product data from CSV using docker exec."""

import pandas as pd
import subprocess
import re
import json

def create_slug(name):
    """Create URL-friendly slug from name."""
    return re.sub(r'[^a-z0-9-]', '', name.lower().replace(' ', '-'))

def execute_sql(sql):
    """Execute SQL via docker exec."""
    cmd = [
        'docker', 'exec', '-i', 'supabase-db',
        'psql', '-U', 'postgres', '-d', 'vividwalls', '-c', sql
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
    return result

def import_products_from_csv(csv_path):
    """Import product data from CSV file."""
    print(f"Reading CSV file: {csv_path}")
    df = pd.read_csv(csv_path)
    
    # Clean column names
    df.columns = df.columns.str.strip()
    
    print(f"Found {len(df)} products in CSV")
    print(f"Columns: {list(df.columns)[:10]}...")  # Show first 10 columns
    
    # First, create collections from unique collection names
    if 'Collection' in df.columns:
        collections = df['Collection'].dropna().unique()
        print(f"\nCreating {len(collections)} collections...")
        
        for collection in collections:
            sql = f"""
                INSERT INTO collections (name, slug, description)
                VALUES ('{collection}', '{create_slug(collection)}', 'The {collection} collection')
                ON CONFLICT (name) DO NOTHING;
            """
            execute_sql(sql)
    
    # Create standard sizes
    print("\nCreating standard sizes...")
    sizes = [
        ('8x10', 8, 10), ('11x14', 11, 14), ('16x20', 16, 20),
        ('20x24', 20, 24), ('24x30', 24, 30), ('24x36', 24, 36),
        ('30x40', 30, 40), ('36x48', 36, 48), ('40x60', 40, 60),
        ('48x72', 48, 72)
    ]
    
    for size_name, width, height in sizes:
        sql = f"""
            INSERT INTO sizes (name, width_inches, height_inches)
            VALUES ('{size_name}', {width}, {height})
            ON CONFLICT (name) DO NOTHING;
        """
        execute_sql(sql)
    
    # Create print types
    print("\nCreating print types...")
    print_types = [
        ('Canvas', 'Gallery-wrapped canvas print'),
        ('Limited Edition Canvas', 'Signed and numbered limited edition canvas')
    ]
    
    for print_name, print_desc in print_types:
        sql = f"""
            INSERT INTO print_types (name, description)
            VALUES ('{print_name}', '{print_desc}')
            ON CONFLICT (name) DO NOTHING;
        """
        execute_sql(sql)
    
    # Process products
    print(f"\nProcessing {len(df)} products...")
    
    # Group by product handle to consolidate variants
    product_groups = df.groupby('Handle')
    
    for handle, group in product_groups:
        try:
            # Get first row for product-level data
            first_row = group.iloc[0]
            
            title = first_row.get('Title', '').strip()
            if not handle or not title:
                continue
            
            # Escape quotes in text fields
            title = title.replace("'", "''")
            description = str(first_row.get('Body (HTML)', '')).replace("'", "''")
            
            # Get collection
            collection_name = first_row.get('Collection', '')
            collection_clause = "NULL"
            if collection_name:
                collection_clause = f"(SELECT id FROM collections WHERE name = '{collection_name}')"
            
            # Insert product
            sql = f"""
                INSERT INTO products (handle, title, description, collection_id, vendor, product_type, status)
                VALUES ('{handle}', '{title}', '{description}', {collection_clause}, 
                        '{first_row.get('Vendor', 'VividWalls')}', '{first_row.get('Type', 'Wall Art')}', 'active')
                ON CONFLICT (handle) DO UPDATE
                SET title = EXCLUDED.title,
                    description = EXCLUDED.description,
                    updated_at = NOW();
            """
            execute_sql(sql)
            
            # Add product image
            if 'Image Src' in first_row and pd.notna(first_row['Image Src']):
                img_src = str(first_row['Image Src']).replace("'", "''")
                sql = f"""
                    INSERT INTO product_images (product_id, src, alt_text, is_primary)
                    SELECT id, '{img_src}', '{title}', true
                    FROM products WHERE handle = '{handle}'
                    ON CONFLICT DO NOTHING;
                """
                execute_sql(sql)
            
            # Process variants
            for _, row in group.iterrows():
                if pd.notna(row.get('Variant SKU')):
                    sku = str(row['Variant SKU'])
                    variant_title = str(row.get('Option1 Value', ''))
                    price = float(row.get('Variant Price', 0)) if pd.notna(row.get('Variant Price')) else 0
                    
                    # Parse size
                    size_match = re.search(r'(\d+)x(\d+)', variant_title)
                    if size_match:
                        size_name = size_match.group(0)
                        print_type = 'Limited Edition Canvas' if 'Limited Edition' in variant_title else 'Canvas'
                        
                        sql = f"""
                            INSERT INTO product_variants (product_id, size_id, print_type_id, sku, price)
                            SELECT p.id, s.id, pt.id, '{sku}', {price}
                            FROM products p, sizes s, print_types pt
                            WHERE p.handle = '{handle}'
                            AND s.name = '{size_name}'
                            AND pt.name = '{print_type}'
                            ON CONFLICT (sku) DO UPDATE
                            SET price = EXCLUDED.price,
                                updated_at = NOW();
                        """
                        execute_sql(sql)
            
        except Exception as e:
            print(f"Error processing {handle}: {e}")
            continue
    
    print("\nImport complete!")

if __name__ == "__main__":
    # Run on droplet
    csv_file = "/root/vivid_mas/data/vividwalls_products_catalog-06-18-25_updated.csv"
    import_products_from_csv(csv_file)