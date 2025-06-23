#!/usr/bin/env python3
"""
Detailed analysis of image coverage with breakdown by product and variant type.
"""

import csv
from collections import defaultdict

def main():
    csv_file = '/Users/kinglerbercy/Projects/vivid_mas/data/exports/shopify_products_COMPLETE_ENHANCED.csv'
    
    print("Detailed image coverage analysis...")
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        products = defaultdict(list)
        current_product = None
        
        for row in reader:
            handle = row.get('Handle', '').strip()
            title = row.get('Title', '').strip()
            image_src = row.get('Image Src', '').strip()
            variant_image = row.get('Variant Image', '').strip()
            size = row.get('Option1 Value', '').strip()
            print_type = row.get('Option2 Value', '').strip()
            
            # Track current product
            if handle:
                current_product = {
                    'handle': handle,
                    'title': title,
                    'main_image': image_src
                }
            
            # Only analyze actual product variants
            if size and print_type and current_product:
                variant_info = {
                    'size': size,
                    'print_type': print_type,
                    'main_image': current_product['main_image'],
                    'variant_image': variant_image,
                    'has_main': bool(current_product['main_image']),
                    'has_variant': bool(variant_image),
                    'image_source': 'variant' if variant_image else ('main' if current_product['main_image'] else 'none')
                }
                
                products[current_product['handle']].append(variant_info)
    
    print(f"\n=== DETAILED IMAGE BREAKDOWN ===")
    print(f"Total products: {len(products)}")
    
    # Variant distribution
    variant_counts = defaultdict(int)
    total_variants = 0
    
    for handle, variants in products.items():
        variant_count = len(variants)
        variant_counts[variant_count] += 1
        total_variants += variant_count
    
    print(f"Total variants: {total_variants}")
    print(f"\nVariant distribution:")
    for count, num_products in sorted(variant_counts.items()):
        print(f"  {num_products} products have {count} variants each")
    
    # Image source analysis
    main_only = 0
    variant_only = 0
    both_images = 0
    no_images = 0
    
    for handle, variants in products.items():
        for variant in variants:
            if variant['has_main'] and variant['has_variant']:
                both_images += 1
            elif variant['has_main'] and not variant['has_variant']:
                main_only += 1
            elif not variant['has_main'] and variant['has_variant']:
                variant_only += 1
            else:
                no_images += 1
    
    print(f"\n=== IMAGE SOURCE ANALYSIS ===")
    print(f"Variants with both main and variant images: {both_images}")
    print(f"Variants with only main image: {main_only}")
    print(f"Variants with only variant image: {variant_only}")
    print(f"Variants with no images: {no_images}")
    
    # Show products with most variants
    print(f"\n=== PRODUCTS BY VARIANT COUNT ===")
    sorted_products = sorted(products.items(), key=lambda x: len(x[1]), reverse=True)
    
    for i, (handle, variants) in enumerate(sorted_products[:10]):
        product_title = variants[0].get('title', 'Unknown') if variants else 'Unknown'
        variant_images = sum(1 for v in variants if v['has_variant'])
        main_images = sum(1 for v in variants if v['has_main'])
        
        print(f"{i+1:2d}. {handle}")
        print(f"     Title: {product_title}")
        print(f"     Variants: {len(variants)}, Main Images: {main_images}, Variant Images: {variant_images}")
        
        # Show variant breakdown
        sizes = set(v['size'] for v in variants)
        print_types = set(v['print_type'] for v in variants)
        print(f"     Sizes: {', '.join(sorted(sizes))}")
        print(f"     Print Types: {', '.join(sorted(print_types))}")
        
        if i < 3:  # Show detailed breakdown for first 3
            print(f"     Variant Details:")
            for v in variants:
                img_status = "✅" if v['has_variant'] or v['has_main'] else "❌"
                img_type = v['image_source']
                print(f"       {img_status} {v['size']} {v['print_type']} ({img_type})")
        print()

if __name__ == '__main__':
    main()