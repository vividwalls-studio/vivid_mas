#!/usr/bin/env python3
"""Import VividWalls product data from CSV to Supabase database."""

import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
import uuid
import re
from datetime import datetime
import sys

# Database connection parameters
DB_CONFIG = {
    'host': '157.230.13.13',
    'port': 5434,  # Supabase DB port
    'database': 'vividwalls',
    'user': 'postgres',
    'password': 'myqP9lSMLobnuIfkUpXQzZg07'  # From .env file
}

def create_slug(name):
    """Create URL-friendly slug from name."""
    return re.sub(r'[^a-z0-9-]', '', name.lower().replace(' ', '-'))

def import_products_from_csv(csv_path):
    """Import product data from CSV file."""
    print(f"Reading CSV file: {csv_path}")
    df = pd.read_csv(csv_path)
    
    # Clean column names
    df.columns = df.columns.str.strip()
    
    print(f"Found {len(df)} products in CSV")
    print(f"Columns: {list(df.columns)}")
    
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    try:
        # First, create collections from unique collection names
        if 'Collection' in df.columns:
            collections = df['Collection'].dropna().unique()
            print(f"\nCreating {len(collections)} collections...")
            
            for collection in collections:
                collection_id = str(uuid.uuid4())
                cur.execute("""
                    INSERT INTO collections (id, name, slug, description)
                    VALUES (%s, %s, %s, %s)
                    ON CONFLICT (name) DO UPDATE
                    SET updated_at = NOW()
                    RETURNING id
                """, (collection_id, collection, create_slug(collection), f"The {collection} collection"))
                conn.commit()
        
        # Create print types and sizes if they don't exist
        print("\nCreating standard sizes and print types...")
        
        # Standard sizes
        sizes = [
            ('8x10', 8, 10),
            ('11x14', 11, 14),
            ('16x20', 16, 20),
            ('20x24', 20, 24),
            ('24x30', 24, 30),
            ('24x36', 24, 36),
            ('30x40', 30, 40),
            ('36x48', 36, 48),
            ('40x60', 40, 60),
            ('48x72', 48, 72)
        ]
        
        for size_name, width, height in sizes:
            cur.execute("""
                INSERT INTO sizes (name, width_inches, height_inches)
                VALUES (%s, %s, %s)
                ON CONFLICT (name) DO NOTHING
            """, (size_name, width, height))
        
        # Print types
        print_types = [
            ('Canvas', 'Gallery-wrapped canvas print'),
            ('Limited Edition Canvas', 'Signed and numbered limited edition canvas')
        ]
        
        for print_name, print_desc in print_types:
            cur.execute("""
                INSERT INTO print_types (name, description)
                VALUES (%s, %s)
                ON CONFLICT (name) DO NOTHING
            """, (print_name, print_desc))
        
        conn.commit()
        
        # Now insert products
        print(f"\nInserting {len(df)} products...")
        
        for index, row in df.iterrows():
            try:
                # Get collection ID if exists
                collection_id = None
                if 'Collection' in row and pd.notna(row['Collection']):
                    cur.execute("SELECT id FROM collections WHERE name = %s", (row['Collection'],))
                    result = cur.fetchone()
                    if result:
                        collection_id = result[0]
                
                # Create product
                product_id = str(uuid.uuid4())
                handle = row.get('Handle', '').strip()
                title = row.get('Title', '').strip()
                
                if not handle or not title:
                    print(f"Skipping row {index}: missing handle or title")
                    continue
                
                cur.execute("""
                    INSERT INTO products (
                        id, handle, title, description, collection_id,
                        vendor, product_type, status, tags
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (handle) DO UPDATE
                    SET title = EXCLUDED.title,
                        updated_at = NOW()
                    RETURNING id
                """, (
                    product_id,
                    handle,
                    title,
                    row.get('Body (HTML)', ''),
                    collection_id,
                    row.get('Vendor', 'VividWalls'),
                    row.get('Type', 'Wall Art'),
                    'active',
                    row.get('Tags', '').split(',') if pd.notna(row.get('Tags')) else []
                ))
                
                # Get the product ID (either new or existing)
                result = cur.fetchone()
                if result:
                    product_id = result[0]
                
                # Add product image if available
                if 'Image Src' in row and pd.notna(row['Image Src']):
                    cur.execute("""
                        INSERT INTO product_images (product_id, src, alt_text, is_primary)
                        VALUES (%s, %s, %s, %s)
                        ON CONFLICT DO NOTHING
                    """, (product_id, row['Image Src'], row.get('Image Alt Text', title), True))
                
                # Create variants if we have variant data
                if 'Variant SKU' in row and pd.notna(row['Variant SKU']):
                    # Get size and print type IDs
                    variant_title = row.get('Option1 Value', '')
                    
                    # Parse size from variant title (e.g., "24x36")
                    size_match = re.search(r'(\d+)x(\d+)', variant_title)
                    if size_match:
                        size_name = size_match.group(0)
                        cur.execute("SELECT id FROM sizes WHERE name = %s", (size_name,))
                        size_result = cur.fetchone()
                        
                        # Determine print type
                        print_type_name = 'Limited Edition Canvas' if 'Limited Edition' in variant_title else 'Canvas'
                        cur.execute("SELECT id FROM print_types WHERE name = %s", (print_type_name,))
                        print_result = cur.fetchone()
                        
                        if size_result and print_result:
                            cur.execute("""
                                INSERT INTO product_variants (
                                    product_id, size_id, print_type_id, sku,
                                    price, compare_at_price, weight_grams
                                ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                                ON CONFLICT (sku) DO UPDATE
                                SET price = EXCLUDED.price,
                                    updated_at = NOW()
                            """, (
                                product_id,
                                size_result[0],
                                print_result[0],
                                row['Variant SKU'],
                                float(row.get('Variant Price', 0)) if pd.notna(row.get('Variant Price')) else 0,
                                float(row.get('Variant Compare At Price', 0)) if pd.notna(row.get('Variant Compare At Price')) else None,
                                int(row.get('Variant Grams', 0)) if pd.notna(row.get('Variant Grams')) else 0
                            ))
                
                if index % 10 == 0:
                    conn.commit()
                    print(f"Processed {index + 1} products...")
                    
            except Exception as e:
                print(f"Error processing row {index}: {e}")
                conn.rollback()
                continue
        
        conn.commit()
        print(f"\nSuccessfully imported products!")
        
    except Exception as e:
        print(f"Error: {e}")
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    # Import the main product catalog
    csv_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/data/exports/vividwalls_products_catalog-06-18-25_updated.csv"
    import_products_from_csv(csv_file)