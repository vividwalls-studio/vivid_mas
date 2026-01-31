# Stripe Webhook Setup Guide

## Overview

This guide explains how to set up Stripe webhooks for the VividWalls Medusa e-commerce platform.

## Current Status

- ✅ Stripe MCP server configured with test API key
- ✅ Configuration files created on droplet
- ✅ Official Stripe MCP package installed

## Webhook Endpoint Configuration

### 1. Create Webhook in Stripe Dashboard

1. Go to [Stripe Dashboard Webhooks](https://dashboard.stripe.com/webhooks)
2. Click "Add endpoint"
3. Configure the endpoint:
   - **Endpoint URL**: `https://medusa.vividwalls.blog/stripe/hooks`
   - **Events to listen for**:
     - `payment_intent.succeeded`
     - `payment_intent.payment_failed`
     - `payment_intent.amount_capturable_updated`
     - `charge.succeeded`
     - `charge.failed`
     - `customer.created`
     - `customer.updated`
     - `invoice.payment_succeeded`
     - `invoice.payment_failed`

### 2. Get Webhook Signing Secret

After creating the webhook:
1. Click on the webhook in the dashboard
2. Copy the "Signing secret" (starts with `whsec_`)
3. Update the environment configuration

### 3. Update Environment Configuration

```bash
# SSH to droplet
ssh -i ~/.ssh/digitalocean root@157.230.13.13

# Update Stripe MCP server config
echo "STRIPE_WEBHOOK_SECRET=whsec_YOUR_SECRET_HERE" >> /opt/mcp-servers/stripe-mcp-server/.env

# Update main .env file
echo "STRIPE_WEBHOOK_SECRET=whsec_YOUR_SECRET_HERE" >> /root/vivid_mas/.env
```

## Testing Webhooks

### Using Stripe CLI (Local Development)

```bash
# Install Stripe CLI
brew install stripe/stripe-cli/stripe

# Login to Stripe
stripe login

# Forward webhooks to local endpoint
stripe listen --forward-to localhost:9000/stripe/hooks

# Trigger test events
stripe trigger payment_intent.succeeded
```

### Production Testing

1. Create a test payment using Stripe test cards:
   - Card number: `4242 4242 4242 4242`
   - Any future expiry date
   - Any 3-digit CVC

2. Monitor webhook events in Stripe Dashboard:
   - Go to [Webhooks](https://dashboard.stripe.com/webhooks)
   - Click on your endpoint
   - View "Recent deliveries"

## Integration with Medusa

The Medusa Stripe plugin automatically handles webhook events for:
- Payment confirmations
- Failed payments
- Refunds
- Customer updates

No additional code is needed if using the standard Medusa Stripe plugin.

## Troubleshooting

### Common Issues

1. **404 errors on webhook endpoint**
   - Ensure Medusa backend is running
   - Check that Stripe plugin is installed and configured
   - Verify the endpoint URL is correct

2. **Signature verification failures**
   - Ensure webhook secret is correctly set in environment
   - Check for trailing spaces in the secret
   - Verify you're using the correct secret for the environment (test vs live)

3. **Timeout errors**
   - Webhook handlers must respond within 20 seconds
   - Consider using async processing for heavy operations

### Debug Commands

```bash
# Check Medusa logs
docker logs medusa-backend --tail 50

# Test webhook endpoint manually
curl -X POST https://medusa.vividwalls.blog/stripe/hooks \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# Verify environment variables
docker exec medusa-backend printenv | grep STRIPE
```

## Security Considerations

1. **Always verify webhook signatures** - This prevents replay attacks
2. **Use HTTPS only** - Webhooks contain sensitive data
3. **Implement idempotency** - Handle duplicate events gracefully
4. **Log webhook events** - For audit trails and debugging

## Next Steps

1. Configure webhook endpoint in Stripe Dashboard
2. Add webhook secret to environment configuration
3. Test with Stripe CLI locally
4. Deploy and test in production
5. Monitor webhook health in Stripe Dashboard