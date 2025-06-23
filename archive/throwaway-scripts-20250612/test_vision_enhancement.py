#!/usr/bin/env python3
"""
Test script for vision-enhanced product description generation.
This script tests the complete pipeline: image download, vision analysis, and professional description writing.
"""

import os
import sys
from pathlib import Path
import pandas as pd
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

def test_vision_enhancement():
    """Test the complete vision enhancement pipeline"""
    
    print("Testing Vision-Enhanced Product Description Generation")
    print("=" * 60)
    
    # Check for API key
    api_key = os.getenv('ANTHROPIC_API_KEY')
    if not api_key:
        print("✗ ANTHROPIC_API_KEY not found in .env file")
        return False
    
    print("✓ Found Anthropic API key in .env file")
    
    # Initialize the updater
    try:
        updater = ProductDescriptionUpdater()
        print("✓ ProductDescriptionUpdater initialized")
    except Exception as e:
        print(f"✗ Failed to initialize updater: {e}")
        return False
    
    # Check if API client is available
    if not updater.anthropic_client:
        print("✗ Anthropic client not available")
        return False
    
    print("✓ Anthropic client ready")
    
    # Load a sample from CSV to get image URL
    csv_file = "data/exports/shopify_products_upload_reconciled.csv"
    if not os.path.exists(csv_file):
        print(f"✗ CSV file not found: {csv_file}")
        return False
    
    print(f"✓ Found CSV file: {csv_file}")
    
    # Read CSV and find first product with image
    try:
        df = pd.read_csv(csv_file)
        sample_row = None
        
        for _, row in df.iterrows():
            handle = row.get('Handle', '')
            image_src = row.get('Image Src', '')
            
            if handle and image_src and handle != '':
                sample_row = row
                break
        
        if sample_row is None:
            print("✗ No products with images found in CSV")
            return False
            
        handle = sample_row['Handle']
        print(f"✓ Testing with product: {handle}")
        
    except Exception as e:
        print(f"✗ Failed to read CSV: {e}")
        return False
    
    # Load corresponding HTML description
    html_file = f"data/product-description/{handle}.html"
    if not os.path.exists(html_file):
        print(f"✗ HTML description file not found: {html_file}")
        return False
    
    print(f"✓ Found HTML description: {html_file}")
    
    # Extract description from HTML
    try:
        extracted_data = updater.extract_text_from_html(html_file)
        if not extracted_data:
            print("✗ Failed to extract data from HTML file")
            return False
        
        print(f"✓ Extracted description ({len(extracted_data['description'])} chars)")
        print(f"  Title: {extracted_data['title']}")
        print(f"  Keywords: {extracted_data.get('keywords', 'None')}")
        print(f"  Collection: {extracted_data.get('collection', 'None')}")
        
    except Exception as e:
        print(f"✗ Failed to extract HTML data: {e}")
        return False
    
    # Test image download
    try:
        print("📥 Downloading artwork image...")
        image_path = updater.download_image_from_csv(handle, sample_row.to_dict())
        
        if not image_path:
            print("✗ Failed to download image")
            return False
        
        if not os.path.exists(image_path):
            print(f"✗ Downloaded image not found: {image_path}")
            return False
        
        print(f"✓ Image downloaded: {image_path}")
        
        # Check file size
        file_size = os.path.getsize(image_path)
        print(f"  File size: {file_size:,} bytes")
        
    except Exception as e:
        print(f"✗ Image download failed: {e}")
        return False
    
    # Test two-step vision analysis process
    try:
        print("🎨 Step 1: Analyzing artwork with Claude Vision...")
        
        # Step 1: Raw visual analysis
        visual_analysis = updater.analyze_artwork_with_vision(
            image_path,
            extracted_data['title']
        )
        
        if not visual_analysis:
            print("✗ Visual analysis failed")
            return False
        
        print(f"✓ Raw visual analysis completed ({len(visual_analysis)} chars)")
        print("\n" + "="*80)
        print("RAW VISUAL ANALYSIS:")
        print("="*80)
        print(visual_analysis)
        print("="*80)
        
        print("\n✍️ Step 2: Creating professional art dealer description...")
        
        # Step 2: Professional description using visual analysis + HTML context
        professional_description = updater.create_professional_description(
            visual_analysis,
            extracted_data['title'],
            extracted_data['description'],
            extracted_data.get('keywords', ''),
            extracted_data.get('collection', '')
        )
        
        if not professional_description:
            print("✗ Professional description creation failed")
            return False
        
        print(f"✓ Professional description completed ({len(professional_description)} chars)")
        print("\n" + "="*80)
        print("FINAL PROFESSIONAL ART DEALER DESCRIPTION:")
        print("="*80)
        print(professional_description)
        print("="*80)
        
        # Validate description quality
        if 750 <= len(professional_description) <= 1000:
            print("✓ Description length is within target range (750-1000 characters)")
        else:
            print(f"⚠ Description length ({len(professional_description)}) is outside target range")
        
        # Check for professional language indicators
        professional_terms = [
            'collection', 'artist', 'contemporary', 'composition', 'palette',
            'limited edition', 'gallery', 'museum', 'aesthetic', 'visual'
        ]
        
        found_terms = [term for term in professional_terms if term.lower() in professional_description.lower()]
        print(f"✓ Professional art terms found: {len(found_terms)}/10")
        print(f"  Terms: {', '.join(found_terms[:5])}{'...' if len(found_terms) > 5 else ''}")
        
        # Show the process benefits
        print(f"\n📊 Process Summary:")
        print(f"  Original HTML description: {len(extracted_data['description'])} chars")
        print(f"  Raw visual analysis: {len(visual_analysis)} chars")
        print(f"  Final professional description: {len(professional_description)} chars")
        print(f"  ✓ Two-step process combines visual AI analysis with contextual knowledge")
        
        return True
        
    except Exception as e:
        print(f"✗ Vision analysis process failed: {e}")
        return False

if __name__ == "__main__":
    success = test_vision_enhancement()
    
    if success:
        print("\n" + "✓" * 60)
        print("✓ Vision enhancement test completed successfully!")
        print("✓ The system is ready to generate professional art descriptions!")
        print("✓ Run: python update_product_descriptions.py")
        print("✓" * 60)
    else:
        print("\n" + "✗" * 60)
        print("✗ Vision enhancement test failed!")
        print("✗ Please check the error messages above and try again.")
        print("✗" * 60)