const fs = require('fs');
const path = require('path');

// Read the section file
const sectionPath = path.join(__dirname, 'services/theme/sections/main-product-vividwalls-gallery-wrap.liquid');
const sectionContent = fs.readFileSync(sectionPath, 'utf8');

// Create a temporary file with the content
const tempFile = path.join(__dirname, 'temp-section.liquid');
fs.writeFileSync(tempFile, sectionContent);

console.log('Section file created at:', tempFile);
console.log('\nTo deploy this section:');
console.log('1. Open Shopify Admin');
console.log('2. Go to Online Store > Themes');
console.log('3. Click "Edit code" on the VividWalls theme');
console.log('4. Navigate to Sections folder');
console.log('5. Add a new section called "main-product-vividwalls-gallery-wrap.liquid"');
console.log('6. Copy the content from temp-section.liquid');
console.log('\nThe file has been saved to:', tempFile);