# Medusa Production Setup Guide

This guide outlines the steps to set up a production-ready Medusa e-commerce platform integrated with VividWalls MAS.

## Current Status

- ✅ Medusa API running with mock endpoints at https://medusa.vividwalls.blog
- ✅ MCP server configured for Medusa integration
- ✅ Database schema created (medusa_db in PostgreSQL)
- ✅ Storefront domain configured (store.vividwalls.blog)

## Production Setup Steps

### 1. Replace Mock API with Actual Medusa v2 Backend

**Current State**: Mock API with hardcoded responses
**Target State**: Full Medusa v2 backend with database persistence

```bash
# Clone Medusa v2 backend
cd /opt
git clone https://github.com/medusajs/medusa.git medusa-backend-v2
cd medusa-backend-v2

# Create production configuration
cat > .env.production << 'EOF'
DATABASE_URL=postgres://medusa:medusa_secure_password_2b69a6e9c275a4fad0d82b6ba3fcef94@postgres:5433/medusa_db
REDIS_URL=redis://redis:6379
JWT_SECRET=Qj1SX+hXEozDgFZsmTpGT+7X7YUZtqJUFymPZfAupaQ=
COOKIE_SECRET=OyLQK4RjdiLP9n488XkVVUcJ1pJ3z27q7WMkBtilYu8=
ADMIN_CORS=https://medusa.vividwalls.blog,http://localhost:7001
STORE_CORS=https://store.vividwalls.blog,https://vividwalls.com,http://localhost:8000
EOF
```

### 2. Set Up Database Migrations

```bash
# Run Medusa migrations
docker exec medusa-backend npx medusa migrations run

# Seed initial data
docker exec medusa-backend npx medusa seed
```

### 3. Configure Stripe Payment Provider

**Prerequisites**:
- Stripe account at https://stripe.com
- API keys from Stripe Dashboard

**Configuration**:

```bash
# Add to /root/vivid_mas/.env
STRIPE_SECRET_KEY=sk_live_xxx  # Your Stripe secret key
STRIPE_WEBHOOK_SECRET=whsec_xxx  # Your webhook secret

# Configure Stripe MCP server
cd /opt/mcp-servers/stripe-mcp-server
cat > .env << 'EOF'
STRIPE_SECRET_KEY=sk_live_xxx
EOF

# Update Medusa configuration
cd /opt/medusa-backend-v2
npm install medusa-payment-stripe

# Add to medusa-config.js plugins section:
{
  resolve: "medusa-payment-stripe",
  options: {
    api_key: process.env.STRIPE_SECRET_KEY,
    webhook_secret: process.env.STRIPE_WEBHOOK_SECRET,
    automatic_payment_methods: true,
  }
}
```

### 4. Configure PayPal Payment Provider

```bash
# Install PayPal plugin
npm install medusa-payment-paypal

# Add to medusa-config.js plugins:
{
  resolve: "medusa-payment-paypal",
  options: {
    client_id: process.env.PAYPAL_CLIENT_ID,
    client_secret: process.env.PAYPAL_CLIENT_SECRET,
    sandbox: false,  // Set to true for testing
  }
}
```

### 5. Set Up Email Notifications

**Using SendGrid (MCP server already available)**:

```bash
# Configure SendGrid
cd /opt/mcp-servers/sendgrid-mcp-server
cat > .env << 'EOF'
SENDGRID_API_KEY=SG.xxx  # Your SendGrid API key
SENDGRID_FROM_EMAIL=orders@vividwalls.com
SENDGRID_FROM_NAME=VividWalls
EOF

# Install Medusa SendGrid plugin
cd /opt/medusa-backend-v2
npm install medusa-plugin-sendgrid

# Add to medusa-config.js:
{
  resolve: "medusa-plugin-sendgrid",
  options: {
    api_key: process.env.SENDGRID_API_KEY,
    from: process.env.SENDGRID_FROM_EMAIL,
    order_placed_template: "d-xxx",  # SendGrid template IDs
    order_shipped_template: "d-xxx",
    customer_created_template: "d-xxx",
  }
}
```

### 6. Configure Shipping Providers

```bash
# Install shipping plugins
npm install medusa-fulfillment-manual  # Basic manual fulfillment
npm install medusa-fulfillment-webshipper  # Advanced shipping

# Add to medusa-config.js:
{
  resolve: "medusa-fulfillment-manual",
  options: {
    // No options required
  }
}
```

### 7. Import Product Catalog from Shopify

**Using Shopify MCP Server**:

