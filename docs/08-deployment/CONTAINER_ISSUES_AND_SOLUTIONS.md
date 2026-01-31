# Container Issues and Solutions Documentation

## Complete Service Status Summary (as of 2025-07-05)

### Working Services (✓)

- **n8n** (port 5678) - Status: 200
- **Open WebUI** (port 3000) - Status: 200  
- **Flowise** (port 3001) - Status: 200
- **Supabase Kong** (port 8000) - Status: 401 (auth required - working)
- **Twenty CRM** (port 3010) - Status: 200
- **Supabase Studio** (port 8001) - Status: 200
- **Neo4j** (port 7474) - Status: 200
- **WordPress** (port 8080) - Status: 200
- **Crawl4AI** (port 11235) - Status: 307 (redirect - working)
- **SearXNG** (port 8085) - Status: 200
- **Postiz** (port 5000) - Status: 307 (redirect - working)
- **ListMonk** (port 9003) - Status: 400 (bad request but accessible)

### Services Not Running (✗)

- **Ollama** (port 11434) - Status: 502 Bad Gateway - Container not running
- **Langfuse** (port 3002) - Status: 502 Bad Gateway - Container not running

## Issues Encountered and Their Solutions

### 1. Port Conflict: WordPress vs SearXNG (Port 8080)

**Issue:**

- Both `wordpress-multisite` and `searxng` were configured to use port 8080
- After restart, WordPress grabbed the port first, preventing searxng from starting

**Solution:**

- Changed searxng to use port 8085 in docker-compose.yml: `- 8085:8080`
- Updated Caddy to proxy to the container's internal port: `reverse_proxy searxng:8080`

**Prevention:**

- Always check port allocations before adding new services
- Document all port assignments in CLAUDE.md

### 2. Caddy Configuration Syntax Error

**Issue:**

- Caddy was in restart loop due to: `unrecognized directive: header_up`
- The `header_up` directive was placed outside of `reverse_proxy` block at line 130

**Root Cause:**

- Someone added WordPress configuration with improper syntax
- `header_up` directives must be inside `reverse_proxy` blocks

**Solution:**

- Created clean Caddyfile with proper syntax
- All directives properly nested within their blocks

**Prevention:**

- Always validate Caddyfile before restarting: `docker exec caddy caddy validate --config /etc/caddy/Caddyfile`
- Never edit Caddyfile without backing up first

### 3. Caddy Host Network Mode Issue

**Issue:**

- All services returned 502 Bad Gateway
- Caddy couldn't reach containers using container names

**Root Cause:**

- Caddy runs with `network_mode: host`
- In host mode, container names aren't resolvable
- Must use `localhost:port` instead of `container:port`

**Solution:**

- Changed all Caddy reverse_proxy directives from container names to localhost
- Example: `reverse_proxy n8n:5678` → `reverse_proxy localhost:5678`

**Prevention:**

- Remember Caddy's special network mode when adding services
- Always use localhost for Caddy reverse proxy targets

### 4. Missing Caddy Configurations

**Issue:**

- Several running services had no Caddy URL configured
- Missing: Postiz, proper Supabase Kong endpoint, ListMonk port mismatch

**Solution:**

- Added all missing service configurations to Caddyfile
- Fixed ListMonk to use correct port (9003 not 9000)
- Ensured all running containers have corresponding Caddy entries

## Critical Rules to Prevent Breaking Containers

### 1. Network Configuration

- **NEVER** change container networks
- All containers must remain on `vivid_mas` network
- Caddy uses `host` network mode (special case)

### 2. Port Assignments (NEVER CHANGE)

n8n: 5678
open-webui: 3000
flowise: 3001
langfuse: 3002
supabase: 8000
twenty/crm: 3010
listmonk: 9003 (local only)
neo4j: 7474
wordpress: 8080
crawl4ai: 11235
searxng: 8085
postgres: 5433
supabase-pooler: 5432

### 3. Database Connections

- n8n MUST connect to `postgres` container (not `db`)
- n8n uses main PostgreSQL on port 5433
- NEVER change `DB_POSTGRESDB_HOST=postgres`

### 4. Volume Mounts

- Don't remove existing volume mounts
- Preserve volume data when recreating containers
- Use proper ownership for volume directories

### 5. Caddy Configuration

- Always backup before changes
- Validate syntax before restart
- Use container names for internal services
- Use localhost for host-exposed ports

### 6. Container Dependencies

- Respect depends_on relationships
- Don't remove containers that others depend on
- Check for orphan containers regularly

### 7. Caddy-Specific Rules

- **ALWAYS** use `localhost:port` in reverse_proxy (not container names)
- **ALWAYS** backup Caddyfile before any changes
- **ALWAYS** validate syntax before reload
- **NEVER** remove existing service configurations
- **APPEND** new services, don't replace the file

## Prevention Checklist

Before making any container changes:

1. ✓ Check for port conflicts: `docker ps --format 'table {{.Names}}\t{{.Ports}}'`
2. ✓ Backup configurations: `cp Caddyfile Caddyfile.backup.$(date +%Y%m%d_%H%M%S)`
3. ✓ Validate Caddy syntax: `docker exec caddy caddy validate --config /etc/caddy/Caddyfile`
4. ✓ Check container networks: `docker ps --format 'table {{.Names}}\t{{.Networks}}'`
5. ✓ Document all changes in this file