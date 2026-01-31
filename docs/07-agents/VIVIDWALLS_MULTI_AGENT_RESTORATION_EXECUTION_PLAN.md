# VividWalls MAS: Future-State Build and Restoration Plan

**Objective:** To construct the official "Future State" architecture for the VividWalls MAS on the production droplet, as defined in `VIVIDWALLS_ECOSYSTEM_FUTURE_STATE.md`. This plan uses a clean build process, populating the ideal structure with essential data recovered from the droplet backup.

**Core Reference Documents:**
*   **Master Plan:** `/Volumes/SeagatePortableDrive/Projects/vivid_mas/VIVIDWALLS_RESTORATION_PLAN.md`
*   **Blueprint:** `/Volumes/SeagatePortableDrive/Projects/vivid_mas/VIVIDWALLS_ECOSYSTEM_FUTURE_STATE.md`
*   **Credentials:** `/Volumes/SeagatePortableDrive/Projects/vivid_mas/VIVIDWALLS_CREDENTIAL_AUDIT_REPORT.md`
*   **Investigation:** `/Volumes/SeagatePortableDrive/Projects/vivid_mas/VIVIDMAS_DOCKER_MCP_ARCHITECTURE_INVESTIGATION_REPORT.md`
*   **File Manifest:** `/Volumes/SeagatePortableDrive/Projects/vivid_mas/DROPLET_CONFIG_FILES_LIST.md`

**Execution Context:** All commands are to be executed remotely on the droplet via SSH.

**Staging Directory:** A new, clean directory, `/root/vivid_mas_build`, will be used for construction.

---

## Agent Roster and Specializations

*The agent roles are the same, but their actions are now guided by the definitive future-state blueprint and the cleanup manifest.*

---

## Phase 0: Credential Consolidation

*   **Goal:** To create a single, authoritative `master.env` file on the local machine that contains every secret required for the restoration. This eliminates manual entry and reduces the risk of error.

| Step | Task Description | Assigned Agent | Execution | Detailed Actions & Commands | Success Criteria |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 0.1 | **Create Master Credentials File** | `Configurator` | Sequential | 1. Create a local file named `master.env`.<br>2. Populate it with all critical secrets identified in the `VIVIDWALLS_CREDENTIAL_AUDIT_REPORT.md`. | A `master.env` file exists locally with all required key-value pairs. |

---

## Phase 1: Constructing the Future-State Scaffold

*   **Goal:** To create the exact directory structure and configuration files specified in the `VIVIDWALLS_ECOSYSTEM_FUTURE_STATE.md` document.
*   **Strategy:** `Architect` will create the complete directory tree. `Configurator` and `ProxyNet` will then populate it with the correct, final versions of the configuration files.

| Step | Task Description | Assigned Agent | Execution | Detailed Actions & Commands (via SSH) | Success Criteria |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1.1 | **Create Future-State Directory Structure** | `Architect` | Sequential | `ssh ... "mkdir -p /root/vivid_mas_build/{services/{supabase,n8n,caddy,...},caddy/sites-enabled,data,n8n/backup,scripts,sql_chunks,shared}` | The remote directory structure in `/root/vivid_mas_build` perfectly matches the blueprint. |
| 1.2 | **Create Final `docker-compose.yml`** | `Configurator` | Concurrent | `ssh ... "cat > /root/vivid_mas_build/docker-compose.yml <<'EOF'\n[Contents of the final docker-compose.yml]...\nEOF"` | The main orchestration `docker-compose.yml` is created in the build directory. |
| 1.3 | **Create Final Caddy Configuration** | `ProxyNet` | Concurrent | 1. `ssh ... "cat > /root/vivid_mas_build/Caddyfile ..."`<br>2. For each service: `ssh ... "cat > /root/vivid_mas_build/caddy/sites-enabled/service.caddy ..."` | The final, modular Caddy configuration is created in the build directory. |
| 1.4 | **Populate Service-Specific Configs** | `Configurator` | Concurrent | For each service (n8n, supabase, etc.):<br>`ssh ... "cat > /root/vivid_mas_build/services/service/docker-compose.yml ..."` | All service-specific `docker-compose.yml` files are created in their correct locations within the build directory. |

---

## Phase 2: Selective Data Migration

*   **Goal:** To migrate essential data from the old backup into the new, correctly structured volumes and directories.
*   **Strategy:** `Orchestrator` will precisely copy only the necessary data, avoiding any old configuration files.

