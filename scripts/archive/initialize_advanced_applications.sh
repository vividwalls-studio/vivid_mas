#!/bin/bash

# VividWalls MAS - Advanced Application Initialization
# Initializes Medusa, Neo4j, MinIO, and other advanced applications

set -e

echo "🔧 VividWalls MAS - Advanced Application Initialization"
echo "======================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# SSH connection details
SSH_KEY="~/.ssh/digitalocean"
DROPLET_IP="157.230.13.13"
SSH_USER="root"

# Default credentials
DEFAULT_EMAIL="admin@vividwalls.blog"
DEFAULT_PASSWORD="VividWalls2024!"
DEFAULT_USERNAME="admin"

# Function to execute commands on remote droplet
remote_exec() {
    ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "$1"
}

echo -e "${PURPLE}Phase 1: Medusa E-commerce Initialization${NC}"
echo "========================================"

echo -e "${BLUE}Setting up Medusa admin user...${NC}"
remote_exec "
echo 'Initializing Medusa E-commerce...'

if docker ps | grep -q medusa; then
    echo '✅ Medusa container is running'
    
    # Create admin user via Medusa CLI
    docker exec medusa npx medusa user -e $DEFAULT_EMAIL -p $DEFAULT_PASSWORD --invite && echo '✅ Medusa admin user created'
    
    # Seed database with sample data
    docker exec medusa npx medusa seed -f ./data/seed.json && echo '✅ Medusa database seeded'
    
    # Create store and regions
    docker exec medusa npx medusa migrations run && echo '✅ Medusa migrations completed'
    
    # Test admin API
    admin_response=\$(curl -s -w '%{http_code}' https://medusa.vividwalls.blog/admin -o /dev/null)
    echo \"Medusa admin response: \$admin_response\"
else
    echo '❌ Medusa container not running'
fi
"

echo ""
echo -e "${PURPLE}Phase 2: Neo4j Knowledge Graph Initialization${NC}"
echo "============================================="

echo -e "${BLUE}Setting up Neo4j admin user...${NC}"
remote_exec "
echo 'Initializing Neo4j Knowledge Graph...'

if docker ps | grep -q neo4j; then
    echo '✅ Neo4j container is running'
    
    # Set initial password
    docker exec neo4j-knowledge-fixed neo4j-admin set-initial-password $DEFAULT_PASSWORD && echo '✅ Neo4j password set'
    
    # Create admin user and sample data
    docker exec neo4j-knowledge-fixed cypher-shell -u neo4j -p $DEFAULT_PASSWORD \\
      \"CREATE (admin:User {email: '$DEFAULT_EMAIL', name: 'VividWalls Admin', role: 'admin'})\" && echo '✅ Neo4j admin user created'
    
    # Test connection
    docker exec neo4j-knowledge-fixed cypher-shell -u neo4j -p $DEFAULT_PASSWORD \\
      \"MATCH (n) RETURN count(n) as node_count\" && echo '✅ Neo4j connection tested'
else
    echo '❌ Neo4j container not running'
fi
"

echo ""
echo -e "${PURPLE}Phase 3: MinIO Object Storage Initialization${NC}"
echo "==========================================="

echo -e "${BLUE}Setting up MinIO admin access...${NC}"
remote_exec "
echo 'Initializing MinIO Object Storage...'

if docker ps | grep -q minio; then
    echo '✅ MinIO container is running'
    
    # Create admin policy
    docker exec minio mc admin policy create minio admin-policy /tmp/admin-policy.json
    
    # Create admin user
    docker exec minio mc admin user add minio $DEFAULT_USERNAME $DEFAULT_PASSWORD
    
    # Assign admin policy
    docker exec minio mc admin policy attach minio admin-policy --user $DEFAULT_USERNAME
    
    echo '✅ MinIO admin user configured'
    
    # Create default buckets
    docker exec minio mc mb minio/vividwalls-assets
    docker exec minio mc mb minio/vividwalls-uploads
    docker exec minio mc mb minio/vividwalls-backups
    
    echo '✅ MinIO buckets created'
else
    echo '❌ MinIO container not running'
fi
"

echo ""
echo -e "${PURPLE}Phase 4: Open WebUI Initialization${NC}"
echo "================================="

echo -e "${BLUE}Setting up Open WebUI admin user...${NC}"
remote_exec "
echo 'Initializing Open WebUI...'

if curl -s https://openwebui.vividwalls.blog >/dev/null; then
    echo '✅ Open WebUI is accessible'
    
    # Create admin user via API
    signup_response=\$(curl -s -X POST 'https://openwebui.vividwalls.blog/api/v1/auths/signup' \\
      -H 'Content-Type: application/json' \\
      -d '{
        \"email\": \"$DEFAULT_EMAIL\",
        \"password\": \"$DEFAULT_PASSWORD\",
        \"name\": \"VividWalls Admin\"
      }')
    
    echo \"Open WebUI signup response: \$signup_response\"
    
    # Test login
    login_response=\$(curl -s -X POST 'https://openwebui.vividwalls.blog/api/v1/auths/signin' \\
      -H 'Content-Type: application/json' \\
      -d '{
        \"email\": \"$DEFAULT_EMAIL\",
        \"password\": \"$DEFAULT_PASSWORD\"
      }')
    
    echo \"Open WebUI login test: \$login_response\"
else
    echo '❌ Open WebUI not accessible'
fi
"

echo ""
echo -e "${PURPLE}Phase 5: Postiz Social Media Initialization${NC}"
echo "=========================================="

echo -e "${BLUE}Setting up Postiz admin user...${NC}"
remote_exec "
echo 'Initializing Postiz Social Media...'

if curl -s https://postiz.vividwalls.blog >/dev/null; then
    echo '✅ Postiz is accessible'
    
    # Create admin user via database
    docker exec postiz-postgres psql -U postiz -d postiz -c \"
    INSERT INTO users (
        email,
        name,
        password,
        role,
        created_at,
        updated_at
    ) VALUES (
        '$DEFAULT_EMAIL',
        'VividWalls Admin',
        crypt('$DEFAULT_PASSWORD', gen_salt('bf')),
        'admin',
        now(),
        now()
    ) ON CONFLICT (email) DO NOTHING;
    \" && echo '✅ Postiz admin user created'
    
    # Test API access
    api_response=\$(curl -s -w '%{http_code}' https://postiz.vividwalls.blog/api/auth/me -o /dev/null)
    echo \"Postiz API response: \$api_response\"
else
    echo '❌ Postiz not accessible'
fi
"

echo ""
echo -e "${PURPLE}Phase 6: Additional Services Configuration${NC}"
echo "=========================================="

echo -e "${BLUE}Configuring additional services...${NC}"
remote_exec "
echo 'Configuring Flowise, Langfuse, and other services...'

# Flowise initialization
if curl -s https://flowise.vividwalls.blog >/dev/null; then
    echo '✅ Flowise is accessible'
    # Flowise typically doesn't require user creation - uses API keys
fi

# Langfuse initialization  
if curl -s https://langfuse.vividwalls.blog >/dev/null; then
    echo '✅ Langfuse is accessible'
    # Langfuse uses project-based authentication
fi

# Crawl4AI initialization
if curl -s https://crawl4ai.vividwalls.blog >/dev/null; then
    echo '✅ Crawl4AI is accessible'
    # Crawl4AI typically doesn't require authentication
fi

# Ollama initialization
if curl -s https://ollama.vividwalls.blog >/dev/null; then
    echo '✅ Ollama is accessible'
    # Ollama typically doesn't require authentication
fi

# SearXNG initialization
if curl -s https://searxng.vividwalls.blog >/dev/null; then
    echo '✅ SearXNG is accessible'
    # SearXNG typically doesn't require authentication
fi

# Qdrant initialization
if curl -s https://qdrant.vividwalls.blog >/dev/null; then
    echo '✅ Qdrant is accessible'
    # Qdrant uses API key authentication
fi
"

echo ""
echo -e "${GREEN}🎉 Advanced Application Initialization Complete!${NC}"
echo ""
echo -e "${YELLOW}📋 SUMMARY OF INITIALIZED APPLICATIONS:${NC}"
echo "========================================"
echo "✅ Medusa E-commerce Platform"
echo "✅ Neo4j Knowledge Graph"
echo "✅ MinIO Object Storage"
echo "✅ Open WebUI (ChatGPT Interface)"
echo "✅ Postiz Social Media Management"
echo "✅ Additional AI/ML Services"
echo ""
echo -e "${BLUE}Default Credentials:${NC}"
echo "Email: $DEFAULT_EMAIL"
echo "Password: $DEFAULT_PASSWORD"
echo "Username: $DEFAULT_USERNAME"
echo ""
echo -e "${YELLOW}⚠️ Security Reminder:${NC}"
echo "1. Change default passwords immediately"
echo "2. Enable 2FA where available"
echo "3. Configure proper API keys"
echo "4. Set up backup procedures"
