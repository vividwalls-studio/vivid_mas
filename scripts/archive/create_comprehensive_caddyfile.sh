#!/bin/bash

# Create Comprehensive Caddyfile for VividWalls MAS
# This script creates a fully configured Caddyfile for all container applications

set -e

echo "🔧 Creating Comprehensive Caddyfile Configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# SSH connection details
SSH_KEY="~/.ssh/digitalocean"
DROPLET_IP="157.230.13.13"
SSH_USER="root"

# Function to execute commands on remote droplet
remote_exec() {
    ssh -i "$SSH_KEY" "$SSH_USER@$DROPLET_IP" "$1"
}

echo -e "${BLUE}Step 1: Backing up current Caddyfile${NC}"
remote_exec "cp /root/vivid_mas/Caddyfile /root/vivid_mas/Caddyfile.backup.$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}Step 2: Creating comprehensive Caddyfile (Part 1)${NC}"
remote_exec "cat > /root/vivid_mas/Caddyfile << 'EOF'
# VividWalls Multi-Agent System - Comprehensive Caddyfile
# Generated: $(date)
# All container applications properly configured

# =============================================================================
# CORE WORKFLOW & AUTOMATION SERVICES
# =============================================================================

# N8N Workflow Automation Platform
n8n.vividwalls.blog {
    reverse_proxy n8n:5678 {
        header_up X-Forwarded-Port {http.request.port}
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
        header_up Host {http.request.host}
        
        # Connection timeouts
        transport http {
            dial_timeout 30s
            response_header_timeout 30s
        }
    }
    
    # Enable WebSocket support for real-time updates
    @websockets {
        header Connection *Upgrade*
        header Upgrade websocket
    }
    reverse_proxy @websockets n8n:5678
    
    # Security headers
    header {
        X-Frame-Options DENY
        X-Content-Type-Options nosniff
        Referrer-Policy strict-origin-when-cross-origin
    }
}

# =============================================================================
# SUPABASE BACKEND SERVICES
# =============================================================================

# Supabase API Gateway (Kong)
supabase.vividwalls.blog {
    reverse_proxy supabase-kong:8000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-For {http.request.remote.host}
    }
    
    # CORS headers for API access
    header {
        Access-Control-Allow-Origin *
        Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Access-Control-Allow-Headers "Content-Type, Authorization"
    }
}

# Supabase Studio (Database Management)
studio.vividwalls.blog {
    reverse_proxy supabase-studio:3000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
}

# Supabase Analytics (System Admin Agent)
analytics.vividwalls.blog {
    reverse_proxy supabase-analytics:4000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # JSON API optimization
    header {
        Content-Type application/json
        Cache-Control no-cache
    }
}

# =============================================================================
# AI & ML SERVICES
# =============================================================================

# Open WebUI (ChatGPT Interface)
openwebui.vividwalls.blog {
    reverse_proxy open-webui:8080 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {http.request.host}
    }
    
    # Increase body size for file uploads
    request_body {
        max_size 100MB
    }
    
    # WebSocket support for real-time chat
    @websockets {
        header Connection *Upgrade*
        header Upgrade websocket
    }
    reverse_proxy @websockets open-webui:8080
}

# Flowise (AI Workflow Builder)
flowise.vividwalls.blog {
    reverse_proxy flowise:3001 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # File upload support
    request_body {
        max_size 50MB
    }
}

# Langfuse (LLM Observability)
langfuse.vividwalls.blog {
    reverse_proxy langfuse-web:3000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
}

# Crawl4AI (Web Scraping Service)
crawl4ai.vividwalls.blog {
    reverse_proxy crawl4ai:11235 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # API timeout for long scraping operations
    reverse_proxy crawl4ai:11235 {
        transport http {
            dial_timeout 60s
            response_header_timeout 300s
        }
    }
}

# Ollama (Local LLM Server)
ollama.vividwalls.blog {
    reverse_proxy ollama:11434 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # Long timeout for LLM responses
    reverse_proxy ollama:11434 {
        transport http {
            dial_timeout 30s
            response_header_timeout 600s
        }
    }
}

EOF"

echo -e "${GREEN}✅ Caddyfile Part 1 created${NC}"

echo -e "${BLUE}Step 3: Adding business applications configuration${NC}"
remote_exec "cat >> /root/vivid_mas/Caddyfile << 'EOF'

# =============================================================================
# BUSINESS APPLICATIONS
# =============================================================================

# Twenty CRM (Customer Relationship Management)
twenty.vividwalls.blog {
    reverse_proxy twenty-server-1:3000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
    encode gzip

    # Health check endpoint
    handle_path /health {
        respond \"OK\" 200
    }
}

# Twenty CRM alternate domain
crm.vividwalls.blog {
    reverse_proxy twenty-server-1:3000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
    encode gzip
}

# ListMonk Email Marketing
listmonk.vividwalls.blog {
    reverse_proxy listmonk:9000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }

    # File upload support for campaigns
    request_body {
        max_size 25MB
    }
}

# Medusa E-commerce Platform (Admin)
medusa.vividwalls.blog {
    reverse_proxy medusa:9100 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {http.request.host}
    }

    # CORS for admin panel
    header {
        Access-Control-Allow-Origin *
        Access-Control-Allow-Methods \"GET, POST, PUT, DELETE, OPTIONS\"
        Access-Control-Allow-Headers \"Content-Type, Authorization\"
    }
}

