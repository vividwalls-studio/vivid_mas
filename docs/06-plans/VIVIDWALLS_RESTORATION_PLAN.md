# VividWalls MAS: Unified Restoration and Hardening Plan

**Date:** July 10, 2025
**Status:** CRITICAL SYSTEM FAILURE - RECOVERY AND HARDENING INITIATED
**Prepared by:** Gemini

## 1. Executive Summary

---

## Phase 0: Credential Consolidation

**Goal:** To create a single, authoritative `master.env` file on the local machine that contains every secret required for the restoration. This eliminates manual entry and reduces the risk of error.

| Step | Task Description | Assigned Agent | Execution | Detailed Actions & Commands | Success Criteria |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0.1 | **Create Master Credentials File** | `Configurator` | Sequential | 1. Create a local file named `master.env`.<br>2. Populate it with all critical secrets identified in the `VIVIDWALLS_CREDENTIAL_AUDIT_REPORT.md`. | A `master.env` file exists locally with all required key-value pairs. |

---

## 2. Phase 1: Immediate System Restoration

The VividWalls Multi-Agent System (MAS) has experienced a critical failure. The immediate trigger was an accidental deletion of system components, but a thorough analysis, reconciling multiple reports and system documents, reveals that pre-existing architectural flaws were the root cause of the system's fragility.

This document provides a unified, step-by-step plan to both **restore** the system to full functionality and **harden** it against future failures. It synthesizes the tactical needs of immediate recovery with the strategic necessity of fixing the underlying architectural debt.

**Key Issues Addressed:**

1. **Architectural Conflict:** Resolving the conflict between production (`/opt/mcp-servers`) and development (`./services/mcp-servers`) environments.
2. **Configuration Errors:** Correcting the `docker-compose.yml` to grant the `n8n` service access to MCP servers and implementing the correct, modular Caddy reverse proxy architecture.
3. **Configuration Scatter:** Centralizing the scattered MCP server configuration files into a single source of truth.
4. **Credential Integrity:** Ensuring the correct, documented encryption keys and secrets for n8n and Supabase are used.

By following this plan, the VividWalls MAS will be restored to a state that is not only operational but significantly more robust, maintainable, and secure.

---

## 2. Phase 1: Immediate System Restoration

This phase focuses on getting the system back online quickly and safely by restoring from backup and correcting the most critical configuration errors.

### Step 1.1: Restore Project Files from Backup

Restore the entire project directory from the last known good backup.

```bash
# This is an example command. Adjust paths for your environment.
# This assumes the backup is located at /droplet_backup/vivid_mas/
echo "Restoring files from /droplet_backup/vivid_mas/..."
cp -r /droplet_backup/vivid_mas/* /Volumes/SeagatePortableDrive/Projects/vivid_mas/
```

### Step 1.2: Verify and Correct `.env` Secrets

This is the most critical step for data integrity. Open the `.env` file and ensure the following variables are present and match the documented production values.

| Variable Name | Correct Value | Source Document |
| :--- | :--- | :--- |
| `N8N_ENCRYPTION_KEY` | `eyJhbGciOi...soleXcs` | `CLAUDE.md` |
| `JWT_SECRET` | `CMl9X2lC-a...zfBYYcBts` | `SUPABASE_JWT_FIX_GUIDE.md` |
| `DB_POSTGRESDB_HOST` | `postgres` | `CLAUDE.md` |

### Step 1.3: Correct `docker-compose.yml`

Modify the main `docker-compose.yml` to fix the `n8n` service. It must have access to the MCP servers and know where to find the configuration file.

**Locate the `n8n` service definition and ensure it looks exactly like this:**

```yaml
  n8n:
    <<: *service-n8n
    container_name: n8n
    restart: unless-stopped
    ports:
      - 5678:5678
    volumes:
      - n8n_storage:/home/node/.n8n
      # Mount the production MCP servers
      - /opt/mcp-servers:/opt/mcp-servers:ro
      # Mount the centralized production config
      - ./configs/mcp/production:/etc/mcp-config:ro
      - ./n8n/backup:/backup
      - ./shared:/data/shared
    environment:
      # Point n8n to the correct config file
      - MCP_CONFIG_PATH=/etc/mcp-config/n8n-mcp-config.json
    networks:
      - vivid_mas
    depends_on:
      n8n-import:
        condition: service_completed_successfully
```

### Step 1.4: Implement Correct Modular Caddy Configuration

Do not use a monolithic `Caddyfile`. The correct architecture uses modular files.

