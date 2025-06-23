#!/usr/bin/env python3
"""
Script to update variant_images_update.csv with actual URLs from the old VividWalls catalog.
Focuses on extracting "No Frame" variant URLs which show the actual canvas size.
"""

import csv
import sys

def main():
    # Read the old catalog and build a mapping of handle+size to actual URLs
    url_mapping = {}
    
    print("Reading old catalog...")
    with open('data/exports/Vividwalls Catalog v1.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Include both "No Frame" and "NA" frame styles (both represent canvas without frame)
            if row['Frame Style'] in ['No Frame', 'NA'] and row['Variant Image']:
                # For NA frame style, also check that Frame Color is NA (to ensure it's truly frameless)
                if row['Frame Style'] == 'NA' and row['Frame Color'] != 'NA':
                    continue
                key = f"{row['Handle']}|{row['Frame Size']}"
                url_mapping[key] = row['Variant Image']
    
    print(f"Found {len(url_mapping)} no-frame variant URLs")
    
    # Read the current variant_images_update.csv
    rows_to_write = []
    updated_count = 0
    
    print("Updating variant_images_update.csv...")
    with open('variant_images_update.csv', 'r') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        
        for row in reader:
            if row['Finish'] == 'Gallery Wrapped Stretched Canvas':
                key = f"{row['Handle']}|{row['Size']}"
                if key in url_mapping:
                    row['Variant Image URL'] = url_mapping[key]
                    updated_count += 1
                    print(f"Updated: {row['Handle']} - {row['Size']}")
            
            rows_to_write.append(row)
    
    # Write the updated file
    with open('variant_images_update_with_actual_urls.csv', 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows_to_write)
    
    print(f"\nUpdated {updated_count} entries")
    print("New file created: variant_images_update_with_actual_urls.csv")
    
    # Show sample of updates
    print("\nSample of updates:")
    with open('variant_images_update_with_actual_urls.csv', 'r') as f:
        reader = csv.DictReader(f)
        count = 0
        for row in reader:
            if 'no_frame' in row['Variant Image URL']:
                print(f"{row['Handle']} ({row['Size']}): {row['Variant Image URL']}")
                count += 1
                if count >= 5:
                    break

if __name__ == "__main__":
    main()