#!/bin/bash

# Daily Maintenance Script for VividWalls MAS
# Run this script daily to ensure system health and performance

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"
REPORT_DIR="maintenance_reports"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Create report directory
mkdir -p "$REPORT_DIR"

# Report file
REPORT_FILE="$REPORT_DIR/daily_$(date +%Y%m%d).log"

echo -e "${BLUE}=== VividWalls MAS Daily Maintenance ===${NC}"
echo -e "${YELLOW}Date: $(date)${NC}"
echo -e "${YELLOW}Report: $REPORT_FILE${NC}\n"

# Function to execute remote command
remote_exec() {
    local command=$1
    local description=$2
    
    echo -e "\n${BLUE}$description${NC}" | tee -a "$REPORT_FILE"
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$command" 2>&1 | tee -a "$REPORT_FILE"
}

# 1. Container Health Check
echo -e "${GREEN}1. Container Health Check${NC}" | tee -a "$REPORT_FILE"
remote_exec "cd /root/vivid_mas && docker-compose ps" "Container status"

# 2. Resource Usage
echo -e "\n${GREEN}2. Resource Usage${NC}" | tee -a "$REPORT_FILE"
remote_exec "
echo 'Memory Usage:'
free -h
echo -e '\nDisk Usage:'
df -h /
echo -e '\nDocker Disk Usage:'
docker system df
" "System resources"

# 3. Database Maintenance
echo -e "\n${GREEN}3. Database Maintenance${NC}" | tee -a "$REPORT_FILE"
remote_exec "
# PostgreSQL vacuum (cleanup)
docker exec postgres psql -U postgres -c 'VACUUM ANALYZE;' 2>/dev/null && echo '✓ PostgreSQL vacuum completed' || echo '✗ PostgreSQL vacuum failed'

# Check database sizes
echo -e '\nDatabase Sizes:'
docker exec postgres psql -U postgres -c \"SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database ORDER BY pg_database_size(pg_database.datname) DESC;\" 2>/dev/null || echo 'Cannot check database sizes'
" "Database maintenance"

# 4. Log Rotation
echo -e "\n${GREEN}4. Log Management${NC}" | tee -a "$REPORT_FILE"
remote_exec "
# Rotate Docker logs
echo 'Rotating Docker logs...'
find /var/lib/docker/containers -name '*.log' -size +100M -exec truncate -s 0 {} \; 2>/dev/null
echo '✓ Docker logs rotated'

# Clean old application logs
find /var/log -name '*.log' -mtime +30 -delete 2>/dev/null || true
echo '✓ Old logs cleaned'

# VividWalls specific logs
if [ -d /var/log/vividwalls ]; then
    find /var/log/vividwalls -name '*.log' -mtime +7 -delete 2>/dev/null || true
    echo '✓ VividWalls logs cleaned'
fi
" "Log management"

# 5. Backup Status
echo -e "\n${GREEN}5. Backup Status${NC}" | tee -a "$REPORT_FILE"
remote_exec "
# Check n8n backups
echo 'N8N Workflow Backups:'
ls -la /root/vivid_mas/n8n/backup/ 2>/dev/null | tail -5 || echo 'No backups found'

# Create daily database backup
BACKUP_FILE=\"/root/vivid_mas/backups/postgres_\$(date +%Y%m%d).sql\"
mkdir -p /root/vivid_mas/backups
if docker exec postgres pg_dumpall -U postgres > \"\$BACKUP_FILE\" 2>/dev/null; then
    echo \"✓ Database backup created: \$BACKUP_FILE\"
    # Keep only last 7 days of backups
    find /root/vivid_mas/backups -name 'postgres_*.sql' -mtime +7 -delete
else
    echo '✗ Database backup failed'
fi
" "Backup management"

# 6. Security Check
echo -e "\n${GREEN}6. Security Check${NC}" | tee -a "$REPORT_FILE"
remote_exec "
# Check for failed SSH attempts
echo 'Recent failed SSH attempts:'
grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -5 || echo 'No failed attempts'

# Check open ports
echo -e '\nOpen ports:'
netstat -tlnp | grep LISTEN | grep -v '127.0.0.1' | head -10
" "Security status"

# 7. Service Availability
echo -e "\n${GREEN}7. Service Availability${NC}" | tee -a "$REPORT_FILE"
endpoints=("n8n.vividwalls.blog" "supabase.vividwalls.blog" "openwebui.vividwalls.blog")
for endpoint in "${endpoints[@]}"; do
    echo -n "Testing https://$endpoint... " | tee -a "$REPORT_FILE"
    
    status=$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 "https://$endpoint" 2>/dev/null)
    if [[ "$status" =~ ^(200|301|302|401|403)$ ]]; then
        echo -e "${GREEN}✓ OK (HTTP $status)${NC}" | tee -a "$REPORT_FILE"
    else
        echo -e "${RED}✗ FAIL (HTTP $status)${NC}" | tee -a "$REPORT_FILE"
    fi
done

# 8. Cleanup Tasks
echo -e "\n${GREEN}8. Cleanup Tasks${NC}" | tee -a "$REPORT_FILE"
remote_exec "
# Remove unused Docker images
docker image prune -f > /dev/null 2>&1 && echo '✓ Unused images removed' || echo '✗ Image cleanup failed'

# Remove dangling volumes
docker volume prune -f > /dev/null 2>&1 && echo '✓ Dangling volumes removed' || echo '✗ Volume cleanup failed'

# Clear package manager cache
apt-get clean > /dev/null 2>&1 && echo '✓ APT cache cleared' || echo '✗ APT cleanup failed'
" "System cleanup"

# 9. Performance Metrics
echo -e "\n${GREEN}9. Performance Metrics${NC}" | tee -a "$REPORT_FILE"
remote_exec "
# CPU load average
echo 'Load Average:' \$(uptime | awk -F'load average:' '{print \$2}')

# Top memory consumers
echo -e '\nTop Memory Consumers:'
ps aux --sort=-%mem | head -6

# Container resource usage
echo -e '\nContainer Resources:'
docker stats --no-stream --format 'table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}'
" "Performance metrics"

# Generate summary
echo -e "\n${BLUE}=== Daily Maintenance Summary ===${NC}" | tee -a "$REPORT_FILE"

# Check for issues
ISSUES=0
if grep -q "✗" "$REPORT_FILE"; then
    ISSUES=$((ISSUES + 1))
    echo -e "${YELLOW}⚠ Issues detected - review report${NC}" | tee -a "$REPORT_FILE"
fi

if grep -q "FAIL" "$REPORT_FILE"; then
    ISSUES=$((ISSUES + 1))
    echo -e "${RED}⚠ Service failures detected${NC}" | tee -a "$REPORT_FILE"
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ All systems healthy${NC}" | tee -a "$REPORT_FILE"
else
    echo -e "${RED}❌ $ISSUES issue(s) require attention${NC}" | tee -a "$REPORT_FILE"
fi

echo -e "\n${BLUE}Report saved to: $REPORT_FILE${NC}"

# Optional: Send email alert if issues found
# if [ $ISSUES -gt 0 ]; then
#     mail -s "VividWalls MAS: $ISSUES issues detected" admin@vividwalls.blog < "$REPORT_FILE"
# fi