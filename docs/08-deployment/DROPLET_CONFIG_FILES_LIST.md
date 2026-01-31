# VividWalls MAS - Droplet Configuration Files List

## Docker Compose Files

### Primary Project Files - `/root/vivid_mas/`

- `/root/vivid_mas/docker-compose.yml` - Main VividWalls MAS compose file
- `/root/vivid_mas/docker-compose.medusa.yml` - Medusa e-commerce service
- `/root/vivid_mas/docker-compose.minimal.yml` - Minimal configuration

### Service-Specific Compose Files - `/root/vivid_mas/services/`

- `/root/vivid_mas/services/caddy/docker/docker-compose.yml` - Caddy service
- `/root/vivid_mas/services/langfuse/docker/docker-compose.yml` - Langfuse service
- `/root/vivid_mas/services/listmonk/docker/docker-compose.yml` - Listmonk email service
- `/root/vivid_mas/services/medusa/docker/docker-compose.yml` - Medusa service
- `/root/vivid_mas/services/medusa/docker/docker-compose.standalone.yml` - Standalone Medusa
- `/root/vivid_mas/services/n8n/docker/docker-compose.yml` - N8N automation service
- `/root/vivid_mas/services/ollama/docker/docker-compose.yml` - Ollama AI service
- `/root/vivid_mas/services/twenty/docker/docker-compose.yml` - Twenty CRM service
- `/root/vivid_mas/services/wordpress/docker/docker-compose.yml` - WordPress service

### Supabase Stack - `/root/vivid_mas/supabase/`

- `/root/vivid_mas/supabase/docker/docker-compose.yml` - Main Supabase stack
- `/root/vivid_mas/supabase/docker/docker-compose.s3.yml` - S3 storage configuration
- `/root/vivid_mas/supabase/docker/dev/docker-compose.dev.yml` - Development configuration

### Legacy/Backup Project Files - `/home/vivid/`

- `/home/vivid/vivid_mas/docker-compose.yml` - Legacy main compose
- `/home/vivid/vivid_mas/supabase/docker/docker-compose.yml` - Legacy Supabase stack
- `/home/vivid/vivid_mas/supabase/docker/docker-compose.s3.yml` - Legacy S3 config
- `/home/vivid/vivid_mas/supabase/docker/dev/docker-compose.dev.yml` - Legacy dev config

### Production Releases - `/home/vivid/production/releases/`

- `/home/vivid/production/releases/20250531_081720/docker-compose.yml` - Release 1
- `/home/vivid/production/releases/20250531_081720/archive/backups/docker-compose.optimized.yml` - Backup
- `/home/vivid/production/releases/20250531_121332/docker-compose.yml` - Release 2
- `/home/vivid/production/releases/20250531_121332/supabase/docker/docker-compose.yml` - Release 2 Supabase
- `/home/vivid/production/releases/20250531_121332/supabase/docker/docker-compose.s3.yml` - Release 2 S3
- `/home/vivid/production/releases/20250531_121332/supabase/docker/dev/docker-compose.dev.yml` - Release 2 dev

### MCP Servers - `/opt/mcp-servers/`

- `/opt/mcp-servers/listmonk-email-marketing/docker-compose.listmonk.yml` - Listmonk MCP
- `/opt/mcp-servers/listmonk-email-marketing/docker-compose.listmonk.fixed.yml` - Fixed version
- `/opt/mcp-servers/neo4j-mcp-server/docker-compose.yml` - Neo4j MCP server

### Standalone Services - `/opt/`

- `/opt/medusa-api-prod/docker-compose.yml` - Production Medusa API
- `/opt/postiz/docker-compose.yml` - Postiz social media service
- `/opt/postiz/docker-compose.dev.yaml` - Postiz development
- `/opt/twenty/packages/twenty-docker/docker-compose.yml` - Twenty CRM
- `/opt/twenty/packages/twenty-docker/docker-compose.override.yml` - Twenty overrides

### Other Locations

- `/root/twenty-crm/docker-compose.yml` - Standalone Twenty CRM

## Caddy Configuration Files

### Primary Caddy Files - `/root/vivid_mas/`

- `/root/vivid_mas/Caddyfile` - Main Caddyfile (current active)
- `/root/vivid_mas/Caddyfile.backup` - Primary backup
- `/root/vivid_mas/Caddyfile.backup.20250708_170256` - Timestamped backup 1
- `/root/vivid_mas/Caddyfile.backup.20250710_034828` - Timestamped backup 2
- `/root/vivid_mas/Caddyfile.before_modular_20250705_214154` - Before modular config
- `/root/vivid_mas/Caddyfile.complete` - Complete configuration
- `/root/vivid_mas/Caddyfile.fixed` - Fixed version
- `/root/vivid_mas/Caddyfile.from_container` - From container export
- `/root/vivid_mas/Caddyfile.main` - Main configuration version
- `/root/vivid_mas/Caddyfile.mixed_config.20250705_200204` - Mixed configuration