```bash
# The Shopify MCP server is already configured
# Use the sync-products-with-shopify tool

# Via n8n workflow:
# 1. Create "Shopify to Medusa Sync" workflow
# 2. Use Shopify MCP node to fetch products
# 3. Transform data to Medusa format
# 4. Use Medusa API to create products

# Or via direct API:
curl -X POST https://medusa.vividwalls.blog/admin/products/sync \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "direction": "shopify-to-medusa",
    "productIds": []  // Empty for all products
  }'
```

### 8. Set Up Admin Dashboard

```bash
# The admin is built into Medusa v2
# Access at: https://medusa.vividwalls.blog/app

# Create admin user
docker exec medusa-backend npx medusa user:create \
  --email admin@vividwalls.com \
  --password "secure-password"

# Configure admin settings in medusa-config.js:
{
  resolve: "@medusajs/admin",
  options: {
    serve: true,
    path: "/app",
    backend_url: "https://medusa.vividwalls.blog",
  }
}
```

### 9. Configure Production API Keys

```bash
# Create production .env file
cat > /root/vivid_mas/.env.production << 'EOF'
# Database
DATABASE_URL=postgres://medusa:xxx@postgres:5433/medusa_db
REDIS_URL=redis://redis:6379

# Security
JWT_SECRET=xxx  # Generate with: openssl rand -base64 32
COOKIE_SECRET=xxx  # Generate with: openssl rand -base64 32

# Stripe
STRIPE_SECRET_KEY=sk_live_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

# PayPal
PAYPAL_CLIENT_ID=xxx
PAYPAL_CLIENT_SECRET=xxx

# SendGrid
SENDGRID_API_KEY=SG.xxx
SENDGRID_FROM_EMAIL=orders@vividwalls.com

# Medusa
MEDUSA_ADMIN_EMAIL=admin@vividwalls.com
MEDUSA_ADMIN_PASSWORD=xxx
MEDUSA_API_TOKEN=xxx  # For MCP server

# Shopify (for sync)
SHOPIFY_DOMAIN=vividwalls.myshopify.com
SHOPIFY_ACCESS_TOKEN=xxx
EOF
```

## Integration with VividWalls MAS

### MCP Server Connections

1. **Medusa MCP Server** - E-commerce operations
   - Location: `/opt/mcp-servers/medusa-mcp-server`
   - Tools: Orders, customers, inventory, analytics

2. **Stripe MCP Server** - Payment processing
   - Location: `/opt/mcp-servers/stripe-mcp-server`
   - Tools: Payments, refunds, subscriptions, disputes

3. **SendGrid MCP Server** - Email notifications
   - Location: `/opt/mcp-servers/sendgrid-mcp-server`
   - Tools: Send emails, manage templates

4. **Shopify MCP Server** - Product sync
   - Location: `/opt/mcp-servers/shopify-mcp-server`
   - Tools: Product import/export, inventory sync

### Agent Workflows

1. **Business Manager Agent**
   - Access to Medusa analytics and revenue reports
   - Monitor sales performance

2. **Finance Director Agent**
   - Stripe integration for payment reconciliation
   - Tax reporting via Medusa

3. **Sales Director Agent**
   - Order management and customer data
   - Discount and promotion creation

4. **Operations Director Agent**
   - Inventory management
   - Shipping and fulfillment

## Deployment Checklist

- [ ] Deploy Medusa v2 backend
- [ ] Run database migrations
- [ ] Configure payment providers
  - [ ] Stripe API keys
  - [ ] PayPal credentials
- [ ] Set up email notifications
  - [ ] SendGrid API key
  - [ ] Email templates
- [ ] Configure shipping options
- [ ] Import product catalog from Shopify
- [ ] Create admin user
- [ ] Generate production API tokens
- [ ] Update MCP server configurations
- [ ] Test payment flow
- [ ] Test email notifications
- [ ] Deploy storefront
- [ ] Configure SSL certificates
- [ ] Set up monitoring and logging

## Security Considerations

1. **API Keys**: Store all secrets in environment variables
2. **Database**: Use strong passwords, enable SSL
3. **Admin Access**: Use strong passwords, enable 2FA
4. **Webhooks**: Validate webhook signatures
5. **CORS**: Configure allowed origins properly
6. **Rate Limiting**: Implement API rate limits

## Monitoring

1. **Uptime Monitoring**: Monitor https://medusa.vividwalls.blog/health
2. **Error Tracking**: Use Sentry or similar
3. **Performance**: Monitor API response times
4. **Business Metrics**: Track via Medusa analytics

## Backup Strategy

1. **Database**: Daily PostgreSQL backups
2. **Media Files**: Backup uploaded product images
3. **Configuration**: Version control for configs
4. **Disaster Recovery**: Document restoration process