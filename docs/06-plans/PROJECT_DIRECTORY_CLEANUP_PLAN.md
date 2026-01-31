# VividWalls MAS Project Directory Cleanup Plan

**Created:** 2026-01-30
**Status:** COMPLETED
**Branch:** `feature/agent-directory-cleanup`

---

## Executive Summary

The VividWalls MAS project root directory has been reorganized from 102 items to 33 visible items (52 total including hidden). Documentation and scripts are now organized into categorized subdirectories.

---

## Results Summary

### Before vs After

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Root directory items (visible) | 102 | 33 | -68% |
| Docs in docs/ root | 208 | 0 | -100% |
| Scripts in scripts/ root | 220 | 0 | -100% |
| Docs subdirectories | 5 | 11 | +120% |
| Scripts subdirectories | 11 | 13 | +18% |

### Files Relocated
- **30 data files** moved to `data/exports/`
- **18 workflow files** moved to `data/workflows/`
- **9 test files** moved to `tests/`
- **111 scripts** archived to `scripts/archive/`

---

## Original State Analysis

### Root Directory Issues (RESOLVED)

| Metric | Original | Target | Achieved |
|--------|---------|--------|----------|
| Root directory items | 102 | ~15-20 | 33 |
| Untracked files | 654 | <100 | 279 |
| Loose docs in docs/ | 208 | Organized by category | 0 |
| Loose scripts in scripts/ | 220 | Organized by function | 0 |

### Problem Areas