### Modular Caddy Site Configurations - `/root/vivid_mas/caddy/sites-enabled/`

- `/root/vivid_mas/caddy/sites-enabled/crawl4ai.caddy` - Crawl4AI service
- `/root/vivid_mas/caddy/sites-enabled/flowise.caddy` - Flowise AI service
- `/root/vivid_mas/caddy/sites-enabled/langfuse.caddy` - Langfuse service
- `/root/vivid_mas/caddy/sites-enabled/listmonk.caddy` - Listmonk email
- `/root/vivid_mas/caddy/sites-enabled/medusa.caddy` - Medusa e-commerce
- `/root/vivid_mas/caddy/sites-enabled/n8n.caddy` - N8N automation
- `/root/vivid_mas/caddy/sites-enabled/neo4j.caddy` - Neo4j database
- `/root/vivid_mas/caddy/sites-enabled/ollama.caddy` - Ollama AI
- `/root/vivid_mas/caddy/sites-enabled/openwebui.caddy` - Open WebUI
- `/root/vivid_mas/caddy/sites-enabled/postiz.caddy` - Postiz social media
- `/root/vivid_mas/caddy/sites-enabled/searxng.caddy` - SearXNG search
- `/root/vivid_mas/caddy/sites-enabled/store.caddy` - Store configuration
- `/root/vivid_mas/caddy/sites-enabled/supabase.caddy` - Supabase stack
- `/root/vivid_mas/caddy/sites-enabled/twenty.caddy` - Twenty CRM
- `/root/vivid_mas/caddy/sites-enabled/wordpress.caddy` - WordPress

### Legacy/Backup Caddy Files - `/home/vivid/`

- `/home/vivid/vivid_mas/Caddyfile` - Legacy main Caddyfile
- `/home/vivid/vivid_mas/Caddyfile.backup` - Legacy backup
- `/home/vivid/vivid_mas/Caddyfile.backup-mcp` - MCP configuration backup
- `/home/vivid/vivid_mas/Caddyfile.backup-twenty` - Twenty service backup

### Production Release Caddy Files - `/home/vivid/production/releases/`

- `/home/vivid/production/releases/20250531_081720/Caddyfile` - Release 1
- `/home/vivid/production/releases/20250531_081720/archive/backups/Caddyfile.complete` - Complete backup
- `/home/vivid/production/releases/20250531_081720/archive/backups/Caddyfile.optimized` - Optimized backup
- `/home/vivid/production/releases/20250531_081720/archive/backups/Caddyfile.working` - Working backup
- `/home/vivid/production/releases/20250531_121332/Caddyfile` - Release 2

### Historical Backups - `/root/backup_20250705_212316/`

- `/root/backup_20250705_212316/Caddyfile.20250704_083654.backup` - Historical backup 1
- `/root/backup_20250705_212316/Caddyfile.20250704_085409.backup` - Historical backup 2
- `/root/backup_20250705_212316/Caddyfile.backup` - General backup
- `/root/backup_20250705_212316/Caddyfile.backup.20250705_201511` - Timestamped backup
- `/root/backup_20250705_212316/Caddyfile.broken` - Broken configuration
- `/root/backup_20250705_212316/Caddyfile.broken.20250705_194017` - Broken timestamped
- `/root/backup_20250705_212316/Caddyfile.complete` - Complete configuration
- `/root/vivid_mas/Caddyfile.fixed` - Fixed configuration
- `/root/backup_20250705_212316/Caddyfile.mixed_config.20250705_200204` - Mixed config

### Service-Specific Caddy Files - `/opt/`

- `/opt/postiz/var/docker/Caddyfile` - Postiz internal Caddyfile
- `/opt/vividwalls/configs/caddy/Caddyfile` - VividWalls configuration

### VividWalls Data Backups

- `/opt/vividwalls/data/backups/20250708_030001/configs/caddy/Caddyfile` - Backup 1
- `/opt/vividwalls/data/backups/20250709_030001/configs/caddy/Caddyfile` - Backup 2

## 🚨 UNNECESSARY DUPLICATIONS & CLEANUP RECOMMENDATIONS

### Critical Duplications - Docker Compose Files

#### **Supabase Stack Duplications** ⚠️
**PROBLEM:** Same Supabase configuration exists in 4 locations
- `/root/vivid_mas/supabase/docker/docker-compose.yml` ← **KEEP (Active)**
- `/home/vivid/vivid_mas/supabase/docker/docker-compose.yml` ← **DELETE (Legacy)**
- `/home/vivid/production/releases/20250531_081720/supabase/docker/docker-compose.yml` ← **ARCHIVE**
- `/home/vivid/production/releases/20250531_121332/supabase/docker/docker-compose.yml` ← **ARCHIVE**

**ACTION:** Delete legacy `/home/vivid/vivid_mas/supabase/` directory entirely

