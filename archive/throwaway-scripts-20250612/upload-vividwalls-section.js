#!/usr/bin/env node

import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs';

const execAsync = promisify(exec);

async function uploadToShopify() {
  console.log('🚀 Uploading VividWalls theme section to Shopify...\n');

  const file = {
    localPath: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/sections/main-product-vividwalls.liquid',
    shopifyKey: 'sections/main-product-vividwalls.liquid',
    description: 'VividWalls Product Page Section (Exact Figma Design)'
  };

  try {
    // First, get the access token from remote server
    console.log('🔑 Getting Shopify credentials from remote server...');
    const tokenCmd = `ssh -i ~/.ssh/digitalocean root@157.230.13.13 "cd /opt/mcp-servers/shopify-mcp-server && grep SHOPIFY_ACCESS_TOKEN .env | cut -d'=' -f2"`;
    const { stdout: token } = await execAsync(tokenCmd);
    const SHOPIFY_ACCESS_TOKEN = token.trim();
    
    const domainCmd = `ssh -i ~/.ssh/digitalocean root@157.230.13.13 "cd /opt/mcp-servers/shopify-mcp-server && grep SHOPIFY_SHOP_URL .env | cut -d'=' -f2"`;
    const { stdout: domain } = await execAsync(domainCmd);
    const MYSHOPIFY_DOMAIN = domain.trim();
    
    console.log(`Store: ${MYSHOPIFY_DOMAIN}\n`);

    // Get list of themes first
    console.log('🔍 Finding themes...');
    const themesCmd = `curl -s -X GET \
      "https://${MYSHOPIFY_DOMAIN}/admin/api/2024-01/themes.json" \
      -H "X-Shopify-Access-Token: ${SHOPIFY_ACCESS_TOKEN}"`;
    
    const { stdout: themesJson } = await execAsync(themesCmd);
    const themesData = JSON.parse(themesJson);
    
    if (!themesData.themes) {
      console.error('❌ Could not get themes:', themesData);
      process.exit(1);
    }
    
    console.log('Available themes:');
    themesData.themes.forEach(theme => {
      console.log(`- ${theme.name} (${theme.role}) - ID: ${theme.id}`);
    });
    
    // Find the target theme
    const targetTheme = themesData.themes.find(t => t.name === 'Updated copy of Dawn') || 
                       themesData.themes.find(t => t.role === 'unpublished') ||
                       themesData.themes[0];
    
    if (!targetTheme) {
      console.error('❌ No theme found!');
      process.exit(1);
    }
    
    const THEME_ID = targetTheme.id;
    console.log(`\n✅ Using theme: ${targetTheme.name} (ID: ${THEME_ID})\n`);
    
    // Upload the file
    console.log(`📄 Uploading ${file.description}...`);
    
    // Read file content
    const content = fs.readFileSync(file.localPath, 'utf8');
    console.log(`   File size: ${content.length} characters`);
    
    // Escape content for JSON
    const escapedContent = JSON.stringify(content);
    
    // Create temp file with JSON payload
    const tempFile = `/tmp/shopify-upload-${Date.now()}.json`;
    const payload = JSON.stringify({
      asset: {
        key: file.shopifyKey,
        value: JSON.parse(escapedContent)
      }
    });
    
    fs.writeFileSync(tempFile, payload);
    
    // Upload using curl
    const uploadCmd = `curl -s -X PUT \
      "https://${MYSHOPIFY_DOMAIN}/admin/api/2024-01/themes/${THEME_ID}/assets.json" \
      -H "X-Shopify-Access-Token: ${SHOPIFY_ACCESS_TOKEN}" \
      -H "Content-Type: application/json" \
      -d @${tempFile}`;
    
    const { stdout: uploadResult } = await execAsync(uploadCmd);
    const result = JSON.parse(uploadResult);
    
    // Clean up temp file
    fs.unlinkSync(tempFile);
    
    if (result.asset) {
      console.log(`✅ Successfully uploaded: ${file.shopifyKey}`);
      console.log(`   Size: ${result.asset.size} bytes`);
      console.log(`   Updated: ${result.asset.updated_at}`);
      console.log(`   Theme ID: ${result.asset.theme_id}\n`);
      
      console.log('✨ Upload complete!');
      console.log(`\nPreview the updated theme at:`);
      console.log(`https://${MYSHOPIFY_DOMAIN}/?preview_theme_id=${THEME_ID}`);
      console.log(`\nTo use this section, create a product template that includes 'main-product-vividwalls'`);
    } else {
      console.error(`❌ Failed to upload: ${file.shopifyKey}`);
      console.error(`   Error: ${JSON.stringify(result.errors || result)}\n`);
    }

  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.stderr) {
      console.error('Stderr:', error.stderr);
    }
    process.exit(1);
  }
}

uploadToShopify().catch(console.error);