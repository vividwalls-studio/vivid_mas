#!/usr/bin/env python3
"""
Complete CSV enhancement script to fill in all missing product data:
- Copy Variant Price to Price / United States
- Add Compare At Price (20% markup)
- Fill Google Shopping columns
- Fill Custom Label columns
- Add Product Category and Type
- Extract keywords from product descriptions and tags
"""

import csv
import re
from pathlib import Path

def extract_keywords_from_description(description, title, tags):
    """Extract relevant keywords from product description, title, and tags"""
    if not description:
        description = ""
    if not title:
        title = ""
    if not tags:
        tags = ""
    
    # Combine all text sources
    all_text = f"{title} {description} {tags}".lower()
    
    # Art-related keywords to look for
    art_keywords = [
        'abstract', 'geometric', 'contemporary', 'modern', 'minimalist',
        'fractal', 'digital', 'constructivist', 'color', 'pattern',
        'texture', 'composition', 'visual', 'artistic', 'design',
        'wall art', 'home decor', 'interior', 'gallery', 'museum',
        'limited edition', 'fine art', 'print', 'canvas'
    ]
    
    # Color keywords
    color_keywords = [
        'red', 'blue', 'green', 'yellow', 'orange', 'purple', 'black', 
        'white', 'gray', 'grey', 'crimson', 'emerald', 'azure', 'noir',
        'royal', 'teal', 'olive', 'pink', 'magenta', 'amber'
    ]
    
    # Style keywords
    style_keywords = [
        'kimono', 'echoes', 'mosaic', 'weave', 'shade', 'crystalline',
        'prismatic', 'structured', 'textured', 'verdant', 'vista',
        'space', 'perspective', 'illusion', 'untiled'
    ]
    
    found_keywords = []
    
    # Find art keywords
    for keyword in art_keywords:
        if keyword in all_text:
            found_keywords.append(keyword.title())
    
    # Find color keywords
    for keyword in color_keywords:
        if keyword in all_text:
            found_keywords.append(keyword.title())
    
    # Find style keywords  
    for keyword in style_keywords:
        if keyword in all_text:
            found_keywords.append(keyword.title())
    
    # Remove duplicates and return first 5
    unique_keywords = list(dict.fromkeys(found_keywords))[:5]
    
    # If no keywords found, use defaults
    if not unique_keywords:
        unique_keywords = ['Abstract Art', 'Wall Decor', 'Modern Art', 'Home Decor']
    
    return unique_keywords

def extract_colors_from_text(text):
    """Extract color information from text"""
    if not text:
        return ""
    
    text_lower = text.lower()
    colors = []
    
    color_map = {
        'red': 'red', 'crimson': 'red', 'scarlet': 'red',
        'blue': 'blue', 'azure': 'blue', 'navy': 'blue', 'royal': 'blue',
        'green': 'green', 'emerald': 'green', 'olive': 'green', 'teal': 'green',
        'yellow': 'yellow', 'amber': 'yellow', 'gold': 'yellow',
        'orange': 'orange', 'coral': 'orange',
        'purple': 'purple', 'magenta': 'purple', 'violet': 'purple',
        'black': 'black', 'noir': 'black',
        'white': 'white', 'cream': 'white',
        'gray': 'gray', 'grey': 'gray', 'silver': 'gray',
        'brown': 'brown', 'rusty': 'brown', 'earthy': 'brown',
        'pink': 'pink'
    }
    
    for color_term, base_color in color_map.items():
        if color_term in text_lower:
            if base_color not in colors:
                colors.append(base_color)
    
    return '; '.join(colors) if colors else 'multicolor'

def calculate_compare_price(variant_price):
    """Calculate compare at price (20% markup)"""
    try:
        price = float(variant_price)
        return round(price * 1.2, 2)
    except (ValueError, TypeError):
        return ""

