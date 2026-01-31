#!/bin/bash

# =============================================================================
# VividWalls MAS Frontend DNS and SSL Setup Script
# =============================================================================
# This script sets up DNS records and SSL/HTTPS configuration for app.vividwalls.blog
# Prerequisites:
# - doctl CLI installed and authenticated
# - SSH access to DigitalOcean droplet
# - Docker and Docker Compose installed on droplet
# =============================================================================

set -e  # Exit on error

# Configuration
DOMAIN="vividwalls.blog"
SUBDOMAIN="app"
DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
SSH_USER="root"
FRONTEND_PORT="3003"
EMAIL="admin@vividwalls.blog"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# =============================================================================
# Step 1: Create DNS A Record
# =============================================================================
print_status "Creating DNS A record for ${SUBDOMAIN}.${DOMAIN}..."

# Check if record already exists
EXISTING_RECORD=$(doctl compute domain records list ${DOMAIN} --format Name,Type,Data --no-header | grep "^${SUBDOMAIN} " || true)

if [ -n "$EXISTING_RECORD" ]; then
    print_warning "DNS record for ${SUBDOMAIN}.${DOMAIN} already exists:"
    echo "$EXISTING_RECORD"
    print_status "Updating existing record..."
    
    # Get record ID
    RECORD_ID=$(doctl compute domain records list ${DOMAIN} --format ID,Name --no-header | grep " ${SUBDOMAIN}$" | awk '{print $1}')
    
    # Update the record
    doctl compute domain records update ${DOMAIN} ${RECORD_ID} \
        --record-data ${DROPLET_IP} \
        --record-ttl 300
else
    print_status "Creating new DNS record..."
    doctl compute domain records create ${DOMAIN} \
        --record-type A \
        --record-name ${SUBDOMAIN} \
        --record-data ${DROPLET_IP} \
        --record-ttl 300
fi

print_status "DNS record created/updated successfully!"

# =============================================================================
# Step 2: Verify DNS Propagation
# =============================================================================
print_status "Checking DNS propagation (this may take a few minutes)..."

# Wait for DNS to propagate
MAX_ATTEMPTS=30
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    DNS_RESULT=$(dig +short ${SUBDOMAIN}.${DOMAIN} @8.8.8.8 || true)
    
    if [ "$DNS_RESULT" = "$DROPLET_IP" ]; then
        print_status "DNS has propagated successfully!"
        break
    else
        print_warning "Waiting for DNS propagation... (Attempt $ATTEMPT/$MAX_ATTEMPTS)"
        sleep 10
        ATTEMPT=$((ATTEMPT + 1))
    fi
done

if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
    print_warning "DNS propagation is taking longer than expected. Continuing anyway..."
fi

# =============================================================================
# Step 3: Deploy Frontend Container
# =============================================================================
print_status "Deploying frontend container to droplet..."

# Create deployment script
cat > /tmp/deploy_frontend.sh << 'DEPLOY_SCRIPT'
#!/bin/bash
set -e

cd /root/vivid_mas

# Update docker-compose.yml to include frontend service
if ! grep -q "vivid-frontend:" docker-compose.yml; then
    echo "Adding frontend service to docker-compose.yml..."
    
    # Backup existing file
    cp docker-compose.yml docker-compose.yml.backup.$(date +%Y%m%d_%H%M%S)
    
    # Add frontend service
    cat >> docker-compose.yml << 'EOF'

  vivid-frontend:
    image: node:20-alpine
    container_name: vivid-frontend
    working_dir: /app
    command: sh -c "npm install && npm run build && npm start"
    ports:
      - "3003:3000"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_N8N_URL=https://n8n.vividwalls.blog
      - NEXT_PUBLIC_SUPABASE_URL=https://supabase.vividwalls.blog
      - NEXT_PUBLIC_API_URL=https://api.vividwalls.blog
    volumes:
      - ./frontend:/app
      - /app/node_modules
      - /app/.next
    networks:
      - vivid_mas
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
EOF
fi

# Clone frontend repository if not exists
if [ ! -d "frontend" ]; then
    echo "Cloning frontend repository..."
    git clone https://github.com/kingler/vividwalls_mas_frontend_v1.git frontend
else
    echo "Updating frontend repository..."
    cd frontend
    git pull
    cd ..
fi

# Create health check endpoint
if [ ! -f "frontend/app/api/health/route.ts" ]; then
    mkdir -p frontend/app/api/health
    cat > frontend/app/api/health/route.ts << 'HEALTH'
