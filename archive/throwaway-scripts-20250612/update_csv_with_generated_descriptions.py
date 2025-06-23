#!/usr/bin/env python3
"""
Update CSV with the professional descriptions that were generated during processing.
This script reads the generated descriptions from the processing logs and updates the CSV.
"""

import os
import sys
import pandas as pd
from pathlib import Path
from dotenv import load_dotenv
import logging
from datetime import datetime
import shutil

# Load environment variables
load_dotenv()

# Add current directory to path for imports
sys.path.append('.')

try:
    from update_product_descriptions import ProductDescriptionUpdater
except ImportError as e:
    print(f"Failed to import ProductDescriptionUpdater: {e}")
    sys.exit(1)

# Configuration
CSV_FILE = "data/exports/backups/shopify_products_upload_reconciled_backup_20250605_060609.csv"
OUTPUT_CSV = "data/exports/shopify_products_upload_reconciled_VISION_ENHANCED.csv"
BACKUP_DIR = "data/exports/backups"

def setup_logging():
    """Set up logging"""
    log_filename = f"logs/csv_update_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    Path("logs").mkdir(exist_ok=True)
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_filename),
            logging.StreamHandler(sys.stdout)
        ]
    )
    
    return logging.getLogger(__name__)

def get_processed_handles():
    """Get list of handles that have visual analyses"""
    processed = set()
    analysis_dir = Path("data/product-description")
    
    for file in analysis_dir.glob("*-visual-analysis.md"):
        handle = file.stem.replace("-visual-analysis", "")
        processed.add(handle)
    
    return processed

def regenerate_descriptions_for_processed_handles(updater, processed_handles, df):
    """Regenerate professional descriptions for handles that have visual analyses"""
    descriptions = {}
    
    print(f"🔄 Regenerating descriptions for {len(processed_handles)} processed products...")
    
    for i, handle in enumerate(processed_handles, 1):
        try:
            print(f"[{i}/{len(processed_handles)}] Generating description for: {handle}")
            
            # Check if we have HTML description data
            if handle not in updater.html_descriptions:
                print(f"  ⚠ No HTML description found for {handle}, skipping")
                continue
            
            desc_data = updater.html_descriptions[handle]
            
            # Find the first row with this handle to get image info
            product_rows = df[df['Handle'] == handle]
            if product_rows.empty:
                print(f"  ⚠ No CSV row found for {handle}, skipping")
                continue
            
            product_row = product_rows.iloc[0]
            
            # Check if image exists
            image_path = f"assets/images/{handle}.png"
            if not os.path.exists(image_path):
                print(f"  ⚠ No image found for {handle}, using text-only enhancement")
                image_path = ""
            
            # Generate professional description
            enhanced_description = updater.enhance_description_with_llm(
                desc_data['full_description'],
                desc_data['title'],
                desc_data.get('keywords', ''),
                image_path,
                desc_data.get('collection', '')
            )
            
            if enhanced_description:
                descriptions[handle] = enhanced_description
                print(f"  ✓ Generated description ({len(enhanced_description)} chars)")
            else:
                print(f"  ✗ Failed to generate description")
                
        except Exception as e:
            print(f"  ✗ Error processing {handle}: {str(e)}")
    
    return descriptions

def update_csv_file(descriptions, logger):
    """Update the CSV file with the generated descriptions"""
    try:
        # Read the CSV file
        logger.info(f"Reading CSV file: {CSV_FILE}")
        df = pd.read_csv(CSV_FILE)
        
        # Create backup
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_path = os.path.join(BACKUP_DIR, f"original_backup_{timestamp}.csv")
        shutil.copy2(CSV_FILE, backup_path)
        logger.info(f"Created backup: {backup_path}")
        
        # Track updates
        body_updates = 0
        seo_updates = 0
        
        # Update each row
        for index, row in df.iterrows():
            handle = row.get('Handle', '')
            
            if handle in descriptions:
                description = descriptions[handle]
                
                # Update Body (HTML) column
                df.at[index, 'Body (HTML)'] = description
                body_updates += 1
                
                # Update SEO Description column
                df.at[index, 'SEO Description'] = description
                seo_updates += 1
                
                logger.debug(f"Updated {handle} with {len(description)} char description")
        
        # Save updated CSV
        df.to_csv(OUTPUT_CSV, index=False)
        
        # Log results
        logger.info("Update Summary:")
        logger.info(f"  Total rows in CSV: {len(df)}")
        logger.info(f"  Products with new descriptions: {len(descriptions)}")
        logger.info(f"  Body (HTML) updates: {body_updates}")
        logger.info(f"  SEO Description updates: {seo_updates}")
        logger.info(f"  Output file: {OUTPUT_CSV}")
        logger.info(f"  Backup created: {backup_path}")
        
        return True
        
    except Exception as e:
        logger.error(f"Error updating CSV: {str(e)}")
        return False

def main():
    """Main function"""
    logger = setup_logging()
    
    print("Vision-Enhanced CSV Update Process")
    print("=" * 50)
    
    # Check if files exist
    if not os.path.exists(CSV_FILE):
        logger.error(f"CSV file not found: {CSV_FILE}")
        return False
    
    # Initialize updater
    try:
        updater = ProductDescriptionUpdater()
        if not updater.anthropic_client:
            logger.warning("Anthropic client not available, using existing descriptions only")
        print("✓ System initialized")
    except Exception as e:
        logger.error(f"Failed to initialize updater: {e}")
        return False
    
    # Load HTML descriptions
    if not updater.load_html_descriptions():
        logger.error("Failed to load HTML descriptions")
        return False
    
    print(f"✓ Loaded {len(updater.html_descriptions)} HTML descriptions")
    
    # Read CSV
    try:
        df = pd.read_csv(CSV_FILE)
        print(f"✓ Read CSV with {len(df)} rows")
    except Exception as e:
        logger.error(f"Failed to read CSV: {e}")
        return False
    
    # Get processed handles
    processed_handles = get_processed_handles()
    print(f"✓ Found {len(processed_handles)} products with visual analyses")
    
    if not processed_handles:
        print("⚠ No processed products found. Run the batch processing first.")
        return False
    
    # Generate descriptions for processed handles
    if updater.anthropic_client:
        descriptions = regenerate_descriptions_for_processed_handles(updater, processed_handles, df)
    else:
        print("⚠ No Anthropic client available, cannot generate new descriptions")
        return False
    
    if not descriptions:
        print("✗ No descriptions were generated")
        return False
    
    print(f"✓ Generated {len(descriptions)} professional descriptions")
    
    # Update CSV
    success = update_csv_file(descriptions, logger)
    
    if success:
        print("\n🎉 CSV update completed successfully!")
        print(f"📄 Enhanced CSV saved as: {OUTPUT_CSV}")
        print(f"📊 Updated {len(descriptions)} products with professional descriptions")
        return True
    else:
        print("\n✗ CSV update failed")
        return False

if __name__ == "__main__":
    try:
        success = main()
        if not success:
            sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)