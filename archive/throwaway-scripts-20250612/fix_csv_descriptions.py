#!/usr/bin/env python3
"""
Fix formatting issues in product descriptions:
1. Add spaces between words that are missing spaces
2. Replace "Kingler Bercy" with "the artist"
"""

import csv
import re
import sys

def fix_description_formatting(description):
    """Fix formatting issues in product descriptions."""
    if not description:
        return description
    
    # Replace Kingler Bercy with "the artist"
    description = description.replace("Kingler Bercy", "the artist")
    description = description.replace("kingler bercy", "the artist")
    description = description.replace("KINGLER BERCY", "the artist")
    
    # Fix common spacing issues
    # Add space after "from" when followed by "the" without space
    description = re.sub(r'from\s*the([A-Z])', r'from the \1', description)
    
    # Add space between lowercase letter followed by uppercase letter (common issue)
    description = re.sub(r'([a-z])([A-Z])', r'\1 \2', description)
    
    # Fix specific patterns found in the data
    description = description.replace("Echosfrom the", "Echoes from the")
    description = description.replace("no1from the", "no1 from the")
    description = description.replace("no2from the", "no2 from the")
    description = description.replace("no3from the", "no3 from the")
    description = description.replace("no4from the", "no4 from the")
    description = description.replace("No.1from the", "No.1 from the")
    description = description.replace("No.2from the", "No.2 from the")
    description = description.replace("Earthfrom the", "Earth from the")
    description = description.replace("Huefrom the", "Hue from the")
    
    # Fix collection names that might be concatenated
    description = description.replace("theGeometric", "the Geometric")
    description = description.replace("theResonating", "the Resonating")
    description = description.replace("theChromatic", "the Chromatic")
    description = description.replace("theIntersecting", "the Intersecting")
    description = description.replace("theShape", "the Shape")
    
    # Fix specific words that might be concatenated
    description = description.replace("Intersectcollection", "Intersect collection")
    description = description.replace("Structurecollection", "Structure collection")
    description = description.replace("Echoescollection", "Echoes collection")
    description = description.replace("Spacescollection", "Spaces collection")
    description = description.replace("Symmetrycollection", "Symmetry collection")
    description = description.replace("Emergencecollection", "Emergence collection")
    
    # Clean up any double spaces that might have been created
    description = re.sub(r'\s+', ' ', description)
    
    return description.strip()

def process_csv(input_file, output_file):
    """Process the CSV file and fix descriptions."""
    rows_processed = 0
    descriptions_fixed = 0
    
    with open(input_file, 'r', encoding='utf-8') as infile, \
         open(output_file, 'w', encoding='utf-8', newline='') as outfile:
        
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            rows_processed += 1
            
            # Fix Body (HTML) field
            if 'Body (HTML)' in row and row['Body (HTML)']:
                original = row['Body (HTML)']
                fixed = fix_description_formatting(original)
                if original != fixed:
                    descriptions_fixed += 1
                    row['Body (HTML)'] = fixed
            
            # Also fix SEO Description field
            if 'SEO Description' in row and row['SEO Description']:
                original = row['SEO Description']
                fixed = fix_description_formatting(original)
                if original != fixed:
                    row['SEO Description'] = fixed
            
            writer.writerow(row)
    
    print(f"Processed {rows_processed} rows")
    print(f"Fixed {descriptions_fixed} descriptions")
    print(f"Output saved to: {output_file}")

if __name__ == "__main__":
    input_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls Product Catalog Updated-Recent.csv"
    output_file = "/Users/kinglerbercy/Projects/vivid_mas/data/exports/Vividwalls Product Catalog Updated-Fixed.csv"
    
    try:
        process_csv(input_file, output_file)
    except Exception as e:
        print(f"Error processing file: {e}")
        sys.exit(1)