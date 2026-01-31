#!/bin/bash

# VividWalls MAS - Application Initialization & Credential Setup
# Initializes all applications with proper admin users and credentials

set -e

echo "🔧 VividWalls MAS - Application Initialization"
echo "=============================================="

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

# Default credentials (will be updated)
DEFAULT_EMAIL="admin@vividwalls.blog"
DEFAULT_PASSWORD="VividWalls2024!"
DEFAULT_USERNAME="admin"

# Function to execute commands on remote droplet
remote_exec() {
    ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "$1"
}

echo -e "${PURPLE}Phase 1: Pre-Initialization Checks${NC}"
echo "=================================="

echo -e "${BLUE}Checking container status...${NC}"
remote_exec "docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -E '(n8n|twenty|listmonk|medusa|wordpress|neo4j|supabase)'"

echo ""
echo -e "${PURPLE}Phase 2: N8N Initialization${NC}"
echo "=========================="

echo -e "${BLUE}Setting up N8N admin user...${NC}"
remote_exec "
echo 'Initializing N8N...'

# Check if N8N is accessible
if curl -s https://n8n.vividwalls.blog >/dev/null; then
    echo '✅ N8N is accessible'
    
    # Try to get N8N setup status
    setup_status=\$(curl -s 'https://n8n.vividwalls.blog/rest/login' | grep -o 'setup' || echo 'configured')
    
    if [[ \$setup_status == 'setup' ]]; then
        echo 'N8N requires initial setup'
        
        # Create admin user via API
        curl -X POST 'https://n8n.vividwalls.blog/rest/owner/setup' \\
          -H 'Content-Type: application/json' \\
          -d '{
            \"email\": \"$DEFAULT_EMAIL\",
            \"password\": \"$DEFAULT_PASSWORD\",
            \"firstName\": \"VividWalls\",
            \"lastName\": \"Admin\"
          }' && echo '✅ N8N admin user created'
    else
        echo 'N8N already configured'
    fi
else
    echo '❌ N8N not accessible'
fi
"

echo ""
echo -e "${PURPLE}Phase 3: Supabase Initialization${NC}"
echo "==============================="

echo -e "${BLUE}Setting up Supabase admin access...${NC}"
remote_exec "
echo 'Initializing Supabase...'

# Check Supabase Studio access
if curl -s https://studio.vividwalls.blog >/dev/null; then
    echo '✅ Supabase Studio is accessible'
    
    # Get Supabase project details
    echo 'Supabase project configuration:'
    docker exec supabase-db psql -U postgres -d postgres -c \"SELECT current_database(), current_user;\" || echo 'Database not accessible'
    
    # Create admin user in auth.users if not exists
    docker exec supabase-db psql -U postgres -d postgres -c \"
    INSERT INTO auth.users (
        id, 
        email, 
        encrypted_password, 
        email_confirmed_at, 
        created_at, 
        updated_at,
        role
    ) VALUES (
        gen_random_uuid(),
        '$DEFAULT_EMAIL',
        crypt('$DEFAULT_PASSWORD', gen_salt('bf')),
        now(),
        now(),
        now(),
        'authenticated'
    ) ON CONFLICT (email) DO NOTHING;
    \" && echo '✅ Supabase admin user created'
else
    echo '❌ Supabase Studio not accessible'
fi
"

echo ""
echo -e "${PURPLE}Phase 4: Twenty CRM Initialization${NC}"
echo "================================"

echo -e "${BLUE}Setting up Twenty CRM admin user...${NC}"
remote_exec "
echo 'Initializing Twenty CRM...'