1. **Loose files in root**: CSV, JSON, SQL, tar.gz, test files cluttering root
2. **Unorganized docs/**: 208 markdown files without categorization
3. **Duplicate directories**: Multiple frontend, test, backup, caddy directories
4. **One-time scripts**: Scripts created for specific tasks never cleaned up
5. **Scattered configs**: Environment and config files in multiple locations

---

## Files to Relocate from Root

### Data Files (CSV)

| File | Target Location |
|------|-----------------|
| `Artwork Keyword Research Variations.csv` | `data/exports/` |
| `Email List Restaurants.csv` | `data/exports/` |
| `Income_Ranking_By_State.csv` | `data/exports/` |
| `Legal Compliance Checklist.csv` | `data/exports/` |
| `per_capita_income_ranking_by_state.csv` | `data/exports/` |
| `vividwalls_product_catalog-06-18-25.csv` | `data/exports/` |
| `vividwalls-q&a - vividwalls-q&a.csv` | `data/exports/` |
| `vividwalls-room-analysis-qa.csv` | `data/exports/` |

### Workflow/Agent Files (JSON)

| File | Target Location |
|------|-----------------|
| `Business Manager Agent.json` | `data/workflows/agents/` |
| `Campaign Manager Agent Strategic.json` | `data/workflows/agents/` |
| `Keyword Agent Enhanced MAS Standards.json` | `data/workflows/agents/` |
| `LinkedIn Profile Scraper Aug 11 2025.json` | `data/workflows/` |
| `lead-gen-workflow-linkedin-update.json` | `data/workflows/` |
| `example-workflow.json` | `data/workflows/examples/` |

### Database Scripts (SQL)

| File | Target Location |
|------|-----------------|
| `email_marketing_agents_sql_updates.sql` | `services/database/schemas/` |
| `marketing_agents_sql_updates.sql` | `services/database/schemas/` |

### Archive/Backup Files

| File | Target Location |
|------|-----------------|
| `frontend.tar.gz` | `archive/backups/` |
| `frontend_v1.tar.gz` | `archive/backups/` |
| `docker-compose.yml.backup.20250709_131701` | `archive/backups/` |

### Test Files

| File | Target Location |
|------|-----------------|
| `test-data-analytics-mcp.js` | `tests/mcp/` |
| `test-facebook-mcp-fixed.py` | `tests/mcp/` |
| `test-facebook-mcp.py` | `tests/mcp/` |
| `test-mcp-detailed.js` | `tests/mcp/` |
| `test-mcp-simple.js` | `tests/mcp/` |
| `test_agent_frontend.html` | `tests/frontend/` |
| `webhook_test_interface.html` | `tests/webhooks/` |

### Documentation Files

| File | Target Location |
|------|-----------------|
| `GEMINI.md` | `docs/ai-instructions/` |
| `MCP_ANALYTICS_TEST_REPORT.md` | `docs/reports/` |
| `MCP_HTTP_TRANSPORT_UPDATE_REPORT.md` | `docs/reports/` |
| `WALLPIXEL_Products_Analysis_Report.md` | `docs/reports/` |
| `Investment Analysis Report Template.md` | `docs/templates/` |
| `email_to_twenty_crm_integration.md` | `docs/03-integrations/` |

### Configuration Files

| File | Target Location |
|------|-----------------|
| `master.env` | `configs/env/` |
| `Caddyfile.droplet` | `configs/caddy/` |
| `Caddyfile.main` | `configs/caddy/` |
| `docker-compose.yml.droplet` | `configs/docker/` |
| `docker-compose.frontend.yml` | `configs/docker/` |

### Log Files

| File | Target Location |
|------|-----------------|
| `dev-output.log` | `logs/` |

---

## Directory Reorganization

### Docs Directory Structure

Current: 208 files loose in `docs/` root

**Proposed structure:**

```
docs/
├── 01-getting-started/          # Existing
├── 02-architecture/             # Existing
├── 03-integrations/             # Existing
├── 04-development/              # Existing
├── 05-evaluations/              # Existing
├── agents/                      # NEW - Agent documentation
│   ├── architecture/
│   ├── configuration/
│   └── workflows/
├── deployment/                  # NEW - Deployment guides
│   ├── docker/
│   ├── caddy/
│   └── droplet/
├── plans/                       # NEW - Implementation plans
├── reports/                     # NEW - Status/analysis reports
├── templates/                   # NEW - Document templates
└── workflows/                   # NEW - Workflow documentation
```

**File categorization rules:**

| Pattern | Target Directory |
|---------|------------------|
| `AGENT_*`, `agent_*`, `*_AGENT*` | `docs/agents/` |
| `DEPLOYMENT_*`, `DOCKER_*`, `CONTAINER_*` | `docs/deployment/` |
| `*_REPORT*`, `*_STATUS*`, `*_SUMMARY*` | `docs/reports/` |
| `WORKFLOW_*`, `*_workflow*` | `docs/workflows/` |
| `*_GUIDE*`, `*_SETUP*` | Keep in appropriate category |
| `MCP_*` | `docs/03-integrations/mcp/` |

### Duplicate Directory Consolidation

| Keep | Remove/Archive | Action |
|------|----------------|--------|
| `configs/` | `config/` (empty) | Delete empty |
| `services/caddy/` | `caddy/` | Move contents, delete |
| `services/n8n/` | `n8n/` | Move contents, delete |
| `tests/` | `test/` | Merge contents |
| `archive/backups/` | `backup/`, `droplet_backup/` | Consolidate |

### Frontend Directory Decision Required

Current state:
- `frontend/` - Appears to be latest
- `frontend_v1/` - Previous version
- `frontend-integration/` - Integration work
- `temp_frontend/` - Temporary

**Options:**
1. Keep `frontend/` as active, archive others to `archive/frontend-versions/`
2. Keep all separate for now, decide later
3. Consolidate into single `frontend/` with version branches

---

## Proposed Final Structure

```
vivid_mas/
├── .claude/                    # Claude Code configuration
├── .context/                   # AI context management
├── .github/                    # GitHub workflows & templates
├── archive/                    # Archived/deprecated content
│   ├── backups/               # Dated backups
│   ├── deprecated/            # Deprecated code
│   ├── frontend-versions/     # Old frontend versions
│   └── one-time-scripts/      # Scripts run once
├── configs/                    # All configuration files
│   ├── caddy/                 # Caddy configurations
│   ├── docker/                # Docker compose variants
│   ├── env/                   # Environment files
│   └── mcp/                   # MCP configurations
├── data/                       # Data files
│   ├── exports/               # CSV exports, reports
│   ├── shared/                # Shared data
│   └── workflows/             # Workflow JSON exports
│       ├── agents/
│       └── examples/
├── docs/                       # Documentation (organized)
│   ├── 01-getting-started/
│   ├── 02-architecture/
│   ├── 03-integrations/
│   ├── 04-development/
│   ├── 05-evaluations/
│   ├── agents/
│   ├── ai-instructions/
│   ├── deployment/
│   ├── plans/
│   ├── reports/
│   ├── templates/
│   └── workflows/
├── frontend/                   # Active frontend (if consolidated)
├── logs/                       # Application logs
├── packages/                   # Shared npm packages
├── scripts/                    # Organized scripts
│   ├── agents/
│   ├── archive/               # Old/one-time scripts
│   ├── deployment/
│   ├── development/
│   ├── n8n/
│   └── testing/
├── services/                   # All services
│   ├── agents/
│   ├── caddy/
│   ├── database/
│   ├── mcp-servers/
│   ├── n8n/
│   └── [other services]
├── shared/                     # Shared resources
├── specs/                      # Specifications
├── tests/                      # All test files
│   ├── frontend/
│   ├── mcp/
│   └── webhooks/
├── .env                        # Environment (gitignored)
├── .gitignore
├── Caddyfile                   # Active Caddy config
├── CLAUDE.md                   # AI instructions
├── CLAUDE.local.md             # Local AI instructions
├── docker-compose.yml          # Main compose file
├── LICENSE
├── package.json
└── README.md
```

---

## Implementation Steps

### Phase 1: Preparation

```bash
# Create backup branch
git checkout -b cleanup/directory-organization

# Verify we're on the right branch
git branch --show-current
```

### Phase 2: Create New Directory Structure

```bash
# Create new directories
mkdir -p data/workflows/agents
mkdir -p data/workflows/examples
mkdir -p docs/agents/architecture
mkdir -p docs/agents/configuration
mkdir -p docs/agents/workflows
mkdir -p docs/deployment/docker
mkdir -p docs/deployment/caddy
mkdir -p docs/deployment/droplet
mkdir -p docs/plans
mkdir -p docs/reports
mkdir -p docs/templates
mkdir -p docs/workflows
mkdir -p docs/ai-instructions
mkdir -p docs/03-integrations/mcp
mkdir -p configs/docker
mkdir -p archive/backups
mkdir -p archive/frontend-versions
mkdir -p archive/one-time-scripts
mkdir -p tests/mcp
mkdir -p tests/frontend
mkdir -p tests/webhooks
```

### Phase 3: Move Root Files

```bash
# Move CSV files
mv "Artwork Keyword Research Variations.csv" data/exports/
mv "Email List Restaurants.csv" data/exports/
mv "Income_Ranking_By_State.csv" data/exports/
mv "Legal Compliance Checklist.csv" data/exports/
mv per_capita_income_ranking_by_state.csv data/exports/
mv vividwalls_product_catalog-06-18-25.csv data/exports/
mv "vividwalls-q&a - vividwalls-q&a.csv" data/exports/
mv vividwalls-room-analysis-qa.csv data/exports/

# Move JSON workflow files
mv "Business Manager Agent.json" data/workflows/agents/
mv "Campaign Manager Agent Strategic.json" data/workflows/agents/
mv "Keyword Agent Enhanced MAS Standards.json" data/workflows/agents/
mv "LinkedIn Profile Scraper Aug 11 2025.json" data/workflows/
mv lead-gen-workflow-linkedin-update.json data/workflows/
mv example-workflow.json data/workflows/examples/

# Move SQL files
mv email_marketing_agents_sql_updates.sql services/database/schemas/
mv marketing_agents_sql_updates.sql services/database/schemas/

# Move test files
mv test-data-analytics-mcp.js tests/mcp/
mv test-facebook-mcp-fixed.py tests/mcp/
mv test-facebook-mcp.py tests/mcp/
mv test-mcp-detailed.js tests/mcp/
mv test-mcp-simple.js tests/mcp/
mv test_agent_frontend.html tests/frontend/
mv webhook_test_interface.html tests/webhooks/

# Move archive files
mv frontend.tar.gz archive/backups/
mv frontend_v1.tar.gz archive/backups/
mv docker-compose.yml.backup.20250709_131701 archive/backups/

# Move config files
mv master.env configs/env/
mv Caddyfile.droplet configs/caddy/
mv Caddyfile.main configs/caddy/
mv docker-compose.yml.droplet configs/docker/
mv docker-compose.frontend.yml configs/docker/

# Move documentation
mv GEMINI.md docs/ai-instructions/
mv MCP_ANALYTICS_TEST_REPORT.md docs/reports/
mv MCP_HTTP_TRANSPORT_UPDATE_REPORT.md docs/reports/
mv WALLPIXEL_Products_Analysis_Report.md docs/reports/
mv "Investment Analysis Report Template.md" docs/templates/
mv email_to_twenty_crm_integration.md docs/03-integrations/

# Move logs
mv dev-output.log logs/
```

### Phase 4: Consolidate Duplicate Directories

```bash
# Remove empty config directory
rmdir config 2>/dev/null || echo "config not empty or doesn't exist"

# Move caddy contents to services/caddy
mv caddy/* services/caddy/ 2>/dev/null
rmdir caddy 2>/dev/null

# Move n8n contents to services/n8n
mv n8n/* services/n8n/ 2>/dev/null
rmdir n8n 2>/dev/null

# Consolidate test directories
mv test/* tests/ 2>/dev/null
rmdir test 2>/dev/null
```

### Phase 5: Organize Docs Directory

```bash
# Move agent-related docs
cd docs
for f in AGENT_* agent_* *_AGENT*.md; do
  [ -f "$f" ] && mv "$f" agents/
done

# Move deployment docs
for f in DEPLOYMENT_* DOCKER_* CONTAINER_* DNS_* CADDY_*.md; do
  [ -f "$f" ] && mv "$f" deployment/
done

# Move reports
for f in *_REPORT*.md *_STATUS*.md *_SUMMARY*.md; do
  [ -f "$f" ] && mv "$f" reports/
done

# Move workflow docs
for f in WORKFLOW_* *_workflow*.md N8N_*.md; do
  [ -f "$f" ] && mv "$f" workflows/
done

cd ..
```

### Phase 6: Update .gitignore

Add to `.gitignore`:
```
# Archives
archive/backups/*.tar.gz
archive/backups/*.backup

# Logs
logs/*.log

# Local configs
configs/env/*.local
```

### Phase 7: Verification

```bash
# Count root items
ls -la | wc -l

# Verify no broken imports
npm run build 2>/dev/null || echo "No npm build configured"

# Check docker-compose validity
docker-compose config --quiet && echo "Docker compose valid"

# Verify git status
git status
```

---

## Testing Checklist

- [ ] `docker-compose up -d` starts all services
- [ ] n8n workflows load correctly
- [ ] MCP servers connect properly
- [ ] No broken file references in documentation
- [ ] Git history preserved for moved files
- [ ] All environment variables still accessible

---

## Rollback Procedure

If issues arise:

```bash
# Reset to main branch
git checkout main

# Or reset current branch
git reset --hard HEAD~1

# Or restore specific files
git checkout HEAD~1 -- <file_path>
```

---

## Post-Cleanup Maintenance

### Recommended Practices

1. **New files**: Place in appropriate directory immediately
2. **One-time scripts**: Move to `archive/one-time-scripts/` after use
3. **Reports**: Always save to `docs/reports/` with date prefix
4. **Backups**: Use `archive/backups/` with timestamp naming

### Directory Ownership

| Directory | Purpose | Owner |
|-----------|---------|-------|
| `docs/` | Documentation | All |
| `scripts/` | Automation | DevOps |
| `services/` | Service configs | DevOps |
| `data/` | Data exports | Analytics |
| `tests/` | Test files | QA |

---

## Approval Required

Before implementation, please confirm:

1. [ ] Frontend directory consolidation approach
2. [ ] Backup retention policy (keep all or prune old?)
3. [ ] Any files that should NOT be moved

**Approved by:** _______________
**Date:** _______________
