#!/bin/bash

# Check all containers on droplet to identify Medusa or related services
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

print_status "🔍 Checking all containers on droplet..."

echo ""
print_status "📋 All running containers:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" || true

echo ""
print_status "📋 All containers (including stopped):"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.CreatedAt}}" || true

echo ""
print_status "🔍 Searching for e-commerce related containers:"
docker ps -a --filter "name=medusa" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" || true
docker ps -a --filter "name=commerce" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" || true
docker ps -a --filter "name=shop" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" || true
docker ps -a --filter "name=store" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" || true

echo ""
print_status "🔍 Checking for Docker Compose services:"
if [ -f "vivid_mas/docker-compose.yml" ]; then
    cd vivid_mas
    print_status "Docker Compose services status:"
    docker-compose ps || true
    cd ..
else
    print_warning "No docker-compose.yml found in vivid_mas directory"
fi

echo ""
print_status "💾 System resource usage:"
echo "Disk usage:"
df -h | head -2
echo ""
echo "Memory usage:"
free -h
echo ""
echo "Docker system usage:"
docker system df || true

echo ""
print_status "🔍 Checking for Medusa-related images:"
docker images | grep -i medusa || print_warning "No Medusa images found"

echo ""
print_status "🔍 Checking for any running services on common ports:"
echo "Port 9000 (Medusa admin):"
netstat -tlnp | grep :9000 || echo "No service on port 9000"
echo "Port 9100 (Medusa mapped):"
netstat -tlnp | grep :9100 || echo "No service on port 9100"

print_success "🎉 Container check completed!"
