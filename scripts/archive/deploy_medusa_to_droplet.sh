#!/bin/bash
# Deploy Medusa E-commerce Platform to DigitalOcean Droplet

set -e  # Exit on error

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
REMOTE_USER="root"
REMOTE_PATH="/root/vivid_mas"

echo "🚀 Deploying Medusa to DigitalOcean Droplet..."
echo "Target: ${REMOTE_USER}@${DROPLET_IP}"
echo ""

# Step 1: Create necessary directories on droplet
echo "📁 Creating directories on droplet..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
mkdir -p /root/vivid_mas/services/medusa/{docker,config}
mkdir -p /opt/mcp-servers/medusa-mcp-server
EOF

# Step 2: Copy Medusa files
echo "📤 Copying Medusa files to droplet..."
rsync -avz --progress \
  -e "ssh -i $SSH_KEY" \
  ./services/medusa/ \
  ${REMOTE_USER}@${DROPLET_IP}:${REMOTE_PATH}/services/medusa/

# Step 3: Copy MCP server files
echo "📤 Copying MCP server files..."
rsync -avz --progress \
  -e "ssh -i $SSH_KEY" \
  ./services/mcp-servers/core/medusa-mcp-server/ \
  ${REMOTE_USER}@${DROPLET_IP}:/opt/mcp-servers/medusa-mcp-server/

# Step 4: Copy updated docker-compose.yml
echo "📤 Copying updated docker-compose.yml..."
scp -i $SSH_KEY ./docker-compose.yml ${REMOTE_USER}@${DROPLET_IP}:${REMOTE_PATH}/

# Step 5: Copy Caddy configuration
echo "📤 Copying Caddy configuration..."
scp -i $SSH_KEY ./caddy/sites-enabled/medusa.caddy ${REMOTE_USER}@${DROPLET_IP}:${REMOTE_PATH}/caddy/sites-enabled/

# Step 6: Update environment variables on droplet
echo "🔧 Updating environment variables..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
cd /root/vivid_mas

# Backup current .env
cp .env .env.backup-$(date +%Y%m%d_%H%M%S)

# Add Medusa environment variables if not present
if ! grep -q "MEDUSA_HOSTNAME" .env; then
    echo "" >> .env
    echo "# Medusa Configuration" >> .env
    echo "MEDUSA_HOSTNAME=medusa.vividwalls.blog" >> .env
    echo "MEDUSA_DB_PASSWORD=medusa_secure_password_$(openssl rand -hex 16)" >> .env
    echo "MEDUSA_JWT_SECRET=$(openssl rand -base64 32)" >> .env
    echo "MEDUSA_COOKIE_SECRET=$(openssl rand -base64 32)" >> .env
    echo "MEDUSA_ADMIN_EMAIL=admin@vividwalls.com" >> .env
    echo "MEDUSA_ADMIN_PASSWORD=$(openssl rand -base64 16)" >> .env
fi

# Show generated passwords
echo ""
echo "Generated Medusa credentials (save these!):"
grep "MEDUSA_" .env | grep -E "(ADMIN|PASSWORD)"
echo ""
EOF

# Step 7: Build MCP server on droplet
echo "🔨 Building MCP server..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
cd /opt/mcp-servers/medusa-mcp-server
npm install
npm run build
chmod +x build/index.js
EOF

# Step 8: Create Medusa database
echo "🗄️ Creating Medusa database..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
cd /root/vivid_mas

# Get the Medusa DB password from .env
MEDUSA_DB_PASSWORD=$(grep MEDUSA_DB_PASSWORD .env | cut -d '=' -f2)

# Create database and user
docker exec postgres psql -U postgres -c "CREATE DATABASE medusa_db;" || echo "Database may already exist"
docker exec postgres psql -U postgres -c "CREATE USER medusa WITH ENCRYPTED PASSWORD '$MEDUSA_DB_PASSWORD';" || echo "User may already exist"
docker exec postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE medusa_db TO medusa;"
docker exec postgres psql -U postgres -c "ALTER DATABASE medusa_db OWNER TO medusa;"
EOF

# Step 9: Start Medusa container
echo "🐳 Starting Medusa container..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
cd /root/vivid_mas

# Pull/build and start Medusa
docker-compose up -d medusa

# Wait for Medusa to start
echo "Waiting for Medusa to start..."
for i in {1..30}; do
    if docker exec medusa curl -f http://localhost:9000/health 2>/dev/null; then
        echo "✅ Medusa is running!"
        break
    fi
    echo -n "."
    sleep 2
done
echo ""

# Run migrations
echo "Running Medusa migrations..."
docker exec medusa npm run migrations:run || echo "Migrations may have already run"

# Create admin user
MEDUSA_ADMIN_EMAIL=$(grep MEDUSA_ADMIN_EMAIL .env | cut -d '=' -f2)
MEDUSA_ADMIN_PASSWORD=$(grep MEDUSA_ADMIN_PASSWORD .env | cut -d '=' -f2)
docker exec medusa npx medusa user -e $MEDUSA_ADMIN_EMAIL -p $MEDUSA_ADMIN_PASSWORD || echo "Admin user may already exist"
EOF

# Step 10: Restart Caddy for new configuration
echo "🔄 Restarting Caddy..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
docker-compose restart caddy
EOF

# Step 11: Configure n8n to use MCP server
echo "🔗 Configuring n8n MCP server..."
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} << 'EOF'
cd /root/vivid_mas

# Create MCP configuration for n8n
cat > n8n-mcp-medusa-config.json << 'EOC'
{
  "medusa": {
    "command": "node",
    "args": ["/opt/mcp-servers/medusa-mcp-server/build/index.js"],
    "env": {
      "MEDUSA_BASE_URL": "http://medusa:9000",
      "MEDUSA_API_TOKEN": "will-be-generated-later"
    }
  }
}
EOC

echo "✅ MCP configuration created. You'll need to:"
echo "1. Generate a Medusa API token from the admin panel"
echo "2. Update the MEDUSA_API_TOKEN in the MCP config"
echo "3. Add this configuration to n8n's MCP settings"
EOF

# Final status check
echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📋 Next steps:"
echo "1. Create DNS A record: Run ./scripts/create_medusa_dns_record.sh"
echo "2. Wait for DNS propagation (5-30 minutes)"
echo "3. Access Medusa at: https://medusa.vividwalls.blog"
echo "4. Login to admin panel: https://medusa.vividwalls.blog/app"
echo "5. Generate API token for MCP server integration"
echo ""
echo "✅ Services status:"
ssh -i $SSH_KEY ${REMOTE_USER}@${DROPLET_IP} "docker ps | grep -E '(medusa|caddy)'"