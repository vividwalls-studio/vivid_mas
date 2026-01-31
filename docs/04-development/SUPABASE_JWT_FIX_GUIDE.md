# Supabase Studio API Error Fix Guide

## Problem
Supabase Studio is showing API errors when trying to retrieve database tables. This is caused by a mismatch between the JWT_SECRET in the .env file and the JWT tokens (ANON_KEY and SERVICE_ROLE_KEY).

## Root Cause
- The JWT_SECRET in .env was set to a placeholder value: `your-super-secret-jwt-token-with-at-least-32-characters-long`
- The ANON_KEY and SERVICE_ROLE_KEY were generated with a different secret: `CMl9X2lC-ane2RR4xDtqPkDAkfQNooTOmMzfBYYcBts`
- This mismatch causes Kong (API gateway) to reject requests with "Invalid JWT" errors

## Solution

### 1. Update .env File
The JWT_SECRET has already been updated to the correct value:
```bash
JWT_SECRET=CMl9X2lC-ane2RR4xDtqPkDAkfQNooTOmMzfBYYcBts
```

### 2. Deploy to Remote Server
Copy the updated .env file to the remote server:
```bash
# SSH into the server
ssh -i ~/.ssh/digitalocean root@157.230.13.13
# Passphrase: freedom

# Backup current .env
cp /root/vivid_mas/.env /root/vivid_mas/.env.backup.$(date +%Y%m%d_%H%M%S)

# Update JWT_SECRET
sed -i 's/JWT_SECRET=.*/JWT_SECRET=CMl9X2lC-ane2RR4xDtqPkDAkfQNooTOmMzfBYYcBts/' /root/vivid_mas/.env
```

### 3. Restart Supabase Services
The Supabase services need to be restarted to pick up the new JWT_SECRET:

```bash
# Navigate to the Supabase directory
cd /home/vivid/vivid_mas/supabase/docker

# Stop Supabase services
docker-compose down

# Start Supabase services with updated configuration
docker-compose up -d

# Verify services are running
docker-compose ps
```

### 4. Verify the Fix
Test that the API is working correctly:

```bash
# Test REST API endpoint
SERVICE_ROLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"

curl -X GET \
  "http://localhost:8000/rest/v1/" \
  -H "apikey: ${SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_ROLE_KEY}"
```

### 5. Access Supabase Studio
Once the services are restarted with the correct JWT_SECRET:
1. Navigate to https://studio.vividwalls.blog
2. Login with credentials from .env:
   - Username: supabase
   - Password: this_password_is_insecure_and_should_be_updated
3. The Studio should now be able to access the database without API errors

## Important JWT Details

### Current Valid Tokens
- **ANON_KEY**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI`
- **SERVICE_ROLE_KEY**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw`
- **JWT_SECRET**: `CMl9X2lC-ane2RR4xDtqPkDAkfQNooTOmMzfBYYcBts`

### Token Expiration
The tokens expire in 2065 (exp: 2064964091), so they don't need to be regenerated.

## Prevention
1. Always ensure JWT_SECRET matches the secret used to generate ANON_KEY and SERVICE_ROLE_KEY
2. When setting up Supabase, generate all three values together using the Supabase CLI or online tool
3. Never use placeholder values in production
4. Document the JWT_SECRET in a secure location as it cannot be recovered from the tokens

## Troubleshooting
If issues persist after following these steps:

1. Check Kong logs:
   ```bash
   docker logs supabase-kong --tail 50
   ```

2. Check PostgREST logs:
   ```bash
   docker logs supabase-rest --tail 50
   ```

3. Verify environment variables are loaded:
   ```bash
   docker exec supabase-kong printenv | grep -E "ANON_KEY|SERVICE_KEY"
   docker exec supabase-rest printenv | grep JWT_SECRET
   ```

4. Test database connectivity directly:
   ```bash
   docker exec supabase-db psql -U postgres -d postgres -c "SELECT current_database();"
   ```