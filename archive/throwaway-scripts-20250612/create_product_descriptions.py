#!/usr/bin/env python3
"""
Product Description Generator
Creates individual HTML files for each product with optimized 60-character descriptions
"""

import csv
import os
import re
from html import unescape

def clean_html(html_text):
    """Remove HTML tags and clean up text"""
    if not html_text:
        return ""
    
    # Remove HTML tags
    clean = re.sub('<[^<]+?>', '', html_text)
    # Decode HTML entities
    clean = unescape(clean)
    # Remove extra whitespace
    clean = ' '.join(clean.split())
    return clean

def create_60_char_description(title, original_description, handle):
    """
    Create optimized 60-character descriptions based on product analysis
    Using first principles: Art buyers want to know the style, collection, and key visual elements
    """
    
    # Extract collection name from original description
    collection_match = re.search(r'from the ([^.]+) collection', original_description, re.IGNORECASE)
    collection = collection_match.group(1) if collection_match else ""
    
    # Clean collection name
    if collection:
        collection = collection.replace(" collection", "").strip()
    
    # Mapping for optimized descriptions based on handle analysis
    descriptions = {
        'intersecting-perspectives-no3': 'Geometric abstract art with intersecting lines & perspective',
        'intersecting-perspectives-no2': 'Bold geometric composition with dynamic intersecting forms',
        'untiled-n011': 'Intersecting Perspectives No1: geometric abstract artwork',
        'deep-echoes': 'Vibrant geometric composition from Chromatic Echoes series',
        'space-form-no4': 'Abstract geometric artwork exploring space & form concepts',
        'vista-echoes': 'Evocative geometric shapes & colors from Chromatic series',
        'noir-echoes': 'Striking monochrome digital tapestry with geometric forms',
        'emerald-echoes': 'Green geometric abstract with dynamic color & shape play',
        'earth-echoes': 'Symmetrical earth-toned geometric design from collection',
        'space-form-no3': 'Compelling geometric exploration of texture & space art',
        'space-form-no2': 'Abstract geometric artwork with textural depth & form',
        'space-form-no1': 'Geometric narrative of texture & space from collection',
        'noir-structures': 'Monochrome geometric exploration with intersecting forms',
        'teal-earth': 'Captivating teal digital art with geometric intersections',
        'primary-hue': 'Geometric abstraction with primary colors & bold forms',
        'textured-noir-no1': 'Fractal-inspired textured artwork in monochrome tones',
        'textured-royal-no1': 'Royal-toned fractal geometric with textured patterns',
        'noir-shade': 'Complex geometric interplay in dramatic black & white',
        'royal-shade': 'Royal purple geometric with complex overlapping shapes',
        'crimson-shade': 'Dramatic red geometric with intricate shape emergence',
        'rusty-shade': 'Earthy rust-toned geometric with organic complexity',
        'earthy-shade': 'Complex earth-toned geometric abstraction with depth',
        'emerald-shade': 'Green geometric overlay with complex shape patterns',
        'purple-shade': 'Purple geometric interplay with dynamic shape forms',
        'festive-patterns-no3': 'Vibrant geometric patterns with festive color energy',
        'festive-patterns-no1': 'Dynamic geometric interplay with bright festive hues',
        'festive-patterns-no2': 'Overlapping geometric array in vibrant festive colors',
        'earthy-kimono': 'Japanese-inspired geometric pattern in earth tones',
        'dark-kimono': 'Bold geometric kimono pattern in striking dark colors',
        'teal-kimono': 'Intricate teal geometric kimono with symmetrical design',
        'red-kimono': 'Striking red geometric assembly with kimono aesthetics',
        'royal-kimono': 'Commanding geometric kimono in regal purple tones',
        'monochrome-kimono': 'Balanced black & white geometric kimono pattern',
        'noir-weave': 'Grayscale geometric weave with captivating visual depth',
        'structured-noir-no2': 'Bold monochromatic geometric with structured forms',
        'structured-noir-no1': 'Elegant black & white geometric intersection design',
        'prismatic-warmth': 'Warm-toned abstract geometric with prismatic effects',
        'crystalline-blue': 'Angular blue geometric forms with crystalline beauty',
        'verdant-layers': 'Forest-inspired green geometric symphony with depth',
        'parallelogram-illusion-no1': 'Abstract geometric playing with visual perception',
        'parallelogram-illusion-no2': 'Geometric composition creating optical illusion effects',
        'earthy-weave': 'Nature-inspired geometric weave in harmonious earth tones',
        'olive-weave': 'Geometric harmony in sophisticated olive color palette',
        'pink-weave': 'Bold pink geometric abstraction with dynamic color play',
        'vivid-mosaic-no1': 'Abstract digital masterpiece with vibrant mosaic forms',
        'vivid-mosaic-no2': 'Expressive mosaic artwork with dynamic color composition',
        'vivid-mosaic-no3': 'Striking mosaic showcasing digital artistry & vibrance',
        'vivid-mosaic-no4': 'Visually arresting mosaic with bold geometric patterns',
        'vivid-mosaic-no7': 'Abstract mosaic full of vitality & colorful energy',
        'noir-mosaic-no1': 'Profound monochrome mosaic with geometric sophistication',
        'noir-mosaic-no2': 'Striking black & white mosaic with distinctive style',
        'noir-mosaic-no3': 'Digital homage to mosaic tradition in monochrome tones',
        'vivid-mosaic-no6': 'Celebration of digital medium with vivid mosaic forms',
        'vivid-mosaic-no5': 'Rich digital tapestry with encapsulated mosaic beauty',
        'fractal-color-dark-double': 'Symmetric fractal art with mesmerizing geometric patterns',
        'fractal-color-red': 'Complex red fractal exploring shape & color dynamics',
        'fractal-color-light': 'Stunning light fractal display with geometric beauty',
        'fractal-color-dark': 'Rich dark fractal with geometric complexity & depth',
        'fractal-noir': 'Elegant monochrome fractal with sophisticated patterns',
        'fractal-noir-double': 'Black & white fractal study with powerful geometry',
        'fractal-double-red': 'Compelling red fractal fusion of texture & geometry'
    }
    
    # Get the optimized description
    optimized = descriptions.get(handle, "")
    
    # If we don't have a custom description, create one
    if not optimized:
        # Extract key words from title and description
        words = title.split()
        if collection:
            optimized = f"{title} from {collection} collection"
        else:
            optimized = f"Abstract geometric artwork: {title}"
        
        # Ensure it's under 60 characters
        if len(optimized) > 60:
            optimized = optimized[:57] + "..."
    
    # Final check and trim if needed
    if len(optimized) > 60:
        optimized = optimized[:57] + "..."
    
    return optimized

