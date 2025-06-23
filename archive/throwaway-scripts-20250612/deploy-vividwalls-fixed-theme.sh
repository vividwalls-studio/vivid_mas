#!/bin/bash

# Deploy VividWalls Fixed Theme Files
# This script uploads the fixed theme files to Shopify

echo "🚀 Deploying VividWalls Fixed Theme Files to Shopify..."

# Navigate to shopify-mcp-server directory
cd /Users/kinglerbercy/Projects/vivid_mas/services/mcp-servers/core/shopify-mcp-server

# Create a temporary directory for theme files
TEMP_DIR="temp-theme-files"
mkdir -p $TEMP_DIR

# Copy the fixed files to the correct theme structure
echo "📁 Organizing theme files..."

# Create necessary directories
mkdir -p $TEMP_DIR/sections
mkdir -p $TEMP_DIR/assets

# Copy the liquid file as a section
cp /Users/kinglerbercy/Projects/vivid_mas/main-product-fixed.liquid $TEMP_DIR/sections/main-product-vividwalls-fixed.liquid

# Copy CSS and JS files to assets
cp /Users/kinglerbercy/Projects/vivid_mas/vividwalls-product-fixed.css $TEMP_DIR/assets/
cp /Users/kinglerbercy/Projects/vivid_mas/vividwalls-product-final.js $TEMP_DIR/assets/

echo "📤 Uploading files to Shopify..."

# Upload all files at once using Shopify CLI
cd $TEMP_DIR
shopify theme push --allow-live --only sections/main-product-vividwalls-fixed.liquid,assets/vividwalls-product-fixed.css,assets/vividwalls-product-final.js
cd ..

# Clean up
rm -rf $TEMP_DIR

echo "✅ Theme files deployed successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Create a new product template that uses the 'main-product-vividwalls-fixed' section"
echo "2. Or update your existing product template to reference this section"
echo "3. Ensure your products have the correct metafields:"
echo "   - custom.collection_name (e.g., 'Vivid Layers')"
echo "   - custom.artist_name (e.g., 'Kingler Bercy')"
echo "4. Tag products with 'limited-edition' to show the Limited Edition badge"