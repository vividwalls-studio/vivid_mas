#!/usr/bin/env node

import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs';
import path from 'path';

const execAsync = promisify(exec);

async function uploadViaRemoteMCP() {
  console.log('🚀 Uploading Figma theme files via remote MCP server...\n');

  const files = [
    {
      localPath: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/sections/main-product-figma.liquid',
      remotePath: '/tmp/main-product-figma.liquid',
      shopifyKey: 'sections/main-product-figma.liquid',
      description: 'Figma Product Page Section'
    },
    {
      localPath: '/Users/kinglerbercy/Projects/vivid_mas/services/theme/assets/vividwalls-product-figma.css',
      remotePath: '/tmp/vividwalls-product-figma.css',
      shopifyKey: 'assets/vividwalls-product-figma.css',
      description: 'Figma Product Page Styles'
    }
  ];

  try {
    // First, copy files to the remote server
    console.log('📤 Copying files to remote server...\n');
    
    for (const file of files) {
      console.log(`Copying ${file.description}...`);
      const scpCommand = `scp -i ~/.ssh/digitalocean "${file.localPath}" root@157.230.13.13:${file.remotePath}`;
      await execAsync(scpCommand);
      console.log(`✅ Copied to remote: ${file.remotePath}\n`);
    }

    // Create a remote upload script
    const uploadScript = `
#!/bin/bash
cd /opt/mcp-servers/shopify-mcp-server

# Source environment variables
source .env

# Run the upload using the Shopify MCP server's environment
node -e "
const fetch = require('node-fetch');
const fs = require('fs');

async function uploadFiles() {
  const SHOPIFY_ACCESS_TOKEN = process.env.SHOPIFY_ACCESS_TOKEN;
  const MYSHOPIFY_DOMAIN = process.env.MYSHOPIFY_DOMAIN || 'vividwalls.myshopify.com';
  const THEME_ID = '172527026463';

  const files = [
    { path: '/tmp/main-product-figma.liquid', key: 'sections/main-product-figma.liquid' },
    { path: '/tmp/vividwalls-product-figma.css', key: 'assets/vividwalls-product-figma.css' }
  ];

  for (const file of files) {
    const content = fs.readFileSync(file.path, 'utf8');
    const url = \\\`https://\\\${MYSHOPIFY_DOMAIN}/admin/api/2024-01/themes/\\\${THEME_ID}/assets.json\\\`;
    
    const response = await fetch(url, {
      method: 'PUT',
      headers: {
        'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        asset: {
          key: file.key,
          value: content
        }
      })
    });

    const data = await response.json();
    if (response.ok) {
      console.log(\\\`✅ Uploaded: \\\${file.key}\\\`);
    } else {
      console.error(\\\`❌ Failed to upload \\\${file.key}:\\\`, data);
    }
  }
}

uploadFiles().catch(console.error);
"
`;

    // Write script to remote server
    console.log('📝 Creating remote upload script...');
    const scriptPath = '/tmp/upload-shopify-files.sh';
    await execAsync(`ssh -i ~/.ssh/digitalocean root@157.230.13.13 'cat > ${scriptPath}' << 'EOF'${uploadScript}
EOF`);
    await execAsync(`ssh -i ~/.ssh/digitalocean root@157.230.13.13 'chmod +x ${scriptPath}'`);

    // Execute the script on remote server
    console.log('\n🚀 Executing upload on remote server...\n');
    const { stdout, stderr } = await execAsync(`ssh -i ~/.ssh/digitalocean root@157.230.13.13 '${scriptPath}'`);
    
    if (stdout) {
      console.log(stdout);
    }
    if (stderr) {
      console.error('Errors:', stderr);
    }

    // Clean up temporary files
    console.log('\n🧹 Cleaning up temporary files...');
    await execAsync(`ssh -i ~/.ssh/digitalocean root@157.230.13.13 'rm -f /tmp/*.liquid /tmp/*.css ${scriptPath}'`);
    
    console.log('\n✨ Upload process complete!');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

uploadViaRemoteMCP().catch(console.error);