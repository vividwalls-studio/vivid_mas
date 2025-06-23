const https = require('https');

const SHOPIFY_STORE_URL = 'vividwalls-2.myshopify.com';
const SHOPIFY_ACCESS_TOKEN = '***REMOVED***';
const THEME_ID = '176582885663';

async function getAllAssets() {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: SHOPIFY_STORE_URL,
            path: `/admin/api/2024-01/themes/${THEME_ID}/assets.json`,
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
                    resolve(response.assets || []);
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
        console.log('🔍 Fetching all theme assets...');
        const assets = await getAllAssets();
        
        // Filter CSS files
        const cssFiles = assets.filter(asset => asset.key.endsWith('.css') && asset.key.startsWith('assets/'));
        
        console.log(`\n📋 Found ${cssFiles.length} CSS files:\n`);
        
        // Group by type
        const vividwallsCss = cssFiles.filter(f => f.key.includes('vividwalls') || f.key.includes('vivid'));
        const productCss = cssFiles.filter(f => f.key.includes('product'));
        const mainCss = cssFiles.filter(f => f.key.includes('main'));
        
        if (vividwallsCss.length > 0) {
            console.log('🎨 VividWalls CSS files:');
            vividwallsCss.forEach(f => {
                console.log(`   - ${f.key} (${f.size} bytes, updated: ${f.updated_at})`);
            });
        }
        
        if (productCss.length > 0) {
            console.log('\n📦 Product-related CSS files:');
            productCss.forEach(f => {
                console.log(`   - ${f.key} (${f.size} bytes, updated: ${f.updated_at})`);
            });
        }
        
        if (mainCss.length > 0) {
            console.log('\n📄 Main CSS files:');
            mainCss.forEach(f => {
                console.log(`   - ${f.key} (${f.size} bytes, updated: ${f.updated_at})`);
            });
        }
        
        // Look for the specific CSS file referenced in main-product.liquid
        const mainProductSimple = cssFiles.find(f => f.key === 'assets/main-product-simple.css');
        if (mainProductSimple) {
            console.log('\n✅ Found main-product-simple.css referenced in the deployed section!');
            console.log(`   Size: ${mainProductSimple.size} bytes`);
            console.log(`   Updated: ${mainProductSimple.updated_at}`);
        } else {
            console.log('\n❌ main-product-simple.css NOT FOUND in theme assets!');
            console.log('   This is the CSS file referenced in the deployed main-product.liquid');
        }
        
        // List all other CSS files
        const otherCss = cssFiles.filter(f => 
            !vividwallsCss.includes(f) && 
            !productCss.includes(f) && 
            !mainCss.includes(f)
        );
        
        if (otherCss.length > 0) {
            console.log('\n📑 Other CSS files:');
            otherCss.slice(0, 10).forEach(f => {
                console.log(`   - ${f.key}`);
            });
            if (otherCss.length > 10) {
                console.log(`   ... and ${otherCss.length - 10} more`);
            }
        }
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

main();