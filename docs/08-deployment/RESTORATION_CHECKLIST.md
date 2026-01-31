# VividWalls MAS Restoration Checklist

## Pre-Restoration Checklist

### Local Environment
- [ ] Project directory: `/Volumes/SeagatePortableDrive/Projects/vivid_mas`
- [ ] SSH key present: `~/.ssh/digitalocean`
- [ ] SSH key permissions: `chmod 600 ~/.ssh/digitalocean`
- [ ] Can SSH to droplet: `ssh -i ~/.ssh/digitalocean root@157.230.13.13`

### Phase 0 Verification
- [ ] `master.env` file exists
- [ ] Contains N8N_ENCRYPTION_KEY
- [ ] Contains JWT_SECRET
- [ ] Contains POSTGRES_PASSWORD
- [ ] Contains all database credentials

### Scripts Verification
- [ ] All deployment scripts are executable
- [ ] Git branch strategy documented
- [ ] Context management system ready

---

## Restoration Execution Checklist

### Phase 1: Architecture Setup (30 min)
- [ ] Run `./scripts/deploy_phase1_to_droplet.sh`
- [ ] Verify `/root/vivid_mas_build/` created on droplet
- [ ] Check docker-compose.yml has MCP volume mount
- [ ] Verify Caddyfile and sites created
- [ ] Confirm .env file deployed

### Phase 2: Data Migration (1 hour)
- [ ] Run `./scripts/deploy_phase2_data_migration.sh`
- [ ] SSH to droplet
- [ ] Execute `/tmp/migrate_volumes.sh`
- [ ] Execute `/tmp/start_services.sh`
- [ ] Execute `/tmp/verify_migration.sh`
- [ ] Verify n8n can access /opt/mcp-servers
- [ ] Confirm workflow count (102+)

### Phase 3: System Validation (30 min)
- [ ] Run `./scripts/deploy_phase3_validation.sh`
- [ ] Review validation report
- [ ] All containers running
- [ ] Endpoints accessible
- [ ] Data integrity confirmed
- [ ] No critical errors

### Phase 4: Production Cutover (45 min)
- [ ] Backup current state noted
- [ ] Run `./scripts/deploy_phase4_cutover.sh`
- [ ] Confirm "yes" when prompted
- [ ] Services stopped successfully
- [ ] Old directory archived
- [ ] Build promoted to production
- [ ] Services restarted
- [ ] Legacy files cleaned (4-9 GB freed)

---

## Post-Restoration Checklist

### Immediate Verification (15 min)
- [ ] Run `./scripts/quick_diagnostics.sh`
- [ ] Access https://n8n.vividwalls.blog
- [ ] Access https://supabase.vividwalls.blog
- [ ] Access https://openwebui.vividwalls.blog
- [ ] Check workflow execution

### Monitoring Setup (15 min)
- [ ] Run `./scripts/post_restoration_monitor.sh`
- [ ] Set up automated monitoring (optional)
- [ ] Review recovery procedures
- [ ] Note archive location for rollback

### 24-Hour Monitoring
- [ ] No container restart loops
- [ ] Memory usage stable
- [ ] Disk usage acceptable
- [ ] All endpoints responsive
- [ ] Workflows executing successfully

### 7-Day Cleanup
- [ ] System stable for 7 days
- [ ] Delete archived directory: `rm -rf /root/vivid_mas_DEPRECATED_*`
- [ ] Remove restoration scripts from /tmp
- [ ] Archive restoration logs

---

## Success Metrics

### Technical Metrics
- ✅ All 48 agents operational
- ✅ 30+ MCP servers accessible
- ✅ 102+ workflows in database
- ✅ All services on vivid_mas network
- ✅ Correct encryption keys

### Business Metrics
- ✅ 95% system readiness achieved
- ✅ Autonomous operations enabled
- ✅ Multi-agent coordination functional
- ✅ 4-9 GB disk space recovered
- ✅ Single source of truth established

---

## Emergency Contacts

### System Access
- Droplet IP: 157.230.13.13
- SSH User: root
- SSH Key: ~/.ssh/digitalocean
- Passphrase: freedom

### Key Directories
- Production: /root/vivid_mas
- Backups: /root/vivid_mas/n8n/backup
- Logs: /var/log/vividwalls
- MCP Servers: /opt/mcp-servers

### Critical Values
- N8N Encryption Key: eyJhbGciOi...soleXcs (see master.env)
- DB Host: postgres (NOT 'db')
- Network: vivid_mas

---

## Notes Section

_Use this space to document any issues or customizations during restoration:_

Date: _______________

Issues Encountered:
- 
- 
- 

Customizations Made:
- 
- 
- 

Time to Complete: _____ hours

---

*Checklist Version: 1.0*  
*Generated: 2025-01-10*