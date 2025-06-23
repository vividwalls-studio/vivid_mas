#!/usr/bin/env node

import fs from 'fs';
import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

// Use the token from the remote server if not set locally
const SHOPIFY_ACCESS_TOKEN = process.env.SHOPIFY_ACCESS_TOKEN || '***REMOVED***';
const MYSHOPIFY_DOMAIN = process.env.MYSHOPIFY_DOMAIN || 'vividwalls.myshopify.com';
const THEME_ID = '172527026463';

if (!SHOPIFY_ACCESS_TOKEN) {
  console.error('Error: SHOPIFY_ACCESS_TOKEN environment variable is required');
  console.error('Please set it in your .env file');
  process.exit(1);
}

async function uploadAsset(themeId, assetKey, content) {
  const url = `https://${MYSHOPIFY_DOMAIN}/admin/api/2024-10/themes/${themeId}/assets.json`;
  
  const response = await fetch(url, {
    method: 'PUT',
    headers: {
      'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      asset: {
        key: assetKey,
        value: content
      }
    })
  });

  const data = await response.json();
  return { response, data };
}

async function main() {
  console.log('🚀 Uploading Figma theme files to Shopify...\n');
  console.log(`Store: ${MYSHOPIFY_DOMAIN}`);
  console.log(`Theme ID: ${THEME_ID}\n`);

  const files = [
    {
      localPath: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/sections/main-product-figma.liquid',
      assetKey: 'sections/main-product-figma.liquid',
      description: 'Figma Product Page Section'
    },
    {
      localPath: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/assets/vividwalls-product-figma.css',
      assetKey: 'assets/vividwalls-product-figma.css',
      description: 'Figma Product Page Styles'
    }
  ];

  let successCount = 0;

  for (const file of files) {
    try {
      console.log(`📄 Uploading ${file.description}...`);
      console.log(`   File: ${file.assetKey}`);
      
      // Check if file exists
      if (!fs.existsSync(file.localPath)) {
        console.error(`   ❌ File not found: ${file.localPath}`);
        continue;
      }
      
      const content = fs.readFileSync(file.localPath, 'utf8');
      console.log(`   Size: ${content.length} characters`);
      
      const { response, data } = await uploadAsset(THEME_ID, file.assetKey, content);
      
      if (response.ok && data.asset) {
        console.log(`   ✅ Successfully uploaded!`);
        console.log(`   Created: ${data.asset.created_at}`);
        console.log(`   Updated: ${data.asset.updated_at}`);
        successCount++;
      } else {
        console.error(`   ❌ Failed to upload`);
        console.error('   Error:', data.errors || data);
      }
    } catch (error) {
      console.error(`   ❌ Error uploading:`, error.message);
    }
    console.log('');
  }

  console.log('='.repeat(50));
  console.log(`\n✨ Upload complete! ${successCount}/${files.length} files uploaded successfully.\n`);
  
  if (successCount === files.length) {
    console.log('Next steps:');
    console.log('1. Go to your Shopify admin > Online Store > Themes');
    console.log('2. Find theme ID 172527026463 and click "Customize"');
    console.log('3. Navigate to a product page');
    console.log('4. The new Figma design should be available as a section option');
    console.log('\nPreview URL:');
    console.log(`https://${MYSHOPIFY_DOMAIN}/?preview_theme_id=${THEME_ID}`);
  }
}

main().catch(console.error);