#!/bin/bash

# Backup transfer script
# Transfers backup files from droplet to local drive

REMOTE_HOST="root@157.230.13.13"
SSH_KEY="$HOME/.ssh/digitalocean"
REMOTE_PATH="/opt/vividwalls/data/backups"
LOCAL_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/droplet_backup/vividwalls_data_backups"

echo "Starting backup transfer from droplet to local drive..."
echo "Remote: $REMOTE_HOST:$REMOTE_PATH"
echo "Local: $LOCAL_PATH"

# Create local directory if it doesn't exist
mkdir -p "$LOCAL_PATH"

# Use rsync with resume capability
# -a: archive mode (preserves permissions, timestamps, etc.)
# -v: verbose
# -z: compress during transfer
# --partial: keep partially transferred files
# --progress: show progress
# --bwlimit: limit bandwidth to avoid timeout (in KB/s)
rsync -avz --partial --progress --bwlimit=5000 \
  -e "ssh -i $SSH_KEY" \
  "$REMOTE_HOST:$REMOTE_PATH/" \
  "$LOCAL_PATH/"

echo "Transfer complete!"
echo ""
echo "To verify the transfer:"
echo "ssh -i $SSH_KEY $REMOTE_HOST 'du -sh $REMOTE_PATH'"
echo "du -sh $LOCAL_PATH"
echo ""
echo "To delete from droplet after verification:"
echo "ssh -i $SSH_KEY $REMOTE_HOST 'rm -rf $REMOTE_PATH/*'"