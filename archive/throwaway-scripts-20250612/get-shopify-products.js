#!/usr/bin/env node

import https from 'https';

const SHOPIFY_ACCESS_TOKEN = '***REMOVED***';
const MYSHOPIFY_DOMAIN = 'vividwalls-2.myshopify.com';

function makeShopifyRequest(method, endpoint) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: MYSHOPIFY_DOMAIN,
      port: 443,
      path: endpoint,
      method: method,
      headers: {
        'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    };

    const req = https.request(options, (res) => {
      let responseData = '';

      res.on('data', (chunk) => {
        responseData += chunk;
      });

      res.on('end', () => {
        try {
          const parsedData = JSON.parse(responseData);
          resolve(parsedData);
        } catch (error) {
          reject(new Error(`Failed to parse response: ${error.message}`));
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    req.end();
  });
}

async function getProducts() {
  try {
    console.log('Fetching products from VividWalls store...\n');
    
    // Get first 20 products
    const response = await makeShopifyRequest('GET', '/admin/api/2024-04/products.json?limit=20');
    
    if (response.products && response.products.length > 0) {
      console.log(`Found ${response.products.length} products:\n`);
      
      response.products.forEach((product, index) => {
        console.log(`${index + 1}. ${product.title}`);
        console.log(`   Handle: ${product.handle}`);
        console.log(`   Product ID: ${product.id}`);
        console.log(`   Status: ${product.status}`);
        console.log(`   Variants: ${product.variants.length}`);
        
        // Show variant details
        if (product.variants.length > 0) {
          console.log(`   Variant Details:`);
          product.variants.forEach((variant, vIndex) => {
            console.log(`     ${vIndex + 1}. ${variant.title || 'Default'}`);
            console.log(`        - Variant ID: ${variant.id}`);
            console.log(`        - Option1: ${variant.option1 || 'N/A'}`);
            console.log(`        - Option2: ${variant.option2 || 'N/A'}`);
            console.log(`        - Option3: ${variant.option3 || 'N/A'}`);
            console.log(`        - Price: $${variant.price}`);
            console.log(`        - Inventory: ${variant.inventory_quantity || 0}`);
            console.log(`        - Available: ${variant.available}`);
          });
        }
        console.log('');
      });
      
      // Check for specific handles we're interested in
      console.log('=== Checking for specific product handles ===\n');
      const targetHandles = ['deep-echoes', 'space-form-no4', 'noir-echoes', 'emerald-echoes', 'vivid-mosaic-no4'];
      
      for (const handle of targetHandles) {
        const found = response.products.find(p => p.handle === handle);
        if (found) {
          console.log(`✓ Found: ${handle} - "${found.title}" (${found.variants.length} variants)`);
        } else {
          console.log(`✗ Not found: ${handle}`);
        }
      }
      
    } else {
      console.log('No products found in the store.');
    }
    
  } catch (error) {
    console.error('Error fetching products:', error.message);
  }
}

// Also try to search for specific products by title/handle
async function searchSpecificProducts() {
  console.log('\n=== Searching for specific products by title/handle ===\n');
  
  const searchTerms = ['deep', 'space', 'noir', 'emerald', 'mosaic'];
  
  for (const term of searchTerms) {
    try {
      const response = await makeShopifyRequest('GET', `/admin/api/2024-04/products.json?title=${term}&limit=10`);
      console.log(`Search for "${term}": Found ${response.products.length} products`);
      response.products.forEach(p => {
        console.log(`  - ${p.title} (handle: ${p.handle}, variants: ${p.variants.length})`);
      });
      console.log('');
    } catch (error) {
      console.error(`Error searching for "${term}":`, error.message);
    }
  }
}

// Run both functions
async function main() {
  await getProducts();
  await searchSpecificProducts();
}

main();