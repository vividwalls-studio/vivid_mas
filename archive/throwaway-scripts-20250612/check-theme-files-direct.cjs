const https = require('https');

const SHOPIFY_STORE_URL = 'vividwalls-2.myshopify.com';
const SHOPIFY_ACCESS_TOKEN = '***REMOVED***';
const THEME_ID = '176582885663';

const filesToCheck = [
    'sections/main-product.liquid',
    'assets/vividwalls-product.css', 
    'assets/vividwalls-product.js'
];

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
                        resolve({
                            exists: true,
                            content: response.asset.value || response.asset.attachment,
                            size: response.asset.size,
                            updatedAt: response.asset.updated_at
                        });
                    } else if (response.errors) {
                        resolve({ exists: false, error: response.errors });
                    } else {
                        resolve({ exists: false });
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

async function checkAllFiles() {
    console.log('🔍 Checking Shopify theme files...');
    console.log(`📦 Theme ID: ${THEME_ID}`);
    console.log('=' .repeat(80));
    
    for (const filePath of filesToCheck) {
        console.log(`\n📄 Checking: ${filePath}`);
        
        try {
            const result = await getThemeFile(filePath);
            
            if (result.exists) {
                console.log(`✅ File exists`);
                console.log(`   Size: ${result.size} bytes`);
                console.log(`   Updated: ${result.updatedAt}`);
                
                if (result.content) {
                    // Show first few lines
                    const lines = result.content.split('\n').slice(0, 10);
                    console.log(`   First 10 lines:`);
                    lines.forEach((line, i) => {
                        console.log(`   ${(i + 1).toString().padStart(2)}: ${line.substring(0, 70)}${line.length > 70 ? '...' : ''}`);
                    });
                }
            } else {
                console.log(`❌ File not found`);
                if (result.error) {
                    console.log(`   Error: ${result.error}`);
                }
            }
        } catch (error) {
            console.error(`❌ Error checking file: ${error.message}`);
        }
    }
    
    console.log('\n' + '=' .repeat(80));
    console.log('✅ Check complete');
}

// Run the check
checkAllFiles().catch(console.error);