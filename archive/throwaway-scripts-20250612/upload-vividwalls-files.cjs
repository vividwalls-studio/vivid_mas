const fs = require('fs').promises;
const path = require('path');

// Shopify store configuration
const SHOPIFY_STORE = 'vividwalls-2.myshopify.com';
const ACCESS_TOKEN = '***REMOVED***';
const THEME_ID = '176582885663'; // VividWalls-Dawn theme

// File mappings
const filesToUpload = [
  {
    localPath: '/Users/kinglerbercy/Projects/vivid_mas/vividwalls-product-fixed.css',
    shopifyPath: 'assets/vividwalls-product.css'
  },
  {
    localPath: '/Users/kinglerbercy/Projects/vivid_mas/vividwalls-product.js',
    shopifyPath: 'assets/vividwalls-product.js'
  },
  {
    localPath: '/Users/kinglerbercy/Projects/vivid_mas/main-product-fixed.liquid',
    shopifyPath: 'sections/main-product.liquid'
  }
];

async function uploadFile(localPath, shopifyPath) {
  try {
    // Read the file content
    const content = await fs.readFile(localPath, 'utf8');
    const base64Content = Buffer.from(content).toString('base64');
    
    console.log(`Uploading ${localPath} to ${shopifyPath}...`);
    
    // Upload to Shopify
    const response = await fetch(
      `https://${SHOPIFY_STORE}/admin/api/2024-01/themes/${THEME_ID}/assets.json`,
      {
        method: 'PUT',
        headers: {
          'X-Shopify-Access-Token': ACCESS_TOKEN,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          asset: {
            key: shopifyPath,
            attachment: base64Content
          }
        })
      }
    );
    
    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Failed to upload ${shopifyPath}: ${error}`);
    }
    
    const result = await response.json();
    console.log(`✅ Successfully uploaded ${shopifyPath}`);
    console.log(`   Size: ${result.asset.size} bytes`);
    console.log(`   Updated: ${result.asset.updated_at}`);
    
    return result;
  } catch (error) {
    console.error(`❌ Error uploading ${localPath}:`, error.message);
    throw error;
  }
}

async function main() {
  console.log('Starting upload to Shopify theme...');
  console.log(`Theme ID: ${THEME_ID}`);
  console.log(`Store: ${SHOPIFY_STORE}\n`);
  
  const results = [];
  
  for (const file of filesToUpload) {
    try {
      const result = await uploadFile(file.localPath, file.shopifyPath);
      results.push({ success: true, file: file.shopifyPath, result });
    } catch (error) {
      results.push({ success: false, file: file.shopifyPath, error: error.message });
    }
  }
  
  console.log('\n=== Upload Summary ===');
  const successful = results.filter(r => r.success);
  const failed = results.filter(r => !r.success);
  
  console.log(`✅ Successful: ${successful.length}`);
  console.log(`❌ Failed: ${failed.length}`);
  
  if (failed.length > 0) {
    console.log('\nFailed uploads:');
    failed.forEach(f => console.log(`  - ${f.file}: ${f.error}`));
  }
}

// Check if access token is set
if (!ACCESS_TOKEN) {
  console.error('Error: SHOPIFY_ACCESS_TOKEN environment variable is not set');
  process.exit(1);
}

main().catch(console.error);