#!/usr/bin/env python3
"""
Fill Cost per Item values in the vision-enhanced CSV using Pictorem cost data.
Maps costs based on Size (Option1 Value) and Print Type (Option2 Value).
"""

import csv
import sys
from pathlib import Path

def main():
    # File paths
    vision_enhanced_file = '/Users/kinglerbercy/Projects/vivid_mas/data/exports/shopify_products_upload_reconciled_VISION_ENHANCED.csv'
    costs_file = '/Users/kinglerbercy/Projects/vivid_mas/data/exports/vividwalls-products-with-costs-2025-06-04.csv'
    
    # Read costs CSV and create mapping
    print("Reading costs CSV...")
    cost_mapping = {}
    
    with open(costs_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            size = row.get('Option1 Value', '').strip()
            print_type = row.get('Option2 Value', '').strip() 
            cost = row.get('Cost per item', '').strip()
            
            # Skip if any required field is empty
            if not size or not print_type or not cost:
                continue
                
            try:
                cost_float = float(cost)
                # Create mapping key
                key = f"{size}|{print_type}"
                cost_mapping[key] = cost_float
                print(f"Mapped: {key} -> ${cost}")
            except ValueError:
                continue
    
    print(f"\nTotal cost mappings created: {len(cost_mapping)}")
    
    # Read vision-enhanced CSV
    print("Reading vision-enhanced CSV...")
    vision_rows = []
    fieldnames = []
    
    with open(vision_enhanced_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            vision_rows.append(row)
    
    # Apply costs to vision-enhanced CSV
    updated_count = 0
    
    for idx, row in enumerate(vision_rows):
        # Skip if cost is already filled
        current_cost = row.get('Cost per item', '').strip()
        if current_cost:
            continue
            
        # Get size and print type
        size = row.get('Option1 Value', '').strip()
        print_type = row.get('Option2 Value', '').strip()
        
        # Skip if size or print type are empty
        if not size or not print_type:
            continue
            
        # Look up cost
        key = f"{size}|{print_type}"
        if key in cost_mapping:
            row['Cost per item'] = str(cost_mapping[key])
            updated_count += 1
            print(f"Updated row {idx}: {key} -> ${cost_mapping[key]}")
    
    print(f"\nTotal rows updated with cost data: {updated_count}")
    
    # Save the updated CSV
    output_file = vision_enhanced_file.replace('.csv', '_WITH_COSTS.csv')
    
    with open(output_file, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(vision_rows)
    
    print(f"\nSaved updated CSV to: {output_file}")
    
    # Summary
    total_cost_rows = sum(1 for row in vision_rows if row.get('Cost per item', '').strip())
    print(f"\nSummary:")
    print(f"- Total rows in vision-enhanced CSV: {len(vision_rows)}")
    print(f"- Rows with cost data after update: {total_cost_rows}")
    print(f"- Rows updated in this run: {updated_count}")

if __name__ == '__main__':
    main()