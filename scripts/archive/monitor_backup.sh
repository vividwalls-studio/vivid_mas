#!/bin/bash

# Monitor backup progress
BACKUP_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/droplet_backup"
LATEST_BACKUP=$(ls -t1 "$BACKUP_DIR" | grep -E '^[0-9]{8}_[0-9]{6}$' | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "No backup in progress found"
    exit 1
fi

BACKUP_PATH="$BACKUP_DIR/$LATEST_BACKUP"
LOG_FILE="$BACKUP_PATH/backup_log_${LATEST_BACKUP}.txt"

echo "Monitoring backup: $LATEST_BACKUP"
echo "----------------------------------------"

# Check if backup is still running
if ps aux | grep -q "[b]ackup_droplet_complete.sh"; then
    echo "Status: RUNNING"
else
    echo "Status: COMPLETED or STOPPED"
fi

echo ""
echo "Current backup size:"
du -sh "$BACKUP_PATH"

echo ""
echo "Contents backed up so far:"
for dir in codebase docker configs databases env_files n8n neo4j supabase qdrant volumes; do
    if [ -d "$BACKUP_PATH/$dir" ]; then
        size=$(du -sh "$BACKUP_PATH/$dir" 2>/dev/null | cut -f1)
        count=$(find "$BACKUP_PATH/$dir" -type f 2>/dev/null | wc -l | xargs)
        printf "%-15s %10s %10s files\n" "$dir:" "$size" "$count"
    fi
done

echo ""
echo "Latest activity:"
if [ -f "$LOG_FILE" ]; then
    tail -5 "$LOG_FILE" | grep -E "(Backing up|Exporting|Creating|Status:|✓)" || tail -5 backup_progress.log | grep -v "xfer#"
fi

echo ""
echo "To view full log: tail -f backup_progress.log"
echo "To stop backup: pkill -f backup_droplet_complete.sh"