# Environment Credential Comparison Report

**Date**: 2025-01-14  
**Purpose**: Compare service-specific .env files with master .env.droplet credentials

## Executive Summary

Multiple critical mismatches and outdated credentials found across service-specific .env files compared to the main .env.droplet configuration. These discrepancies could cause authentication failures and service connectivity issues.

## Critical Findings

### 1. Supabase MCP Server ❌ CRITICAL MISMATCH
- **ANON_KEY**: Using demo/placeholder key instead of production key
  - Current: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...ic3MiOiAic3VwYWJhc2UtZGVtbyI...` (demo key)
  - Should be: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...ic3MiOiAic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0...`
- **SERVICE_ROLE_KEY**: Using demo/placeholder key
  - Current: Demo key with "supabase-demo" issuer
  - Should be: Production key from .env.droplet
- **Missing**: JWT_SECRET, database credentials

### 2. N8N MCP Server ⚠️ INCONSISTENT
- **N8N_API_KEY**: Using old encryption key format
  - Current: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...aWF0IjoxNzUwNDQ5MzEzfQ...`
  - Main .env has different N8N_ENCRYPTION_KEY
- **N8N_API_URL**: Using direct IP instead of domain
  - Current: `http://157.230.13.13:5678/api/v1`
  - Should use: `https://n8n.vividwalls.blog/api/v1`
- **Missing**: Database connection details, proper encryption key

### 3. Neo4j MCP Server ❌ WRONG PASSWORD
- **NEO4J_PASSWORD**: 
  - Current: `vividwalls2024`
  - Should be: `vivid_mas_neo4j_2024_password` (from NEO4J_AUTH in .env.droplet)
- **NEO4J_URI**: Using container name instead of public URL
  - Current: `bolt://vividwalls-neo4j:7687`
  - Better: Use neo4j.vividwalls.blog endpoint

### 4. Shopify MCP Server ✅ OK
- Has unique Shopify-specific credentials (ACCESS_TOKEN, DOMAIN)
- These are service-specific and not in main .env.droplet
- No issues found

### 5. SendGrid MCP Server ✅ OK
- Has SendGrid API key and Twilio credentials
- These are service-specific API keys not in main .env.droplet
- No issues found

### 6. Stripe MCP Server ✅ OK
- Has Stripe-specific API keys (test and live)
- These are service-specific and not in main .env.droplet
- No issues found

### 7. Listmonk MCP Server ❌ WRONG CREDENTIALS
- **Username**: 
  - Current: `vidid_mas` (typo)
  - Should be: `admin_kb` (from .env.droplet)
- **Password**:
  - Current: `vivid-connect`
  - Should be: `#Freedom2025#` (from .env.droplet)

### 8. Twenty MCP Server ✅ OK
- Has Twenty-specific API key
- URL correctly uses domain: `https://crm.vividwalls.blog`
- No issues found

### 9. WordPress MCP Server ❌ WRONG PASSWORD
- **Password**:
  - Current: `TempPass123!`
  - Should be: `17oHjUWbOs5k!A9J1u` (from .env.droplet)
- **Username**: Matches correctly (`kingler-admin`)

## Missing Service Configurations

The following services mentioned in .env.droplet have no corresponding MCP server .env files checked:
- Flowise
- Crawl4AI
- ClickHouse
- MinIO
- Postiz

## Recommendations

### Immediate Actions Required

1. **Update Supabase MCP Server .env**:
   ```env
   SUPABASE_URL=https://supabase.vividwalls.blog
   SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw
   ```

2. **Update N8N MCP Server .env**:
   ```env
   N8N_API_URL=https://n8n.vividwalls.blog/api/v1
   N8N_ENCRYPTION_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3MjgwMTc0NC1mZDc0LTRkYzMtYWZkNy1hZjZjOGQyMTY4M2QiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUyMjYwMjg4fQ.QG1AO6aPdy09vyLtVExpnDQLX3aZHCtEfP-RZG97cH8
   ```

3. **Update Neo4j MCP Server .env**:
   ```env
   NEO4J_URI=bolt://neo4j.vividwalls.blog:7687
   NEO4J_USERNAME=neo4j
   NEO4J_PASSWORD=vivid_mas_neo4j_2024_password
   ```

4. **Update Listmonk MCP Server .env**:
   ```env
   LISTMONK_URL=https://listmonk.vividwalls.blog
   LISTMONK_USERNAME=admin_kb
   LISTMONK_PASSWORD=#Freedom2025#
   ```

5. **Update WordPress MCP Server .env**:
   ```env
   WORDPRESS_PASSWORD=17oHjUWbOs5k!A9J1u
   ```

### Best Practices

1. **Create a sync script** to automatically update service .env files from master .env.droplet
2. **Use environment variable substitution** where possible instead of hardcoding
3. **Implement validation checks** before deploying to ensure credentials match
4. **Store sensitive credentials in a secure vault** and reference them programmatically

## Security Notes

- Several API keys and passwords are exposed in plain text .env files
- Consider using Docker secrets or environment variable injection at runtime
- Rotate any credentials that may have been compromised
- The master .env.droplet should be deleted after successful restoration as noted

## Conclusion

Critical credential mismatches exist in Supabase, N8N, Neo4j, Listmonk, and WordPress MCP servers that must be resolved before deployment. These mismatches would prevent proper authentication and service connectivity.