export async function GET() {
  return Response.json({ status: 'ok', timestamp: new Date().toISOString() })
}
HEALTH
fi

# Start the frontend container
echo "Starting frontend container..."
docker-compose up -d vivid-frontend

# Wait for container to be healthy
echo "Waiting for frontend to be ready..."
sleep 30

# Check container status
docker ps | grep vivid-frontend

echo "Frontend deployment complete!"
DEPLOY_SCRIPT

# Copy and execute deployment script on droplet
print_status "Copying deployment script to droplet..."
scp -i ${SSH_KEY} /tmp/deploy_frontend.sh ${SSH_USER}@${DROPLET_IP}:/tmp/

print_status "Executing deployment on droplet..."
ssh -i ${SSH_KEY} ${SSH_USER}@${DROPLET_IP} "chmod +x /tmp/deploy_frontend.sh && /tmp/deploy_frontend.sh"

# =============================================================================
# Step 4: Update Caddy Configuration
# =============================================================================
print_status "Updating Caddy configuration on droplet..."

# Copy Caddy configuration to droplet
scp -i ${SSH_KEY} /Volumes/SeagatePortableDrive/Projects/vivid_mas/caddy/sites-enabled/app.caddy \
    ${SSH_USER}@${DROPLET_IP}:/root/vivid_mas/caddy/sites-enabled/

# Reload Caddy
ssh -i ${SSH_KEY} ${SSH_USER}@${DROPLET_IP} "docker exec caddy caddy reload --config /etc/caddy/Caddyfile"

# =============================================================================
# Step 5: Verify SSL Certificate
# =============================================================================
print_status "Waiting for SSL certificate generation..."
sleep 10

# Check SSL certificate
print_status "Verifying SSL certificate..."
SSL_CHECK=$(curl -I https://${SUBDOMAIN}.${DOMAIN} 2>&1 | grep "HTTP/2 200" || true)

if [ -n "$SSL_CHECK" ]; then
    print_status "SSL certificate verified successfully!"
else
    print_warning "SSL certificate verification failed. Checking Caddy logs..."
    ssh -i ${SSH_KEY} ${SSH_USER}@${DROPLET_IP} "docker logs caddy --tail 20"
fi

# =============================================================================
# Step 6: Test the Application
# =============================================================================
print_status "Testing application availability..."

# Test HTTP redirect to HTTPS
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -L http://${SUBDOMAIN}.${DOMAIN} || true)
HTTPS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://${SUBDOMAIN}.${DOMAIN} || true)

if [ "$HTTPS_RESPONSE" = "200" ]; then
    print_status "Application is accessible via HTTPS!"
else
    print_warning "Application returned status code: $HTTPS_RESPONSE"
fi

# =============================================================================
# Step 7: Create Update Script
# =============================================================================
print_status "Creating update script for future deployments..."

cat > /Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/update_frontend.sh << 'UPDATE_SCRIPT'
#!/bin/bash
# Quick update script for frontend changes

SSH_KEY="~/.ssh/digitalocean"
SSH_USER="root"
DROPLET_IP="157.230.13.13"

echo "Updating frontend on droplet..."
ssh -i ${SSH_KEY} ${SSH_USER}@${DROPLET_IP} << 'REMOTE_COMMANDS'
cd /root/vivid_mas/frontend
git pull
docker-compose restart vivid-frontend
echo "Frontend updated and restarted!"
REMOTE_COMMANDS
UPDATE_SCRIPT

chmod +x /Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/update_frontend.sh

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "========================================="
echo "DNS and SSL Setup Complete!"
echo "========================================="
echo ""
print_status "DNS Record: ${SUBDOMAIN}.${DOMAIN} → ${DROPLET_IP}"
print_status "SSL Certificate: Automatically managed by Caddy"
print_status "Application URL: https://${SUBDOMAIN}.${DOMAIN}"
echo ""
echo "Services Status:"
echo "- DNS: Configured via DigitalOcean"
echo "- SSL: Let's Encrypt via Caddy"
echo "- Frontend: Running on port ${FRONTEND_PORT}"
echo "- Reverse Proxy: Caddy"
echo ""
echo "Next Steps:"
echo "1. Visit https://${SUBDOMAIN}.${DOMAIN} to access the application"
echo "2. Check Caddy logs: ssh ${SSH_USER}@${DROPLET_IP} 'docker logs caddy'"
echo "3. Check Frontend logs: ssh ${SSH_USER}@${DROPLET_IP} 'docker logs vivid-frontend'"
echo "4. Update frontend: ./scripts/update_frontend.sh"
echo ""
echo "========================================="