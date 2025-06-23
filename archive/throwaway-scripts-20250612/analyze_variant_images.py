#!/usr/bin/env python3
"""Analyze variant images in VividWalls product catalog"""

import csv
import json
from collections import defaultdict

def analyze_variant_images(csv_file):
    """Analyze the variant images in the product catalog"""
    
    products = defaultdict(lambda: {
        'title': '',
        'sizes': {},
        'variant_images': {},
        'issues': []
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
            
            # Update product title if present
            if title:
                products[handle]['title'] = title
            
            # Track sizes for this product
            if size:
                products[handle]['sizes'][size] = True
            
            # Check if this variant has an image
            if variant_image and variant_image.strip():
                key = f"{size}_{finish}"
                products[handle]['variant_images'][key] = variant_image
    
    # Analyze each product
    print("VIVIDWALLS VARIANT IMAGE ANALYSIS")
    print("=" * 80)
    print()
    
    # Statistics
    total_products = len(products)
    products_with_correct_variants = 0
    products_with_no_variants = 0
    products_with_incorrect_variants = 0
    
    # Required sizes
    required_sizes = ['24x36', '36x48', '53x72']
    
    for handle, data in products.items():
        title = data['title']
        sizes = list(data['sizes'].keys())
        variant_images = data['variant_images']
        
        # Check which size variants have images
        size_variants_with_images = []
        finish_variants_with_images = []
        
        for key, image in variant_images.items():
            parts = key.split('_')
            if len(parts) >= 2:
                size, finish = parts[0], '_'.join(parts[1:])
                if size in required_sizes:
                    if finish in ['Gallery Wrapped Stretched Canvas', 'Canvas Roll']:
                        finish_variants_with_images.append(key)
                    else:
                        size_variants_with_images.append(size)
        
        # Check if product has proper size-based variant images
        has_all_size_variants = all(size in size_variants_with_images for size in required_sizes)
        
        if not variant_images:
            products_with_no_variants += 1
            data['issues'].append('NO_VARIANT_IMAGES')
        elif finish_variants_with_images and not size_variants_with_images:
            products_with_incorrect_variants += 1
            data['issues'].append('ONLY_FINISH_VARIANTS')
        elif has_all_size_variants:
            products_with_correct_variants += 1
        else:
            products_with_incorrect_variants += 1
            missing_sizes = [s for s in required_sizes if s not in size_variants_with_images]
            data['issues'].append(f'MISSING_SIZE_VARIANTS: {", ".join(missing_sizes)}')
    
    # Print summary
    print(f"Total products analyzed: {total_products}")
    print(f"Products with correct size variants: {products_with_correct_variants}")
    print(f"Products with no variant images: {products_with_no_variants}")
    print(f"Products with incorrect variants: {products_with_incorrect_variants}")
    print()
    
    # Print detailed issues
    print("DETAILED PRODUCT ANALYSIS")
    print("-" * 80)
    
    for handle, data in sorted(products.items()):
        if data['issues']:
            print(f"\n{handle} - {data['title']}")
            print(f"  Issues: {', '.join(data['issues'])}")
            if data['variant_images']:
                print(f"  Current variant images:")
                for key, image in sorted(data['variant_images'].items()):
                    print(f"    - {key}")
    
    # Products with correct variants
    print("\n\nPRODUCTS WITH CORRECT SIZE VARIANTS")
    print("-" * 80)
    
    for handle, data in sorted(products.items()):
        if not data['issues'] and data['variant_images']:
            print(f"\n{handle} - {data['title']}")
            print("  Size variants with images:")
            for key in sorted(data['variant_images'].keys()):
                print(f"    - {key}")
    
    return products

if __name__ == "__main__":
    csv_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls_Product_Catalog_Jun_10 2025.csv"
    analyze_variant_images(csv_file)