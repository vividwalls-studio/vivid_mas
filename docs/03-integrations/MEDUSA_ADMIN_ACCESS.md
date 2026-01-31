# Medusa Admin Dashboard Access

## Overview

The Medusa admin dashboard provides a web interface for managing your e-commerce store, including products, orders, customers, and settings.

## Access URLs

- **Production Admin**: https://medusa.vividwalls.blog/app
- **API Base URL**: https://medusa.vividwalls.blog

## Admin Credentials

**Default Admin Account:**
- Email: `admin@vividwalls.com`
- Password: `admin123`

**Important**: Change these credentials immediately after first login!

## Features Available

### Dashboard Overview
- Total revenue tracking
- Order statistics
- Customer metrics
- Product inventory status
- Recent order activity
- Revenue charts

### Product Management
- View all 20 imported products from Shopify
- Edit product details
- Manage variants and pricing
- Update inventory levels
- Add product images

### Order Management
- View and process orders
- Update order status
- Issue refunds via Stripe
- Print packing slips
- Export order data

### Customer Management
- View customer profiles
- Order history
- Customer groups
- Export customer data

### Settings
- Store configuration
- Payment methods (Stripe configured)
- Shipping zones
- Tax settings
- User management

## API Endpoints

### Authentication
```bash
POST https://medusa.vividwalls.blog/admin/auth
{
  "email": "admin@vividwalls.com",
  "password": "admin123"
}
```

### Dashboard Stats
```bash
GET https://medusa.vividwalls.blog/admin/dashboard
Authorization: Bearer <token>
```

### Products
```bash
GET https://medusa.vividwalls.blog/admin/products
Authorization: Bearer <token>
```

### Orders
```bash
GET https://medusa.vividwalls.blog/admin/orders
Authorization: Bearer <token>
```

## Integration with MCP Servers

The admin dashboard can trigger actions through various MCP servers:

1. **Shopify MCP Server**
   - Sync products
   - Update inventory
   - Import new products

2. **Stripe MCP Server**
   - Process refunds
   - View payment details
   - Create payment links

3. **SendGrid MCP Server**
   - Send order confirmations
   - Customer notifications
   - Marketing emails

## Troubleshooting

### Cannot Access Admin Dashboard

1. Check if Medusa container is running:
   ```bash
   docker ps | grep medusa
   ```

2. Check container logs:
   ```bash
   docker logs medusa --tail 50
   ```

3. Verify Caddy is routing correctly:
   ```bash
   curl -I https://medusa.vividwalls.blog/health
   ```

### Login Issues

1. Verify credentials are correct
2. Check API response:
   ```bash
   curl -X POST https://medusa.vividwalls.blog/admin/auth \
     -H "Content-Type: application/json" \
     -d '{"email":"admin@vividwalls.com","password":"admin123"}'
   ```

### Missing Data

If products or orders are not showing:

1. Check database connection:
   ```bash
   docker exec postgres psql -U medusa -d medusa_db -c "SELECT COUNT(*) FROM product;"
   ```

2. Verify API endpoints:
   ```bash
   curl https://medusa.vividwalls.blog/admin/products \
     -H "Authorization: Bearer <token>"
   ```

## Security Best Practices

1. **Change Default Password**: First priority after setup
2. **Enable 2FA**: When available
3. **Limit Admin Access**: Create role-based accounts
4. **Regular Backups**: Database and configuration
5. **Monitor Access Logs**: Check for unauthorized attempts

## Next Steps

1. Change admin password
2. Create additional admin users
3. Configure email templates
4. Set up automated backups
5. Enable monitoring alerts