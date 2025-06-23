const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚀 Uploading Gallery Wrap Section to Shopify...\n');

// Get credentials from remote server
console.log('🔑 Getting Shopify credentials from remote server...');
exec('ssh root@142.93.184.16 "cat /root/vividwalls-mas/.env | grep SHOPIFY"', (error, stdout, stderr) => {
  if (error) {
    console.error('❌ Failed to get credentials:', error.message);
    return;
  }

  const lines = stdout.split('\n');
  const store = lines.find(l => l.includes('SHOPIFY_STORE_DOMAIN'))?.split('=')[1]?.trim() || '';
  const token = lines.find(l => l.includes('SHOPIFY_ACCESS_TOKEN'))?.split('=')[1]?.trim() || '';

  if (!store || !token) {
    console.error('❌ Missing credentials');
    return;
  }

  console.log(`Store: ${store}\n`);

  // File to upload
  const filePath = path.join(__dirname, 'services/theme/sections/main-product-vividwalls-gallery-wrap.liquid');
  const fileContent = fs.readFileSync(filePath, 'utf8');

  // Create upload script
  const uploadScript = `
const https = require('https');

// Theme ID from our previous work
const themeId = '176583573791';
const assetKey = 'sections/main-product-vividwalls-gallery-wrap.liquid';

console.log('📤 Uploading file to theme:', themeId);

const data = JSON.stringify({
  asset: {
    key: assetKey,
    value: ${JSON.stringify(fileContent)}
  }
});

const options = {
  hostname: '${store}',
  port: 443,
  path: \`/admin/api/2024-01/themes/\${themeId}/assets.json\`,
  method: 'PUT',
  headers: {
    'X-Shopify-Access-Token': '${token}',
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data)
  }
};

const req = https.request(options, (res) => {
  let body = '';
  res.on('data', (chunk) => body += chunk);
  res.on('end', () => {
    if (res.statusCode === 200) {
      console.log('✅ Successfully uploaded:', assetKey);
    } else {
      console.error('❌ Upload failed:', res.statusCode, body);
    }
  });
});

req.on('error', (e) => {
  console.error('❌ Request error:', e.message);
});

req.write(data);
req.end();
`;

  // Copy and execute on remote
  fs.writeFileSync('/tmp/upload-gallery-wrap.js', uploadScript);
  
  exec('scp /tmp/upload-gallery-wrap.js root@142.93.184.16:/tmp/', (err) => {
    if (err) {
      console.error('❌ Failed to copy script:', err.message);
      return;
    }

    exec('ssh root@142.93.184.16 "cd /tmp && node upload-gallery-wrap.js"', (err, stdout, stderr) => {
      if (err) {
        console.error('❌ Upload failed:', err.message);
        return;
      }
      
      console.log(stdout);
      if (stderr) console.error(stderr);
      
      // Cleanup
      exec('ssh root@142.93.184.16 "rm /tmp/upload-gallery-wrap.js"', () => {
        console.log('\n✨ Upload process complete!');
      });
    });
  });
});