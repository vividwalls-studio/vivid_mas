#!/usr/bin/env node

import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';
import { promisify } from 'util';

dotenv.config();
const execAsync = promisify(exec);

async function uploadThemeFiles() {
  const themeId = '172527026463';
  const storeDomain = process.env.SHOPIFY_STORE_DOMAIN || 'vividwalls.myshopify.com';
  const accessToken = process.env.SHOPIFY_ACCESS_TOKEN;
  
  if (!accessToken) {
    console.error('Error: SHOPIFY_ACCESS_TOKEN not found in environment');
    process.exit(1);
  }

  const files = [
    {
      source: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/sections/main-product-figma.liquid',
      destination: 'sections/main-product-figma.liquid'
    },
    {
      source: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/assets/vividwalls-product-figma.css',
      destination: 'assets/vividwalls-product-figma.css'
    }
  ];

  console.log(`Uploading theme files to theme ${themeId}...`);

  for (const file of files) {
    try {
      // Read file content
      const content = fs.readFileSync(file.source, 'utf8');
      console.log(`\nUploading ${file.destination}...`);
      
      // Create the request body
      const body = JSON.stringify({
        asset: {
          key: file.destination,
          value: content
        }
      });

      // Use curl to upload the file (with -s for silent mode)
      const command = `curl -s -X PUT \
        "https://${storeDomain}/admin/api/2024-10/themes/${themeId}/assets.json" \
        -H "X-Shopify-Access-Token: ${accessToken}" \
        -H "Content-Type: application/json" \
        -d '${body.replace(/'/g, "'\\''")}'`;

      const { stdout, stderr } = await execAsync(command);
      
      if (stderr) {
        console.error(`Error uploading ${file.destination}:`, stderr);
      } else {
        const response = JSON.parse(stdout);
        if (response.asset) {
          console.log(`✓ Successfully uploaded ${file.destination}`);
          console.log(`  - Key: ${response.asset.key}`);
          console.log(`  - Size: ${response.asset.size} bytes`);
        } else if (response.errors) {
          console.error(`✗ Error uploading ${file.destination}:`, response.errors);
        }
      }
    } catch (error) {
      console.error(`Error processing ${file.destination}:`, error.message);
    }
  }

  console.log('\nTheme file upload complete!');
}

// Run the upload
uploadThemeFiles().catch(console.error);