#### **Main Project Duplications** ⚠️
**PROBLEM:** Multiple main docker-compose.yml files
- `/root/vivid_mas/docker-compose.yml` ← **KEEP (Active)**
- `/home/vivid/vivid_mas/docker-compose.yml` ← **DELETE (Legacy)**
- `/home/vivid/production/releases/*/docker-compose.yml` ← **ARCHIVE (Keep for rollback)**

**ACTION:** Delete `/home/vivid/vivid_mas/docker-compose.yml`

#### **Service Conflicts** ⚠️
**PROBLEM:** Same services in multiple locations
- **Twenty CRM:** 3 locations
  - `/root/vivid_mas/services/twenty/docker/docker-compose.yml` ← **KEEP**
  - `/opt/twenty/packages/twenty-docker/docker-compose.yml` ← **EVALUATE**
  - `/root/twenty-crm/docker-compose.yml` ← **DELETE (Orphaned)**

- **Medusa E-commerce:** 4 locations
  - `/root/vivid_mas/services/medusa/docker/docker-compose.yml` ← **KEEP**
  - `/root/vivid_mas/docker-compose.medusa.yml` ← **CONSOLIDATE**
  - `/opt/medusa-api-prod/docker-compose.yml` ← **EVALUATE**
  - `/opt/vividwalls-medusa/` ← **EVALUATE**

- **Listmonk Email:** 3 locations
  - `/root/vivid_mas/services/listmonk/docker/docker-compose.yml` ← **KEEP**
  - `/opt/mcp-servers/listmonk-email-marketing/docker-compose.listmonk.yml` ← **EVALUATE**
  - `/opt/mcp-servers/listmonk-email-marketing/docker-compose.listmonk.fixed.yml` ← **DELETE**

#### **Postiz Social Media** ⚠️
**PROBLEM:** Development and production confusion
- `/opt/postiz/docker-compose.yml` ← **PRODUCTION**
- `/opt/postiz/docker-compose.dev.yaml` ← **DEVELOPMENT**
- Missing service-specific file in `/root/vivid_mas/services/postiz/`

### Critical Duplications - Caddy Files

#### **Excessive Backup Files** ⚠️
**PROBLEM:** 10+ backup Caddyfiles in `/root/vivid_mas/`
- Keep: `Caddyfile` (active), `Caddyfile.backup` (latest backup)
- Archive: All timestamped backups older than 7 days
- Delete: `.broken`, `.mixed_config`, `.from_container` versions

#### **Legacy Directory Duplications** ⚠️
**PROBLEM:** Complete duplication in `/home/vivid/vivid_mas/`
- **DELETE ENTIRE:** `/home/vivid/vivid_mas/` directory (superseded by `/root/vivid_mas/`)

#### **Historical Backup Chaos** ⚠️
**PROBLEM:** 9 backup files in `/root/backup_20250705_212316/`
- **ACTION:** Archive entire directory to compressed backup and remove from active filesystem

### Recommended Cleanup Actions

#### **IMMEDIATE (High Priority)**
1. **Delete Legacy Directory:** `rm -rf /home/vivid/vivid_mas/` (entire legacy structure)
2. **Delete Orphaned Services:** 
   - `rm -rf /root/twenty-crm/`
   - Evaluate and possibly remove duplicate `/opt/` services
3. **Consolidate Caddy Backups:** Keep only `Caddyfile.backup` and active `Caddyfile`

#### **MEDIUM PRIORITY**
1. **Archive Historical Backups:** Compress and move `/root/backup_20250705_212316/` to cold storage
2. **Consolidate Service Configs:** Merge duplicate service configurations
3. **Standardize MCP Locations:** Decide on `/opt/mcp-servers/` vs `/root/vivid_mas/services/` strategy

#### **LOW PRIORITY (Future Maintenance)**
1. **Automated Backup Rotation:** Implement 7-day rotation for Caddyfile backups
2. **Service Discovery:** Create single source of truth for all service configurations
3. **Documentation:** Update all references to point to canonical locations

### Disk Space Recovery Estimate
- **Legacy `/home/vivid/vivid_mas/`:** ~2-5 GB
- **Historical backups:** ~500 MB - 1 GB  
- **Duplicate Caddyfiles:** ~50-100 MB
- **Orphaned services:** ~1-3 GB
- **Total Recovery:** ~4-9 GB of the 128 GB used space

## Summary

**Total Files Found:**

- **Docker Compose Files:** 28 active/production files (excluding node_modules and overlay files)
- **Caddy Configuration Files:** 35 files (including backups and modular configurations)

**Key Active Configurations:**

- Main Project: `/root/vivid_mas/docker-compose.yml` + `/root/vivid_mas/Caddyfile`
- Modular Caddy: 17 service-specific `.caddy` files in `/root/vivid_mas/caddy/sites-enabled/`
- Service Compose: 9 individual service docker-compose files in `/root/vivid_mas/services/`

**Note:** This list excludes Docker overlay files (`/var/lib/docker/overlay2/`) and node_modules files which are internal Docker and dependency files not directly managed as part of the VividWalls MAS configuration.