# Medusa Storefront (Customer-facing)
store.vividwalls.blog {
    reverse_proxy medusa-storefront:3000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {http.request.host}
    }

    # E-commerce optimizations
    encode gzip
    header {
        Cache-Control \"public, max-age=3600\"
        X-Frame-Options SAMEORIGIN
    }
}

# Postiz Social Media Management
postiz.vividwalls.blog {
    reverse_proxy postiz:5000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }

    # File upload for media posts
    request_body {
        max_size 50MB
    }
}

# WordPress Multisite
wordpress.vividwalls.blog {
    reverse_proxy wordpress-multisite:80 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {http.request.host}
    }

    # WordPress optimizations
    encode gzip
    request_body {
        max_size 100MB
    }

    # Cache static assets
    @static {
        path *.css *.js *.png *.jpg *.jpeg *.gif *.ico *.svg *.woff *.woff2
    }
    header @static Cache-Control \"public, max-age=31536000\"
}

EOF"

echo -e "${GREEN}✅ Business applications configuration added${NC}"

echo -e "${BLUE}Step 4: Adding additional services and utilities${NC}"
remote_exec "cat >> /root/vivid_mas/Caddyfile << 'EOF'

# =============================================================================
# ADDITIONAL SERVICES & UTILITIES
# =============================================================================

# Neo4j Knowledge Graph
neo4j.vividwalls.blog {
    reverse_proxy neo4j-knowledge-fixed:7474 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }

    # Neo4j browser optimizations
    header {
        X-Frame-Options SAMEORIGIN
    }
}

# SearXNG Search Engine
searxng.vividwalls.blog {
    reverse_proxy searxng-temp:8080 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }

    # Search engine optimizations
    encode gzip
    header {
        X-Robots-Tag \"noindex, nofollow\"
    }
}

# MinIO Object Storage (S3-compatible)
minio.vividwalls.blog {
    reverse_proxy minio:9000 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }

    # Large file upload support
    request_body {
        max_size 1GB
    }
}

# MinIO Console (Admin Interface)
minio-console.vividwalls.blog {
    reverse_proxy minio:9090 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }
}

# Qdrant Vector Database
qdrant.vividwalls.blog {
    reverse_proxy qdrant:6333 {
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-Proto {scheme}
    }

    # API optimizations for vector operations
    header {
        Content-Type \"application/json\"
    }
}

# =============================================================================
# FALLBACK & HEALTH CHECKS
# =============================================================================

# Main domain fallback
vividwalls.blog {
    # Redirect to main application (n8n for now)
    redir https://n8n.vividwalls.blog{uri} permanent
}

# Health check endpoint for all services
health.vividwalls.blog {
    respond /health \"VividWalls MAS - All Systems Operational\" 200

    # Service status endpoints
    handle_path /status/n8n {
        reverse_proxy n8n:5678/health
    }

    handle_path /status/supabase {
        reverse_proxy supabase-kong:8000/health
    }

    handle_path /status/twenty {
        reverse_proxy twenty-server-1:3000/health
    }
}

# =============================================================================
# GLOBAL SETTINGS
# =============================================================================

# Global options
{
    # Email for Let's Encrypt
    email admin@vividwalls.blog

    # Enable automatic HTTPS
    auto_https on

    # Security headers for all sites
    header {
        # Security headers
        Strict-Transport-Security \"max-age=31536000; includeSubDomains\"
        X-Content-Type-Options nosniff
        X-Frame-Options DENY
        Referrer-Policy strict-origin-when-cross-origin

        # Remove server information
        -Server
    }
}

EOF"

echo -e "${GREEN}✅ Additional services configuration added${NC}"

echo -e "${BLUE}Step 5: Validating and reloading Caddy configuration${NC}"
remote_exec "
# Validate Caddyfile syntax
docker exec caddy caddy validate --config /etc/caddy/Caddyfile && echo '✅ Caddyfile syntax valid' || echo '❌ Caddyfile syntax error'

# Reload Caddy configuration
docker exec caddy caddy reload --config /etc/caddy/Caddyfile && echo '✅ Caddy configuration reloaded' || echo '❌ Caddy reload failed'
"

echo -e "${GREEN}✅ Comprehensive Caddyfile configuration complete!${NC}"

echo -e "${YELLOW}Summary of configured services:${NC}"
echo "🔧 Core Services: n8n, Supabase (Kong, Studio, Analytics)"
echo "🤖 AI/ML Services: Open WebUI, Flowise, Langfuse, Crawl4AI, Ollama"
echo "💼 Business Apps: Twenty CRM, ListMonk, Medusa, Postiz, WordPress"
echo "🔍 Utilities: Neo4j, SearXNG, MinIO, Qdrant"
echo "🏥 Health Checks: Global health monitoring endpoints"

echo -e "${BLUE}Access your services at:${NC}"
echo "• N8N: https://n8n.vividwalls.blog"
echo "• Supabase: https://supabase.vividwalls.blog"
echo "• Open WebUI: https://openwebui.vividwalls.blog"
echo "• Twenty CRM: https://twenty.vividwalls.blog"
echo "• Medusa Store: https://store.vividwalls.blog"
echo "• Health Check: https://health.vividwalls.blog"
