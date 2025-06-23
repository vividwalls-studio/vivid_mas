#!/usr/bin/env python3
"""
Reorder product variants to ensure sizes appear in the correct order: 24x36, 36x48, 53x72
"""

import csv
import sys
from collections import defaultdict

def get_size_order(size):
    """Return sort order for sizes."""
    size_order = {
        '24x36': 1,
        '36x48': 2,
        '53x72': 3
    }
    return size_order.get(size, 999)  # Unknown sizes go last

def get_print_type_order(print_type):
    """Return sort order for print types - Gallery Wrapped comes before Canvas Roll."""
    print_type_order = {
        'Gallery Wrapped Stretched Canvas': 1,
        'Canvas Roll': 2
    }
    return print_type_order.get(print_type, 999)

def reorder_variants(input_file, output_file):
    """Reorder product variants by size and print type."""
    
    # Read all rows
    with open(input_file, 'r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames
        all_rows = list(reader)
    
    # Group rows by product handle
    products = defaultdict(list)
    for row in all_rows:
        handle = row.get('Handle', '')
        if handle:  # Only process rows with handles
            products[handle].append(row)
    
    # Process each product
    reordered_rows = []
    products_reordered = 0
    
    for handle, product_rows in products.items():
        # Separate the main product row from variant rows
        main_row = None
        variant_rows = []
        
        for row in product_rows:
            # The main product row has Title filled
            if row.get('Title', '').strip():
                main_row = row
            else:
                variant_rows.append(row)
        
        # Sort variant rows by size and print type
        if variant_rows:
            # First sort to ensure we maintain consistent ordering
            variant_rows.sort(key=lambda x: (
                get_size_order(x.get('Option1 Value', '')),
                get_print_type_order(x.get('Option2 Value', '')),
                x.get('Variant SKU', '')  # Use SKU as tiebreaker for consistency
            ))
            products_reordered += 1
        
        # Add main row first, then sorted variants
        if main_row:
            reordered_rows.append(main_row)
        reordered_rows.extend(variant_rows)
    
    # Write reordered data
    with open(output_file, 'w', encoding='utf-8', newline='') as outfile:
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(reordered_rows)
    
    print(f"Reordered {products_reordered} products")
    print(f"Total rows processed: {len(all_rows)}")
    print(f"Output saved to: {output_file}")

def verify_order(csv_file):
    """Verify the order of variants in the CSV file."""
    print("\nVerifying variant order...")
    
    with open(csv_file, 'r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        
        current_handle = None
        sizes_for_product = []
        
        for row in reader:
            handle = row.get('Handle', '')
            size = row.get('Option1 Value', '')
            print_type = row.get('Option2 Value', '')
            
            if handle != current_handle:
                # New product - print previous product's sizes
                if current_handle and sizes_for_product:
                    print(f"{current_handle}: {' → '.join(sizes_for_product)}")
                
                current_handle = handle
                sizes_for_product = []
            
            if size and not row.get('Title', '').strip():  # Variant row
                sizes_for_product.append(f"{size} ({print_type})")
        
        # Print last product
        if current_handle and sizes_for_product:
            print(f"{current_handle}: {' → '.join(sizes_for_product)}")

if __name__ == "__main__":
    input_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls Product Catalog Updated-Fixed.csv"
    output_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls Product Catalog Updated-Reordered.csv"
    
    try:
        reorder_variants(input_file, output_file)
        # Verify first few products
        print("\nFirst 5 products after reordering:")
        verify_order(output_file)
    except Exception as e:
        print(f"Error processing file: {e}")
        sys.exit(1)