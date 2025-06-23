#!/usr/bin/env python3
"""
Script to remove CSS styling from HTML product description files
and convert keywords to comma-separated format.
"""

import os
import re
from pathlib import Path

def remove_css_and_convert_keywords(html_content):
    """
    Remove CSS styling and convert keywords to comma-separated format.
    """
    # Remove the entire <style> section
    html_content = re.sub(r'<style>.*?</style>', '', html_content, flags=re.DOTALL)
    
    # Extract keywords from styled spans
    keyword_pattern = r'<span style="[^"]*">([^<]+)</span>'
    keywords = re.findall(keyword_pattern, html_content)
    
    # Create comma-separated keyword list
    keywords_list = ', '.join(keywords) if keywords else ''
    
    # Remove the entire keywords div section with styled spans
    html_content = re.sub(
        r'<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: start;">.*?</div>',
        f'<div class="keywords">{keywords_list}</div>' if keywords_list else '<div class="keywords"></div>',
        html_content,
        flags=re.DOTALL
    )
    
    # Clean up extra whitespace and normalize formatting
    html_content = re.sub(r'\n\s*\n', '\n', html_content)
    html_content = html_content.strip()
    
    return html_content

def process_html_files(directory_path):
    """
    Process all HTML files in the specified directory.
    """
    directory = Path(directory_path)
    
    if not directory.exists():
        print(f"Directory {directory_path} does not exist!")
        return
    
    html_files = list(directory.glob("*.html"))
    
    if not html_files:
        print(f"No HTML files found in {directory_path}")
        return
    
    print(f"Found {len(html_files)} HTML files to process...")
    
    processed_count = 0
    
    for html_file in html_files:
        try:
            # Skip description.md file
            if html_file.name == 'description.md':
                continue
                
            print(f"Processing: {html_file.name}")
            
            # Read the file
            with open(html_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Process the content
            processed_content = remove_css_and_convert_keywords(content)
            
            # Write back to file
            with open(html_file, 'w', encoding='utf-8') as f:
                f.write(processed_content)
            
            processed_count += 1
            
        except Exception as e:
            print(f"Error processing {html_file.name}: {str(e)}")
    
    print(f"\nProcessing complete! {processed_count} files processed successfully.")

def main():
    """
    Main function to run the script.
    """
    # Directory containing the HTML files
    directory_path = "data/product-description"
    
    print("Starting CSS removal and keyword conversion process...")
    print(f"Target directory: {directory_path}")
    
    # Process all HTML files
    process_html_files(directory_path)

if __name__ == "__main__":
    main() 