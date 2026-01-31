#!/bin/bash

# SSH into droplet and clean up Medusa containers
# This script connects to the Digital Ocean droplet and runs the Medusa cleanup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Use the known droplet configuration
DROPLET_IP="157.230.13.13"
SSH_KEY_PATH="$HOME/.ssh/digitalocean"

print_status "🚀 Connecting to droplet at $DROPLET_IP to clean up Medusa containers..."

# Check if SSH key exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    print_error "SSH key not found at $SSH_KEY_PATH"
    print_error "Please ensure the Digital Ocean SSH key is properly configured"
    exit 1
fi

# Prepare SSH command with the correct key
SSH_CMD="ssh -i $SSH_KEY_PATH -o StrictHostKeyChecking=no root@$DROPLET_IP"

# Create the cleanup script content to send to droplet
CLEANUP_SCRIPT='#!/bin/bash

# Medusa Container Cleanup Script (Remote Execution)
set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_status "🔍 Starting Medusa container cleanup on droplet..."

# Check if docker is available
if ! command -v docker &> /dev/null; then
    print_error "Docker not found on droplet"
    exit 1
fi

# List all Medusa containers
print_status "📋 Current Medusa containers:"
docker ps -a --filter "name=medusa" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" || true

# Get container names
MEDUSA_CONTAINERS=$(docker ps -a --filter "name=medusa" --format "{{.Names}}" | sort)

if [ -z "$MEDUSA_CONTAINERS" ]; then
    print_warning "No Medusa containers found"
    exit 0
fi

print_status "Found containers: $MEDUSA_CONTAINERS"

# Identify main vs duplicate containers
MAIN_CONTAINER=""
OTHER_CONTAINERS=""

for container in $MEDUSA_CONTAINERS; do
    if [ "$container" = "medusa" ]; then
        MAIN_CONTAINER="medusa"
    else
        OTHER_CONTAINERS="$OTHER_CONTAINERS $container"
    fi
done

if [ -n "$MAIN_CONTAINER" ]; then
    print_success "Main container: $MAIN_CONTAINER"
else
    print_warning "No main medusa container found"
fi

if [ -n "$OTHER_CONTAINERS" ]; then
    print_warning "Duplicate containers:$OTHER_CONTAINERS"
    
    # Stop and remove duplicates
    for container in $OTHER_CONTAINERS; do
        container=$(echo $container | xargs)
        if [ -n "$container" ]; then
            print_status "Stopping $container..."
            docker stop "$container" 2>/dev/null || true
            print_status "Removing $container..."
            docker rm "$container" 2>/dev/null || true
        fi
    done
    
    print_success "✅ Duplicates removed"
else
    print_success "No duplicates found"
fi

# Ensure main container is running
if [ -n "$MAIN_CONTAINER" ]; then
    STATUS=$(docker inspect --format="{{.State.Status}}" "$MAIN_CONTAINER" 2>/dev/null || echo "not_found")
    
    if [ "$STATUS" != "running" ]; then
        print_status "Starting main Medusa container..."
        docker start "$MAIN_CONTAINER" 2>/dev/null || true
    fi
fi

# Restart via docker-compose if available
if [ -f "vivid_mas/docker-compose.yml" ]; then
    print_status "Restarting via docker-compose..."
    cd vivid_mas
    docker-compose up -d medusa 2>/dev/null || true
    cd ..
fi

print_status "📊 Final status:"
docker ps --filter "name=medusa" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" || true

print_success "🎉 Cleanup completed!"
'

print_status "📤 Sending cleanup script to droplet and executing..."

# Execute the cleanup script on the droplet
echo "$CLEANUP_SCRIPT" | $SSH_CMD 'bash -s'

if [ $? -eq 0 ]; then
    print_success "✅ Medusa container cleanup completed successfully!"
    print_status "💡 The main Medusa container should now be running without duplicates"
else
    print_error "❌ Cleanup failed. Please check the output above for errors."
    exit 1
fi
