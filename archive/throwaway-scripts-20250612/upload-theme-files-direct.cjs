#!/usr/bin/env node

const fs = require('fs').promises;
const path = require('path');
const fetch = require('node-fetch');

// Shopify configuration
const config = {
  shopifyDomain: 'vividwalls-2.myshopify.com',
  accessToken: '***REMOVED***',
  themeId: '176582885663'
};

// Files to upload
const filesToUpload = [
  {
    path: '/Users/kinglerbercy/Projects/vivid_mas/vividwalls-product.css',
    key: 'assets/vividwalls-product.css'
  },
  {
    path: '/Users/kinglerbercy/Projects/vivid_mas/vividwalls-product.js', 
    key: 'assets/vividwalls-product.js'
  },
  {
    path: '/Users/kinglerbercy/Projects/vivid_mas/main-product.liquid',
    key: 'sections/main-product.liquid'
  }
];

// API endpoint for theme assets
const getApiUrl = () => {
  return `https://${config.shopifyDomain}/admin/api/2024-01/themes/${config.themeId}/assets.json`;
};

// Upload a single file
async function uploadFile(filePath, assetKey) {
  try {
    console.log(`Reading file: ${filePath}`);
    const content = await fs.readFile(filePath, 'utf8');
    
    console.log(`Uploading ${assetKey}...`);
    
    const response = await fetch(getApiUrl(), {
      method: 'PUT',
      headers: {
        'X-Shopify-Access-Token': config.accessToken,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        asset: {
          key: assetKey,
          value: content
        }
      })
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Failed to upload ${assetKey}: ${response.status} - ${error}`);
    }

    const result = await response.json();
    console.log(`✓ Successfully uploaded ${assetKey}`);
    return result;
  } catch (error) {
    console.error(`✗ Error uploading ${assetKey}:`, error.message);
    throw error;
  }
}

// Main function
async function main() {
  console.log('Starting theme file upload...');
  console.log(`Theme ID: ${config.themeId}`);
  console.log(`Store: ${config.shopifyDomain}`);
  console.log('');

  const results = [];
  const errors = [];

  for (const file of filesToUpload) {
    try {
      const result = await uploadFile(file.path, file.key);
      results.push({ file: file.key, status: 'success' });
    } catch (error) {
      errors.push({ file: file.key, error: error.message });
    }
  }

  console.log('\n--- Upload Summary ---');
  console.log(`Successful uploads: ${results.length}`);
  console.log(`Failed uploads: ${errors.length}`);

  if (errors.length > 0) {
    console.log('\nErrors:');
    errors.forEach(err => {
      console.log(`- ${err.file}: ${err.error}`);
    });
  }

  console.log('\nUpload complete!');
}

// Check if node-fetch is installed
const checkDependencies = async () => {
  try {
    require.resolve('node-fetch');
  } catch (e) {
    console.log('Installing required dependency: node-fetch');
    const { execSync } = require('child_process');
    execSync('npm install node-fetch@2', { stdio: 'inherit' });
  }
};

// Run the script
(async () => {
  await checkDependencies();
  await main();
})();