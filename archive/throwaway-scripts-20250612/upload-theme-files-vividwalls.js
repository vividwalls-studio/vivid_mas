import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// No need for Shopify API object initialization for direct API calls

// Use the Shopify credentials from the MCP server
const shop = 'vividwalls-2.myshopify.com';
const accessToken = '***REMOVED***';

async function uploadThemeFiles() {
  try {
    console.log('Starting theme file upload...');
    
    // Get list of themes
    const themesResponse = await fetch(`https://${shop}/admin/api/2024-01/themes.json`, {
      headers: {
        'X-Shopify-Access-Token': accessToken,
        'Content-Type': 'application/json'
      }
    });
    
    const themesData = await themesResponse.json();
    console.log('Available themes:');
    themesData.themes.forEach(theme => {
      console.log(`- ${theme.name} (ID: ${theme.id}, Role: ${theme.role})`);
    });
    
    // Find VividWalls theme
    const vividWallsTheme = themesData.themes.find(theme => 
      theme.name.toLowerCase().includes('vividwalls') || 
      theme.name.toLowerCase().includes('vivid walls')
    );
    
    if (!vividWallsTheme) {
      throw new Error('VividWalls theme not found');
    }
    
    console.log(`\nUsing theme: ${vividWallsTheme.name} (ID: ${vividWallsTheme.id})`);
    
    // Files to upload
    const files = [
      {
        key: 'sections/main-product-vividwalls.liquid',
        value: fs.readFileSync(path.join(__dirname, 'services/theme/sections/main-product-vividwalls.liquid'), 'utf8')
      },
      {
        key: 'assets/vividwalls-product-page.css',
        value: fs.readFileSync(path.join(__dirname, 'services/theme/assets/vividwalls-product-page.css'), 'utf8')
      }
    ];
    
    // Upload each file
    for (const file of files) {
      console.log(`\nUploading ${file.key}...`);
      
      const updateResponse = await fetch(`https://${shop}/admin/api/2024-01/themes/${vividWallsTheme.id}/assets.json`, {
        method: 'PUT',
        headers: {
          'X-Shopify-Access-Token': accessToken,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          asset: {
            key: file.key,
            value: file.value
          }
        })
      });
      
      if (!updateResponse.ok) {
        const errorData = await updateResponse.text();
        throw new Error(`Failed to upload ${file.key}: ${errorData}`);
      }
      
      const result = await updateResponse.json();
      console.log(`✓ Successfully uploaded ${file.key}`);
      console.log(`  Size: ${result.asset.size} bytes`);
      console.log(`  Updated: ${result.asset.updated_at}`);
    }
    
    console.log('\n✨ All files uploaded successfully!');
    console.log('\nNext steps:');
    console.log('1. Go to your Shopify admin');
    console.log('2. Navigate to Online Store > Themes');
    console.log(`3. Find the "${vividWallsTheme.name}" theme`);
    console.log('4. Click "Customize" to verify the changes');
    console.log('5. Create a product template using the new section if needed');
    
  } catch (error) {
    console.error('Error uploading theme files:', error);
    process.exit(1);
  }
}

// Run the upload
uploadThemeFiles();