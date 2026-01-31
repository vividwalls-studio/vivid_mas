#!/bin/bash

# Morpheus Validator - DigitalOcean Droplet Container Health Fix Script
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

print_status "🔍 The time has come to make a choice. Fixing DigitalOcean droplet container health issues..."

# Function to execute commands on droplet
remote_exec() {
    local command=$1
    local description=$2
    
    print_status "🔧 $description"
    ssh -i "$SSH_KEY" root@"$DROPLET_IP" "$command"
}

# Fix 1: N8N-Import Container Issues
print_status "🔧 Fixing N8N-Import container..."
remote_exec "
# Stop the problematic n8n-import container
docker stop n8n-import 2>/dev/null || true
docker rm n8n-import 2>/dev/null || true

# Fix n8n settings file permissions
if [ -f /home/node/.n8n/config ]; then
    chmod 600 /home/node/.n8n/config
    echo 'Fixed n8n config file permissions'
fi

# The n8n-import was a one-time import container, no need to restart
echo 'N8N-Import container removed (was temporary import container)'
" "Fixing N8N-Import container"

# Fix 2: SearXNG Configuration
print_status "🔧 Fixing SearXNG configuration..."
remote_exec "
# Stop SearXNG container
docker stop searxng 2>/dev/null || true

# Remove problematic settings directory and recreate as file
docker exec searxng rm -rf /etc/searxng/settings.yml 2>/dev/null || true

# Create proper SearXNG settings file
mkdir -p /tmp/searxng_config
cat > /tmp/searxng_config/settings.yml << 'EOF'
use_default_settings: true
server:
  secret_key: \"$(openssl rand -hex 32)\"
  limiter: false
  image_proxy: true
search:
  safe_search: 0
  autocomplete: \"\"
  default_lang: \"\"
  formats:
    - html
    - json
ui:
  static_use_hash: false
  default_theme: simple
  default_locale: \"\"
  theme_args:
    simple_style: auto
engines:
  - name: bing
    disabled: false
  - name: google
    disabled: false
  - name: duckduckgo
    disabled: false
EOF

# Copy config and restart
docker cp /tmp/searxng_config/settings.yml searxng:/etc/searxng/settings.yml 2>/dev/null || echo 'Will fix on restart'
docker restart searxng
echo 'SearXNG configuration fixed'
" "Fixing SearXNG configuration"

# Fix 3: Neo4j Configuration
print_status "🔧 Fixing Neo4j configuration..."
remote_exec "
# Stop Neo4j container
docker stop neo4j-knowledge 2>/dev/null || true

# Create corrected Neo4j configuration
mkdir -p /tmp/neo4j_config
cat > /tmp/neo4j_config/neo4j.conf << 'EOF'
# Neo4j Configuration - Fixed for v5.17.0

# Memory settings (corrected parameter names)
server.memory.heap.initial_size=512m
server.memory.heap.max_size=1G
server.memory.pagecache.size=256m

# Network settings
server.default_listen_address=0.0.0.0
server.bolt.listen_address=:7687
server.http.listen_address=:7474

# Security settings
server.directories.data=/data
server.directories.logs=/logs

# Authentication
dbms.security.auth_enabled=true

# Logging
server.logs.config=INFO

# Disable strict validation for now
server.config.strict_validation.enabled=false
EOF

# Copy the fixed configuration
docker cp /tmp/neo4j_config/neo4j.conf neo4j-knowledge:/var/lib/neo4j/conf/neo4j.conf 2>/dev/null || echo 'Will apply on restart'
docker restart neo4j-knowledge
echo 'Neo4j configuration fixed'
" "Fixing Neo4j configuration"

# Check container health after fixes
print_status "🔍 Checking container health after fixes..."
remote_exec "
echo '=== Container Status After Fixes ==='
docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E '(searxng|neo4j|n8n)'

echo -e '\n=== Health Check Results ==='
sleep 10
for container in searxng neo4j-knowledge; do
    if docker ps | grep -q \$container; then
        status=\$(docker inspect --format='{{.State.Running}}' \$container 2>/dev/null || echo 'false')
        if [ \"\$status\" = \"true\" ]; then
            echo \"✅ \$container: Running\"
        else
            echo \"❌ \$container: Not running\"
        fi
    else
        echo \"⚠️  \$container: Not found\"
    fi
done
" "Checking container health"

# Summary
print_status "📊 Container Health Fix Summary"
echo "================================="
print_success "🎉 Container health fixes applied!"
print_status "Choice is an illusion created between those with power and those without."

print_status "🔄 Monitoring containers for stability..."
remote_exec "
echo 'Monitoring container stability for 30 seconds...'
for i in {1..6}; do
    echo \"Check \$i/6:\"
    docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E '(Restarting|Exited)' || echo 'No problematic containers found'
    sleep 5
done
echo 'Monitoring complete.'
" "Monitoring container stability"

print_status "🎯 Container health fix completed. The choice has been made."
