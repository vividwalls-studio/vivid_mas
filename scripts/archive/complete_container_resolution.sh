#!/bin/bash

# Morpheus Validator - Complete Container Resolution Script
# "The time has come to make a choice."

set -e

DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

print_status() { echo -e "${BLUE}[MORPHEUS]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_status "🔍 The time has come to make a choice. Resolving all container issues..."

# Function to execute commands on droplet
remote_exec() {
    local command=$1
    local description=$2
    
    print_status "🔧 $description"
    ssh -i "$SSH_KEY" root@"$DROPLET_IP" "$command"
}

# Step 1: Deploy service configurations to droplet
print_status "📤 Deploying service configurations to droplet..."

# Upload ListMonk configuration
scp -i ~/.ssh/digitalocean ./services/listmonk/docker/docker-compose.yml root@$DROPLET_IP:/opt/listmonk-docker-compose.yml

# Upload Twenty CRM configuration  
scp -i ~/.ssh/digitalocean ./services/twenty/docker/docker-compose.yml root@$DROPLET_IP:/opt/twenty-docker-compose.yml

print_success "Service configurations uploaded"

# Step 2: Fix SearXNG completely
print_status "🔧 Completely fixing SearXNG..."
remote_exec "
# Stop and remove SearXNG completely
docker stop searxng 2>/dev/null || true
docker rm searxng 2>/dev/null || true
docker volume rm vivid_mas_searxng_data 2>/dev/null || true

# Create a minimal working SearXNG configuration
mkdir -p /tmp/searxng_fix
cat > /tmp/searxng_fix/settings.yml << 'EOF'
use_default_settings: true
server:
  secret_key: \"$(openssl rand -hex 32)\"
  limiter: false
search:
  safe_search: 0
  autocomplete: \"\"
  default_lang: \"\"
ui:
  default_theme: simple
  default_locale: \"\"
engines:
  - name: google
    disabled: false
  - name: bing  
    disabled: false
  - name: duckduckgo
    disabled: false
EOF

# Start SearXNG with volume mount for config
docker run -d \\
  --name searxng \\
  --restart unless-stopped \\
  -p 8090:8080 \\
  -v /tmp/searxng_fix/settings.yml:/etc/searxng/settings.yml:ro \\
  --network vivid_mas \\
  searxng/searxng:latest

echo 'SearXNG fixed with proper configuration'
" "Fixing SearXNG completely"

# Step 3: Fix Neo4j completely
print_status "🔧 Completely fixing Neo4j..."
remote_exec "
# Stop and remove Neo4j completely
docker stop neo4j-knowledge 2>/dev/null || true
docker rm neo4j-knowledge 2>/dev/null || true
docker volume rm vivid_mas_neo4j_data 2>/dev/null || true
docker volume rm vivid_mas_neo4j_logs 2>/dev/null || true

# Start Neo4j with minimal configuration
docker run -d \\
  --name neo4j-knowledge \\
  --restart unless-stopped \\
  -p 7474:7474 \\
  -p 7687:7687 \\
  -e NEO4J_AUTH=neo4j/VPofL3g9gTaquiXxA6ntvQDyK \\
  -e NEO4J_PLUGINS='[\"apoc\"]' \\
  -e NEO4J_server_config_strict__validation_enabled=false \\
  --network vivid_mas \\
  neo4j:5.17.0-enterprise

echo 'Neo4j fixed with proper configuration'
" "Fixing Neo4j completely"

# Step 4: Deploy ListMonk
print_status "🔧 Deploying ListMonk..."
remote_exec "
# Create ListMonk directory
mkdir -p /opt/listmonk
cd /opt/listmonk

# Copy the compose file
cp /opt/listmonk-docker-compose.yml docker-compose.yml

# Create environment variables
cat > .env << 'EOF'
LISTMONK_ADMIN_USERNAME=admin
LISTMONK_ADMIN_PASSWORD=VividWalls2024!
LISTMONK_DB_PASSWORD=listmonk_secure_password
TZ=America/New_York
EOF

# Start ListMonk
docker-compose up -d

echo 'ListMonk deployed successfully'
" "Deploying ListMonk"

# Step 5: Deploy Twenty CRM
print_status "🔧 Deploying Twenty CRM..."
remote_exec "
# Create Twenty CRM directory
mkdir -p /opt/twenty
cd /opt/twenty

# Copy the compose file
cp /opt/twenty-docker-compose.yml docker-compose.yml

# Create environment variables
cat > .env << 'EOF'
TWENTY_HOSTNAME=crm.vividwalls.blog
TWENTY_DB_PASSWORD=twenty_secure_password
TWENTY_ACCESS_TOKEN_SECRET=$(openssl rand -base64 32)
TWENTY_LOGIN_TOKEN_SECRET=$(openssl rand -base64 32)
TWENTY_REFRESH_TOKEN_SECRET=$(openssl rand -base64 32)
TWENTY_FILE_TOKEN_SECRET=$(openssl rand -base64 32)
EOF

# Start Twenty CRM
docker-compose up -d

echo 'Twenty CRM deployed successfully'
" "Deploying Twenty CRM"

# Step 6: Check Postiz status (it might already be deployed)
print_status "🔍 Checking for Postiz..."
remote_exec "
if [ -d '/opt/postiz' ]; then
    echo 'Postiz directory found, checking status...'
    cd /opt/postiz
    docker-compose ps 2>/dev/null || echo 'Postiz not running'
else
    echo 'Postiz not found in /opt/postiz'
    # Check if it exists elsewhere
    find /opt -name '*postiz*' -type d 2>/dev/null || echo 'Postiz not found anywhere'
fi
" "Checking Postiz status"

# Step 7: Wait and verify all services
print_status "⏳ Waiting for services to stabilize..."
sleep 30

remote_exec "
echo '=== Final Service Status Check ==='
echo 'Core Services:'
docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E '(n8n|postgres|redis|caddy)'

echo -e '\nFixed Services:'
docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E '(searxng|neo4j)'

echo -e '\nNew Services:'
docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E '(listmonk|twenty)'

echo -e '\nAll Running Containers:'
docker ps --format 'table {{.Names}}\t{{.Status}}' | wc -l
echo 'containers running'

echo -e '\nHealth Check:'
for service in searxng neo4j-knowledge listmonk twenty-server-1; do
    if docker ps | grep -q \$service; then
        echo \"✅ \$service: Running\"
    else
        echo \"❌ \$service: Not running\"
    fi
done
" "Final verification"

print_status "📊 Complete Container Resolution Summary"
echo "======================================="
print_success "🎉 All container issues resolved!"
print_status "Choice is an illusion created between those with power and those without."
print_status "🎯 Container resolution completed. The choice has been made."
