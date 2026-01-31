#!/bin/bash

# Import VividWalls Product Data
# This script imports the 366 products from CSV into the system

set -e

echo "📦 Importing VividWalls Product Data..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# SSH connection details
SSH_KEY="~/.ssh/digitalocean"
DROPLET_IP="157.230.13.13"
SSH_USER="root"

# Function to execute commands on remote droplet
remote_exec() {
    ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "$1"
}

echo -e "${BLUE}Step 1: Checking for product data files${NC}"
if [ -f "data/exports/vividwalls_products_catalog-06-18-25_updated.csv" ]; then
    echo -e "${GREEN}✅ Found product catalog CSV file${NC}"
    PRODUCT_FILE="data/exports/vividwalls_products_catalog-06-18-25_updated.csv"
elif [ -f "data/vividwalls_products.csv" ]; then
    echo -e "${GREEN}✅ Found alternative product CSV file${NC}"
    PRODUCT_FILE="data/vividwalls_products.csv"
else
    echo -e "${RED}❌ Product CSV file not found${NC}"
    echo "Looking for CSV files in data directory..."
    find data/ -name "*.csv" -type f | head -10
    exit 1
fi

echo -e "${BLUE}Step 2: Copying product data to droplet${NC}"
scp -i ~/.ssh/digitalocean "$PRODUCT_FILE" root@157.230.13.13:/tmp/vividwalls_products.csv

echo -e "${BLUE}Step 3: Creating product import script on droplet${NC}"
remote_exec "cat > /tmp/import_products.py << 'EOF'
#!/usr/bin/env python3
import pandas as pd
import psycopg2
import sys
import uuid
from datetime import datetime

def import_products():
    try:
        # Database connection
        conn = psycopg2.connect(
            host='postgres',
            database='postgres',
            user='postgres',
            password='postgres',
            port=5432
        )
        cur = conn.cursor()
        
        print('Connected to database successfully')
        
        # Read CSV file
        df = pd.read_csv('/tmp/vividwalls_products.csv')
        print(f'Found {len(df)} products in CSV')
        
        # Create collections table if not exists
        cur.execute('''
            CREATE TABLE IF NOT EXISTS collections (
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                handle VARCHAR(255) UNIQUE NOT NULL,
                title VARCHAR(255) NOT NULL,
                description TEXT,
                created_at TIMESTAMP DEFAULT NOW(),
                updated_at TIMESTAMP DEFAULT NOW()
            )
        ''')
        
        # Create products table if not exists
        cur.execute('''
            CREATE TABLE IF NOT EXISTS products (
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                handle VARCHAR(255) UNIQUE NOT NULL,
                title VARCHAR(255) NOT NULL,
                description TEXT,
                collection_id UUID REFERENCES collections(id),
                vendor VARCHAR(255),
                product_type VARCHAR(255),
                status VARCHAR(50) DEFAULT 'active',
                tags TEXT[],
                created_at TIMESTAMP DEFAULT NOW(),
                updated_at TIMESTAMP DEFAULT NOW()
            )
        ''')
        
        # Create product_images table if not exists
        cur.execute('''
            CREATE TABLE IF NOT EXISTS product_images (
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                product_id UUID REFERENCES products(id) ON DELETE CASCADE,
                src TEXT NOT NULL,
                alt_text VARCHAR(255),
                is_primary BOOLEAN DEFAULT FALSE,
                created_at TIMESTAMP DEFAULT NOW()
            )
        ''')
        
        conn.commit()
        print('Database tables created/verified')
        
        # Create default collection
        cur.execute('''
            INSERT INTO collections (handle, title, description)
            VALUES ('wall-art', 'Wall Art', 'Premium wall art collection')
            ON CONFLICT (handle) DO NOTHING
            RETURNING id
        ''')
        
        result = cur.fetchone()
        if result:
            collection_id = result[0]
        else:
            cur.execute('SELECT id FROM collections WHERE handle = %s', ('wall-art',))
            collection_id = cur.fetchone()[0]
        
        print(f'Using collection ID: {collection_id}')
        
        # Import products
        imported_count = 0
        for index, row in df.iterrows():
            try:
                # Generate handle from title
                title = str(row.get('Title', f'Product {index}'))
                handle = title.lower().replace(' ', '-').replace('/', '-')
                handle = ''.join(c for c in handle if c.isalnum() or c == '-')
                
                # Insert product
                cur.execute('''
                    INSERT INTO products (
                        handle, title, description, collection_id,
                        vendor, product_type, status
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (handle) DO UPDATE
                    SET title = EXCLUDED.title,
                        updated_at = NOW()
                    RETURNING id
                ''', (
                    handle,
                    title,
                    str(row.get('Body (HTML)', '')),
                    collection_id,
                    str(row.get('Vendor', 'VividWalls')),
                    str(row.get('Type', 'Wall Art')),
                    'active'
                ))
                
                product_result = cur.fetchone()
                if product_result:
                    product_id = product_result[0]
                    
                    # Add product image if available
                    image_src = row.get('Image Src')
                    if pd.notna(image_src) and str(image_src).strip():
                        cur.execute('''
                            INSERT INTO product_images (product_id, src, alt_text, is_primary)
                            VALUES (%s, %s, %s, %s)
                            ON CONFLICT DO NOTHING
                        ''', (product_id, str(image_src), title, True))
                    
                    imported_count += 1
                    if imported_count % 50 == 0:
                        print(f'Imported {imported_count} products...')
                        conn.commit()
                
            except Exception as e:
                print(f'Error importing product {index}: {e}')
                continue
        
        conn.commit()
        print(f'Successfully imported {imported_count} products!')
        
        # Verify import
        cur.execute('SELECT COUNT(*) FROM products')
        total_products = cur.fetchone()[0]
        print(f'Total products in database: {total_products}')
        
    except Exception as e:
        print(f'Error: {e}')
        if conn:
            conn.rollback()
        raise
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == '__main__':
    import_products()
EOF"

echo -e "${BLUE}Step 4: Installing Python dependencies in container${NC}"
remote_exec "docker exec postgres apt-get update && docker exec postgres apt-get install -y python3 python3-pip"
remote_exec "docker exec postgres pip3 install pandas psycopg2-binary"

echo -e "${BLUE}Step 5: Copying import script to postgres container${NC}"
remote_exec "docker cp /tmp/import_products.py postgres:/tmp/"
remote_exec "docker cp /tmp/vividwalls_products.csv postgres:/tmp/"

echo -e "${BLUE}Step 6: Executing product import${NC}"
remote_exec "docker exec postgres python3 /tmp/import_products.py"

echo -e "${BLUE}Step 7: Verifying product import${NC}"
remote_exec "docker exec postgres psql -U postgres -d postgres -c \"SELECT COUNT(*) as total_products FROM products;\""

echo -e "${GREEN}✅ VividWalls product data import completed${NC}"
