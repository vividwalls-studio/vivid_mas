#!/bin/bash
# Deploy agent data to Digital Ocean Supabase instance
# This script handles the complete deployment process

set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
LOCAL_PROJECT_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas"
REMOTE_PROJECT_PATH="/root/vivid_mas"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Digital Ocean Supabase Data Deployment ===${NC}"
echo "Droplet IP: $DROPLET_IP"
echo ""

# Function to run commands on droplet
run_on_droplet() {
    ssh -i $SSH_KEY root@$DROPLET_IP "$1"
}

# Function to upload files to droplet
upload_to_droplet() {
    local source=$1
    local dest=$2
    echo -e "${YELLOW}Uploading $source to droplet...${NC}"
    scp -i $SSH_KEY -r "$source" root@$DROPLET_IP:"$dest"
}

# Step 1: Check SSH connection
echo -e "${YELLOW}Step 1: Testing SSH connection...${NC}"
if run_on_droplet "echo 'SSH connection successful'"; then
    echo -e "${GREEN}✓ SSH connection established${NC}"
else
    echo -e "${RED}✗ Failed to connect to droplet${NC}"
    exit 1
fi

# Step 2: Check if project exists on droplet
echo -e "\n${YELLOW}Step 2: Checking project on droplet...${NC}"
if run_on_droplet "[ -d $REMOTE_PROJECT_PATH ] && echo 'exists'"; then
    echo -e "${GREEN}✓ Project found at $REMOTE_PROJECT_PATH${NC}"
else
    echo -e "${RED}✗ Project not found at $REMOTE_PROJECT_PATH${NC}"
    echo "Would you like to create the directory? (y/N)"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_on_droplet "mkdir -p $REMOTE_PROJECT_PATH"
        echo -e "${GREEN}✓ Directory created${NC}"
    else
        exit 1
    fi
fi

# Step 3: Upload necessary files
echo -e "\n${YELLOW}Step 3: Uploading data files...${NC}"
echo "Uploading scripts directory..."
upload_to_droplet "$LOCAL_PROJECT_PATH/scripts" "$REMOTE_PROJECT_PATH/"
echo "Uploading mcp_conversion directory..."
upload_to_droplet "$LOCAL_PROJECT_PATH/mcp_conversion" "$REMOTE_PROJECT_PATH/"
echo "Uploading SQL chunks..."
upload_to_droplet "$LOCAL_PROJECT_PATH/sql_chunks" "$REMOTE_PROJECT_PATH/"
echo -e "${GREEN}✓ Files uploaded${NC}"

# Step 4: Check Supabase environment
echo -e "\n${YELLOW}Step 4: Checking Supabase environment...${NC}"
run_on_droplet "cd $REMOTE_PROJECT_PATH && docker ps | grep -E 'supabase|postgrest' || echo 'No Supabase containers found'"

# Step 5: Set up environment variables
echo -e "\n${YELLOW}Step 5: Setting up environment variables...${NC}"
echo "Enter the Supabase ANON key (or press Enter to skip if already set):"
read -s ANON_KEY
if [ ! -z "$ANON_KEY" ]; then
    run_on_droplet "export SUPABASE_ANON_KEY='$ANON_KEY'"
    echo -e "${GREEN}✓ ANON key set${NC}"
fi

# Step 6: Choose insertion method
echo -e "\n${YELLOW}Step 6: Choose insertion method:${NC}"
echo "1) PostgREST Direct Insert (Recommended)"
echo "2) Manual SQL Insertion"
echo "3) Python HTTP Insertion"
echo "4) Exit"
read -p "Select option (1-4): " choice

case $choice in
    1)
        echo -e "\n${BLUE}Running PostgREST Direct Insert...${NC}"
        run_on_droplet "cd $REMOTE_PROJECT_PATH && \
            export SUPABASE_URL='https://supabase.vividwalls.blog' && \
            export SUPABASE_ANON_KEY='$ANON_KEY' && \
            bash scripts/postgrest_direct_insert.sh"
        ;;
    2)
        echo -e "\n${BLUE}Running Manual SQL Insertion...${NC}"
        echo "This will execute SQL files through psql. Continue? (y/N)"
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for i in {1..4}; do
                echo -e "${YELLOW}Executing chunk_00${i}.sql...${NC}"
                run_on_droplet "cd $REMOTE_PROJECT_PATH && \
                    docker exec -i supabase-db psql -U postgres -d postgres < sql_chunks/chunk_00${i}.sql"
            done
        fi
        ;;
    3)
        echo -e "\n${BLUE}Running Python HTTP Insertion...${NC}"
        run_on_droplet "cd $REMOTE_PROJECT_PATH && \
            export SUPABASE_URL='https://supabase.vividwalls.blog' && \
            export SUPABASE_ANON_KEY='$ANON_KEY' && \
            python3 scripts/postgrest_http_insert.py"
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

# Step 7: Run verification
echo -e "\n${YELLOW}Step 7: Running verification...${NC}"
echo "Would you like to run the verification script? (y/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Running verification queries...${NC}"
    run_on_droplet "cd $REMOTE_PROJECT_PATH && \
        docker exec -i supabase-db psql -U postgres -d postgres < scripts/verify_schema.sql"
fi

# Step 8: Test connection
echo -e "\n${YELLOW}Step 8: Test API connection...${NC}"
echo "Testing PostgREST API endpoint..."
run_on_droplet "curl -s -X GET \
    'https://supabase.vividwalls.blog/rest/v1/agents?select=id,name,role&limit=3' \
    -H 'apikey: $ANON_KEY' \
    -H 'Authorization: Bearer $ANON_KEY' | jq '.' || echo 'Failed to query API'"

echo -e "\n${GREEN}=== Deployment Complete ===${NC}"
echo "Next steps:"
echo "1. Check the Supabase dashboard at https://supabase.vividwalls.blog"
echo "2. Verify data in the SQL Editor"
echo "3. Test your n8n workflows with the new data"