#!/usr/bin/env python3
"""
Product Description Updater

This script extracts text descriptions from HTML files in the data/product-description directory,
generates shorter versions (max 160 characters), and updates a Shopify product CSV file by:
- Adding short descriptions to the Body (HTML) column for products with empty/long descriptions
- Adding short descriptions to the SEO Title column for products with empty SEO titles
- Preserving all required Shopify column headers and existing data

Usage:
    python update_product_descriptions.py

Requirements:
    pip install beautifulsoup4 pandas lxml
"""

import os
import sys
import csv
import logging
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Optional

try:
    from bs4 import BeautifulSoup
    import pandas as pd
    import anthropic
    import requests
    import base64
    from urllib.parse import urlparse
    from dotenv import load_dotenv
except ImportError as e:
    print(f"Missing required packages. Please install: pip install beautifulsoup4 pandas lxml anthropic requests python-dotenv")
    sys.exit(1)

# Load environment variables
load_dotenv()

# Configuration
HTML_DIR = "data/product-description"
CSV_FILE = "data/exports/backups/shopify_products_upload_reconciled_backup_20250605_060609.csv"
BACKUP_DIR = "data/exports/backups"
LOG_DIR = "logs"
IMAGE_DIR = "assets/images"
MAX_DESC_LENGTH = 1000
MIN_DESC_LENGTH = 750
LONG_DESC_THRESHOLD = 300  # Consider descriptions longer than this as "long"

