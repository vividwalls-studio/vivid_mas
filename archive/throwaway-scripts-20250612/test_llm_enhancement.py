#!/usr/bin/env python3
"""
Test script for LLM enhancement of product descriptions.
This script processes a single product to test the Claude API integration.
"""

import os
import sys
from pathlib import Path
from bs4 import BeautifulSoup

try:
    import anthropic
except ImportError:
    print("Missing anthropic package. Please install: pip install anthropic")
    sys.exit(1)

def test_llm_enhancement():
    """Test the LLM enhancement with a single product"""
    
    # Check for API key
    api_key = os.getenv('ANTHROPIC_API_KEY')
    if not api_key:
        print("Please set ANTHROPIC_API_KEY environment variable")
        print("Example: export ANTHROPIC_API_KEY='your-api-key-here'")
        return False
    
    # Initialize Anthropic client
    try:
        client = anthropic.Anthropic(api_key=api_key)
        print("✓ Anthropic API client initialized successfully")
    except Exception as e:
        print(f"✗ Failed to initialize Anthropic client: {e}")
        return False
    
    # Test with crimson-shade.html
    html_file = "data/product-description/crimson-shade.html"
    
    if not os.path.exists(html_file):
        print(f"✗ Test file not found: {html_file}")
        return False
    
    # Extract content from HTML
    try:
        with open(html_file, 'r', encoding='utf-8') as file:
            soup = BeautifulSoup(file.read(), 'html.parser')
        
        # Extract title
        title_element = soup.find('h1', class_='product-title')
        title = title_element.get_text(strip=True) if title_element else ""
        
        # Extract description
        description_div = soup.find('div', class_='description')
        content_div = description_div.find('div')
        
        description_text = ""
        if content_div:
            paragraphs = content_div.find_all('p')
            for p in paragraphs:
                if p.get('style') and 'italic' in p.get('style'):
                    continue
                text = p.get_text(separator=' ', strip=True)
                if text:
                    description_text += text + " "
        
        # Extract keywords
        keywords = ""
        keywords_div = soup.find('div', class_='keywords')
        if keywords_div:
            keywords = keywords_div.get_text(strip=True)
        
        description_text = description_text.strip()
        
        print(f"✓ Extracted content from {html_file}")
        print(f"  Title: {title}")
        print(f"  Original length: {len(description_text)} characters")
        print(f"  Keywords: {keywords}")
        
    except Exception as e:
        print(f"✗ Failed to extract content: {e}")
        return False
    
    # Test LLM enhancement
    try:
        prompt = f"""You are an expert e-commerce copywriter specializing in art and home decor products. Your task is to rewrite a product description to be more engaging, SEO-optimized, and compelling for potential buyers.

PRODUCT INFORMATION:
Title: {title}
Original Description: {description_text}
Keywords: {keywords}

REQUIREMENTS:
1. LENGTH: The final description must be between 750-1000 characters (including spaces)
2. SEO OPTIMIZATION: Include relevant keywords naturally throughout the text
3. COMPELLING LANGUAGE: Use vivid, descriptive language that evokes emotion and desire
4. TARGET AUDIENCE: Art lovers, interior designers, and home decorators
5. FEATURES TO HIGHLIGHT:
   - Visual impact and aesthetic appeal
   - Quality materials and printing
   - Versatility for different spaces
   - Professional gallery-quality finish
   - Color palette and artistic style
6. CALL TO ACTION: Include subtle urgency or exclusivity
7. TECHNICAL DETAILS: Mention printing quality, materials, and durability
8. EMOTIONAL APPEAL: Connect with how the art transforms spaces and moods

STYLE GUIDELINES:
- Use sophisticated yet accessible language
- Write in third person
- Include sensory descriptions (visual impact, texture, etc.)
- Emphasize the transformative power of art
- Balance artistic appreciation with practical benefits
- Include collection name and artist when mentioned

FORMATTING:
- Write as a single flowing paragraph
- No bullet points or special formatting
- Natural sentence flow that reads smoothly

Please rewrite the description following these guidelines. The output should be exactly the enhanced description text with no additional commentary or formatting."""

        print("🤖 Sending request to Claude API...")
        
        response = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            max_tokens=1500,
            temperature=0.7,
            messages=[
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        )
        
        enhanced_description = response.content[0].text.strip()
        
        print("✓ Received response from Claude API")
        print(f"✓ Enhanced description length: {len(enhanced_description)} characters")
        print("\n" + "="*80)
        print("ENHANCED DESCRIPTION:")
        print("="*80)
        print(enhanced_description)
        print("="*80)
        
        # Validate length
        if 750 <= len(enhanced_description) <= 1000:
            print("✓ Description length is within target range (750-1000 characters)")
        else:
            print(f"⚠ Description length ({len(enhanced_description)}) is outside target range")
        
        return True
        
    except Exception as e:
        print(f"✗ LLM enhancement failed: {e}")
        return False

if __name__ == "__main__":
    print("Testing LLM Enhancement for Product Descriptions")
    print("=" * 50)
    
    success = test_llm_enhancement()
    
    if success:
        print("\n✓ LLM enhancement test completed successfully!")
        print("You can now run the full script with: python update_product_descriptions.py")
    else:
        print("\n✗ LLM enhancement test failed!")
        print("Please check your API key and try again.")