#!/bin/bash

# Morpheus Validator - Container Health Fix Script
# "The time has come to make a choice."

set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

print_status() { echo -e "${BLUE}[MORPHEUS]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_status "🔍 The time has come to make a choice. Fixing container health issues..."

# Function to check container health
check_container_health() {
    local container_name=$1
    local health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null || echo "no-health-check")
    
    case $health_status in
        "healthy")
            print_success "✅ $container_name: Healthy"
            return 0
            ;;
        "unhealthy")
            print_error "❌ $container_name: Unhealthy"
            return 1
            ;;
        "starting")
            print_warning "⏳ $container_name: Starting"
            return 2
            ;;
        "no-health-check")
            local running_status=$(docker inspect --format='{{.State.Running}}' "$container_name" 2>/dev/null || echo "false")
            if [ "$running_status" = "true" ]; then
                print_warning "⚠️  $container_name: Running (no health check)"
                return 2
            else
                print_error "❌ $container_name: Not running"
                return 1
            fi
            ;;
        *)
            print_warning "❓ $container_name: Unknown status ($health_status)"
            return 2
            ;;
    esac
}

# Fix Supabase Vector Container
print_status "🔧 Fixing Supabase Vector configuration..."
if docker ps | grep -q "supabase-vector"; then
    if check_container_health "supabase-vector"; then
        print_success "Supabase Vector is now healthy"
    else
        print_status "Restarting Supabase Vector..."
        docker restart supabase-vector
        sleep 10
        check_container_health "supabase-vector"
    fi
else
    print_error "Supabase Vector container not found"
fi

# Fix Medusa Container
print_status "🔧 Checking Medusa container..."
if docker ps | grep -q "medusa"; then
    if check_container_health "medusa"; then
        print_success "Medusa is running"
    else
        print_status "Checking Medusa logs..."
        docker logs --tail 10 medusa
    fi
else
    print_error "Medusa container not found"
fi

# Fix Ngrok Container (disable it for now due to account limitations)
print_status "🔧 Handling Ngrok Facebook container..."
if docker ps -a | grep -q "ngrok-facebook"; then
    print_warning "Stopping ngrok-facebook due to account limitations"
    docker stop ngrok-facebook 2>/dev/null || true
    docker rm ngrok-facebook 2>/dev/null || true
    print_success "Ngrok container removed to prevent restart loops"
fi

# Check all critical containers
print_status "🔍 Checking all critical container health..."
critical_containers=(
    "postgres"
    "redis" 
    "n8n"
    "caddy"
    "supabase-kong"
    "supabase-db"
    "supabase-auth"
    "ollama"
    "open-webui"
    "flowise"
)

unhealthy_count=0
for container in "${critical_containers[@]}"; do
    if docker ps | grep -q "$container"; then
        if ! check_container_health "$container"; then
            ((unhealthy_count++))
        fi
    else
        print_warning "⚠️  $container: Not running"
        ((unhealthy_count++))
    fi
done

# Summary
echo ""
print_status "📊 Health Check Summary"
echo "================================="
if [ $unhealthy_count -eq 0 ]; then
    print_success "🎉 All critical containers are healthy!"
    print_status "Choice is an illusion created between those with power and those without."
else
    print_warning "⚠️  $unhealthy_count containers need attention"
    print_status "The Matrix has you... but we're working on it."
fi

# Create ongoing monitoring
print_status "🔄 Setting up continuous health monitoring..."
cat > /tmp/health_monitor.sh << 'EOF'
#!/bin/bash
while true; do
    echo "$(date): Checking container health..."
    docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(unhealthy|restarting|exited)"
    sleep 300  # Check every 5 minutes
done
EOF

chmod +x /tmp/health_monitor.sh
print_success "Health monitoring script created at /tmp/health_monitor.sh"

print_status "🎯 Container health fix completed. The choice has been made."
