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

async function getAllProducts() {
  try {
    console.log('Fetching ALL products from VividWalls store...\n');
    
    let allProducts = [];
    let nextPageUrl = '/admin/api/2024-04/products.json?limit=250';
    
    while (nextPageUrl) {
      console.log(`Fetching page: ${nextPageUrl}`);
      const response = await makeShopifyRequest('GET', nextPageUrl);
      
      if (response.products) {
        allProducts = allProducts.concat(response.products);
        console.log(`Retrieved ${response.products.length} products, total so far: ${allProducts.length}`);
      }
      
      // Check for next page
      nextPageUrl = null;
      if (response.products && response.products.length === 250) {
        // There might be more products, check the Link header or try next page
        // For simplicity, we'll use cursor-based pagination
        const lastProduct = response.products[response.products.length - 1];
        if (lastProduct) {
          nextPageUrl = `/admin/api/2024-04/products.json?limit=250&since_id=${lastProduct.id}`;
        }
      }
    }
    
    console.log(`\nTotal products found: ${allProducts.length}\n`);
    
    // Target handles from CSV
    const targetHandles = [
      'deep-echoes', 'space-form-no4', 'noir-echoes', 'emerald-echoes', 'vivid-mosaic-no4',
      'space-form-no-4', 'noir-echoes-1', 'space-form-4', 'vivid-mosaic-4',
      'space-form', 'noir', 'mosaic', 'space', 'form'
    ];
    
    console.log('=== Checking for target product handles ===\n');
    
    const foundProducts = [];
    const notFoundHandles = [];
    
    for (const handle of targetHandles) {
      const found = allProducts.find(p => p.handle === handle || p.handle.includes(handle));
      if (found) {
        console.log(`✓ Found: ${handle} -> "${found.title}" (handle: ${found.handle}, variants: ${found.variants.length})`);
        foundProducts.push(found);
      } else {
        console.log(`✗ Not found: ${handle}`);
        notFoundHandles.push(handle);
      }
    }
    
    console.log(`\n=== Summary ===`);
    console.log(`Found products: ${foundProducts.length}`);
    console.log(`Not found handles: ${notFoundHandles.length}`);
    
    // Show all product handles for reference
    console.log(`\n=== All Product Handles in Store ===`);
    const allHandles = allProducts.map(p => p.handle).sort();
    allHandles.forEach((handle, index) => {
      console.log(`${index + 1}. ${handle}`);
    });
    
    // Analyze current variant structure
    console.log(`\n=== Current Variant Structure Analysis ===`);
    const variantOptions = new Set();
    const framingOptions = new Set();
    
    allProducts.forEach(product => {
      product.variants.forEach(variant => {
        if (variant.option1) variantOptions.add(`Size: ${variant.option1}`);
        if (variant.option2) variantOptions.add(`Frame Color: ${variant.option2}`);
        if (variant.option3) variantOptions.add(`Frame Type: ${variant.option3}`);
      });
    });
    
    console.log('Unique variant options found:');
    Array.from(variantOptions).sort().forEach(option => {
      console.log(`  - ${option}`);
    });
    
  } catch (error) {
    console.error('Error fetching products:', error.message);
  }
}

getAllProducts();