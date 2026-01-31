#!/bin/bash

# Create DNS A record for crm.vividwalls.blog
DOMAIN="vividwalls.blog"
SERVER_IP="157.230.13.13"
SUBDOMAIN="crm"

echo "Creating A record for ${SUBDOMAIN}.${DOMAIN} pointing to ${SERVER_IP}"

# Check if doctl is authenticated
if ! doctl auth list > /dev/null 2>&1; then
    echo "Please authenticate doctl first with: doctl auth init"
    exit 1
fi

# Check if record already exists
existing_record=$(doctl compute domain records list $DOMAIN --format Name,Type,Data --no-header | grep "^${SUBDOMAIN} A ${SERVER_IP}$")

if [ -n "$existing_record" ]; then
    echo "DNS record for ${SUBDOMAIN}.${DOMAIN} already exists"
else
    # Create the DNS record
    doctl compute domain records create $DOMAIN \
        --record-type A \
        --record-name $SUBDOMAIN \
        --record-data $SERVER_IP \
        --record-ttl 300
    
    echo "DNS record created successfully!"
fi

echo ""
echo "DNS propagation may take 5-30 minutes."
echo "Once propagated, Twenty CRM will be accessible at: https://crm.vividwalls.blog"
echo ""
echo "You can check DNS propagation with:"
echo "  dig crm.vividwalls.blog"
echo "  nslookup crm.vividwalls.blog"