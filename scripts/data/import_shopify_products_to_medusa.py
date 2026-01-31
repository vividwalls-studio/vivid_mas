#!/usr/bin/env python3
"""
Import Shopify Products to Medusa
This script syncs products from Shopify to Medusa using both MCP servers
"""

import os
import json
import requests
from typing import List, Dict, Any
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ShopifyToMedusaSync:
    def __init__(self, shopify_config: Dict[str, str], medusa_config: Dict[str, str]):
        self.shopify_domain = shopify_config['domain']
        self.shopify_token = shopify_config['access_token']
        self.medusa_url = medusa_config['url']
        self.medusa_token = medusa_config['api_token']
        
        # Set up headers
        self.shopify_headers = {
            'X-Shopify-Access-Token': self.shopify_token,
            'Content-Type': 'application/json'
        }
        
        self.medusa_headers = {
            'Authorization': f'Bearer {self.medusa_token}',
            'Content-Type': 'application/json'
        }
    
    def fetch_shopify_products(self, limit: int = 250) -> List[Dict[str, Any]]:
        """Fetch products from Shopify"""
        logger.info("Fetching products from Shopify...")
        
        url = f"https://{self.shopify_domain}/admin/api/2024-01/products.json"
        params = {'limit': limit}
        
        try:
            response = requests.get(url, headers=self.shopify_headers, params=params)
            response.raise_for_status()
            products = response.json().get('products', [])
            logger.info(f"Fetched {len(products)} products from Shopify")
            return products
        except Exception as e:
            logger.error(f"Error fetching Shopify products: {e}")
            return []
    
    def transform_product(self, shopify_product: Dict[str, Any]) -> Dict[str, Any]:
        """Transform Shopify product to Medusa format"""
        
        # Basic product data
        medusa_product = {
            'title': shopify_product['title'],
            'subtitle': shopify_product.get('product_type', ''),
            'description': shopify_product.get('body_html', ''),
            'handle': shopify_product['handle'],
            'is_giftcard': False,
            'status': 'published' if shopify_product['status'] == 'active' else 'draft',
            'thumbnail': shopify_product.get('image', {}).get('src', ''),
            'weight': self._get_weight(shopify_product),
            'metadata': {
                'shopify_id': str(shopify_product['id']),
                'shopify_created_at': shopify_product['created_at'],
                'vendor': shopify_product.get('vendor', '')
            }
        }
        
        # Transform variants
        medusa_product['variants'] = []
        for variant in shopify_product.get('variants', []):
            medusa_variant = {
                'title': variant['title'],
                'sku': variant.get('sku', ''),
                'barcode': variant.get('barcode', ''),
                'hs_code': variant.get('harmonized_system_code', ''),
                'inventory_quantity': variant.get('inventory_quantity', 0),
                'allow_backorder': variant.get('inventory_policy') == 'continue',
                'manage_inventory': variant.get('inventory_management') == 'shopify',
                'weight': variant.get('weight', 0),
                'prices': [{
                    'amount': int(float(variant['price']) * 100),  # Convert to cents
                    'currency_code': 'USD'
                }],
                'options': self._get_variant_options(variant, shopify_product),
                'metadata': {
                    'shopify_variant_id': str(variant['id']),
                    'shopify_inventory_item_id': str(variant.get('inventory_item_id', ''))
                }
            }
            medusa_product['variants'].append(medusa_variant)
        
        # Product options (sizes, colors, etc.)
        medusa_product['options'] = []
        for option in shopify_product.get('options', []):
            medusa_option = {
                'title': option['name'],
                'values': [{'value': v} for v in option['values']]
            }
            medusa_product['options'].append(medusa_option)
        
        # Images
        medusa_product['images'] = []
        for image in shopify_product.get('images', []):
            medusa_product['images'].append({
                'url': image['src']
            })
        
        # Categories/Collections (would need separate API call in real implementation)
        medusa_product['categories'] = []
        medusa_product['tags'] = [{'value': tag} for tag in shopify_product.get('tags', '').split(',') if tag.strip()]
        
        return medusa_product
    
    def _get_weight(self, product: Dict[str, Any]) -> float:
        """Get product weight from first variant"""
        variants = product.get('variants', [])
        if variants and 'weight' in variants[0]:
            return float(variants[0]['weight'])
        return 0.0
    
    def _get_variant_options(self, variant: Dict[str, Any], product: Dict[str, Any]) -> List[Dict[str, str]]:
        """Extract variant options"""
        options = []
        
        # Map option1, option2, option3 to their names
        for i in range(1, 4):
            option_value = variant.get(f'option{i}')
            if option_value and i <= len(product.get('options', [])):
                option_name = product['options'][i-1]['name']
                options.append({
                    'option': option_name,
                    'value': option_value
                })
        
        return options
    
    def create_medusa_product(self, product_data: Dict[str, Any]) -> bool:
        """Create product in Medusa"""
        url = f"{self.medusa_url}/admin/products"
        
        try:
            response = requests.post(url, headers=self.medusa_headers, json=product_data)
            response.raise_for_status()
            logger.info(f"Created product: {product_data['title']}")
            return True
        except Exception as e:
            logger.error(f"Error creating product {product_data['title']}: {e}")
            if hasattr(e, 'response') and e.response:
                logger.error(f"Response: {e.response.text}")
            return False
    
    def sync_products(self, dry_run: bool = False):
        """Main sync function"""
        logger.info("Starting Shopify to Medusa product sync...")
        
        # Fetch products from Shopify
        shopify_products = self.fetch_shopify_products()
        
        if not shopify_products:
            logger.warning("No products found in Shopify")
            return
        
        # Transform and sync each product
        success_count = 0
        error_count = 0
        
        for shopify_product in shopify_products:
            logger.info(f"Processing: {shopify_product['title']}")
            
            # Transform to Medusa format
            medusa_product = self.transform_product(shopify_product)
            
            if dry_run:
                logger.info(f"[DRY RUN] Would create product: {medusa_product['title']}")
                logger.debug(json.dumps(medusa_product, indent=2))
            else:
                # Create in Medusa
                if self.create_medusa_product(medusa_product):
                    success_count += 1
                else:
                    error_count += 1
        
        # Summary
        logger.info("=" * 50)
        logger.info(f"Sync completed!")
        logger.info(f"Successfully synced: {success_count} products")
        logger.info(f"Errors: {error_count} products")
        
        if dry_run:
            logger.info("[DRY RUN] No actual changes were made")

def main():
    """Main entry point"""
    
    # Load configuration from environment or use defaults
    shopify_config = {
        'domain': os.getenv('SHOPIFY_DOMAIN', 'vividwalls.myshopify.com'),
        'access_token': os.getenv('SHOPIFY_ACCESS_TOKEN', '')
    }
    
    medusa_config = {
        'url': os.getenv('MEDUSA_URL', 'https://medusa.vividwalls.blog'),
        'api_token': os.getenv('MEDUSA_API_TOKEN', 'test-api-token-12345')
    }
    
    # Validate configuration
    if not shopify_config['access_token']:
        logger.error("SHOPIFY_ACCESS_TOKEN environment variable is required")
        logger.info("Get your access token from Shopify Admin > Apps > Private apps")
        return
    
    # Check for dry run mode
    dry_run = os.getenv('DRY_RUN', 'false').lower() == 'true'
    
    if dry_run:
        logger.info("Running in DRY RUN mode - no changes will be made")
    
    # Create sync instance and run
    sync = ShopifyToMedusaSync(shopify_config, medusa_config)
    sync.sync_products(dry_run=dry_run)

if __name__ == "__main__":
    main()