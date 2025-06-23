#!/usr/bin/env node

import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

const SHOPIFY_ACCESS_TOKEN = process.env.SHOPIFY_ACCESS_TOKEN || '***REMOVED***';
const MYSHOPIFY_DOMAIN = process.env.MYSHOPIFY_DOMAIN || 'vividwalls.myshopify.com';

async function getThemes() {
  // Try different API versions
  const apiVersions = ['2024-01', '2023-10', '2024-10'];
  
  for (const version of apiVersions) {
    console.log(`Trying API version: ${version}`);
    const url = `https://${MYSHOPIFY_DOMAIN}/admin/api/${version}/themes.json`;
    
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
        'Content-Type': 'application/json',
      }
    });

    console.log(`Response status: ${response.status}`);
    const data = await response.json();
    
    if (response.ok) {
      console.log(`✅ Success with API version ${version}\n`);
      return data;
    } else {
      console.log(`❌ Failed with ${version}: ${JSON.stringify(data)}\n`);
    }
  }
  
  throw new Error('Could not connect to Shopify with any API version');
}

async function main() {
  console.log('🔍 Checking Shopify themes...\n');
  console.log(`Store: ${MYSHOPIFY_DOMAIN}\n`);

  try {
    const data = await getThemes();
    
    if (data.themes) {
      console.log(`Found ${data.themes.length} themes:\n`);
      
      data.themes.forEach((theme, index) => {
        console.log(`${index + 1}. ${theme.name}`);
        console.log(`   ID: ${theme.id}`);
        console.log(`   Role: ${theme.role}`);
        console.log(`   Created: ${theme.created_at}`);
        console.log(`   Updated: ${theme.updated_at}`);
        if (theme.previewable) {
          console.log(`   Preview: https://${MYSHOPIFY_DOMAIN}/?preview_theme_id=${theme.id}`);
        }
        console.log('');
      });
      
      // Find the main theme
      const mainTheme = data.themes.find(t => t.role === 'main');
      if (mainTheme) {
        console.log(`✅ Main (published) theme: "${mainTheme.name}" (ID: ${mainTheme.id})`);
      }
      
      // Find "Updated copy of Dawn" theme
      const targetTheme = data.themes.find(t => t.name === 'Updated copy of Dawn');
      if (targetTheme) {
        console.log(`✅ Target theme found: "${targetTheme.name}" (ID: ${targetTheme.id})`);
      }
      
    } else if (data.errors) {
      console.error('❌ Error from Shopify:', data.errors);
    } else {
      console.error('❌ Unexpected response:', data);
    }
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

main().catch(console.error);