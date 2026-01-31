#!/bin/bash

# Setup Medusa Stripe Integration Script
# This script configures Stripe payment processing for Medusa

set -e

echo "========================================="
echo "Medusa Stripe Integration Setup"
echo "========================================="

# Check if running on the droplet
if [[ ! -f /root/vivid_mas/.env ]]; then
    echo "Error: This script must be run on the VividWalls droplet"
    exit 1
fi

# Function to prompt for API keys
get_stripe_credentials() {
    echo ""
    echo "Please provide your Stripe credentials:"
    echo "You can find these in your Stripe Dashboard at https://dashboard.stripe.com/apikeys"
    echo ""
    
    read -p "Enter your Stripe Secret Key (starts with sk_): " STRIPE_SECRET_KEY
    if [[ ! "$STRIPE_SECRET_KEY" =~ ^sk_ ]]; then
        echo "Error: Invalid Stripe secret key format"
        exit 1
    fi
    
    read -p "Enter your Stripe Publishable Key (starts with pk_): " STRIPE_PUBLISHABLE_KEY
    if [[ ! "$STRIPE_PUBLISHABLE_KEY" =~ ^pk_ ]]; then
        echo "Error: Invalid Stripe publishable key format"
        exit 1
    fi
    
    read -p "Enter your Stripe Webhook Secret (starts with whsec_) [optional]: " STRIPE_WEBHOOK_SECRET
}

# Function to update environment files
update_env_files() {
    echo ""
    echo "Updating environment configuration..."
    
    # Update main .env file
    if ! grep -q "STRIPE_SECRET_KEY" /root/vivid_mas/.env; then
        cat >> /root/vivid_mas/.env << EOF

# Stripe Configuration
STRIPE_SECRET_KEY=$STRIPE_SECRET_KEY
STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY
STRIPE_WEBHOOK_SECRET=$STRIPE_WEBHOOK_SECRET
EOF
        echo "✓ Updated /root/vivid_mas/.env"
    else
        echo "⚠️  Stripe configuration already exists in .env"
    fi
    
    # Configure Stripe MCP server
    mkdir -p /opt/mcp-servers/stripe-mcp-server
    cat > /opt/mcp-servers/stripe-mcp-server/.env << EOF
STRIPE_SECRET_KEY=$STRIPE_SECRET_KEY
EOF
    echo "✓ Configured Stripe MCP server"
}

# Function to setup Medusa Stripe plugin
setup_medusa_stripe() {
    echo ""
    echo "Installing Medusa Stripe plugin..."
    
    # Create a temporary Medusa config update
    cat > /tmp/medusa-stripe-config.js << 'EOF'
// Add this to the plugins array in medusa-config.js
{
  resolve: "medusa-payment-stripe",
  options: {
    api_key: process.env.STRIPE_SECRET_KEY,
    webhook_secret: process.env.STRIPE_WEBHOOK_SECRET,
    automatic_payment_methods: true,
    payment_description: "Order from VividWalls",
    capture: true,  // Automatically capture payments
  }
}
EOF
    
    echo "✓ Stripe plugin configuration created"
    echo ""
    echo "Note: You'll need to manually add the above configuration to your medusa-config.js"
}

# Function to create webhook endpoint
setup_stripe_webhook() {
    echo ""
    echo "Setting up Stripe webhook..."
    echo ""
    echo "Please create a webhook endpoint in your Stripe Dashboard:"
    echo "1. Go to https://dashboard.stripe.com/webhooks"
    echo "2. Click 'Add endpoint'"
    echo "3. Set the endpoint URL to: https://medusa.vividwalls.blog/stripe/hooks"
    echo "4. Select these events:"
    echo "   - payment_intent.succeeded"
    echo "   - payment_intent.payment_failed"
    echo "   - payment_intent.amount_capturable_updated"
    echo "5. Copy the webhook signing secret and update STRIPE_WEBHOOK_SECRET"
}

# Function to test Stripe connection
test_stripe_connection() {
    echo ""
    echo "Testing Stripe connection..."
    
    # Test using Node.js
    node -e "
    const stripe = require('stripe')('$STRIPE_SECRET_KEY');
    stripe.paymentIntents.list({ limit: 1 })
        .then(() => console.log('✓ Stripe connection successful'))
        .catch(err => console.error('✗ Stripe connection failed:', err.message));
    " 2>/dev/null || echo "Note: Install stripe npm package to test connection"
}

# Function to configure Stripe MCP tools
configure_mcp_tools() {
    echo ""
    echo "Configuring Stripe MCP server tools..."
    
    cat > /opt/mcp-servers/stripe-mcp-server/config.json << EOF
{
  "tools": [
    "paymentIntents.read",
    "paymentLinks.create",
    "customers.create",
    "customers.read",
    "products.create",
    "products.read",
    "prices.create",
    "prices.read",
    "invoices.create",
    "invoices.update",
    "refunds.create",
    "subscriptions.read",
    "subscriptions.update",
    "balance.read",
    "disputes.read"
  ],
  "stripeAccount": null
}
EOF
    echo "✓ Stripe MCP tools configured"
}

# Main execution
main() {
    echo ""
    echo "This script will configure Stripe payment processing for your Medusa store."
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    
    # Get credentials
    get_stripe_credentials
    
    # Update configuration
    update_env_files
    setup_medusa_stripe
    configure_mcp_tools
    
    # Setup webhook
    setup_stripe_webhook
    
    # Test connection
    test_stripe_connection
    
    echo ""
    echo "========================================="
    echo "Stripe Integration Setup Complete!"
    echo "========================================="
    echo ""
    echo "Next steps:"
    echo "1. Add the Stripe plugin configuration to your medusa-config.js"
    echo "2. Install the plugin: npm install medusa-payment-stripe"
    echo "3. Restart your Medusa backend"
    echo "4. Create the webhook endpoint in Stripe Dashboard"
    echo "5. Test a payment flow"
    echo ""
    echo "For production:"
    echo "- Use live API keys (sk_live_... and pk_live_...)"
    echo "- Ensure webhook endpoint is properly configured"
    echo "- Test the complete payment flow"
    echo "- Monitor webhook events in Stripe Dashboard"
}

# Run main function
main