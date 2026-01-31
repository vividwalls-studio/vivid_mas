#!/bin/bash

# Fix Supabase JWT configuration mismatch
# This script updates the JWT_SECRET to match the existing ANON_KEY and SERVICE_ROLE_KEY

set -e

echo "=== Supabase JWT Fix Script ==="
echo "This script will fix the JWT_SECRET mismatch issue"
echo ""

# The correct JWT_SECRET that matches the existing tokens
CORRECT_JWT_SECRET="CMl9X2lC-ane2RR4xDtqPkDAkfQNooTOmMzfBYYcBts"

# Check if we're on the remote server
if [ -d "/root/vivid_mas" ]; then
    ENV_PATH="/root/vivid_mas/.env"
    SUPABASE_PATH="/home/vivid/vivid_mas/supabase/docker"
else
    echo "Error: This script should be run on the remote server"
    echo "Please SSH into the server first:"
    echo "ssh -i ~/.ssh/digitalocean root@157.230.13.13"
    exit 1
fi

# Backup current .env
echo "1. Backing up current .env file..."
cp $ENV_PATH ${ENV_PATH}.backup.$(date +%Y%m%d_%H%M%S)
echo "   Backup created"

# Check current JWT_SECRET
echo ""
echo "2. Checking current JWT_SECRET..."
CURRENT_SECRET=$(grep "^JWT_SECRET=" $ENV_PATH | cut -d'=' -f2)
echo "   Current: $CURRENT_SECRET"

if [ "$CURRENT_SECRET" == "$CORRECT_JWT_SECRET" ]; then
    echo "   JWT_SECRET is already correct!"
else
    echo "   Updating to correct JWT_SECRET..."
    sed -i "s/^JWT_SECRET=.*/JWT_SECRET=$CORRECT_JWT_SECRET/" $ENV_PATH
    echo "   Updated successfully"
fi

# Restart Supabase services
echo ""
echo "3. Restarting Supabase services..."
cd $SUPABASE_PATH

echo "   Stopping services..."
docker-compose down

echo "   Starting services..."
docker-compose up -d

echo "   Waiting for services to be ready..."
sleep 10

# Verify services are running
echo ""
echo "4. Verifying services..."
docker-compose ps

# Test the API
echo ""
echo "5. Testing Supabase REST API..."
SERVICE_ROLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X GET \
  "http://localhost:8000/rest/v1/" \
  -H "apikey: ${SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_ROLE_KEY}")

if [ "$RESPONSE" == "200" ]; then
    echo "   ✓ API is working correctly (HTTP $RESPONSE)"
    echo ""
    echo "=== Fix completed successfully! ==="
    echo "Supabase Studio should now work without API errors"
    echo "Access it at: https://studio.vividwalls.blog"
else
    echo "   ✗ API returned HTTP $RESPONSE"
    echo "   Please check the logs:"
    echo "   docker logs supabase-kong --tail 20"
    echo "   docker logs supabase-rest --tail 20"
fi