| Step | Task Description | Assigned Agent | Execution | Detailed Actions & Commands (via SSH) | Success Criteria |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 2.1 | **Migrate Secrets and n8n Data** | `Orchestrator` | Sequential | 1. `scp ./master.env root@157.230.13.13:/root/vivid_mas_build/.env`<br>2. `ssh ... "cp -r /root/vivid_mas_backup/n8n/backup/* /root/vivid_mas_build/n8n/backup/"` | The `master.env` is securely copied as the remote `.env`, and n8n data is migrated. |
| 2.2 | **Migrate Database Volume Data** | `Orchestrator` | Sequential | 1. `ssh ... "cd /root/vivid_mas_build && docker-compose up -d postgres supabase-db"` (Start DBs to create volumes)<br>2. `ssh ... "N8N_VOL=\\$(< /dev/null); rsync -a /backup/n8n_vol/ \\$N8N_VOL/"`<br>3. `ssh ... "SUPA_VOL=\\$(< /dev/null); rsync -a /backup/supa_vol/ \\$SUPA_VOL/"`<br>4. `ssh ... "cd /root/vivid_mas_build && docker-compose down"` | The n8n and Supabase database files are copied from the backup into the newly created Docker volumes. |
| 2.3 | **Start All Services from Build Directory** | `Orchestrator` | Sequential | `ssh ... "cd /root/vivid_mas_build && docker-compose up -d"` | All services start successfully from the build directory, using the final architecture and migrated data. | 

---

## Phase 3: System Validation

*   **Goal:** To perform a full end-to-end system check to ensure the newly constructed "Future State" is fully operational.
*   **Strategy:** `Auditor` and `ProxyNet` validate the system against the blueprint's specifications.

| Step | Task Description | Assigned Agent | Execution | Detailed Actions & Commands (via SSH) | Success Criteria |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 3.1 | **Verify Container Health** | `Orchestrator` | Sequential | `ssh ... "cd /root/vivid_mas_build && docker-compose ps"` | All containers listed in the blueprint are `running` or `Up`. |
| 3.2 | **Verify Caddy Endpoints** | `ProxyNet` | Sequential | For each service in the blueprint: `ssh ... "curl -I https://<service>.vividwalls.blog"` | All public URLs from the blueprint are live and return a valid HTTP status. |
| 3.3 | **Audit Data Integrity** | `Auditor` | Sequential | Access Supabase Studio and n8n UIs. Verify that all data (tables, records, workflows, credentials) has been successfully migrated. | The application state matches the state from the backup. |

---

## Phase 4: Production Cutover and Guided Cleanup

*   **Goal:** To make the new instance the live production system and decommission the old, broken instance using the file manifest as a guide.
*   **Strategy:** A swift and careful cutover performed by the `Orchestrator`, with cleanup actions informed by the `DROPLET_CONFIG_FILES_LIST.md`.

| Step | Task Description | Assigned Agent | Execution | Detailed Actions & Commands (via SSH) | Success Criteria |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 4.1 | **Stop All Services (Old and New)** | `Orchestrator` | Sequential | `ssh ... "cd /root/vivid_mas_build && docker-compose down"`<br>`ssh ... "docker stop \$(docker ps -aq)"` | All Docker containers on the droplet are stopped. |
| 4.2 | **Archive the Old Project Directory** | `Orchestrator` | Sequential | `ssh ... "mv /root/vivid_mas /root/vivid_mas_DEPRECATED_\$(date +%Y%m%d)"` | The old project directory is safely archived. |
| 4.3 | **Promote New Build to Live** | `Orchestrator` | Sequential | `ssh ... "mv /root/vivid_mas_build /root/vivid_mas"` | The new, correct project directory is now the live `/root/vivid_mas`. |
| 4.4 | **Restart Services from Live Directory** | `Orchestrator` | Sequential | `ssh ... "cd /root/vivid_mas && docker-compose up -d"` | The final production system is live and running from the correct directory. |
| 4.5 | **Execute Guided Cleanup** | `Architect` & `Orchestrator` | Sequential | 1. `Architect` reviews `DROPLET_CONFIG_FILES_LIST.md` and provides a list of explicit `rm -rf` commands to `Orchestrator`.<br>2. `Orchestrator` executes the deletion commands, e.g., `ssh ... "rm -rf /home/vivid/vivid_mas/"`, `ssh ... "rm -rf /root/twenty-crm/"`. | All legacy and duplicated files/directories identified in the manifest are removed. |
| 4.6 | **Final System Prune** | `Orchestrator` | Sequential | `ssh ... "docker system prune -af"` | All old, unused Docker objects are removed from the droplet. |
