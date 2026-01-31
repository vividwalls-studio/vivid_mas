#!/bin/bash

# Fix SSL Certificate Issues
# This script addresses SSL certificate acquisition and configuration

set -e

echo "🔒 Fixing SSL Certificate Issues..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# SSH connection details
SSH_KEY="~/.ssh/digitalocean"
DROPLET_IP="157.230.13.13"
SSH_USER="root"

# Function to execute commands on remote droplet
remote_exec() {
    ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "$1"
}

echo -e "${BLUE}Step 1: Checking current SSL certificate status${NC}"
remote_exec "docker exec caddy caddy list-certificates"

echo -e "${BLUE}Step 2: Checking Caddy configuration${NC}"
remote_exec "docker exec caddy caddy validate --config /etc/caddy/Caddyfile"

echo -e "${BLUE}Step 3: Checking DNS resolution for domains${NC}"
domains=("n8n.vividwalls.blog" "supabase.vividwalls.blog" "openwebui.vividwalls.blog")
for domain in "${domains[@]}"; do
    echo "Checking DNS for $domain:"
    nslookup "$domain" || echo "DNS resolution failed for $domain"
done

echo -e "${BLUE}Step 4: Forcing SSL certificate renewal${NC}"
remote_exec "docker exec caddy caddy reload --config /etc/caddy/Caddyfile"

echo -e "${BLUE}Step 5: Creating SSL certificate troubleshooting script${NC}"
remote_exec "cat > /tmp/ssl_troubleshoot.sh << 'EOF'
#!/bin/bash

echo \"SSL Certificate Troubleshooting Report\"
echo \"======================================\"

echo \"1. Caddy Status:\"
docker exec caddy caddy version

echo \"2. Certificate Status:\"
docker exec caddy caddy list-certificates

echo \"3. Caddy Logs (last 20 lines):\"
docker logs caddy --tail 20

echo \"4. Port 80/443 Status:\"
netstat -tlnp | grep -E ':80|:443'

echo \"5. DNS Resolution Check:\"
for domain in n8n.vividwalls.blog supabase.vividwalls.blog openwebui.vividwalls.blog; do
    echo \"Checking \$domain:\"
    nslookup \$domain
    echo \"---\"
done

echo \"6. Caddy Configuration Validation:\"
docker exec caddy caddy validate --config /etc/caddy/Caddyfile

echo \"7. ACME Challenge Test:\"
curl -I http://n8n.vividwalls.blog/.well-known/acme-challenge/test || echo \"ACME challenge path not accessible\"

echo \"SSL Troubleshooting Complete\"
EOF"

echo -e "${BLUE}Step 6: Making troubleshooting script executable${NC}"
remote_exec "chmod +x /tmp/ssl_troubleshoot.sh"

echo -e "${BLUE}Step 7: Running SSL troubleshooting${NC}"
remote_exec "/tmp/ssl_troubleshoot.sh"

echo -e "${BLUE}Step 8: Attempting to force certificate acquisition${NC}"
remote_exec "docker exec caddy caddy reload --config /etc/caddy/Caddyfile --force"

echo -e "${BLUE}Step 9: Checking if certificates were acquired${NC}"
sleep 30  # Wait for certificate acquisition
remote_exec "docker exec caddy caddy list-certificates"

echo -e "${BLUE}Step 10: Testing HTTPS endpoints${NC}"
domains=("n8n.vividwalls.blog" "supabase.vividwalls.blog" "openwebui.vividwalls.blog")
for domain in "${domains[@]}"; do
    echo "Testing HTTPS for $domain:"
    curl -I "https://$domain" --connect-timeout 10 || echo "HTTPS test failed for $domain"
done

echo -e "${GREEN}✅ SSL certificate troubleshooting completed${NC}"
echo -e "${YELLOW}Note: SSL certificates may take up to 24 hours to fully propagate${NC}"
