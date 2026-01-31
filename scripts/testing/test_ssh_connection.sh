#!/bin/bash

echo "Testing SSH connection to Digital Ocean droplet..."
echo "When prompted, enter passphrase: freedom"
echo ""

# Test basic connection
ssh -i /Users/kinglerbercy/.ssh/digitalocean root@157.230.13.13 "echo 'SSH connection successful!'"