def create_html_file(handle, title, description, output_dir):
    """Create an individual HTML file for each product"""
    
    filename = f"{handle}.html"
    filepath = os.path.join(output_dir, filename)
    
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - Product Description</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 40px;
            color: #333;
        }}
        .product-card {{
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            max-width: 600px;
            margin: 0 auto;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .product-title {{
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }}
        .description {{
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }}
        .meta {{
            font-size: 0.9em;
            color: #666;
            margin-top: 15px;
        }}
        .char-count {{
            text-align: right;
            font-weight: bold;
            color: #27ae60;
        }}
    </style>
</head>
<body>
    <div class="product-card">
        <h1 class="product-title">{title}</h1>
        <div class="description">
            <p>{description}</p>
        </div>
        <div class="meta">
            <div><strong>Handle:</strong> {handle}</div>
            <div class="char-count">Character Count: {len(description)}/60</div>
        </div>
    </div>
</body>
</html>"""
    
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(html_content)
    
    return filepath

def main():
    """Main function to process all products and create HTML files"""
    
    # Read products from CSV
    products = {}
    with open('data/exports/products_export-6-4-25.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        
        for row in reader:
            handle = row.get('Handle', '').strip()
            title = row.get('Title', '').strip()
            body_html = row.get('Body (HTML)', '').strip()
            
            if handle and title and body_html and handle not in products:
                clean_description = clean_html(body_html)
                products[handle] = {
                    'title': title,
                    'original_html': body_html,
                    'clean_description': clean_description,
                    'length': len(clean_description)
                }
    
    # Create output directory
    output_dir = '/Users/kinglerbercy/Projects/vivid_mas/data/product-description'
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each product
    created_files = []
    for handle, data in products.items():
        # Create 60-character description
        short_description = create_60_char_description(
            data['title'], 
            data['clean_description'], 
            handle
        )
        
        # Create HTML file
        filepath = create_html_file(
            handle, 
            data['title'], 
            short_description, 
            output_dir
        )
        
        created_files.append({
            'handle': handle,
            'title': data['title'],
            'original_length': data['length'],
            'new_length': len(short_description),
            'description': short_description,
            'file': filepath
        })
        
        print(f"✓ Created: {handle}.html ({len(short_description)}/60 chars)")
        print(f"  Description: {short_description}")
        print()
    
    # Summary
    print(f"\n{'='*60}")
    print(f"SUMMARY: Created {len(created_files)} HTML files")
    print(f"Directory: {output_dir}")
    print(f"{'='*60}")
    
    return created_files

if __name__ == "__main__":
    main() 