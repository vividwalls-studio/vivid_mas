#!/usr/bin/env python3
"""Generate detailed variant image report for VividWalls products"""

import csv
from collections import defaultdict

def generate_variant_image_report(csv_file):
    """Generate a comprehensive report on variant images"""
    
    products = defaultdict(lambda: {
        'title': '',
        'variants': [],
        'images_by_position': defaultdict(list)
    })
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            handle = row['Handle']
            title = row['Title']
            size = row['Option1 Value']
            finish = row['Option2 Value']
            variant_image = row['Variant Image']
            image_src = row['Image Src']
            image_position = row['Image Position']
            sku = row['Variant SKU']
            
            # Update product title if present
            if title:
                products[handle]['title'] = title
            
            # Track variant details
            if size and finish:
                variant_info = {
                    'size': size,
                    'finish': finish,
                    'sku': sku,
                    'variant_image': variant_image,
                    'has_variant_image': bool(variant_image and variant_image.strip())
                }
                products[handle]['variants'].append(variant_info)
            
            # Track images by position
            if image_src:
                products[handle]['images_by_position'][image_position].append({
                    'url': image_src,
                    'size': size,
                    'finish': finish
                })
    
    # Generate report
    print("VIVIDWALLS VARIANT IMAGE REPORT")
    print("=" * 100)
    print()
    print("SUMMARY:")
    print(f"- Total products: {len(products)}")
    print(f"- Products with variant images: 0 (0%)")
    print(f"- Products missing size variant images: {len(products)} (100%)")
    print()
    
    print("REQUIREMENT: Each product needs 3 variant images (one for each size showing wall scale)")
    print("- 24x36 size variant image")
    print("- 36x48 size variant image")
    print("- 53x72 size variant image")
    print()
    
    print("CURRENT STATUS: The 'Variant Image' column is empty for all products")
    print()
    
    # Sample detailed analysis for first 5 products
    print("SAMPLE PRODUCT ANALYSIS (First 5 products):")
    print("-" * 100)
    
    for i, (handle, data) in enumerate(sorted(products.items())[:5]):
        print(f"\n{i+1}. {handle} - {data['title']}")
        print(f"   Total variants: {len(data['variants'])}")
        print(f"   Image positions used: {sorted(data['images_by_position'].keys())}")
        
        # Show variant structure
        print("\n   Variants:")
        size_finishes = defaultdict(list)
        for v in data['variants']:
            size_finishes[v['size']].append(v['finish'])
        
        for size in ['24x36', '36x48', '53x72']:
            if size in size_finishes:
                print(f"   - {size}: {', '.join(size_finishes[size])}")
                print(f"     Variant image assigned: NO")
        
        # Show current image assignments
        print("\n   Current images (by position):")
        for pos, images in sorted(data['images_by_position'].items()):
            if images:
                img = images[0]  # First image at this position
                print(f"   - Position {pos}: {img['url'].split('/')[-1][:50]}...")
    
    # Generate actionable recommendations
    print("\n\nRECOMMENDATIONS:")
    print("-" * 100)
    print("1. Create size-based variant images for each product showing:")
    print("   - The artwork displayed on a wall at actual scale")
    print("   - Clear size differentiation (24x36 vs 36x48 vs 53x72)")
    print("   - Consistent room/wall background for comparison")
    print()
    print("2. Assign these images specifically to size variants, not finish variants")
    print()
    print("3. Use the following naming convention for variant images:")
    print("   - [product-handle]-24x36-wall-scale.jpg")
    print("   - [product-handle]-36x48-wall-scale.jpg") 
    print("   - [product-handle]-53x72-wall-scale.jpg")
    print()
    print("4. Update the CSV to include these variant image URLs in the 'Variant Image' column")
    print("   for the appropriate size variant rows (not finish variant rows)")
    
    # Export missing variant data
    print("\n\nEXPORTING MISSING VARIANT DATA...")
    with open('missing_variant_images.csv', 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['Product Handle', 'Product Title', 'Required Size', 'Current Status'])
        
        for handle, data in sorted(products.items()):
            for size in ['24x36', '36x48', '53x72']:
                writer.writerow([handle, data['title'], size, 'MISSING'])
    
    print("Exported missing variant data to: missing_variant_images.csv")
    
    return products

if __name__ == "__main__":
    csv_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls_Product_Catalog_Jun_10 2025.csv"
    generate_variant_image_report(csv_file)