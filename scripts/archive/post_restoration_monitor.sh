#!/bin/bash

# Post-Restoration Monitoring Script for VividWalls MAS
# This script monitors the system health after restoration

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== VividWalls MAS Post-Restoration Monitor ===${NC}"
echo -e "${YELLOW}Monitoring: $REMOTE_USER@$DROPLET_IP${NC}"

# Function to execute remote command
remote_exec() {
    local command=$1
    local description=$2
    
    echo -e "\n${BLUE}$description${NC}"
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$command"
}

# Create monitoring script on remote
remote_exec "cat > /tmp/continuous_monitor.sh << 'MONITOR'
#!/bin/bash

# Colors
GREEN='\\033[0;32m'
BLUE='\\033[0;34m'
YELLOW='\\033[1;33m'
RED='\\033[0;31m'
NC='\\033[0m'

cd /root/vivid_mas

echo -e \"\\${BLUE}=== VividWalls MAS Health Monitor ===\"
echo -e \"Time: \\$(date)\\${NC}\"

# 1. Container Status
echo -e \"\\n\\${BLUE}1. Container Health Status\\${NC}\"
TOTAL_CONTAINERS=\\$(docker-compose ps -q | wc -l)
RUNNING_CONTAINERS=\\$(docker-compose ps -q | xargs docker inspect -f '{{.State.Running}}' | grep true | wc -l)

echo \"Total Containers: \\$TOTAL_CONTAINERS\"
echo \"Running: \\$RUNNING_CONTAINERS\"

