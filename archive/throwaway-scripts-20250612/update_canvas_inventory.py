#!/usr/bin/env python3
"""
Update VividWalls inventory for canvas variants (Size + Print Type).

This script processes the inventory CSV and updates quantities for the new variant structure:
- Size: 24x36, 36x48, 53x72
- Print Type: Canvas Roll, Gallery Wrapped Canvas

Limited edition allocation strategy:
- 24x36: 50 units total (25 Canvas Roll + 25 Gallery Wrapped)
- 36x48: 35 units total (18 Canvas Roll + 17 Gallery Wrapped)  
- 53x72: 15 units total (8 Canvas Roll + 7 Gallery Wrapped)

Total edition size: 100 units per artwork
"""

import csv
import sys
from pathlib import Path
from collections import defaultdict

def update_canvas_inventory(input_csv_path, output_csv_path):
    """
    Update inventory quantities for canvas variants.
    
    Args:
        input_csv_path: Path to input CSV file
        output_csv_path: Path to output CSV file
    """
    
    # Limited edition allocation strategy for canvas variants
    CANVAS_ALLOCATIONS = {
        ('24x36', 'Canvas Roll'): 25,
        ('24x36', 'Gallery Wrapped Canvas'): 25,
        ('36x48', 'Canvas Roll'): 18,
        ('36x48', 'Gallery Wrapped Canvas'): 17,
        ('53x72', 'Canvas Roll'): 8,
        ('53x72', 'Gallery Wrapped Canvas'): 7,
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
    
    # Count canvas variant combinations
    canvas_counts = defaultdict(int)
    for row in rows:
        if row['Option1 Name'] == 'Size' and row['Option2 Name'] == 'Print Type':
            combo = (row['Option1 Value'], row['Option2 Value'])
            canvas_counts[combo] += 1
    
    print(f"\nCurrent canvas variant distribution:")
    for combo, count in canvas_counts.items():
        print(f"  {combo[0]} - {combo[1]}: {count} records")
    
    # Update inventory for canvas limited edition model
    updated_count = 0
    
    for row in rows:
        # Only update rows with Size + Print Type options and location "170 Avenue F" (not Printful)
        if (row['Option1 Name'] == 'Size' and 
            row['Option2 Name'] == 'Print Type' and
            row['Location'] == '170 Avenue F'):
            
            size = row['Option1 Value']
            print_type = row['Option2 Value']
            combo = (size, print_type)
            
            if combo in CANVAS_ALLOCATIONS:
                allocation = CANVAS_ALLOCATIONS[combo]
                
                # Update inventory quantities
                row['Available'] = str(allocation)
                row['On hand'] = str(allocation)
                row['Incoming'] = '0'
                row['Unavailable'] = '0'
                row['Committed'] = '0'
                
                updated_count += 1
    
    print(f"\nUpdated {updated_count} canvas inventory records")
    
    # Display updated canvas allocations
    print(f"\nUpdated limited edition canvas allocations:")
    size_totals = {'24x36': 0, '36x48': 0, '53x72': 0}
    
    for (size, print_type), allocation in CANVAS_ALLOCATIONS.items():
        canvas_records = [row for row in rows if 
                         row['Location'] == '170 Avenue F' and 
                         row['Option1 Value'] == size and 
                         row['Option2 Value'] == print_type]
        
        if canvas_records:
            total_available = sum(int(row['Available']) for row in canvas_records if row['Available'].isdigit())
            unique_products = len(set(row['Handle'] for row in canvas_records))
            print(f"  {size} - {print_type}: {total_available} total units across {unique_products} products ({allocation} per product)")
            size_totals[size] += total_available
    
    print(f"\nSize totals:")
    for size, total in size_totals.items():
        print(f"  {size}: {total} total units")
    
    print(f"\nTotal edition size per artwork: {sum(size_totals.values()) // len(set(row['Handle'] for row in rows if row['Location'] == '170 Avenue F' and row['Option1 Name'] == 'Size'))} units")
    
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
    """Main function to update canvas inventory."""
    
    input_path = Path("/Users/kinglerbercy/Projects/vivid_mas/data/exports/inventory_export_1.csv")
    output_path = Path("/Users/kinglerbercy/Projects/vivid_mas/data/exports/inventory_export_canvas_limited_edition.csv")
    
    if not input_path.exists():
        print(f"Error: Input file not found: {input_path}")
        sys.exit(1)
    
    print("VividWalls Canvas Limited Edition Inventory Update")
    print("=" * 60)
    print(f"New Variant Structure: Size + Print Type")
    print(f"Print Types: Canvas Roll, Gallery Wrapped Canvas")
    print(f"Edition size: 100 units per artwork")
    print(f"Canvas allocations:")
    print(f"  24x36: 50 total (25 Canvas Roll + 25 Gallery Wrapped)")
    print(f"  36x48: 35 total (18 Canvas Roll + 17 Gallery Wrapped)")
    print(f"  53x72: 15 total (8 Canvas Roll + 7 Gallery Wrapped)")
    print("=" * 60)
    
    success = update_canvas_inventory(input_path, output_path)
    
    if success:
        print(f"\n✅ Canvas inventory successfully updated for limited edition model!")
        print(f"📄 Updated file: {output_path}")
        print(f"\nNext steps:")
        print(f"1. Review the updated canvas inventory file")
        print(f"2. Update Shopify inventory widget for canvas variants")
        print(f"3. Test the limited edition widget with canvas options")
        print(f"4. Update widget documentation for new variant structure")
    else:
        print(f"\n❌ Failed to update canvas inventory")
        sys.exit(1)

if __name__ == "__main__":
    main()