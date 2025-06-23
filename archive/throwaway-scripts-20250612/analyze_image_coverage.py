#!/usr/bin/env python3
"""
Analyze image coverage across all product variants in the enhanced CSV.
Check which variants have images and which are missing them.
"""

import csv
from collections import defaultdict

def main():
    csv_file = '/Users/kinglerbercy/Projects/vivid_mas/data/exports/shopify_products_COMPLETE_ENHANCED.csv'
    
    print("Analyzing image coverage for all product variants...")
    
    # Read the CSV and analyze image data
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        products = defaultdict(list)
        current_product = None
        
        total_variants = 0
        variants_with_images = 0
        variants_with_variant_images = 0
        missing_images = []
        
        for row_idx, row in enumerate(reader):
            handle = row.get('Handle', '').strip()
            title = row.get('Title', '').strip()
            image_src = row.get('Image Src', '').strip()
            variant_image = row.get('Variant Image', '').strip()
            size = row.get('Option1 Value', '').strip()
            print_type = row.get('Option2 Value', '').strip()
            sku = row.get('Variant SKU', '').strip()
            
            # Track current product
            if handle:
                current_product = {
                    'handle': handle,
                    'title': title,
                    'main_image': image_src
                }
            
            # Only analyze actual product variants (with size/print type)
            if size and print_type:
                total_variants += 1
                
                variant_info = {
                    'row': row_idx + 2,  # +2 for header and 0-based index
                    'handle': current_product['handle'] if current_product else 'Unknown',
                    'title': current_product['title'] if current_product else 'Unknown',
                    'size': size,
                    'print_type': print_type,
                    'sku': sku,
                    'main_image': current_product['main_image'] if current_product else '',
                    'variant_image': variant_image,
                    'has_any_image': bool(variant_image or (current_product and current_product['main_image']))
                }
                
                products[current_product['handle'] if current_product else 'Unknown'].append(variant_info)
                
                # Count image coverage
                if variant_info['has_any_image']:
                    variants_with_images += 1
                else:
                    missing_images.append(variant_info)
                
                if variant_image:
                    variants_with_variant_images += 1
    
    # Analysis results
    print(f"\n=== IMAGE COVERAGE ANALYSIS ===")
    print(f"Total product variants analyzed: {total_variants}")
    print(f"Variants with any image: {variants_with_images}")
    print(f"Variants with specific variant images: {variants_with_variant_images}")
    print(f"Variants missing images: {len(missing_images)}")
    print(f"Image coverage: {(variants_with_images/total_variants*100):.1f}%")
    
    # Product-level analysis
    print(f"\n=== PRODUCT-LEVEL ANALYSIS ===")
    print(f"Total products: {len(products)}")
    
    products_with_all_images = 0
    products_partial_images = 0
    products_no_images = 0
    
    for handle, variants in products.items():
        variants_with_img = sum(1 for v in variants if v['has_any_image'])
        total_vars = len(variants)
        
        if variants_with_img == total_vars:
            products_with_all_images += 1
        elif variants_with_img > 0:
            products_partial_images += 1
        else:
            products_no_images += 1
        
        if variants_with_img < total_vars:
            print(f"\n📦 {handle} ({variants[0]['title']})")
            print(f"   Variants: {total_vars}, With Images: {variants_with_img}")
            for variant in variants:
                if not variant['has_any_image']:
                    print(f"   ❌ Missing: {variant['size']} {variant['print_type']} (Row {variant['row']})")
    
    print(f"\nProducts with all variants having images: {products_with_all_images}")
    print(f"Products with some variants missing images: {products_partial_images}")
    print(f"Products with no images: {products_no_images}")
    
    # Size/Print Type analysis
    print(f"\n=== VARIANT TYPE ANALYSIS ===")
    size_coverage = defaultdict(lambda: {'total': 0, 'with_images': 0})
    print_type_coverage = defaultdict(lambda: {'total': 0, 'with_images': 0})
    
    for product_variants in products.values():
        for variant in product_variants:
            size = variant['size']
            print_type = variant['print_type']
            
            size_coverage[size]['total'] += 1
            print_type_coverage[print_type]['total'] += 1
            
            if variant['has_any_image']:
                size_coverage[size]['with_images'] += 1
                print_type_coverage[print_type]['with_images'] += 1
    
    print("\nImage coverage by size:")
    for size, data in sorted(size_coverage.items()):
        coverage = (data['with_images'] / data['total'] * 100) if data['total'] > 0 else 0
        print(f"  {size}: {data['with_images']}/{data['total']} ({coverage:.1f}%)")
    
    print("\nImage coverage by print type:")
    for print_type, data in sorted(print_type_coverage.items()):
        coverage = (data['with_images'] / data['total'] * 100) if data['total'] > 0 else 0
        print(f"  {print_type}: {data['with_images']}/{data['total']} ({coverage:.1f}%)")
    
    # Show sample of products with good image coverage
    print(f"\n=== SAMPLE PRODUCTS WITH COMPLETE IMAGE COVERAGE ===")
    complete_count = 0
    for handle, variants in products.items():
        if all(v['has_any_image'] for v in variants):
            if complete_count < 5:
                print(f"✅ {handle} ({variants[0]['title']}) - {len(variants)} variants, all with images")
                complete_count += 1
    
    if missing_images:
        print(f"\n=== VARIANTS MISSING IMAGES (First 10) ===")
        for i, variant in enumerate(missing_images[:10]):
            print(f"❌ Row {variant['row']}: {variant['handle']} - {variant['size']} {variant['print_type']}")

if __name__ == '__main__':
    main()