#!/bin/bash

# Phase 1.3: Create Modular Caddy Site Configurations
# This script creates individual Caddy configuration files for each service

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Phase 1.3: Creating Caddy Site Configurations ===${NC}"

# Target directory
SITES_DIR="/root/vivid_mas_build/caddy/sites-enabled"

# Create sites-enabled directory if it doesn't exist
mkdir -p "$SITES_DIR"

# Function to create Caddy site config
create_site_config() {
    local filename=$1
    local content=$2
    local filepath="$SITES_DIR/$filename"
    
    echo "$content" > "$filepath"
    echo -e "${GREEN}✓ Created: $filename${NC}"
}

# n8n configuration
create_site_config "n8n.caddy" '# N8N Workflow Automation
n8n.vividwalls.blog {
    reverse_proxy n8n:5678 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # Websocket support for real-time updates
    @websocket {
        header Connection *Upgrade*
        header Upgrade websocket
    }
    reverse_proxy @websocket n8n:5678
    
    # Increase timeouts for long-running workflows
    timeout 300s
}'

# Open WebUI configuration
create_site_config "openwebui.caddy" '# Open WebUI - ChatGPT Interface
openwebui.vividwalls.blog {
    reverse_proxy open-webui:8080 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # Increase body size for file uploads
    request_body {
        max_size 100MB
    }
}'

# Flowise configuration
create_site_config "flowise.caddy" '# Flowise AI Workflow Builder
flowise.vividwalls.blog {
    reverse_proxy flowise:3001 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Langfuse configuration
create_site_config "langfuse.caddy" '# Langfuse LLM Observability
langfuse.vividwalls.blog {
    reverse_proxy langfuse-web:3000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Ollama configuration
create_site_config "ollama.caddy" '# Ollama Local LLM Server
ollama.vividwalls.blog {
    reverse_proxy ollama:11434 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # Increase timeouts for model loading
    timeout 600s
}'

# Supabase configuration
create_site_config "supabase.caddy" '# Supabase API Gateway
supabase.vividwalls.blog {
    reverse_proxy supabase-kong:8000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Supabase Studio configuration
create_site_config "studio.caddy" '# Supabase Studio Dashboard
studio.vividwalls.blog {
    reverse_proxy supabase-studio:3000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Neo4j configuration
create_site_config "neo4j.caddy" '# Neo4j Knowledge Graph
neo4j.vividwalls.blog {
    reverse_proxy neo4j-knowledge:7474 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Twenty CRM configuration
create_site_config "crm.caddy" '# Twenty CRM
crm.vividwalls.blog {
    reverse_proxy twenty-server-1:3000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# ListMonk configuration
create_site_config "listmonk.caddy" '# ListMonk Email Marketing
listmonk.vividwalls.blog {
    reverse_proxy listmonk:9000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# WordPress configuration
create_site_config "wordpress.caddy" '# WordPress Multisite
wordpress.vividwalls.blog {
    reverse_proxy wordpress-multisite:80 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
        header_up Host {host}
    }
    
    # PHP file handling
    php_fastcgi wordpress-multisite:9000
    
    # Security headers
    header {
        X-Content-Type-Options nosniff
        X-Frame-Options SAMEORIGIN
        X-XSS-Protection "1; mode=block"
    }
}'

# Crawl4AI configuration
create_site_config "crawl4ai.caddy" '# Crawl4AI Web Scraping Service
crawl4ai.vividwalls.blog {
    reverse_proxy localhost:11235 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # API authentication
    basicauth {
        admin {$CRAWL4AI_PASSWORD}
    }
}'

# SearxNG configuration
create_site_config "searxng.caddy" '# SearxNG Privacy Search Engine
searxng.vividwalls.blog {
    reverse_proxy localhost:8080 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Postiz configuration (if deployed)
create_site_config "postiz.caddy" '# Postiz Social Media Management
postiz.vividwalls.blog {
    reverse_proxy postiz:5000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}'

# Medusa configuration (future)
create_site_config "medusa.caddy" '# Medusa E-commerce Platform
medusa.vividwalls.blog {
    reverse_proxy medusa:9000 {
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
    
    # API endpoint
    handle /api/* {
        reverse_proxy medusa:9000
    }
    
    # Admin panel
    handle /admin/* {
        reverse_proxy medusa-admin:7000
    }
}'

# Count created files
SITE_COUNT=$(ls -1 "$SITES_DIR"/*.caddy 2>/dev/null | wc -l)

echo -e "\n${GREEN}=== Phase 1.3 Complete ===${NC}"
echo -e "${BLUE}Created ${SITE_COUNT} Caddy site configurations${NC}"
echo -e "${YELLOW}Location: $SITES_DIR${NC}"

# Create summary
cat > "$SITES_DIR/../caddy_summary.txt" << EOF
Caddy Site Configurations Created:
=================================

Service Endpoints:
- n8n: https://n8n.vividwalls.blog
- Open WebUI: https://openwebui.vividwalls.blog
- Flowise: https://flowise.vividwalls.blog
- Langfuse: https://langfuse.vividwalls.blog
- Ollama: https://ollama.vividwalls.blog
- Supabase: https://supabase.vividwalls.blog
- Studio: https://studio.vividwalls.blog
- Neo4j: https://neo4j.vividwalls.blog
- CRM: https://crm.vividwalls.blog
- ListMonk: https://listmonk.vividwalls.blog
- WordPress: https://wordpress.vividwalls.blog
- Crawl4AI: https://crawl4ai.vividwalls.blog
- SearxNG: https://searxng.vividwalls.blog
- Postiz: https://postiz.vividwalls.blog
- Medusa: https://medusa.vividwalls.blog

Total Sites: ${SITE_COUNT}
EOF

echo -e "${GREEN}✓ Summary saved to caddy_summary.txt${NC}"