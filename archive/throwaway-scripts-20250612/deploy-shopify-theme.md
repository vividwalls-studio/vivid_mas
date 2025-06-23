# Deploy VividWalls Product Page to Shopify

## Method 1: Using Shopify CLI (Recommended)

1. Install Shopify CLI:
```bash
npm install -g @shopify/cli @shopify/theme
```

2. Login to your store:
```bash
shopify login --store=your-store.myshopify.com
```

3. Push theme files:
```bash
# From the theme directory
shopify theme push --path=services/theme
```

## Method 2: Manual Upload via Admin

1. Go to your Shopify Admin → Online Store → Themes
2. Click "Actions" → "Edit code" on your current theme
3. Upload the files:
   - `templates/product.vividwalls.liquid` → Templates folder
   - `assets/vividwalls-product-page-new.css` → Assets folder

## Method 3: Using Theme Kit

1. Install Theme Kit:
```bash
brew install themekit
```

2. Configure:
```bash
theme configure --password=[your-api-password] --store=[your-store.myshopify.com] --themeid=[theme-id]
```

3. Upload files:
```bash
theme deploy templates/product.vividwalls.liquid assets/vividwalls-product-page-new.css
```

## Apply Template to Products

1. In Shopify Admin, go to Products
2. Select a product
3. In "Theme template" section, select "product.vividwalls"
4. Save

## Preview Links

Once deployed, you can preview at:
- `https://your-store.myshopify.com/products/[product-handle]?preview_theme_id=[theme-id]`
- Or use the theme editor preview

## Quick Test

To quickly test without deploying:
1. Use the Online Store Editor
2. Navigate to a product page
3. Change template to "product.vividwalls"