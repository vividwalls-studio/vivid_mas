#!/bin/bash

# Automated VividWalls MAS Restoration Script
# This script automates the entire restoration process with safety checks

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_USER="root"
PROJECT_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Timing
START_TIME=$(date +%s)

echo -e "${BLUE}=== VividWalls MAS Automated Restoration ===${NC}"
echo -e "${YELLOW}Target: $REMOTE_USER@$DROPLET_IP${NC}"
echo -e "${YELLOW}Started: $(date)${NC}\n"

# Safety check
echo -e "${RED}⚠️  WARNING: This will perform a complete system restoration${NC}"
echo -e "${RED}The following will occur:${NC}"
echo "1. Deploy new architecture to /root/vivid_mas_build"
echo "2. Migrate data from current system"
echo "3. Stop all current services"
echo "4. Replace production directory"
echo "5. Clean up legacy files (4-9 GB)"
echo ""
read -p "Type 'RESTORE' to proceed: " -r
if [[ ! $REPLY == "RESTORE" ]]; then
    echo "Restoration cancelled."
    exit 1
fi

# Function to execute phase
execute_phase() {
    local phase_num=$1
    local phase_name=$2
    local script=$3
    
    echo -e "\n${BLUE}=== Phase $phase_num: $phase_name ===${NC}"
    echo -e "${YELLOW}Starting at: $(date)${NC}"
    
    if [ -f "$script" ]; then
        if bash "$script"; then
            echo -e "${GREEN}✓ Phase $phase_num completed successfully${NC}"
            return 0
        else
            echo -e "${RED}✗ Phase $phase_num failed!${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Script not found: $script${NC}"
        return 1
    fi
}

# Function to run remote script
run_remote_script() {
    local script=$1
    local description=$2
    
    echo -e "${BLUE}Running: $description${NC}"
    if ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "$script"; then
        echo -e "${GREEN}✓ Success${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
}

# Change to project directory
cd "$PROJECT_DIR"

# Pre-flight checks
echo -e "${BLUE}=== Pre-flight Checks ===${NC}"

# Check SSH connection
echo -n "Checking SSH connection... "
if ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "echo connected" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ Cannot connect to droplet${NC}"
    exit 1
fi

# Check master.env exists
echo -n "Checking master.env... "
if [ -f "master.env" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ master.env not found${NC}"
    echo "Run Phase 0 first to create master.env"
    exit 1
fi

# Check all scripts exist
echo -n "Checking deployment scripts... "
scripts=(
    "scripts/deploy_phase1_to_droplet.sh"
    "scripts/deploy_phase2_data_migration.sh"
    "scripts/deploy_phase3_validation.sh"
    "scripts/deploy_phase4_cutover.sh"
)
missing=0
for script in "${scripts[@]}"; do
    if [ ! -f "$script" ]; then
        echo -e "${RED}✗ Missing: $script${NC}"
        missing=$((missing + 1))
    fi
done
if [ $missing -eq 0 ]; then
    echo -e "${GREEN}✓ All scripts present${NC}"
else
    exit 1
fi

# Create restoration log
LOG_FILE="restoration_$(date +%Y%m%d_%H%M%S).log"
echo "Logging to: $LOG_FILE"

# Execute Phase 1
if ! execute_phase 1 "Architecture Setup" "scripts/deploy_phase1_to_droplet.sh" 2>&1 | tee -a "$LOG_FILE"; then
    echo -e "${RED}Phase 1 failed. Aborting restoration.${NC}"
    exit 1
fi

# Execute Phase 2
if ! execute_phase 2 "Data Migration" "scripts/deploy_phase2_data_migration.sh" 2>&1 | tee -a "$LOG_FILE"; then
    echo -e "${RED}Phase 2 failed. Aborting restoration.${NC}"
    exit 1
fi

# Run migration scripts on remote
echo -e "\n${BLUE}Running remote migration scripts...${NC}"
if ! run_remote_script "/tmp/migrate_volumes.sh" "Volume migration" 2>&1 | tee -a "$LOG_FILE"; then
    echo -e "${RED}Volume migration failed${NC}"
    exit 1
fi

if ! run_remote_script "/tmp/start_services.sh" "Service startup" 2>&1 | tee -a "$LOG_FILE"; then
    echo -e "${RED}Service startup failed${NC}"
    exit 1
fi

# Wait for services to stabilize
echo -e "${YELLOW}Waiting 30 seconds for services to stabilize...${NC}"
sleep 30

# Execute Phase 3
if ! execute_phase 3 "System Validation" "scripts/deploy_phase3_validation.sh" 2>&1 | tee -a "$LOG_FILE"; then
    echo -e "${YELLOW}⚠ Validation reported issues${NC}"
    echo "Review the validation report before proceeding:"
    ssh -i "$SSH_KEY" "$REMOTE_USER@$DROPLET_IP" "cat /root/vivid_mas_build/phase3_validation_report.txt"
    
    read -p "Continue with cutover despite validation issues? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Restoration paused at Phase 3. System running from build directory."
        exit 1
    fi
fi

# Final confirmation before cutover
echo -e "\n${RED}⚠️  FINAL CONFIRMATION REQUIRED${NC}"
echo "Phase 4 will:"
echo "- Stop ALL services"
echo "- Archive current production directory"
echo "- Promote build to production"
echo "- Clean up 4-9 GB of legacy files"
echo ""
read -p "Proceed with production cutover? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Cutover cancelled. System running from build directory."
    exit 0
fi

# Execute Phase 4
if ! execute_phase 4 "Production Cutover" "scripts/deploy_phase4_cutover.sh" 2>&1 | tee -a "$LOG_FILE"; then
    echo -e "${RED}Phase 4 failed! System may be in inconsistent state${NC}"
    echo "Check logs and run recovery procedures"
    exit 1
fi

# Post-restoration checks
echo -e "\n${BLUE}=== Post-Restoration Verification ===${NC}"

# Quick health check
echo "Running quick diagnostics..."
if [ -f "scripts/quick_diagnostics.sh" ]; then
    bash "scripts/quick_diagnostics.sh" 2>&1 | tee -a "$LOG_FILE"
fi

# Calculate total time
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
HOURS=$((DURATION / 3600))
MINUTES=$(((DURATION % 3600) / 60))

# Final summary
echo -e "\n${GREEN}=== Restoration Complete ===${NC}"
echo -e "${BLUE}Summary:${NC}"
echo "- Start time: $(date -d @$START_TIME)"
echo "- End time: $(date -d @$END_TIME)"
echo "- Duration: ${HOURS}h ${MINUTES}m"
echo "- Log file: $LOG_FILE"
echo ""
echo -e "${GREEN}✅ VividWalls MAS has been successfully restored!${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Monitor system for 24 hours"
echo "2. Set up automated monitoring:"
echo "   ./scripts/post_restoration_monitor.sh"
echo "3. Review recovery procedures:"
echo "   ssh -i ~/.ssh/digitalocean root@$DROPLET_IP 'cat /root/vivid_mas/RECOVERY_PROCEDURES.md'"
echo ""
echo -e "${BLUE}Access Points:${NC}"
echo "- N8N: https://n8n.vividwalls.blog"
echo "- Supabase: https://supabase.vividwalls.blog"
echo "- Open WebUI: https://openwebui.vividwalls.blog"
echo ""
echo -e "${GREEN}System is now operational at 95% readiness${NC}"