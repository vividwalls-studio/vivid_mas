const fs = require('fs');
const path = require('path');

async function uploadThemeFiles() {
  try {
    // Load environment variables
    require('dotenv').config({ path: path.join(__dirname, '.env') });
    
    const fetch = require('node-fetch');
    const SHOPIFY_STORE_DOMAIN = process.env.SHOPIFY_STORE_DOMAIN;
    const SHOPIFY_ACCESS_TOKEN = process.env.SHOPIFY_ACCESS_TOKEN;
    
    if (!SHOPIFY_STORE_DOMAIN || !SHOPIFY_ACCESS_TOKEN) {
      throw new Error('Missing Shopify credentials');
    }
    
    // First, get the theme ID for 'Updated copy of Dawn'
    const themesResponse = await fetch(`https://${SHOPIFY_STORE_DOMAIN}/admin/api/2024-01/themes.json`, {
      headers: {
        'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
        'Content-Type': 'application/json'
      }
    });
    
    const themes = await themesResponse.json();
    const theme = themes.themes.find(t => t.name === 'Updated copy of Dawn');
    
    if (!theme) {
      throw new Error('Theme not found');
    }
    
    console.log('Found theme:', theme.name, 'ID:', theme.id);
    
    // Read the files
    const liquidContent = fs.readFileSync('/Users/kinglerbercy/Projects/vivid_mas/services/theme/sections/main-product-figma.liquid', 'utf8');
    const cssContent = fs.readFileSync('/Users/kinglerbercy/Projects/vivid_mas/services/theme/assets/vividwalls-product-figma.css', 'utf8');
    
    // Upload the section file
    console.log('Uploading section file...');
    const sectionResponse = await fetch(`https://${SHOPIFY_STORE_DOMAIN}/admin/api/2024-01/themes/${theme.id}/assets.json`, {
      method: 'PUT',
      headers: {
        'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        asset: {
          key: 'sections/main-product-figma.liquid',
          value: liquidContent
        }
      })
    });
    
    if (!sectionResponse.ok) {
      const error = await sectionResponse.text();
      throw new Error(`Failed to upload section: ${error}`);
    }
    
    console.log('Section uploaded successfully');
    
    // Upload the CSS file
    console.log('Uploading CSS file...');
    const cssResponse = await fetch(`https://${SHOPIFY_STORE_DOMAIN}/admin/api/2024-01/themes/${theme.id}/assets.json`, {
      method: 'PUT',
      headers: {
        'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        asset: {
          key: 'assets/vividwalls-product-figma.css',
          value: cssContent
        }
      })
    });
    
    if (!cssResponse.ok) {
      const error = await cssResponse.text();
      throw new Error(`Failed to upload CSS: ${error}`);
    }
    
    console.log('CSS uploaded successfully');
    console.log('All files uploaded successfully!');
    
  } catch (error) {
    console.error('Error:', error.message);
  }
}

uploadThemeFiles();