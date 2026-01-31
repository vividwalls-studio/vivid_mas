#!/bin/bash
# Script to create DNS A record for Medusa on DigitalOcean

# Configuration
DOMAIN="vividwalls.blog"
SERVER_IP="157.230.13.13"
SUBDOMAIN="medusa"

echo "Creating DNS A record for ${SUBDOMAIN}.${DOMAIN}..."

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "Error: doctl CLI is not installed. Please install it first:"
    echo "brew install doctl"
    exit 1
fi

# Check if authenticated
if ! doctl auth list &> /dev/null; then
    echo "Error: Not authenticated with DigitalOcean. Run 'doctl auth init' first."
    exit 1
fi

# Create the A record
echo "Creating A record for ${SUBDOMAIN}.${DOMAIN} pointing to ${SERVER_IP}..."
doctl compute domain records create $DOMAIN \
    --record-type A \
    --record-name $SUBDOMAIN \
    --record-data $SERVER_IP \
    --record-ttl 300

# Check if the record was created successfully
if [ $? -eq 0 ]; then
    echo "✅ DNS A record created successfully!"
    echo ""
    echo "DNS Record Details:"
    echo "- Domain: ${SUBDOMAIN}.${DOMAIN}"
    echo "- Type: A"
    echo "- IP: ${SERVER_IP}"
    echo "- TTL: 300 seconds"
    echo ""
    echo "Please wait 5-30 minutes for DNS propagation."
    echo ""
    echo "To verify DNS propagation, run:"
    echo "  dig ${SUBDOMAIN}.${DOMAIN}"
    echo "  nslookup ${SUBDOMAIN}.${DOMAIN}"
    echo ""
    echo "Once propagated, Medusa will be accessible at:"
    echo "  https://${SUBDOMAIN}.${DOMAIN}"
    echo "  Admin: https://${SUBDOMAIN}.${DOMAIN}/app"
else
    echo "❌ Failed to create DNS record. Please check your authentication and try again."
    exit 1
fi

# Verify the record was created
echo ""
echo "Current DNS records for ${DOMAIN}:"
doctl compute domain records list $DOMAIN | grep -E "(Type|medusa|^ID)" | head -20