# N8N Encryption Key Auto-Generation Prevention Guide

## The Problem

n8n automatically generates a new encryption key when:
1. The `N8N_ENCRYPTION_KEY` environment variable is empty or not set
2. No config file exists at `/home/node/.n8n/config`

This auto-generation is **built into n8n** and **cannot be disabled**. There is no flag or setting to turn it off.

## Why This Happens

When docker-compose uses the syntax:
```yaml
environment:
  - N8N_ENCRYPTION_KEY
```

It means "pass the value of N8N_ENCRYPTION_KEY from the host environment". If the variable isn't set in the shell, Docker passes an empty string, triggering n8n's auto-generation.

## Prevention Strategy

### 1. Always Use docker-compose with .env File

Docker Compose automatically loads `.env` file in the same directory. The current setup IS working correctly:
- `.env` contains: `N8N_ENCRYPTION_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- `docker compose config` shows the key is being passed correctly

### 2. Never Run Docker Commands Directly

**WRONG:**
```bash
docker run n8nio/n8n:latest
docker start n8n
```

**CORRECT:**
```bash
docker compose up -d n8n
docker compose restart n8n
```

### 3. Clean Up Auto-Generated Configs

If n8n auto-generates a key, remove it immediately:
```bash
docker run --rm -v vivid_mas_n8n_storage:/data alpine rm -rf /data/.n8n/config
```

### 4. Verification Before Starting

Always verify the key is set:
```bash
cd /root/vivid_mas
docker compose config | grep N8N_ENCRYPTION_KEY
```

## Root Cause Summary

1. **n8n's design philosophy** prioritizes "ease of use" over security/stability
2. **No option exists** to disable auto-generation
3. **The only prevention** is ensuring the environment variable is always set

## Recommended Workflow

1. **Always work from `/root/vivid_mas` directory**
2. **Always use `docker compose` commands**
3. **Never use standalone `docker` commands for n8n**
4. **Verify .env has the correct key before any operations**

## Feature Request

Consider submitting a feature request to n8n for:
- `N8N_ENCRYPTION_KEY_REQUIRED=true` flag
- Fail to start if no key provided instead of auto-generating

This would prevent accidental key mismatches.