def main():
    input_file = '/Users/kinglerbercy/Projects/vivid_mas/data/exports/shopify_products_upload_reconciled_VISION_ENHANCED_WITH_COSTS.csv'
    output_file = '/Users/kinglerbercy/Projects/vivid_mas/data/exports/shopify_products_COMPLETE_ENHANCED.csv'
    
    print("Reading vision-enhanced CSV with costs...")
    
    # Read the input CSV
    rows = []
    fieldnames = []
    
    with open(input_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            rows.append(row)
    
    print(f"Processing {len(rows)} rows...")
    
    current_product_info = {}
    updated_count = 0
    
    for idx, row in enumerate(rows):
        # Track current product info from main product rows
        handle = row.get('Handle', '').strip()
        if handle:  # This is a main product row
            current_product_info = {
                'title': row.get('Title', ''),
                'description': row.get('Body (HTML)', ''),
                'seo_description': row.get('SEO Description', ''),
                'tags': row.get('Tags', ''),
                'handle': handle
            }
        
        # Always apply enhancements to all rows
        variant_price = row.get('Variant Price', '').strip()
        
        # 1. Copy Variant Price to Price / United States
        if variant_price:
            row['Price / United States'] = variant_price
            row['Included / United States'] = 'TRUE'
        
        # 2. Calculate and add Compare At Price
        if variant_price:
            compare_price = calculate_compare_price(variant_price)
            if compare_price:
                row['Compare At Price / United States'] = str(compare_price)
                row['Variant Compare At Price'] = str(compare_price)
        
        # 3. Add Product Category and Type
        row['Product Category'] = 'Home & Garden > Decor > Artwork'
        row['Type'] = 'Artwork'
        
        # 4. Fill Google Shopping columns
        row['Google Shopping / Google Product Category'] = 'Home & Garden > Decor > Artwork'
        row['Google Shopping / Gender'] = 'unisex'
        row['Google Shopping / Age Group'] = 'adult'
        row['Google Shopping / Condition'] = 'new'
        row['Google Shopping / Custom Product'] = 'true'
        
        # 5. Extract keywords and fill custom labels
        if current_product_info:
            description = current_product_info.get('description', '')
            title = current_product_info.get('title', '')
            tags = current_product_info.get('tags', '')
            seo_desc = current_product_info.get('seo_description', '')
            
            # Use SEO description if available, otherwise use body description
            main_text = seo_desc if seo_desc else description
            
            keywords = extract_keywords_from_description(main_text, title, tags)
            
            # Fill custom labels with keywords
            if len(keywords) > 0:
                row['Google Shopping / Custom Label 0'] = keywords[0] if len(keywords) > 0 else ''
            if len(keywords) > 1:
                row['Google Shopping / Custom Label 1'] = keywords[1] if len(keywords) > 1 else ''
            if len(keywords) > 2:
                row['Google Shopping / Custom Label 2'] = keywords[2] if len(keywords) > 2 else ''
            if len(keywords) > 3:
                row['Google Shopping / Custom Label 3'] = keywords[3] if len(keywords) > 3 else ''
            if len(keywords) > 4:
                row['Google Shopping / Custom Label 4'] = keywords[4] if len(keywords) > 4 else ''
            
            # Add collection/style info if available
            if not row['Google Shopping / Custom Label 0']:
                row['Google Shopping / Custom Label 0'] = 'Abstract Art'
            if not row['Google Shopping / Custom Label 1']:
                row['Google Shopping / Custom Label 1'] = 'Wall Decor'
            
            # 6. Fill color pattern metadata
            colors = extract_colors_from_text(f"{title} {main_text}")
            if colors:
                row['Color (product.metafields.shopify.color-pattern)'] = colors
        
        # 7. Set status and other fields
        if not row.get('Status', '').strip():
            row['Status'] = 'ACTIVE'
        
        # 8. Set vendor if missing
        if not row.get('Vendor', '').strip():
            row['Vendor'] = 'VividWalls'
        
        # 9. Set published status
        if not row.get('Published', '').strip():
            row['Published'] = 'TRUE'
        
        updated_count += 1
        
        if idx % 50 == 0:
            print(f"Processed {idx + 1} rows...")
    
    print(f"Enhanced {updated_count} rows")
    
    # Write the enhanced CSV
    with open(output_file, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    
    print(f"\nSaved complete enhanced CSV to: {output_file}")
    
    # Summary statistics
    products_with_prices = sum(1 for row in rows if row.get('Price / United States', '').strip())
    products_with_compare = sum(1 for row in rows if row.get('Compare At Price / United States', '').strip())
    products_with_categories = sum(1 for row in rows if row.get('Product Category', '').strip())
    products_with_labels = sum(1 for row in rows if row.get('Google Shopping / Custom Label 0', '').strip())
    
    print(f"\nEnhancement Summary:")
    print(f"- Total rows processed: {len(rows)}")
    print(f"- Products with US pricing: {products_with_prices}")
    print(f"- Products with compare pricing: {products_with_compare}")
    print(f"- Products with categories: {products_with_categories}")
    print(f"- Products with custom labels: {products_with_labels}")

if __name__ == '__main__':
    main()