1. **Ensure the main `Caddyfile` contains only the import statement:**

    ```caddy
    {
        email kingler@vividwalls.co
    }

    # Import all site configurations
    import /etc/caddy/sites-enabled/*.caddy
    ```

2. **Create/verify the individual service files in `caddy/sites-enabled/`.** For example, `caddy/sites-enabled/n8n.caddy` should contain:

    ```caddy
    n8n.vividwalls.blog {
        reverse_proxy localhost:5678
    }
    ```

    *Ensure a separate `.caddy` file exists for every service, pointing to the correct `localhost` port as documented in `CONTAINER_ISSUES_AND_SOLUTIONS.md`.*

### Step 1.5: Start and Verify Services

Bring the system online and perform initial checks.

```bash
# Ensure the external network exists
docker network create vivid_mas

# Start all services
docker-compose up -d

# --- Verification ---

# 1. Check all containers are running
docker ps --format "table {{.Names}}\t{{.Status}}"

# 2. Verify n8n can access MCP servers and the config
docker exec n8n ls -l /opt/mcp-servers/
docker exec n8n ls -l /etc/mcp-config/n8n-mcp-config.json

# 3. Check Caddy logs for errors
docker logs caddy --tail 50

# 4. Test a primary endpoint
curl -I https://n8n.vividwalls.blog
```

---

## 3. Phase 2: System Hardening and Standardization

After immediate restoration, perform these steps to fix the underlying architectural issues and prevent future failures.

### Step 2.1: Centralize MCP Configuration

The "Configuration File Scatter" is a major risk. Consolidate all MCP configurations.

1. Create the directory structure: `mkdir -p configs/mcp/production` and `mkdir -p configs/mcp/development`.
2. Identify the correct production `n8n-mcp-config.json` from the backup (`/droplet_backup/.../n8n-mcp-config.json`).
3. Move it to `configs/mcp/production/n8n-mcp-config.json`.
4. Create a development version in `configs/mcp/development/` that points to local paths (e.g., `/opt/mcp-servers/core/shopify-mcp-server/build/index.js`).

### Step 2.2: Create a Development Environment Override

To resolve the dev/prod conflict, create a `docker-compose.override.yml` file. This file is automatically used by Docker Compose alongside the main file during local development. **Do not commit this file to git if it contains secrets.**

**File: `docker-compose.override.yml`**

```yaml
# This file is for local development ONLY
services:
  n8n:
    volumes:
      # Unmount production volumes
      - /dev/null:/opt/mcp-servers
      - /dev/null:/etc/mcp-config
      # Mount local development volumes
      - ./services/mcp-servers:/opt/mcp-servers:ro
      - ./configs/mcp/development:/etc/mcp-config:ro
```

Now, running `docker-compose up` locally will use the development setup, while the production server (which doesn't have this file) will use the production setup from the main `docker-compose.yml`.

### Step 2.3: Document the Architecture

Create an Architecture Decision Record (ADR) to document these changes and prevent future configuration drift.

**File: `docs/adr/001-standardize-mcp-and-caddy-architecture.md`**

```markdown
# ADR-001: Standardize MCP, Caddy, and Environment Architecture

## Status
Accepted

## Context
The system suffered a critical failure due to architectural inconsistencies, including scattered configurations, conflicting dev/prod setups, and incorrect Docker Compose files.

## Decision
1.  **Caddy:** The system will exclusively use a modular Caddy configuration located in `caddy/sites-enabled/`.
2.  **MCP Servers:** Production deployments will mount `/opt/mcp-servers`. Development will use a `docker-compose.override.yml` to mount the local `./services/mcp-servers` directory.
3.  **MCP Configuration:** Configurations will be centralized in the `configs/mcp/` directory, separated by environment. The `n8n` service will use the `MCP_CONFIG_PATH` environment variable to load the correct file.

## Consequences
- Clear separation between production and development environments.
- A single source of truth for all configurations.
- Reduced risk of deployment errors and configuration drift.
```

---

## 4. Final System Verification

After completing both phases, perform a full system health check.

1. **Verify n8n Workflows:** Log in to the n8n UI. Confirm all 40+ workflows are present and that credentials have been successfully decrypted.
2. **Verify Supabase Data:** Log in to Supabase Studio. Confirm all ~41 tables and their data are present.
3. **End-to-End Test:** Trigger a core agent workflow in n8n and verify that it successfully interacts with other services (like Supabase) via the now-accessible MCP servers.
4. **Check all Caddy Endpoints:** Systematically `curl -I` every URL managed by Caddy to ensure all services are accessible.

This unified plan will restore the VividWalls MAS and leave it in a significantly more resilient and manageable state.