if curl -s https://twenty.vividwalls.blog >/dev/null; then
    echo '✅ Twenty CRM is accessible'
    
    # Create admin user via database
    docker exec twenty-db-1 psql -U twenty -d twenty -c \"
    INSERT INTO \\\"user\\\" (
        id,
        email,
        \\\"firstName\\\",
        \\\"lastName\\\",
        \\\"passwordHash\\\",
        \\\"emailVerified\\\",
        \\\"createdAt\\\",
        \\\"updatedAt\\\"
    ) VALUES (
        gen_random_uuid(),
        '$DEFAULT_EMAIL',
        'VividWalls',
        'Admin',
        crypt('$DEFAULT_PASSWORD', gen_salt('bf')),
        true,
        now(),
        now()
    ) ON CONFLICT (email) DO NOTHING;
    \" && echo '✅ Twenty CRM admin user created'
    
    # Try GraphQL signup
    curl -X POST 'https://twenty.vividwalls.blog/graphql' \\
      -H 'Content-Type: application/json' \\
      -d '{
        \"query\": \"mutation signup(\$email: String!, \$password: String!, \$firstName: String!, \$lastName: String!) { signup(email: \$email, password: \$password, firstName: \$firstName, lastName: \$lastName) { loginToken { token } } }\",
        \"variables\": {
          \"email\": \"$DEFAULT_EMAIL\",
          \"password\": \"$DEFAULT_PASSWORD\",
          \"firstName\": \"VividWalls\",
          \"lastName\": \"Admin\"
        }
      }' && echo '✅ Twenty CRM GraphQL signup attempted'
else
    echo '❌ Twenty CRM not accessible'
fi
"

echo ""
echo -e "${PURPLE}Phase 5: ListMonk Initialization${NC}"
echo "==============================="

echo -e "${BLUE}Setting up ListMonk admin user...${NC}"
remote_exec "
echo 'Initializing ListMonk...'

if curl -s https://listmonk.vividwalls.blog >/dev/null; then
    echo '✅ ListMonk is accessible'
    
    # Create admin user via database
    docker exec listmonk_db psql -U listmonk -d listmonk -c \"
    INSERT INTO users (
        email,
        name,
        password,
        type,
        status,
        created_at,
        updated_at
    ) VALUES (
        '$DEFAULT_EMAIL',
        'VividWalls Admin',
        crypt('$DEFAULT_PASSWORD', gen_salt('bf')),
        'admin',
        'enabled',
        now(),
        now()
    ) ON CONFLICT (email) DO NOTHING;
    \" && echo '✅ ListMonk admin user created'
    
    # Try to access admin panel
    admin_response=\$(curl -s -w '%{http_code}' https://listmonk.vividwalls.blog/admin -o /dev/null)
    echo \"ListMonk admin panel response: \$admin_response\"
else
    echo '❌ ListMonk not accessible'
fi
"

echo ""
echo -e "${PURPLE}Phase 6: WordPress Initialization${NC}"
echo "==============================="

echo -e "${BLUE}Setting up WordPress admin user...${NC}"
remote_exec "
echo 'Initializing WordPress...'

if curl -s https://wordpress.vividwalls.blog >/dev/null 2>&1; then
    echo '✅ WordPress is accessible'
    
    # Create admin user via WP-CLI
    docker exec wordpress-multisite wp user create $DEFAULT_USERNAME $DEFAULT_EMAIL \\
      --role=administrator \\
      --user_pass=$DEFAULT_PASSWORD \\
      --first_name=VividWalls \\
      --last_name=Admin \\
      --allow-root && echo '✅ WordPress admin user created'
    
    # Update site URL
    docker exec wordpress-multisite wp option update home 'https://wordpress.vividwalls.blog' --allow-root
    docker exec wordpress-multisite wp option update siteurl 'https://wordpress.vividwalls.blog' --allow-root
    
    echo '✅ WordPress URLs updated'
else
    echo '❌ WordPress not accessible'
fi
"

echo ""
echo -e "${GREEN}🎉 Application Initialization Complete!${NC}"
echo ""
echo -e "${YELLOW}📋 SUMMARY OF CREATED CREDENTIALS:${NC}"
echo "=================================="
echo "Email: $DEFAULT_EMAIL"
echo "Password: $DEFAULT_PASSWORD"
echo "Username: $DEFAULT_USERNAME"
echo ""
echo "Applications initialized:"
echo "• N8N Workflow Automation"
echo "• Supabase Backend"
echo "• Twenty CRM"
echo "• ListMonk Email Marketing"
echo "• WordPress CMS"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Test login with new credentials"
echo "2. Change default passwords"
echo "3. Configure application settings"
echo "4. Set up integrations"
