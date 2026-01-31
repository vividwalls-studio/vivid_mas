#!/bin/bash

# Remote Medusa cleanup script (to be executed on the droplet)
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

print_status "🔍 Starting Medusa container cleanup..."

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
