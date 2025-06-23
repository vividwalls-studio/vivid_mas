#!/usr/bin/env python3
"""
Update VividWalls inventory to align with limited edition business model.

This script processes the inventory CSV and updates quantities based on the limited edition allocation strategy:
- 24x36 (Small): 50 units per artwork
- 36x48 (Medium): 35 units per artwork  
- 53x72 (Large): 15 units per artwork

Total edition size: 100 units per artwork
"""

import csv
import sys
from pathlib import Path
from collections import defaultdict

def update_limited_edition_inventory(input_csv_path, output_csv_path):
    """
    Update inventory quantities to reflect limited edition allocations.
    
    Args:
        input_csv_path: Path to input CSV file
        output_csv_path: Path to output CSV file
    """
    
    # Limited edition allocation strategy
    SIZE_ALLOCATIONS = {
        '24 x 36': 50,  # Small prints
        '36 x 48': 35,  # Medium prints
        '53 x 72': 15   # Large prints
    }
    
    print(f"Reading inventory from: {input_csv_path}")
    
    # Read the CSV file
    try:
        with open(input_csv_path, 'r', newline='', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            rows = list(reader)
            headers = reader.fieldnames
        print(f"Loaded {len(rows)} inventory records")
    except Exception as e:
        print(f"Error reading CSV: {e}")
        return False
    
    # Display current structure
    print(f"\nCSV Structure:")
    print(f"Columns: {headers}")
    
    # Count size variants
    size_counts = defaultdict(int)
    for row in rows:
        if row['Option1 Name'] == 'Frame Size':
            size_counts[row['Option1 Value']] += 1
    
    print(f"\nCurrent size distribution:")
    for size, count in size_counts.items():
        print(f"  {size}: {count} records")
    
    # Update inventory for limited edition model
    updated_count = 0
    
    for row in rows:
        # Only update rows with Frame Size options and location "170 Avenue F" (not Printful)
        if (row['Option1 Name'] == 'Frame Size' and 
            row['Location'] == '170 Avenue F' and
            row['Option1 Value'] in SIZE_ALLOCATIONS):
            
            size = row['Option1 Value']
            allocation = SIZE_ALLOCATIONS[size]
            
            # Update inventory quantities
            row['Available'] = str(allocation)
            row['On hand'] = str(allocation)
            row['Incoming'] = '0'
            row['Unavailable'] = '0'
            row['Committed'] = '0'
            
            updated_count += 1
    
    print(f"\nUpdated {updated_count} inventory records")
    
    # Display updated size distribution
    print(f"\nUpdated limited edition allocations:")
    for size in ['24 x 36', '36 x 48', '53 x 72']:
        size_records = [row for row in rows if row['Location'] == '170 Avenue F' and row['Option1 Value'] == size]
        if size_records:
            total_available = sum(int(row['Available']) for row in size_records if row['Available'].isdigit())
            unique_products = len(set(row['Handle'] for row in size_records))
            print(f"  {size}: {total_available} total units across {unique_products} products ({SIZE_ALLOCATIONS[size]} per product)")
    
    # Save updated CSV
    try:
        with open(output_csv_path, 'w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=headers)
            writer.writeheader()
            writer.writerows(rows)
        print(f"\nSaved updated inventory to: {output_csv_path}")
        return True
    except Exception as e:
        print(f"Error saving CSV: {e}")
        return False

def main():
    """Main function to update inventory."""
    
    input_path = Path("/Users/kinglerbercy/Projects/vivid_mas/data/exports/inventory_export_1.csv")
    output_path = Path("/Users/kinglerbercy/Projects/vivid_mas/data/exports/inventory_export_limited_edition.csv")
    
    if not input_path.exists():
        print(f"Error: Input file not found: {input_path}")
        sys.exit(1)
    
    print("VividWalls Limited Edition Inventory Update")
    print("=" * 50)
    print(f"Business Model: Limited edition prints with allocated quantities")
    print(f"Edition size: 100 units per artwork")
    print(f"Size allocations:")
    print(f"  - 24x36 (Small): 50 units")
    print(f"  - 36x48 (Medium): 35 units") 
    print(f"  - 53x72 (Large): 15 units")
    print("=" * 50)
    
    success = update_limited_edition_inventory(input_path, output_path)
    
    if success:
        print(f"\n✅ Inventory successfully updated for limited edition model!")
        print(f"📄 Updated file: {output_path}")
        print(f"\nNext steps:")
        print(f"1. Review the updated inventory file")
        print(f"2. Import to Shopify using the inventory widget deployment")
        print(f"3. Test the limited edition widget on product pages")
    else:
        print(f"\n❌ Failed to update inventory")
        sys.exit(1)

if __name__ == "__main__":
    main()