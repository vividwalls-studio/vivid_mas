#!/bin/bash

# Medusa Container Cleanup Script
# This script cleans up duplicated Medusa containers and keeps only the latest one

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

print_status "🔍 Starting Medusa container cleanup..."

# Check if we're on the droplet (look for docker)
if ! command -v docker &> /dev/null; then
    print_error "Docker not found. Make sure you're running this on the droplet."
    exit 1
fi

# List all containers (running and stopped) related to Medusa
print_status "📋 Listing all Medusa-related containers..."
echo ""
docker ps -a --filter "name=medusa" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Get all Medusa container names
MEDUSA_CONTAINERS=$(docker ps -a --filter "name=medusa" --format "{{.Names}}" | sort)

if [ -z "$MEDUSA_CONTAINERS" ]; then
    print_warning "No Medusa containers found."
    exit 0
fi

print_status "Found the following Medusa containers:"
echo "$MEDUSA_CONTAINERS"
echo ""

# Identify the main container (should be just "medusa")
MAIN_CONTAINER=""
OTHER_CONTAINERS=""

for container in $MEDUSA_CONTAINERS; do
    if [ "$container" = "medusa" ]; then
        MAIN_CONTAINER="medusa"
    else
        OTHER_CONTAINERS="$OTHER_CONTAINERS $container"
    fi
done

print_status "🎯 Analysis:"
if [ -n "$MAIN_CONTAINER" ]; then
    print_success "Main container found: $MAIN_CONTAINER"
else
    print_warning "Main 'medusa' container not found"
fi

if [ -n "$OTHER_CONTAINERS" ]; then
    print_warning "Duplicate/related containers found:$OTHER_CONTAINERS"
else
    print_success "No duplicate containers found"
fi

echo ""

# If we have duplicates, ask for confirmation to clean them up
if [ -n "$OTHER_CONTAINERS" ]; then
    print_warning "⚠️  This will stop and remove the following containers:$OTHER_CONTAINERS"
    print_status "The main 'medusa' container will be preserved."
    echo ""
    read -p "Do you want to proceed with cleanup? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "🧹 Starting cleanup process..."
        
        # Stop and remove duplicate containers
        for container in $OTHER_CONTAINERS; do
            container=$(echo $container | xargs)  # Trim whitespace
            if [ -n "$container" ]; then
                print_status "Stopping container: $container"
                docker stop "$container" 2>/dev/null || print_warning "Container $container was not running"
                
                print_status "Removing container: $container"
                docker rm "$container" 2>/dev/null || print_warning "Container $container was already removed"
            fi
        done
        
        print_success "✅ Duplicate containers cleaned up!"
        
        # Check if main container is running
        if [ -n "$MAIN_CONTAINER" ]; then
            MAIN_STATUS=$(docker inspect --format='{{.State.Status}}' "$MAIN_CONTAINER" 2>/dev/null || echo "not_found")
            
            if [ "$MAIN_STATUS" = "running" ]; then
                print_success "✅ Main Medusa container is running"
            elif [ "$MAIN_STATUS" = "exited" ] || [ "$MAIN_STATUS" = "created" ]; then
                print_status "🔄 Starting main Medusa container..."
                docker start "$MAIN_CONTAINER"
                print_success "✅ Main Medusa container started"
            else
                print_warning "Main Medusa container status: $MAIN_STATUS"
            fi
        fi
        
    else
        print_status "Cleanup cancelled by user"
        exit 0
    fi
else
    print_success "✅ No cleanup needed - no duplicate containers found"
fi

# Clean up orphaned volumes (optional)
print_status "🧹 Checking for orphaned volumes..."
ORPHANED_VOLUMES=$(docker volume ls -q --filter "dangling=true" | grep -E "(medusa|postgres|redis)" || true)

if [ -n "$ORPHANED_VOLUMES" ]; then
    print_warning "Found orphaned volumes related to Medusa:"
    echo "$ORPHANED_VOLUMES"
    echo ""
    read -p "Do you want to remove orphaned volumes? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$ORPHANED_VOLUMES" | xargs docker volume rm
        print_success "✅ Orphaned volumes cleaned up"
    fi
else
    print_success "✅ No orphaned volumes found"
fi

# Final status check
print_status "📊 Final container status:"
echo ""
docker ps --filter "name=medusa" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Check if we need to restart the main service via docker-compose
if [ -f "/home/$(whoami)/vivid_mas/docker-compose.yml" ]; then
    print_status "🔄 Ensuring main Medusa service is running via docker-compose..."
    cd "/home/$(whoami)/vivid_mas"
    docker-compose up -d medusa
    print_success "✅ Main Medusa service restarted via docker-compose"
fi

print_success "🎉 Medusa container cleanup completed!"
print_status "💡 You can now access Medusa at the configured URL (typically port 9100)"