class ProductDescriptionUpdater:
    def __init__(self):
        self.setup_logging()
        self.html_descriptions = {}
        self.processed_count = 0
        self.updated_count = 0
        self.skipped_count = 0
        self.setup_anthropic_client()
        
    def setup_logging(self):
        """Set up logging configuration"""
        # Create logs directory if it doesn't exist
        Path(LOG_DIR).mkdir(exist_ok=True)
        
        # Configure logging
        log_filename = f"{LOG_DIR}/product_update_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
        
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(log_filename),
                logging.StreamHandler(sys.stdout)
            ]
        )
        
        self.logger = logging.getLogger(__name__)
        self.logger.info("Product Description Updater started")
        
    def setup_anthropic_client(self):
        """Set up Anthropic API client"""
        try:
            # Try to get API key from environment variable
            api_key = os.getenv('ANTHROPIC_API_KEY')
            if not api_key:
                self.logger.warning("ANTHROPIC_API_KEY not found in environment. LLM enhancement will be skipped.")
                self.anthropic_client = None
                return
                
            self.anthropic_client = anthropic.Anthropic(api_key=api_key)
            self.logger.info("Anthropic API client initialized successfully")
            
            # Create image directory if it doesn't exist
            Path(IMAGE_DIR).mkdir(parents=True, exist_ok=True)
            self.logger.info(f"Image directory ready: {IMAGE_DIR}")
            
        except Exception as e:
            self.logger.warning(f"Failed to initialize Anthropic client: {str(e)}. LLM enhancement will be skipped.")
            self.anthropic_client = None
        
    def extract_text_from_html(self, html_file_path: str) -> Optional[Dict[str, str]]:
        """
        Extract clean text from HTML file
        
        Args:
            html_file_path: Path to HTML file
            
        Returns:
            Dictionary with 'title', 'description', and 'handle' keys, or None if error
        """
        try:
            with open(html_file_path, 'r', encoding='utf-8') as file:
                soup = BeautifulSoup(file.read(), 'html.parser')
            
            # Extract title
            title_element = soup.find('h1', class_='product-title')
            title = title_element.get_text(strip=True) if title_element else ""
            
            # Extract description text, excluding keywords and italic quotes/credits
            description_div = soup.find('div', class_='description')
            if not description_div:
                return None
                
            description_text = ""
            
            # Find the first div inside description div (contains all the paragraphs)
            content_div = description_div.find('div')
            if content_div:
                # Get all paragraphs within the content div
                paragraphs = content_div.find_all('p')
                for p in paragraphs:
                    # Skip italic paragraphs (usually quotes/credits) 
                    if p.get('style') and 'italic' in p.get('style'):
                        continue
                    
                    # Get text and preserve paragraph separation
                    text = p.get_text(separator=' ', strip=True)
                    if text:
                        description_text += text + " "
            
            # If no content found, try alternative extraction
            if not description_text.strip():
                # Look for all paragraphs directly in description div
                paragraphs = description_div.find_all('p')
                for p in paragraphs:
                    if p.get('style') and 'italic' in p.get('style'):
                        continue
                    text = p.get_text(separator=' ', strip=True)
                    if text:
                        description_text += text + " "
            
            # Extract handle from filename
            handle = Path(html_file_path).stem
            
            # Extract keywords if available
            keywords = ""
            keywords_div = soup.find('div', class_='keywords')
            if keywords_div:
                keywords = keywords_div.get_text(strip=True)
            
            # Extract collection name from the description
            collection = ""
            if 'collection' in description_text.lower():
                # Try to extract collection name from text patterns
                import re
                collection_match = re.search(r'from the ([^\s]+ [^\s]+) collection', description_text)
                if collection_match:
                    collection = collection_match.group(1)
            
            # Clean up description text
            description_text = description_text.strip()
            description_text = ' '.join(description_text.split())  # Remove extra whitespace
            
            return {
                'title': title,
                'description': description_text,
                'keywords': keywords,
                'collection': collection,
                'handle': handle
            }
            
        except Exception as e:
            self.logger.error(f"Error extracting text from {html_file_path}: {str(e)}")
            return None
    
    def generate_seo_optimized_description(self, full_description: str, title: str) -> str:
        """
        Generate an SEO-optimized description (750-1000 characters) from the full description
        
        Args:
            full_description: The full product description text
            title: Product title for SEO enhancement
            
        Returns:
            SEO-optimized description that fits within 750-1000 character range
        """
        # If description is already in optimal range, return as-is
        if MIN_DESC_LENGTH <= len(full_description) <= MAX_DESC_LENGTH:
            return full_description
            
        # If too short, pad with SEO-friendly content
        if len(full_description) < MIN_DESC_LENGTH:
            # Add some SEO-friendly phrases while staying natural
            seo_additions = [
                f" This {title} artwork features premium quality printing on durable materials.",
                " Perfect for modern home decor and contemporary interior design.",
                " Available in multiple sizes to suit any space.",
                " Gallery-quality artwork that transforms any room.",
                " Professionally printed with archival inks for lasting beauty."
            ]
            
            enhanced_desc = full_description
            for addition in seo_additions:
                test_desc = enhanced_desc + addition
                if len(test_desc) <= MAX_DESC_LENGTH:
                    enhanced_desc = test_desc
                if len(enhanced_desc) >= MIN_DESC_LENGTH:
                    break
                    
            return enhanced_desc
            
        # If too long, intelligently trim while preserving key information
        if len(full_description) > MAX_DESC_LENGTH:
            # Split into sentences
            sentences = []
            temp_sentence = ""
            
            for char in full_description:
                temp_sentence += char
                if char in '.!?' and len(temp_sentence.strip()) > 10:
                    sentences.append(temp_sentence.strip())
                    temp_sentence = ""
            
            # Add any remaining text
            if temp_sentence.strip():
                sentences.append(temp_sentence.strip())
            
            # Build optimal description by including complete sentences
            optimal_desc = ""
            for sentence in sentences:
                test_desc = f"{optimal_desc} {sentence}".strip()
                if len(test_desc) > MAX_DESC_LENGTH:
                    break
                optimal_desc = test_desc
                
                # Stop if we've reached a good length
                if len(optimal_desc) >= MIN_DESC_LENGTH and len(optimal_desc) <= MAX_DESC_LENGTH:
                    continue
            
            # If we're still too short or too long, use word-level trimming
            if len(optimal_desc) < MIN_DESC_LENGTH or len(optimal_desc) > MAX_DESC_LENGTH:
                words = full_description.split()
                optimal_desc = ""
                
                for word in words:
                    test_desc = f"{optimal_desc} {word}".strip()
                    if len(test_desc) > MAX_DESC_LENGTH:
                        break
                    optimal_desc = test_desc
            
            return optimal_desc.strip()
            
        return full_description
    
    def download_image_from_csv(self, handle: str, csv_data: dict) -> str:
        """
        Download artwork image from CSV data for vision analysis
        
        Args:
            handle: Product handle
            csv_data: CSV row data containing image URL
            
        Returns:
            Path to downloaded image or empty string if failed
        """
        try:
            # Get image URL from CSV data
            image_url = csv_data.get('Image Src', '')
            if not image_url:
                self.logger.warning(f"No image URL found for {handle}")
                return ""
            
            # Create filename
            parsed_url = urlparse(image_url)
            filename = f"{handle}.png"
            image_path = os.path.join(IMAGE_DIR, filename)
            
            # Skip if already downloaded
            if os.path.exists(image_path):
                self.logger.debug(f"Image already exists: {image_path}")
                return image_path
            
            # Download image
            self.logger.info(f"Downloading image for {handle}: {image_url}")
            response = requests.get(image_url, timeout=30)
            response.raise_for_status()
            
            # Save image
            with open(image_path, 'wb') as f:
                f.write(response.content)
            
            self.logger.info(f"✓ Downloaded image: {image_path}")
            return image_path
            
        except Exception as e:
            self.logger.error(f"Failed to download image for {handle}: {str(e)}")
            return ""
    
    def encode_image_for_vision(self, image_path: str) -> str:
        """Encode image to base64 for vision API"""
        try:
            with open(image_path, 'rb') as image_file:
                return base64.b64encode(image_file.read()).decode('utf-8')
        except Exception as e:
            self.logger.error(f"Failed to encode image {image_path}: {str(e)}")
            return ""
    
    def analyze_artwork_with_vision(self, image_path: str, title: str) -> str:
        """Use Claude's vision capabilities to create raw visual analysis of artwork"""
        if not self.anthropic_client or not image_path or not os.path.exists(image_path):
            return ""
            
        try:
            # Encode image
            base64_image = self.encode_image_for_vision(image_path)
            if not base64_image:
                return ""
            
            # Create visual analysis prompt
            prompt = f"""You are a professional art critic and visual analyst. Examine this artwork titled "{title}" and provide a detailed visual analysis.

ANALYSIS REQUIREMENTS:
1. Describe the visual elements you observe: composition, color palette, forms, textures, lines, shapes
2. Identify the artistic technique and medium apparent in the work
3. Analyze the spatial relationships and visual flow
4. Describe the emotional impact and mood conveyed
5. Note any artistic style influences or movement characteristics
6. Assess the overall aesthetic qualities and visual appeal

ANALYSIS FORMAT:
Provide a comprehensive visual description in 2-3 paragraphs, focusing purely on what you see in the image. This analysis will be used as source material to write professional product descriptions.

Focus on:
- Specific colors, their relationships and intensity
- Geometric forms, patterns, and structural elements
- Texture and surface qualities
- Composition and balance
- Visual rhythm and movement
- Emotional resonance of the visual elements
- Technical execution and craftsmanship

Write as a professional art analyst would document their observations for reference. Be specific and detailed about the visual elements you observe."""

            # Make vision API call
            response = self.anthropic_client.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=2000,
                temperature=0.5,
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "image",
                                "source": {
                                    "type": "base64",
                                    "media_type": "image/png",
                                    "data": base64_image
                                }
                            },
                            {
                                "type": "text",
                                "text": prompt
                            }
                        ]
                    }
                ]
            )
            
            visual_analysis = response.content[0].text.strip()
            self.logger.info(f"✓ Visual analysis completed for {title}: {len(visual_analysis)} chars")
            
            # Save raw visual analysis to product-description directory
            self.save_visual_analysis(title, visual_analysis)
            
            return visual_analysis
                
        except Exception as e:
            self.logger.error(f"Visual analysis failed for {title}: {str(e)}")
            return ""
    
    def save_visual_analysis(self, title: str, visual_analysis: str) -> None:
        """Save raw visual analysis to the product-description directory"""
        try:
            # Create filename from title (handle format)
            handle = title.lower().replace(' ', '-').replace('no.', 'no').replace('.', '')
            filename = f"{handle}-visual-analysis.md"
            filepath = os.path.join(HTML_DIR, filename)
            
            # Create markdown content
            timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            content = f"""# Visual Analysis: {title}

**Generated:** {timestamp}  
**Source:** Claude Vision API Analysis  
**Character Count:** {len(visual_analysis)}

## Raw Visual Description

{visual_analysis}

---
*This analysis was generated using Claude's vision capabilities to analyze the artwork image. It serves as source material for creating professional product descriptions.*
"""
            
            # Write to file
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            
            self.logger.info(f"💾 Saved visual analysis: {filepath}")
            
        except Exception as e:
            self.logger.error(f"Failed to save visual analysis for {title}: {str(e)}")
    
    def create_professional_description(self, visual_analysis: str, title: str, original_description: str, keywords: str, collection: str) -> str:
        """Create professional art dealer description using visual analysis and HTML context"""
        if not self.anthropic_client:
            return ""
            
        try:
            # Create professional art dealer prompt
            prompt = f"""You are a distinguished art dealer and curator writing for prestigious art galleries and art publications. You have been provided with a detailed visual analysis of an artwork and background context. Your task is to create an elegant, professional product description for a limited edition artwork.

VISUAL ANALYSIS:
{visual_analysis}

ARTWORK CONTEXT:
Title: {title}
Collection: {collection}
Background Context: {original_description}
Keywords: {keywords}

TASK:
Using the visual analysis as your primary source and the background context for additional details, write a sophisticated product description that would appeal to serious art collectors and be worthy of a premier gallery catalog.

REQUIREMENTS:
1. LENGTH: Exactly 750-1000 characters (including spaces)
2. TONE: Sophisticated, authoritative, yet accessible to collectors and art enthusiasts  
3. STYLE: Professional art dealer/gallery catalog style
4. PERSPECTIVE: Third person, referring to "the artist" (never use the artist's name)
5. FOCUS: Visual analysis, artistic merit, and collector appeal

CONTENT STRUCTURE:
- Opening: Compelling visual description based on the analysis
- Middle: Technical and aesthetic commentary with art-world vocabulary
- Closing: Market positioning and collector appeal

LANGUAGE GUIDELINES:
- Use sophisticated art terminology appropriately
- Integrate specific visual details from the analysis
- Reference artistic movements or styles when relevant
- Emphasize the work's uniqueness and limited edition status
- Balance intellectual analysis with emotional resonance
- Naturally incorporate SEO keywords from the context

SEO CONSIDERATIONS:
- Include terms like "limited edition," "contemporary art," "collector"
- Reference the collection name naturally
- Use descriptive color and style terms from the visual analysis
- Include quality indicators like "museum-quality" or "gallery-standard"

FORMATTING:
- Single flowing paragraph
- No bullet points or special formatting
- Elegant, gallery-catalog style prose

Create a professional description that would be worthy of a premier art publication and compel serious collectors. Output only the description text with no additional commentary."""

            response = self.anthropic_client.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=1500,
                temperature=0.6,
                messages=[
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            )
            
            professional_description = response.content[0].text.strip()
            
            # Validate length
            if MIN_DESC_LENGTH <= len(professional_description) <= MAX_DESC_LENGTH:
                self.logger.info(f"✓ Professional description for {title}: {len(professional_description)} chars")
                return professional_description
            else:
                self.logger.warning(f"Professional description for {title} was {len(professional_description)} chars, adjusting")
                # Trim to fit if too long
                if len(professional_description) > MAX_DESC_LENGTH:
                    sentences = professional_description.split('. ')
                    trimmed = ""
                    for sentence in sentences:
                        test_length = len(trimmed + sentence + ". ")
                        if test_length > MAX_DESC_LENGTH:
                            break
                        trimmed += sentence + ". "
                    return trimmed.strip()
                return professional_description
                
        except Exception as e:
            self.logger.error(f"Professional description creation failed for {title}: {str(e)}")
            return ""
    
    def enhance_description_with_llm(self, original_description: str, title: str, keywords: str = "", image_path: str = "", collection: str = "") -> str:
        """
        Use Claude API to enhance and rewrite the product description
        
        Args:
            original_description: The original description text
            title: Product title
            keywords: Optional keywords for SEO
            image_path: Path to artwork image for vision analysis
            collection: Collection name
            
        Returns:
            Enhanced description or original if LLM is not available
        """
        if not self.anthropic_client:
            self.logger.debug(f"LLM not available for {title}, using original description")
            return original_description
            
        # Try vision analysis first if image is available (two-step process)
        if image_path and os.path.exists(image_path):
            # Step 1: Analyze the image to get raw visual description
            visual_analysis = self.analyze_artwork_with_vision(image_path, title)
            
            if visual_analysis:
                self.logger.info(f"📸 Raw visual analysis for {title} completed")
                # Step 2: Create professional description using visual analysis + HTML context
                professional_description = self.create_professional_description(
                    visual_analysis, title, original_description, keywords, collection
                )
                
                if professional_description:
                    self.logger.info(f"✍️ Professional description created for {title}")
                    return professional_description
                else:
                    self.logger.warning(f"Professional description creation failed for {title}, falling back")
            else:
                self.logger.warning(f"Visual analysis failed for {title}, falling back to text enhancement")
            
        try:
            prompt = f"""You are an expert e-commerce copywriter specializing in art and home decor products. Your task is to rewrite a product description to be more engaging, SEO-optimized, and compelling for potential buyers.

PRODUCT INFORMATION:
Title: {title}
Original Description: {original_description}
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

            response = self.anthropic_client.messages.create(
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
            
            # Validate length
            if MIN_DESC_LENGTH <= len(enhanced_description) <= MAX_DESC_LENGTH:
                self.logger.info(f"✓ LLM enhanced {title}: {len(enhanced_description)} chars")
                return enhanced_description
            else:
                self.logger.warning(f"LLM output for {title} was {len(enhanced_description)} chars, using fallback")
                return self.generate_seo_optimized_description(original_description, title)
                
        except Exception as e:
            self.logger.error(f"LLM enhancement failed for {title}: {str(e)}")
            return self.generate_seo_optimized_description(original_description, title)
    
    def load_html_descriptions(self) -> bool:
        """
        Load and process all HTML files in the product description directory
        
        Returns:
            True if successful, False otherwise
        """
        if not os.path.exists(HTML_DIR):
            self.logger.error(f"HTML directory not found: {HTML_DIR}")
            return False
            
        html_files = list(Path(HTML_DIR).glob("*.html"))
        
        if not html_files:
            self.logger.warning(f"No HTML files found in {HTML_DIR}")
            return False
            
        self.logger.info(f"Found {len(html_files)} HTML files to process")
        
        for html_file in html_files:
            self.logger.info(f"Processing {html_file.name}")
            
            extracted_data = self.extract_text_from_html(str(html_file))
            if extracted_data:
                handle = extracted_data['handle']
                
                # Store extracted data first, we'll enhance with images later during CSV processing
                optimal_desc = extracted_data['description']
                
                self.html_descriptions[handle] = {
                    'title': extracted_data['title'],
                    'full_description': extracted_data['description'],
                    'keywords': extracted_data.get('keywords', ''),
                    'collection': extracted_data.get('collection', ''),
                    'optimal_description': optimal_desc,
                    'char_count': len(optimal_desc)
                }
                
                self.logger.info(f"  ✓ {handle}: {len(optimal_desc)} chars")
                self.processed_count += 1
            else:
                self.logger.warning(f"  ✗ Failed to extract data from {html_file.name}")
                
        self.logger.info(f"Successfully processed {self.processed_count} HTML files")
        return True
    
    def create_backup(self) -> str:
        """
        Create a backup of the original CSV file
        
        Returns:
            Path to backup file
        """
        # Create backup directory if it doesn't exist
        Path(BACKUP_DIR).mkdir(parents=True, exist_ok=True)
        
        # Generate backup filename with timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        original_name = Path(CSV_FILE).stem
        backup_filename = f"{original_name}_backup_{timestamp}.csv"
        backup_path = os.path.join(BACKUP_DIR, backup_filename)
        
        # Copy the file
        shutil.copy2(CSV_FILE, backup_path)
        self.logger.info(f"Created backup: {backup_path}")
        
        return backup_path
    
    def should_update_body(self, current_body: str, force_llm_rewrite: bool = False) -> bool:
        """
        Determine if the Body (HTML) column should be updated
        
        Args:
            current_body: Current content of Body (HTML) column
            force_llm_rewrite: Force update all descriptions for LLM enhancement
            
        Returns:
            True if should update, False otherwise
        """
        # Force update if LLM rewrite is requested
        if force_llm_rewrite and self.anthropic_client:
            return True
            
        # Update if empty
        if not current_body or current_body.strip() == "":
            return True
            
        # Update if it ends with "..." (truncated)
        if current_body.strip().endswith("..."):
            return True
            
        return False
    
    def should_update_seo_title(self, current_seo_title: str) -> bool:
        """
        Determine if the SEO Title column should be updated
        
        Args:
            current_seo_title: Current content of SEO Title column
            
        Returns:
            True if should update, False otherwise
        """
        # Update only if empty
        return not current_seo_title or current_seo_title.strip() == ""
    
    def update_csv_file(self) -> bool:
        """
        Update the CSV file with extracted descriptions
        
        Returns:
            True if successful, False otherwise
        """
        if not os.path.exists(CSV_FILE):
            self.logger.error(f"CSV file not found: {CSV_FILE}")
            return False
            
        # Create backup
        backup_path = self.create_backup()
        
        try:
            # Read CSV file
            self.logger.info(f"Reading CSV file: {CSV_FILE}")
            df = pd.read_csv(CSV_FILE)
            
            # Log initial statistics
            total_rows = len(df)
            unique_handles = df['Handle'].nunique()
            self.logger.info(f"CSV contains {total_rows} rows with {unique_handles} unique handles")
            
            # Track updates
            body_updates = 0
            seo_title_updates = 0
            
            # Process each row
            for index, row in df.iterrows():
                handle = row['Handle']
                
                # Skip if we don't have description data for this handle
                if handle not in self.html_descriptions:
                    continue
                    
                desc_data = self.html_descriptions[handle]
                updated_this_row = False
                
                # Download image and enhance description with vision analysis
                image_path = ""
                enhanced_description = desc_data['optimal_description']
                
                if self.anthropic_client:
                    # Download image for vision analysis
                    image_path = self.download_image_from_csv(handle, row.to_dict())
                    
                    # Enhance description with LLM (with vision if image available)
                    enhanced_description = self.enhance_description_with_llm(
                        desc_data['full_description'],
                        desc_data['title'],
                        desc_data['keywords'],
                        image_path,
                        desc_data['collection']
                    )
                    
                    # Update our stored data
                    self.html_descriptions[handle]['optimal_description'] = enhanced_description
                    self.html_descriptions[handle]['char_count'] = len(enhanced_description)
                
                # Update Body (HTML) column if needed (force LLM rewrite)
                current_body = str(row.get('Body (HTML)', ''))
                if self.should_update_body(current_body, force_llm_rewrite=True):
                    df.at[index, 'Body (HTML)'] = enhanced_description
                    body_updates += 1
                    updated_this_row = True
                    self.logger.debug(f"Updated Body for {handle}")
                
                # Update SEO Description column if needed (force LLM rewrite)
                current_seo_desc = str(row.get('SEO Description', ''))
                if self.should_update_seo_title(current_seo_desc) or self.anthropic_client:
                    df.at[index, 'SEO Description'] = enhanced_description
                    seo_title_updates += 1
                    updated_this_row = True
                    self.logger.debug(f"Updated SEO Description for {handle}")
                
                if updated_this_row:
                    self.updated_count += 1
                else:
                    self.skipped_count += 1
            
            # Save updated CSV
            df.to_csv(CSV_FILE, index=False)
            
            # Log results
            self.logger.info("Update Summary:")
            self.logger.info(f"  Total rows processed: {total_rows}")
            self.logger.info(f"  Unique products with updates: {self.updated_count}")
            self.logger.info(f"  Body (HTML) updates: {body_updates}")
            self.logger.info(f"  SEO Description updates: {seo_title_updates}")
            self.logger.info(f"  Products skipped (no updates needed): {self.skipped_count}")
            self.logger.info(f"  Backup created: {backup_path}")
            self.logger.info(f"  Updated CSV saved: {CSV_FILE}")
            
            return True
            
        except Exception as e:
            self.logger.error(f"Error updating CSV file: {str(e)}")
            # Restore backup on error
            try:
                shutil.copy2(backup_path, CSV_FILE)
                self.logger.info("Restored original CSV file from backup")
            except Exception as restore_error:
                self.logger.error(f"Failed to restore backup: {str(restore_error)}")
            
            return False
    
    def generate_report(self) -> str:
        """
        Generate a detailed processing report
        
        Returns:
            Report content as string
        """
        report_lines = [
            "Product Description Update Report",
            "=" * 40,
            f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            "",
            "Processing Summary:",
            f"  HTML files processed: {self.processed_count}",
            f"  Products updated: {self.updated_count}",
            f"  Products skipped: {self.skipped_count}",
            "",
            "Description Details:",
        ]
        
        # Sort by handle for consistent reporting
        for handle in sorted(self.html_descriptions.keys()):
            data = self.html_descriptions[handle]
            report_lines.extend([
                f"  {handle}:",
                f"    Title: {data['title']}",
                f"    Optimal Description ({data['char_count']} chars): {data['optimal_description'][:100]}{'...' if len(data['optimal_description']) > 100 else ''}",
                ""
            ])
        
        return "\n".join(report_lines)
    
    def save_report(self, report_content: str) -> str:
        """
        Save the processing report to a file
        
        Args:
            report_content: The report content to save
            
        Returns:
            Path to saved report file
        """
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        report_filename = f"{LOG_DIR}/update_report_{timestamp}.txt"
        
        with open(report_filename, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        self.logger.info(f"Report saved: {report_filename}")
        return report_filename
    
    def run(self) -> bool:
        """
        Main execution method
        
        Returns:
            True if successful, False otherwise
        """
        try:
            self.logger.info("Starting product description update process")
            
            # Step 1: Load and process HTML files
            if not self.load_html_descriptions():
                self.logger.error("Failed to load HTML descriptions")
                return False
            
            if not self.html_descriptions:
                self.logger.error("No valid descriptions were extracted")
                return False
            
            # Step 2: Update CSV file
            if not self.update_csv_file():
                self.logger.error("Failed to update CSV file")
                return False
            
            # Step 3: Generate and save report
            report_content = self.generate_report()
            report_path = self.save_report(report_content)
            
            self.logger.info("Product description update completed successfully!")
            self.logger.info(f"Check the report for details: {report_path}")
            
            return True
            
        except Exception as e:
            self.logger.error(f"Unexpected error during execution: {str(e)}")
            return False

def main():
    """Main entry point"""
    # Check if required files exist
    if not os.path.exists(CSV_FILE):
        print(f"Error: CSV file not found: {CSV_FILE}")
        sys.exit(1)
        
    if not os.path.exists(HTML_DIR):
        print(f"Error: HTML directory not found: {HTML_DIR}")
        sys.exit(1)
    
    # Run the updater
    updater = ProductDescriptionUpdater()
    success = updater.run()
    
    if success:
        print("\n✓ Product descriptions updated successfully!")
        print(f"✓ Backup created in: {BACKUP_DIR}")
        print(f"✓ Logs available in: {LOG_DIR}")
    else:
        print("\n✗ Update failed. Check logs for details.")
        sys.exit(1)

if __name__ == "__main__":
    main() 