#!/bin/bash

# Copy backup file to n8n container
docker cp ./droplet_backup/20250626_180723/codebase/n8n-workflows-backup.json n8n:/tmp/workflows.json

# Import workflows
docker exec n8n n8n import:workflow --input=/tmp/workflows.json

# Verify import
docker exec postgres psql -U postgres -d postgres -c "SELECT COUNT(*) as imported_workflows FROM workflow_entity;"