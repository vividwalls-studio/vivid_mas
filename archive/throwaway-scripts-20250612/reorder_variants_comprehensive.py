#!/usr/bin/env python3
"""
Comprehensive reordering of product variants to ensure proper size and print type order.
"""

import csv
import sys
from collections import defaultdict, OrderedDict

def get_sort_key(row):
    """Generate a sort key for a variant row."""
    size = row.get('Option1 Value', '')
    print_type = row.get('Option2 Value', '')
    
    # Define the exact order we want
    size_order = {'24x36': 1, '36x48': 2, '53x72': 3}
    print_order = {'Gallery Wrapped Stretched Canvas': 1, 'Canvas Roll': 2}
    
    return (
        size_order.get(size, 999),
        print_order.get(print_type, 999)
    )

def reorder_product_variants(input_file, output_file):
    """Reorder variants for all products."""
    
    # Read all rows
    with open(input_file, 'r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames
        all_rows = list(reader)
    
    # Process rows
    output_rows = []
    current_product_rows = []
    current_handle = None
    products_processed = 0
    
    for row in all_rows:
        handle = row.get('Handle', '')
        
        # Check if we're starting a new product
        if handle != current_handle:
            # Process the previous product if it exists
            if current_product_rows:
                sorted_rows = sort_product_rows(current_product_rows)
                output_rows.extend(sorted_rows)
                products_processed += 1
            
            # Start new product
            current_product_rows = [row]
            current_handle = handle
        else:
            # Add to current product
            current_product_rows.append(row)
    
    # Don't forget the last product
    if current_product_rows:
        sorted_rows = sort_product_rows(current_product_rows)
        output_rows.extend(sorted_rows)
        products_processed += 1
    
    # Write output
    with open(output_file, 'w', encoding='utf-8', newline='') as outfile:
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(output_rows)
    
    print(f"Processed {products_processed} products")
    print(f"Total rows: {len(output_rows)}")
    print(f"Output saved to: {output_file}")

def sort_product_rows(product_rows):
    """Sort rows for a single product."""
    # Find the main row (has Title)
    main_row = None
    variant_rows = []
    
    for row in product_rows:
        if row.get('Title', '').strip():
            main_row = row
        else:
            variant_rows.append(row)
    
    # Sort variants
    variant_rows.sort(key=get_sort_key)
    
    # Return main row first, then sorted variants
    result = []
    if main_row:
        result.append(main_row)
    result.extend(variant_rows)
    
    return result

def analyze_products(csv_file):
    """Analyze and report on product variant patterns."""
    print("\nAnalyzing product variants...")
    
    with open(csv_file, 'r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        
        products = defaultdict(list)
        
        for row in reader:
            handle = row.get('Handle', '')
            size = row.get('Option1 Value', '')
            print_type = row.get('Option2 Value', '')
            
            if handle and size and not row.get('Title', '').strip():
                products[handle].append((size, print_type))
    
    # Expected combinations
    expected_sizes = ['24x36', '36x48', '53x72']
    expected_print_types = ['Gallery Wrapped Stretched Canvas', 'Canvas Roll']
    
    # Check each product
    issues = []
    for handle, variants in products.items():
        # Check if all expected combinations exist
        for size in expected_sizes:
            for print_type in expected_print_types:
                if (size, print_type) not in variants:
                    issues.append(f"{handle}: Missing {size} - {print_type}")
    
    # Print first 10 products
    print("\nFirst 10 products:")
    for i, (handle, variants) in enumerate(list(products.items())[:10]):
        print(f"\n{handle}:")
        for size, print_type in variants:
            print(f"  - {size} ({print_type})")
    
    if issues:
        print(f"\nFound {len(issues)} missing variant combinations:")
        for issue in issues[:10]:  # Show first 10 issues
            print(f"  - {issue}")
        if len(issues) > 10:
            print(f"  ... and {len(issues) - 10} more")

if __name__ == "__main__":
    input_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls Product Catalog Updated-Fixed.csv"
    output_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls Product Catalog Final.csv"
    
    try:
        reorder_product_variants(input_file, output_file)
        analyze_products(output_file)
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)