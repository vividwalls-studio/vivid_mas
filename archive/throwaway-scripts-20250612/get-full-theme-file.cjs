const https = require('https');
const fs = require('fs');

const SHOPIFY_STORE_URL = 'vividwalls-2.myshopify.com';
const SHOPIFY_ACCESS_TOKEN = '***REMOVED***';
const THEME_ID = '176582885663';

async function getThemeFile(filePath) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: SHOPIFY_STORE_URL,
            path: `/admin/api/2024-01/themes/${THEME_ID}/assets.json?asset[key]=${encodeURIComponent(filePath)}`,
            method: 'GET',
            headers: {
                'X-Shopify-Access-Token': SHOPIFY_ACCESS_TOKEN,
                'Content-Type': 'application/json'
            }
        };

        const req = https.request(options, (res) => {
            let data = '';
            
            res.on('data', (chunk) => {
                data += chunk;
            });
            
            res.on('end', () => {
                try {
                    const response = JSON.parse(data);
                    if (response.asset) {
                        resolve(response.asset.value);
                    } else {
                        reject(new Error('File not found'));
                    }
                } catch (e) {
                    reject(e);
                }
            });
        });
        
        req.on('error', reject);
        req.end();
    });
}

async function main() {
    try {
        console.log('📥 Downloading sections/main-product.liquid...');
        const content = await getThemeFile('sections/main-product.liquid');
        
        // Save to file
        fs.writeFileSync('deployed-main-product.liquid', content);
        console.log('✅ Saved to deployed-main-product.liquid');
        
        // Also check for the CSS file referenced
        console.log('\n📋 Checking CSS reference in main-product.liquid...');
        const cssMatch = content.match(/\{\{\s*['"]([^'"]+\.css)['"].*\}\}/);
        if (cssMatch) {
            console.log(`Found CSS reference: ${cssMatch[1]}`);
            
            console.log(`\n📥 Downloading assets/${cssMatch[1]}...`);
            try {
                const cssContent = await getThemeFile(`assets/${cssMatch[1]}`);
                fs.writeFileSync(`deployed-${cssMatch[1]}`, cssContent);
                console.log(`✅ Saved to deployed-${cssMatch[1]}`);
            } catch (e) {
                console.log(`❌ Could not download ${cssMatch[1]}: ${e.message}`);
            }
        }
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

main();