#!/usr/bin/env python3
"""
Batch processing script for vision-enhanced product descriptions.
Processes products in smaller batches to avoid timeouts and API rate limits.
"""

import os
import sys
import time
import pandas as pd
from pathlib import Path
from dotenv import load_dotenv

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
BATCH_SIZE = 5  # Process 5 products at a time
DELAY_BETWEEN_BATCHES = 10  # 10 seconds delay between batches
DELAY_BETWEEN_PRODUCTS = 2  # 2 seconds delay between products

def get_processed_handles():
    """Get list of handles that have already been processed"""
    processed = set()
    
    # Check for existing visual analysis files
    analysis_dir = Path("data/product-description")
    for file in analysis_dir.glob("*-visual-analysis.md"):
        handle = file.stem.replace("-visual-analysis", "")
        processed.add(handle)
    
    return processed

def process_batch(updater, df, batch_handles, batch_num):
    """Process a batch of products"""
    print(f"\n🔄 Processing Batch {batch_num} ({len(batch_handles)} products)")
    print("=" * 60)
    
    batch_success = 0
    batch_errors = 0
    
    for i, handle in enumerate(batch_handles, 1):
        try:
            print(f"\n[{i}/{len(batch_handles)}] Processing: {handle}")
            
            # Find the first row with this handle
            product_row = df[df['Handle'] == handle].iloc[0]
            
            # Check if we have HTML description data
            if handle not in updater.html_descriptions:
                print(f"  ⚠ No HTML description found for {handle}, skipping")
                continue
            
            desc_data = updater.html_descriptions[handle]
            
            # Download image
            print(f"  📥 Downloading image...")
            image_path = updater.download_image_from_csv(handle, product_row.to_dict())
            
            if image_path:
                print(f"  ✓ Image downloaded: {os.path.basename(image_path)}")
            else:
                print(f"  ⚠ Image download failed, will use text-only enhancement")
            
            # Enhance description with LLM (with vision if image available)
            print(f"  🤖 Generating professional description...")
            enhanced_description = updater.enhance_description_with_llm(
                desc_data['full_description'],
                desc_data['title'],
                desc_data['keywords'],
                image_path,
                desc_data['collection']
            )
            
            if enhanced_description:
                print(f"  ✓ Professional description created ({len(enhanced_description)} chars)")
                batch_success += 1
            else:
                print(f"  ✗ Description generation failed")
                batch_errors += 1
            
            # Small delay between products to avoid rate limits
            if i < len(batch_handles):
                time.sleep(DELAY_BETWEEN_PRODUCTS)
                
        except Exception as e:
            print(f"  ✗ Error processing {handle}: {str(e)}")
            batch_errors += 1
    
    print(f"\n📊 Batch {batch_num} Summary:")
    print(f"  ✓ Successful: {batch_success}")
    print(f"  ✗ Errors: {batch_errors}")
    
    return batch_success, batch_errors

def main():
    """Main batch processing function"""
    print("Vision-Enhanced Batch Product Description Processing")
    print("=" * 60)
    
    # Check if CSV file exists
    if not os.path.exists(CSV_FILE):
        print(f"✗ CSV file not found: {CSV_FILE}")
        return False
    
    # Initialize updater
    try:
        updater = ProductDescriptionUpdater()
        if not updater.anthropic_client:
            print("✗ Anthropic client not available")
            return False
        print("✓ Vision enhancement system initialized")
    except Exception as e:
        print(f"✗ Failed to initialize updater: {e}")
        return False
    
    # Load HTML descriptions
    if not updater.load_html_descriptions():
        print("✗ Failed to load HTML descriptions")
        return False
    
    print(f"✓ Loaded {len(updater.html_descriptions)} HTML descriptions")
    
    # Read CSV file
    try:
        df = pd.read_csv(CSV_FILE)
        unique_handles = df['Handle'].dropna().unique()
        unique_handles = [h for h in unique_handles if h != '']
        print(f"✓ Found {len(unique_handles)} unique products in CSV")
    except Exception as e:
        print(f"✗ Failed to read CSV: {e}")
        return False
    
    # Filter to only handles we have HTML descriptions for
    available_handles = [h for h in unique_handles if h in updater.html_descriptions]
    print(f"✓ {len(available_handles)} products have HTML descriptions")
    
    # Get already processed handles
    processed_handles = get_processed_handles()
    print(f"✓ {len(processed_handles)} products already processed")
    
    # Get remaining handles to process
    remaining_handles = [h for h in available_handles if h not in processed_handles]
    print(f"📋 {len(remaining_handles)} products remaining to process")
    
    if not remaining_handles:
        print("🎉 All products have already been processed!")
        return True
    
    # Create batches
    batches = []
    for i in range(0, len(remaining_handles), BATCH_SIZE):
        batch = remaining_handles[i:i + BATCH_SIZE]
        batches.append(batch)
    
    print(f"📦 Created {len(batches)} batches of {BATCH_SIZE} products each")
    
    # Process batches
    total_success = 0
    total_errors = 0
    
    for batch_num, batch_handles in enumerate(batches, 1):
        batch_success, batch_errors = process_batch(updater, df, batch_handles, batch_num)
        total_success += batch_success
        total_errors += batch_errors
        
        # Delay between batches (except for the last batch)
        if batch_num < len(batches):
            print(f"\n⏱ Waiting {DELAY_BETWEEN_BATCHES} seconds before next batch...")
            time.sleep(DELAY_BETWEEN_BATCHES)
    
    # Final summary
    print("\n" + "🎉" * 60)
    print("FINAL PROCESSING SUMMARY")
    print("🎉" * 60)
    print(f"Total products processed: {total_success}")
    print(f"Total errors: {total_errors}")
    print(f"Success rate: {(total_success/(total_success+total_errors)*100):.1f}%")
    
    # Check what's been created
    visual_analyses = len(list(Path("data/product-description").glob("*-visual-analysis.md")))
    images_downloaded = len(list(Path("assets/images").glob("*.png")))
    
    print(f"\nFiles created:")
    print(f"  📸 Visual analyses: {visual_analyses}")
    print(f"  🖼 Images downloaded: {images_downloaded}")
    
    print("\n✅ Batch processing completed!")
    print("📝 All visual analyses saved to: data/product-description/")
    print("🖼 All images saved to: assets/images/")
    
    return True

if __name__ == "__main__":
    try:
        success = main()
        if not success:
            sys.exit(1)
    except KeyboardInterrupt:
        print("\n\n⏹ Processing interrupted by user")
        print("✅ Progress has been saved. You can resume by running this script again.")
    except Exception as e:
        print(f"\n✗ Unexpected error: {e}")
        sys.exit(1)