# VividWalls MAS Operational Runbook

## Overview

This runbook provides standard operating procedures for maintaining the VividWalls Multi-Agent System in production.

## Table of Contents

1. [Daily Operations](#daily-operations)
2. [Weekly Maintenance](#weekly-maintenance)
3. [Monthly Tasks](#monthly-tasks)
4. [Incident Response](#incident-response)
5. [Performance Tuning](#performance-tuning)
6. [Backup & Recovery](#backup--recovery)
7. [Security Procedures](#security-procedures)
8. [Troubleshooting Guide](#troubleshooting-guide)

---

## Daily Operations

### Morning Health Check (5 minutes)

```bash
# Run quick diagnostics
./scripts/quick_diagnostics.sh

# Check overnight alerts
ssh -i ~/.ssh/digitalocean root@157.230.13.13 "tail -20 /var/log/vividwalls/alerts.log"
```

### Daily Maintenance (15 minutes)

```bash
# Run automated daily maintenance
./scripts/daily_maintenance.sh
```

**Daily maintenance includes:**
- Container health verification
- Resource usage monitoring
- Database vacuum
- Log rotation
- Backup verification
- Security checks

### End of Day Review

1. Review daily maintenance report
2. Check for any failed workflows
3. Verify all services are accessible
4. Note any issues for follow-up

---

## Weekly Maintenance

### Monday: Workflow Review

```bash
# Review workflow performance
./scripts/workflow_manager.sh
# Select option 7 (Show statistics)
```

- Check for failed executions
- Review workflow performance
- Update inactive workflows
- Export workflow backup

### Wednesday: System Updates

```bash
ssh -i ~/.ssh/digitalocean root@157.230.13.13

# Update system packages
apt update && apt upgrade -y

# Update Docker images (careful - test first)
cd /root/vivid_mas
docker-compose pull
# Only restart if updates are critical
```

### Friday: Performance Review

```bash
# Generate performance report
ssh -i ~/.ssh/digitalocean root@157.230.13.13 "
docker stats --no-stream > /tmp/weekly_stats.txt
docker system df >> /tmp/weekly_stats.txt
"

# Download report
scp -i ~/.ssh/digitalocean root@157.230.13.13:/tmp/weekly_stats.txt ./reports/
```

---

## Monthly Tasks

### First Monday: Full System Backup

```bash
# Create full system backup
ssh -i ~/.ssh/digitalocean root@157.230.13.13 "
cd /root/vivid_mas
tar -czf /backup/vivid_mas_full_$(date +%Y%m).tar.gz \
  --exclude='*.log' \
  --exclude='node_modules' \
  .
"
```

### Second Monday: Security Audit

1. Review SSH access logs
2. Check for unusual activity
3. Update passwords if needed
4. Review firewall rules
5. Check SSL certificates

### Third Monday: Capacity Planning

- Review disk usage trends
- Check memory utilization
- Plan for scaling needs
- Review backup retention

### Fourth Monday: Disaster Recovery Test

```bash
# Test recovery procedures
# Use a staging environment if available
```

---

## Incident Response

### Severity Levels

**P1 - Critical**: Complete system outage
**P2 - Major**: Key service degraded
**P3 - Minor**: Non-critical issue
**P4 - Low**: Cosmetic/improvement

### P1 Response Procedure

1. **Acknowledge** (< 5 minutes)
   ```bash
   ./scripts/quick_diagnostics.sh
   ```

2. **Diagnose** (< 15 minutes)
   ```bash
   ./scripts/emergency_recovery.sh
   # Select option 1 (Diagnose)
   ```

3. **Mitigate** (< 30 minutes)
   - Try quick fixes first
   - Consider rollback if needed
   - Document actions taken

4. **Resolve** (< 2 hours)
   - Implement permanent fix
   - Test thoroughly
   - Update documentation

5. **Post-Mortem** (< 24 hours)
   - Root cause analysis
   - Prevention measures
   - Update runbooks

### Common Issues Quick Reference

| Issue | Quick Fix | Script |
|-------|-----------|--------|
| N8N down | Restart container | `docker-compose restart n8n` |
| Database connection lost | Fix host config | `emergency_recovery.sh` → Option 3 |
| MCP servers not accessible | Fix mount | `emergency_recovery.sh` → Option 4 |
| Out of memory | Clear logs/cache | `emergency_recovery.sh` → Option 9 |
| Service not accessible | Check Caddy | `docker-compose restart caddy` |

---

## Performance Tuning

### Container Resource Limits

Edit `docker-compose.yml` to set limits:

```yaml
services:
  n8n:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

### Database Optimization

```sql
-- Run monthly
VACUUM ANALYZE;
REINDEX DATABASE postgres;
```

### Docker Cleanup

```bash
# Weekly cleanup
docker system prune -af
docker volume prune -f
```

---

## Backup & Recovery

### Backup Schedule

- **Daily**: Database & workflows (automated)
- **Weekly**: Configuration files
- **Monthly**: Full system backup

### Backup Locations

- Local: `/root/vivid_mas/backups/`
- Workflows: `/root/vivid_mas/n8n/backup/`
- Emergency: `/root/emergency_export_*.tar.gz`

### Recovery Procedures

1. **Workflow Recovery**
   ```bash
   ./scripts/workflow_manager.sh
   # Select option 3 (Import workflows)
   ```

2. **Database Recovery**
   ```bash
   docker exec -i postgres psql -U postgres < backup.sql
   ```

3. **Full System Recovery**
   ```bash
   ./scripts/emergency_recovery.sh
   # Select option 6 (Rollback)
   ```

---

## Security Procedures

### Access Control

1. **SSH Keys Only** - No password authentication
2. **Firewall Rules** - Only required ports open
3. **SSL/TLS** - All services use HTTPS
4. **Authentication** - Strong passwords, rotate quarterly

### Security Checklist

- [ ] Review SSH access logs weekly
- [ ] Check for failed login attempts
- [ ] Verify SSL certificates monthly
- [ ] Update system packages monthly
- [ ] Review container vulnerabilities quarterly

### Emergency Security Response

```bash
# If compromise suspected
ssh -i ~/.ssh/digitalocean root@157.230.13.13

# 1. Isolate system
ufw deny from any

# 2. Export critical data
./emergency_export.sh

# 3. Review logs
grep -r "Failed password" /var/log/

# 4. Change all passwords
# Update master.env and redeploy
```

---

## Troubleshooting Guide

### Diagnostic Tools

```bash
# System health
./scripts/quick_diagnostics.sh

# Detailed monitoring
./scripts/post_restoration_monitor.sh

# Container logs
docker logs <container> --tail 100

# Database queries
docker exec postgres psql -U postgres -c "SELECT * FROM ..."
```

### Log Locations

- Docker logs: `/var/lib/docker/containers/*/`
- System logs: `/var/log/syslog`
- Application logs: `/var/log/vividwalls/`
- Caddy logs: `docker logs caddy`

### Performance Issues

1. **Slow Response**
   - Check memory: `free -h`
   - Check CPU: `top`
   - Check disk I/O: `iotop`

2. **High Memory Usage**
   - Identify culprit: `docker stats`
   - Restart service: `docker-compose restart <service>`
   - Clear caches: `sync && echo 3 > /proc/sys/vm/drop_caches`

3. **Disk Space Issues**
   - Check usage: `df -h`
   - Find large files: `du -sh /* | sort -h`
   - Clean Docker: `docker system prune -af`

---

## Appendix

### Useful Commands

```bash
# Watch container status
watch docker-compose ps

# Follow logs
docker-compose logs -f n8n

# Database console
docker exec -it postgres psql -U postgres

# Network debugging
docker network inspect vivid_mas

# Resource monitoring
htop
```

### Contact Information

- System Admin: admin@vividwalls.blog
- Droplet IP: 157.230.13.13
- Documentation: /root/vivid_mas/docs/

### Change Log

- 2025-01-10: Initial runbook created
- Version: 1.0

---

*End of Operational Runbook*