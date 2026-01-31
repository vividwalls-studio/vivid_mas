# N8N Encryption Key Management Guide

## Critical Discovery (June 30, 2025)

### The Problem
After extensive investigation, we discovered a critical mismatch:
- **File system (.env)**: `N8N_ENCRYPTION_KEY=pAyfxPn9h2yqv32GtzSLA73h2IdZ1n88` (old key)
- **Docker container**: `N8N_ENCRYPTION_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (new key)

This mismatch has caused repeated confusion and webhook failures because:
1. Credentials in the database were encrypted with the old key
2. n8n container is running with the new key from environment
3. Multiple backup .env files exist with different keys

## Sources of Confusion

### 1. Multiple .env Files Found
```
/root/vivid_mas/.env                           # Main file (currently has OLD key)
/root/vivid_mas/.env.backup-20250605-205011    # OLD key
/root/vivid_mas/.env.backup-20250610-211612    # OLD key
/root/vivid_mas/.env.backup.20250616_165948    # OLD key
/root/vivid_mas/.env.backup-keys               # NEW key
/root/vivid_mas/.env.backup-webhook            # NEW key
/root/vivid_mas/.env.backup.new_key            # NEW key
/root/vivid_mas/supabase/docker/.env           # OLD key
```

### 2. Docker Environment Override
The docker-compose.yml uses environment variable substitution:
```yaml
- N8N_ENCRYPTION_KEY
```
This means Docker can use a different key than what's in .env if the environment variable is set.

### 3. Multiple n8n Installations
Found multiple n8n directories in backups:
- `/root/vivid_mas/n8n`
- Multiple in `/root/vivid_mas/droplet_backup/*/n8n`

## The Correct Keys

### Production Key (User's Key from UI - June 20, 2025)
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs
```

### Old Key (Original Installation)
```
pAyfxPn9h2yqv32GtzSLA73h2IdZ1n88
```

## Prevention Rules

### RULE 1: Single Source of Truth
- **ALWAYS** check both .env file AND docker container environment
- The .env file should be the single source of truth
- Never rely on environment variables that might be set elsewhere

### RULE 2: No Key Changes Without Migration
- **NEVER** change the encryption key without migrating credentials
- If key must change, all credentials need to be re-entered in n8n UI
- Document any key changes immediately

### RULE 3: Clean Up Confusion Sources
```bash
# Remove old backup files
rm -f /root/vivid_mas/.env.backup*
# Keep only the current .env file
```

### RULE 4: Verification Commands
Always verify the key in use:
```bash
# Check .env file
grep N8N_ENCRYPTION_KEY /root/vivid_mas/.env

# Check docker container
docker exec n8n printenv | grep N8N_ENCRYPTION_KEY

# They MUST match!
```

## Current Webhook Issue Resolution

The Business Manager workflow (ID: czgQFXq4Bh6Ho3q3) webhook fails because:
1. Telegram credentials were encrypted with old key
2. n8n is running with new key
3. Cannot decrypt credentials = cannot activate webhook

### Solution Options:
1. **Use old key temporarily** (current approach)
2. **Re-enter all credentials** in n8n UI with new key
3. **Export/Import workflows** after fixing encryption key

## Database Information
- **Type**: PostgreSQL (not SQLite!)
- **Host**: postgres (container name)
- **Database**: postgres
- **Tables**: workflow_entity (75 workflows), credentials_entity
- **Password**: myqP9lSMLobnuIfkUpXQzZg07

## Critical Files to Monitor
1. `/root/vivid_mas/.env` - Main configuration
2. `/root/vivid_mas/docker-compose.yml` - Service definitions
3. PostgreSQL credentials_entity table - Encrypted credentials

## Lessons Learned
1. Environment variable precedence can override .env files
2. Docker containers can maintain different environments than host
3. Multiple backup files create confusion about which key is correct
4. Changing encryption keys breaks all stored credentials
5. Always verify actual runtime environment, not just files