if [ \"\\$RUNNING_CONTAINERS\" -lt \"\\$TOTAL_CONTAINERS\" ]; then
    echo -e \"\\${RED}⚠ Some containers are not running!\\${NC}\"
    docker-compose ps | grep -v 'Up'
else
    echo -e \"\\${GREEN}✓ All containers running\\${NC}\"
fi

# 2. Critical Service Checks
echo -e \"\\n\\${BLUE}2. Critical Service Status\\${NC}\"

# N8N
echo -n \"N8N Workflow Engine: \"
if curl -s -o /dev/null -w '%{http_code}' http://localhost:5678/healthz | grep -q 200; then
    echo -e \"\\${GREEN}✓ Healthy\\${NC}\"
else
    echo -e \"\\${RED}✗ Not responding\\${NC}\"
fi

# PostgreSQL
echo -n \"PostgreSQL Database: \"
if docker exec postgres pg_isready -U postgres > /dev/null 2>&1; then
    WORKFLOW_COUNT=\\$(docker exec postgres psql -U postgres -d postgres -t -c 'SELECT COUNT(*) FROM workflow_entity;' 2>/dev/null | tr -d ' ')
    echo -e \"\\${GREEN}✓ Healthy (\\$WORKFLOW_COUNT workflows)\\${NC}\"
else
    echo -e \"\\${RED}✗ Not accessible\\${NC}\"
fi

# MCP Servers
echo -n \"MCP Server Access: \"
if docker exec n8n ls /opt/mcp-servers > /dev/null 2>&1; then
    MCP_COUNT=\\$(docker exec n8n find /opt/mcp-servers -name 'package.json' | wc -l)
    echo -e \"\\${GREEN}✓ Accessible (\\$MCP_COUNT servers)\\${NC}\"
else
    echo -e \"\\${RED}✗ Not mounted\\${NC}\"
fi

# 3. Resource Usage
echo -e \"\\n\\${BLUE}3. Resource Usage\\${NC}\"

# Memory
TOTAL_MEM=\\$(free -h | grep Mem | awk '{print \\$2}')
USED_MEM=\\$(free -h | grep Mem | awk '{print \\$3}')
echo \"Memory: \\$USED_MEM / \\$TOTAL_MEM\"

# Disk
DISK_USAGE=\\$(df -h / | tail -1 | awk '{print \\$5}')
echo \"Disk Usage: \\$DISK_USAGE\"

# Docker disk
echo \"Docker Disk Usage:\"
docker system df | grep -E '(Images|Containers|Volumes)'

# 4. Network Connectivity
echo -e \"\\n\\${BLUE}4. Network & Endpoints\\${NC}\"

# Check key endpoints
endpoints=(
    'n8n.vividwalls.blog'
    'supabase.vividwalls.blog'
    'openwebui.vividwalls.blog'
)

for endpoint in \"\\${endpoints[@]}\"; do
    echo -n \"https://\\$endpoint: \"
    if curl -s -o /dev/null -w '%{http_code}' --connect-timeout 3 \"https://\\$endpoint\" | grep -qE '^(200|301|302|401)'; then
        echo -e \"\\${GREEN}✓ Accessible\\${NC}\"
    else
        echo -e \"\\${RED}✗ Not accessible\\${NC}\"
    fi
done

# 5. Recent Logs Check
echo -e \"\\n\\${BLUE}5. Recent Error Logs\\${NC}\"

# Check n8n logs for errors
echo \"N8N Recent Errors:\"
docker logs n8n --tail 50 2>&1 | grep -iE '(error|fail|crash)' | tail -5 || echo \"  No recent errors\"

# Check PostgreSQL logs
echo -e \"\\nPostgreSQL Recent Errors:\"
docker logs postgres --tail 50 2>&1 | grep -iE '(error|fatal|fail)' | tail -5 || echo \"  No recent errors\"

# 6. Workflow Execution Status
echo -e \"\\n\\${BLUE}6. N8N Workflow Status\\${NC}\"

# Get recent workflow executions (if accessible)
if docker exec postgres psql -U postgres -d postgres -c \"SELECT mode, COUNT(*) FROM execution_entity WHERE finished_at > NOW() - INTERVAL '1 hour' GROUP BY mode;\" 2>/dev/null; then
    echo -e \"\\${GREEN}✓ Recent workflow executions found\\${NC}\"
else
    echo \"Unable to query workflow executions\"
fi

# Summary
echo -e \"\\n\\${BLUE}=== Health Summary ===\"
if [ \"\\$RUNNING_CONTAINERS\" -eq \"\\$TOTAL_CONTAINERS\" ] && curl -s http://localhost:5678/healthz > /dev/null 2>&1; then
    echo -e \"\\${GREEN}✅ System Status: HEALTHY\\${NC}\"
else
    echo -e \"\\${RED}⚠️  System Status: ISSUES DETECTED\\${NC}\"
fi
echo -e \"\\${BLUE}====================\\${NC}\"

MONITOR
chmod +x /tmp/continuous_monitor.sh
" "Creating monitoring script"

# Create alert script
remote_exec "cat > /tmp/setup_alerts.sh << 'ALERTS'
#!/bin/bash

# Setup basic alerting for critical issues

cd /root/vivid_mas

# Create alert log directory
mkdir -p /var/log/vividwalls

# Create health check cron job
cat > /tmp/health_check_cron.sh << 'CRON'
#!/bin/bash

# Run health checks
/tmp/continuous_monitor.sh > /var/log/vividwalls/health_check.log 2>&1

# Check for critical issues
if grep -q 'ISSUES DETECTED' /var/log/vividwalls/health_check.log; then
    echo \"[\\$(date)] ALERT: System health issues detected\" >> /var/log/vividwalls/alerts.log
    
    # Could add email/webhook notification here
fi

# Rotate logs
if [ -f /var/log/vividwalls/health_check.log ]; then
    mv /var/log/vividwalls/health_check.log /var/log/vividwalls/health_check.\\$(date +%Y%m%d_%H%M%S).log
fi

# Keep only last 7 days of logs
find /var/log/vividwalls -name 'health_check.*.log' -mtime +7 -delete
CRON
chmod +x /tmp/health_check_cron.sh

# Add to crontab (every 15 minutes)
(crontab -l 2>/dev/null; echo \"*/15 * * * * /tmp/health_check_cron.sh\") | crontab -

echo \"✓ Health monitoring cron job installed\"
echo \"  Logs: /var/log/vividwalls/\"
echo \"  Frequency: Every 15 minutes\"

ALERTS
chmod +x /tmp/setup_alerts.sh
" "Creating alert setup script"

# Create recovery procedures
remote_exec "cat > /root/vivid_mas/RECOVERY_PROCEDURES.md << 'RECOVERY'
# VividWalls MAS Recovery Procedures

## Common Issues and Solutions

### 1. N8N Cannot Access MCP Servers

**Symptoms:**
- Workflows fail with \"MCP server not found\"
- /opt/mcp-servers not accessible from n8n container

**Solution:**
\`\`\`bash
# Verify mount
docker exec n8n ls /opt/mcp-servers

# If not mounted, update docker-compose.yml
# Add under n8n volumes:
# - /opt/mcp-servers:/opt/mcp-servers:ro

# Restart n8n
docker-compose restart n8n
\`\`\`

### 2. Database Connection Failed

**Symptoms:**
- N8N shows \"Database connection failed\"
- Workflows not loading

**Solution:**
\`\`\`bash
# Check PostgreSQL is running
docker-compose ps postgres

# Verify connection settings
docker exec n8n printenv | grep DB_POSTGRESDB

# Should show:
# DB_POSTGRESDB_HOST=postgres (NOT 'db')

# Restart if needed
docker-compose restart postgres n8n
\`\`\`

### 3. Encryption Key Mismatch

**Symptoms:**
- \"Invalid credentials\" errors
- Cannot decrypt stored credentials

**Solution:**
\`\`\`bash
# Check key matches production
docker exec n8n printenv | grep N8N_ENCRYPTION_KEY

# Key must be exactly:
# eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs

# If wrong, update .env and restart
\`\`\`

### 4. Service Not Accessible via HTTPS

**Symptoms:**
- https://service.vividwalls.blog returns 502/503
- Service running but not accessible

**Solution:**
\`\`\`bash
# Check Caddy is running
docker-compose ps caddy

# Check Caddy configuration
docker exec caddy caddy validate --config /etc/caddy/Caddyfile

# Check specific site config
cat /root/vivid_mas/caddy/sites-enabled/service.caddy

# Restart Caddy
docker-compose restart caddy
\`\`\`

### 5. Container Restart Loop

**Symptoms:**
- Container constantly restarting
- Status shows \"Restarting (1) X seconds ago\"

**Solution:**
\`\`\`bash
# Check logs
docker logs container_name --tail 50

# Common fixes:
# - Check environment variables in .env
# - Verify volume mounts exist
# - Check port conflicts

# Force recreate
docker-compose up -d --force-recreate container_name
\`\`\`

### 6. Disk Space Issues

**Symptoms:**
- \"No space left on device\" errors
- Services failing to start

**Solution:**
\`\`\`bash
# Check disk usage
df -h

# Clean Docker system
docker system prune -af
docker volume prune -f

# Remove old logs
find /var/log -name '*.log' -mtime +30 -delete

# Remove old backups
rm -rf /root/vivid_mas_DEPRECATED_*
\`\`\`

## Emergency Rollback

If the system becomes completely unusable:

\`\`\`bash
# Stop everything
cd /root/vivid_mas
docker-compose down

# Find latest archive
ls -la /root/vivid_mas_DEPRECATED_*

# Restore from archive
mv /root/vivid_mas /root/vivid_mas_failed_\\$(date +%Y%m%d)
mv /root/vivid_mas_DEPRECATED_XXXXXXX /root/vivid_mas

# Start old system
cd /root/vivid_mas
docker-compose up -d
\`\`\`

## Monitoring Commands

\`\`\`bash
# Run full health check
/tmp/continuous_monitor.sh

# Check recent alerts
tail -f /var/log/vividwalls/alerts.log

# Watch container status
watch docker-compose ps

# Monitor resource usage
htop
docker stats
\`\`\`

## Support Contacts

- Documentation: /root/vivid_mas/docs/
- Logs: /var/log/vividwalls/
- Backups: /root/vivid_mas/n8n/backup/

RECOVERY
" "Creating recovery procedures"

# Execute monitoring
echo -e "\n${GREEN}=== Running Initial Health Check ===${NC}"
remote_exec "/tmp/continuous_monitor.sh" "System health check"

# Setup options
echo -e "\n${BLUE}=== Monitoring Options ===${NC}"
echo -e "${YELLOW}1. One-time health check:${NC}"
echo "   ssh -i ~/.ssh/digitalocean root@$DROPLET_IP '/tmp/continuous_monitor.sh'"

echo -e "\n${YELLOW}2. Setup automated monitoring (recommended):${NC}"
echo "   ssh -i ~/.ssh/digitalocean root@$DROPLET_IP '/tmp/setup_alerts.sh'"

echo -e "\n${YELLOW}3. View recovery procedures:${NC}"
echo "   ssh -i ~/.ssh/digitalocean root@$DROPLET_IP 'cat /root/vivid_mas/RECOVERY_PROCEDURES.md'"

echo -e "\n${GREEN}✓ Post-restoration monitoring setup complete${NC}"