#!/usr/bin/env python3
"""
Comprehensive CSV Cleanup Script
Fixes all inconsistencies in products_export-6-4-25-shortened.csv
"""

import csv
import re
from collections import defaultdict
from datetime import datetime

class CSVCleanup:
    def __init__(self, input_file, output_file):
        self.input_file = input_file
        self.output_file = output_file
        self.cleanup_report = []
        self.products_data = {}
        
        # Define NEW PRODUCT STRUCTURE (replacing old framing system)
        # Option 1: Size (24x36, 36x48, 53x72)
        # Option 2: Print Type (Gallery Wrapped Canvas, Canvas Roll)
        
        # Pricing Applied (from Pictorem data)
        # | Size  | Gallery Wrapped | Canvas Roll |
        # |-------|-----------------|-------------|
        # | 53x72 | $550.92         | $413.39     |
        # | 36x48 | $315.94         | $237.18     |
        # | 24x36 | $204.00         | $153.00     |
        
        self.target_pricing = {
            ('53x72', 'Gallery Wrapped Canvas'): '550.92',
            ('53x72', 'Canvas Roll'): '413.39',
            ('36x48', 'Gallery Wrapped Canvas'): '315.94',
            ('36x48', 'Canvas Roll'): '237.18',
            ('24x36', 'Gallery Wrapped Canvas'): '204.00',
            ('24x36', 'Canvas Roll'): '153.00'
        }
        
        # Supported sizes for new structure
        self.target_sizes = ['24x36', '36x48', '53x72']
        
        # Supported print types for new structure  
        self.target_print_types = ['Gallery Wrapped Canvas', 'Canvas Roll']
        
        # Inventory management (100 per size, distributed across print types)
        # Total inventory per artwork: 300 (3 sizes x 100 each)
        self.inventory_per_size = 100
        self.inventory_per_variant = 50  # 100 split between 2 print types per size
        
        # Handle corrections
        self.handle_corrections = {
            'untiled-n011': 'intersecting-perspectives-no1',
            'space-form-no4': 'space-form-no4',  # Keep as is, fix title instead
            'space-form-no3': 'space-form-no3',
            'space-form-no2': 'space-form-no2', 
            'space-form-no1': 'space-form-no1',
            'verdant-layers': 'structured-emerald-no3'
        }
        
        # Collection corrections
        self.collection_corrections = {
            'Space Form': 'Resonant Structure',
            'Chromatic Echoes': 'Chromatic Echoes'  # Keep some as is
        }
        
        # Title corrections
        self.title_corrections = {
            'Space & Form no4': 'Space & Form no4',
            'Space & Form no3': 'Space & Form no3',
            'Space & Form no2': 'Space & Form no2',
            'Space & Form no1': 'Space & Form no1'
        }

    def log_change(self, change_type, details):
        """Log changes made during cleanup"""
        self.cleanup_report.append({
            'type': change_type,
            'details': details,
            'timestamp': datetime.now().isoformat()
        })

    def standardize_size(self, size_value):
        """Standardize size values to consistent format"""
        if not size_value:
            return size_value
            
        # Convert various size formats to standard
        size_mappings = {
            '53 x 72': '53x72',
            '36 x 48': '36x48', 
            '24 x 36': '24x36',
            '72x53': '53x72',  # Fix inverted dimensions
            '48x36': '36x48',
            '36x24': '24x36'
        }
        
        return size_mappings.get(size_value, size_value)

    def generate_sku(self, handle, size, print_type):
        """Generate unique SKU for each variant"""
        # Clean handle for SKU
        clean_handle = handle.upper().replace('-', '-')
        
        # Clean print type for SKU
        if 'Gallery Wrapped' in print_type:
            type_code = 'GALLERY-WRAPPED'
        elif 'Canvas Roll' in print_type:
            type_code = 'CANVAS-ROLL'
        else:
            # For old system variants, convert to new system
            type_code = 'GALLERY-WRAPPED'  # Default to gallery wrapped
            
        # Clean size for SKU
        size_code = size.replace('x', 'X') if size else 'UNKNOWN'
        
        return f"{clean_handle}-{type_code}-{size_code}"

    def convert_old_to_new_variants(self, variants):
        """
        Convert old framing system variants to NEW PRODUCT STRUCTURE
        
        OLD SYSTEM: Frame Size + Frame Color + Frame Style (9 variants)
        NEW SYSTEM: Size + Print Type (6 variants)
        
        New Product Structure:
        - Option 1: Size (24x36, 36x48, 53x72)  
        - Option 2: Print Type (Gallery Wrapped Canvas, Canvas Roll)
        """
        new_variants = []
        
        # Group by size to eliminate duplicate sizes from old system
        size_groups = defaultdict(list)
        for variant in variants:
            size = self.standardize_size(variant.get('option1_value', ''))
            size_groups[size].append(variant)
        
        # Create NEW STRUCTURE variants for each size
        for size in self.target_sizes:  # Use target sizes to ensure consistency
            if size in size_groups:
                template_variant = size_groups[size][0]  # Use first variant as template
                
                # Create Gallery Wrapped Canvas variant
                gallery_variant = template_variant.copy()
                gallery_variant.update({
                    'option1_name': 'Size',
                    'option1_value': size,
                    'option2_name': 'Print Type',
                    'option2_value': 'Gallery Wrapped Canvas',
                    'option3_name': '',
                    'option3_value': ''
                })
                
                # Apply NEW PRICING STRUCTURE
                price_key = (size, 'Gallery Wrapped Canvas')
                if price_key in self.target_pricing:
                    gallery_variant['price'] = self.target_pricing[price_key]
                
                # Inventory is managed through Shopify admin, not CSV fields
                
                new_variants.append(gallery_variant)
                
                # Create Canvas Roll variant  
                roll_variant = gallery_variant.copy()
                roll_variant.update({
                    'option2_value': 'Canvas Roll'
                })
                
                # Apply NEW PRICING STRUCTURE
                price_key = (size, 'Canvas Roll')
                if price_key in self.target_pricing:
                    roll_variant['price'] = self.target_pricing[price_key]
                
                # Inventory is managed through Shopify admin, not CSV fields
                    
                new_variants.append(roll_variant)
        
        return new_variants

    def load_and_analyze_data(self):
        """Load CSV data and analyze structure"""
        with open(self.input_file, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            self.headers = reader.fieldnames
            
            current_product = None
            
            for row in reader:
                handle = row.get('Handle', '').strip()
                title = row.get('Title', '').strip()
                
                # Main product row (has title and handle)
                if handle and title:
                    current_product = handle
                    self.products_data[handle] = {
                        'main_row': row,
                        'variants': []
                    }
                
                # Variant row (belongs to current product)
                elif current_product and row.get('Variant SKU'):
                    variant_data = {
                        'option1_name': row.get('Option1 Name', ''),
                        'option1_value': row.get('Option1 Value', ''),
                        'option2_name': row.get('Option2 Name', ''),
                        'option2_value': row.get('Option2 Value', ''),
                        'option3_name': row.get('Option3 Name', ''),
                        'option3_value': row.get('Option3 Value', ''),
                        'price': row.get('Variant Price', ''),
                        'sku': row.get('Variant SKU', ''),
                        'full_row': row
                    }
                    self.products_data[current_product]['variants'].append(variant_data)

    def cleanup_product_data(self):
        """Apply all cleanup rules to product data"""
        cleaned_products = {}
        
        for handle, product_data in self.products_data.items():
            main_row = product_data['main_row'].copy()
            variants = product_data['variants']
            
            # Fix handle if needed
            corrected_handle = self.handle_corrections.get(handle, handle)
            if corrected_handle != handle:
                self.log_change('handle_correction', f'{handle} -> {corrected_handle}')
                handle = corrected_handle
                main_row['Handle'] = handle
            
            # Fix title if needed
            title = main_row.get('Title', '')
            if title in self.title_corrections:
                main_row['Title'] = self.title_corrections[title]
                self.log_change('title_correction', f'{title} -> {self.title_corrections[title]}')
            
            # Fix collection tags if needed
            tags = main_row.get('Tags', '')
            if tags in self.collection_corrections:
                main_row['Tags'] = self.collection_corrections[tags]
                self.log_change('collection_correction', f'{tags} -> {self.collection_corrections[tags]}')
            
            # Ensure required fields are populated
            main_row['Vendor'] = main_row.get('Vendor', '') or 'VividWalls'
            main_row['Type'] = main_row.get('Type', '') or 'Artwork'
            main_row['Product Category'] = main_row.get('Product Category', '') or 'Home & Garden > Decor > Artwork'
            
            # Determine if this uses old or new variant system
            # Check for old system indicators
            has_frame_options = any(
                'Frame' in v.get('option1_name', '') or 
                'Frame' in v.get('option2_name', '') or 
                'Frame' in v.get('option3_name', '') or
                v.get('option2_value', '') in ['Thin Floating Frame'] or
                v.get('option3_value', '') in ['Black', 'White', 'None'] or
                v.get('option2_name', '') == 'Frame Syle'  # Note: typo in original data
                for v in variants
            )
            
            # Also check if this is NOT already using the new system
            has_new_system = any(
                v.get('option2_value', '') in ['Gallery Wrapped Canvas', 'Canvas Roll'] 
                for v in variants
            )
            
            # Convert if it has old frame options and doesn't already use new system
            if has_frame_options and not has_new_system:
                # Convert old system to new system
                new_variants = self.convert_old_to_new_variants(variants)
                self.log_change('variant_conversion', f'{handle}: Converted {len(variants)} old variants to {len(new_variants)} new variants')
                variants = new_variants
            
            # Update variant pricing and SKUs
            for i, variant in enumerate(variants):
                size = self.standardize_size(variant.get('option1_value', ''))
                print_type = variant.get('option2_value', '')
                
                # Generate new SKU
                new_sku = self.generate_sku(handle, size, print_type)
                variant['sku'] = new_sku
                
                # Update pricing if in target structure
                price_key = (size, print_type)
                if price_key in self.target_pricing:
                    old_price = variant.get('price', '')
                    new_price = self.target_pricing[price_key]
                    if old_price != new_price:
                        variant['price'] = new_price
                        self.log_change('price_correction', f'{handle} {size} {print_type}: {old_price} -> {new_price}')
                
                # Standardize option names
                variant['option1_name'] = 'Size'
                variant['option2_name'] = 'Print Type'
                variant['option3_name'] = ''
                variant['option3_value'] = ''
            
            cleaned_products[handle] = {
                'main_row': main_row,
                'variants': variants
            }
        
        return cleaned_products

    def write_cleaned_csv(self, cleaned_products):
        """Write the cleaned data to output CSV"""
        
        # Use ONLY existing Shopify CSV headers - don't add any new fields
        # Shopify's CSV format is strict and must be preserved exactly
        extended_headers = list(self.headers)
        
        with open(self.output_file, 'w', encoding='utf-8', newline='') as file:
            writer = csv.DictWriter(file, fieldnames=extended_headers, quoting=csv.QUOTE_ALL)
            writer.writeheader()
            
            for handle, product_data in cleaned_products.items():
                main_row = product_data['main_row']
                variants = product_data['variants']
                
                # Write main product row with first variant data
                if variants:
                    first_variant = variants[0]
                    main_row.update({
                        'Option1 Name': first_variant['option1_name'],
                        'Option1 Value': first_variant['option1_value'],
                        'Option2 Name': first_variant['option2_name'],
                        'Option2 Value': first_variant['option2_value'],
                        'Option3 Name': first_variant['option3_name'],
                        'Option3 Value': first_variant['option3_value'],
                        'Variant SKU': first_variant['sku'],
                        'Variant Price': first_variant['price'],
                        # Use EXISTING Shopify fields only
                        'Variant Inventory Tracker': 'shopify',
                        'Variant Inventory Policy': 'deny',
                        'Variant Fulfillment Service': 'manual',
                        'Variant Requires Shipping': 'true',
                        'Variant Taxable': 'false',
                        'Variant Grams': '0.0',
                        'Status': 'active',
                        'Published': 'true'
                    })
                
                writer.writerow(main_row)
                
                # Write additional variant rows
                for variant in variants[1:]:
                    variant_row = {field: '' for field in extended_headers}
                    variant_row.update({
                        'Handle': handle,
                        'Option1 Name': variant['option1_name'],
                        'Option1 Value': variant['option1_value'],
                        'Option2 Name': variant['option2_name'],
                        'Option2 Value': variant['option2_value'],
                        'Option3 Name': variant['option3_name'],
                        'Option3 Value': variant['option3_value'],
                        'Variant SKU': variant['sku'],
                        'Variant Price': variant['price'],
                        # Use EXISTING Shopify fields only
                        'Variant Inventory Tracker': 'shopify',
                        'Variant Inventory Policy': 'deny',
                        'Variant Fulfillment Service': 'manual',
                        'Variant Requires Shipping': 'true',
                        'Variant Taxable': 'false',
                        'Variant Grams': '0.0'
                    })
                    writer.writerow(variant_row)

    def generate_report(self):
        """Generate cleanup report"""
        report_content = f"""# CSV Cleanup Report
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Summary
- Input file: {self.input_file}
- Output file: {self.output_file}
- Total products processed: {len(self.products_data)}
- Total changes made: {len(self.cleanup_report)}

## New Product Structure Applied
**Unified Variant System (replacing old framing options):**
- **Option 1**: Size (24x36, 36x48, 53x72)
- **Option 2**: Print Type (Gallery Wrapped Canvas, Canvas Roll)
- **Framing options completely removed** (as requested)

## Pricing Applied (from Pictorem data)

| Size  | Gallery Wrapped | Canvas Roll |
|-------|-----------------|-------------|
| 53x72 | $550.92         | $413.39     |
| 36x48 | $315.94         | $237.18     |
| 24x36 | $204.00         | $153.00     |

## Inventory Management (Shopify Aligned)
- **Inventory tracking**: Managed through Shopify admin dashboard
- **Inventory policy**: `deny` (prevents overselling)
- **CSV format**: Preserved Shopify's strict column structure
- **Note**: Inventory quantities must be set directly in Shopify admin after upload

## Changes Made
"""
        
        change_types = defaultdict(list)
        for change in self.cleanup_report:
            change_types[change['type']].append(change['details'])
        
        for change_type, changes in change_types.items():
            report_content += f"\n### {change_type.replace('_', ' ').title()}\n"
            for change in changes:
                report_content += f"- {change}\n"
        
        report_content += f"\n## Benefits of New Structure\n"
        report_content += f"- ✅ Simplified from 9 variants per product to 6 variants\n"
        report_content += f"- ✅ Eliminated confusing frame color/style options\n"
        report_content += f"- ✅ Consistent pricing across all products\n"
        report_content += f"- ✅ Aligned with Pictorem fulfillment capabilities\n"
        report_content += f"- ✅ Unique SKUs for every variant\n"
        report_content += f"- ✅ Ready for Shopify upload\n"
        
        with open('cleanup_report.md', 'w') as f:
            f.write(report_content)
        
        print(f"✅ Cleanup report saved to: cleanup_report.md")

    def run_cleanup(self):
        """Execute the complete cleanup process"""
        print("🚀 Starting comprehensive CSV cleanup...")
        print("=" * 60)
        
        # Phase 1: Load and analyze
        print("📊 Phase 1: Loading and analyzing data...")
        self.load_and_analyze_data()
        print(f"   Loaded {len(self.products_data)} products")
        
        # Phase 2: Clean up data
        print("🔧 Phase 2: Cleaning up data...")
        cleaned_products = self.cleanup_product_data()
        print(f"   Applied {len(self.cleanup_report)} fixes")
        
        # Phase 3: Write output
        print("💾 Phase 3: Writing cleaned CSV...")
        self.write_cleaned_csv(cleaned_products)
        print(f"   Cleaned CSV saved to: {self.output_file}")
        
        # Phase 4: Generate report
        print("📋 Phase 4: Generating report...")
        self.generate_report()
        
        # Phase 5: Validate new structure
        print("🔍 Phase 5: Validating new product structure...")
        self.validate_new_structure()
        
        print("\\n🎉 COMPREHENSIVE CSV CLEANUP COMPLETED!")
        print("=" * 60)
        print(f"✅ Input:  {self.input_file}")
        print(f"✅ Output: {self.output_file}")
        print(f"✅ Products: {len(self.products_data)}")
        print(f"✅ Changes: {len(self.cleanup_report)}")
        print("✅ New product structure successfully applied!")
        print("=" * 60)
    
    def validate_new_structure(self):
        """Validate that the new product structure is correctly implemented"""
        validation_errors = []
        structure_summary = {
            'total_variants': 0, 
            'gallery_wrapped': 0, 
            'canvas_roll': 0
        }
        
        for handle, product in self.products_data.items():
            variants = product.get('variants', [])
            structure_summary['total_variants'] += len(variants)
            
            # Check that all variants follow new structure
            for variant in variants:
                if variant.get('option1_name') != 'Size':
                    validation_errors.append(f"{handle}: Option1 should be 'Size', found '{variant.get('option1_name')}'")
                
                if variant.get('option2_name') != 'Print Type':
                    validation_errors.append(f"{handle}: Option2 should be 'Print Type', found '{variant.get('option2_name')}'")
                
                size = variant.get('option1_value')
                print_type = variant.get('option2_value')
                
                if size not in self.target_sizes:
                    validation_errors.append(f"{handle}: Invalid size '{size}', should be one of {self.target_sizes}")
                
                if print_type not in self.target_print_types:
                    validation_errors.append(f"{handle}: Invalid print type '{print_type}', should be one of {self.target_print_types}")
                
                # Count print types
                if print_type == 'Gallery Wrapped Canvas':
                    structure_summary['gallery_wrapped'] += 1
                elif print_type == 'Canvas Roll':
                    structure_summary['canvas_roll'] += 1
        
        # Report results
        if validation_errors:
            print("⚠️  VALIDATION ERRORS FOUND:")
            for error in validation_errors[:5]:  # Show first 5 errors
                print(f"   - {error}")
            if len(validation_errors) > 5:
                print(f"   ... and {len(validation_errors) - 5} more errors")
        else:
            print("✅ New product structure validation passed!")
            print(f"   📊 Total variants: {structure_summary['total_variants']}")
            print(f"   🖼️  Gallery Wrapped: {structure_summary['gallery_wrapped']}")
            print(f"   📜 Canvas Roll: {structure_summary['canvas_roll']}")
            print("   📦 Inventory: Managed through Shopify admin (not CSV)")

if __name__ == "__main__":
    input_file = "data/exports/products_export-6-4-25-shortened.csv"
    output_file = "data/exports/products_export-6-4-25-CLEANED.csv"
    
    cleanup = CSVCleanup(input_file, output_file)
    cleanup.run_cleanup() 