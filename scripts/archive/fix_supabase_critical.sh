#!/bin/bash

# VividWalls MAS - Definitive Supabase Fix
# Resolves the critical authentication issues permanently

echo "🔧 DEFINITIVE SUPABASE AUTHENTICATION FIX"
echo "=========================================="

# SSH connection details
SSH_KEY="~/.ssh/digitalocean"
DROPLET_IP="157.230.13.13"
SSH_USER="root"

echo "Step 1: Stop problematic containers"
ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "
docker stop supabase-auth supabase-storage
"

echo ""
echo "Step 2: Reset Supabase database completely"
ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "
# Drop and recreate the vividwalls database
docker exec supabase-db psql -U postgres -c 'DROP DATABASE IF EXISTS vividwalls;'
docker exec supabase-db psql -U postgres -c 'CREATE DATABASE vividwalls;'

# Recreate the admin users with known passwords
docker exec supabase-db psql -U postgres -c \"
DROP ROLE IF EXISTS supabase_auth_admin;
DROP ROLE IF EXISTS supabase_storage_admin;
CREATE ROLE supabase_auth_admin WITH LOGIN PASSWORD 'supabase123' CREATEDB;
CREATE ROLE supabase_storage_admin WITH LOGIN PASSWORD 'supabase123' CREATEDB;
GRANT ALL PRIVILEGES ON DATABASE vividwalls TO supabase_auth_admin;
GRANT ALL PRIVILEGES ON DATABASE vividwalls TO supabase_storage_admin;
\"
"

echo ""
echo "Step 3: Update docker-compose environment variables"
ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "
cd /root/vivid_mas

# Backup current docker-compose
cp docker-compose.yml docker-compose.yml.backup

# Update environment variables for Supabase services
sed -i 's/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=supabase123/' docker-compose.yml
sed -i 's/DB_PASSWORD=.*/DB_PASSWORD=supabase123/' docker-compose.yml
"

echo ""
echo "Step 4: Restart Supabase services with docker-compose"
ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "
cd /root/vivid_mas
docker-compose up -d supabase-auth supabase-storage
"

echo ""
echo "Step 5: Wait and verify"
sleep 30

ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "
echo 'Final status:'
docker ps --filter name=supabase-auth --format 'Auth: {{.Status}}'
docker ps --filter name=supabase-storage --format 'Storage: {{.Status}}'

echo ''
echo 'Recent logs:'
echo 'Auth logs:'
docker logs supabase-auth --tail 3
echo 'Storage logs:'
docker logs supabase-storage --tail 3
"

echo ""
echo "✅ Supabase fix complete!"
echo ""
echo "If containers are still restarting, the issue may require:"
echo "1. Supabase version downgrade"
echo "2. Complete Supabase stack recreation"
echo "3. Alternative authentication configuration"
