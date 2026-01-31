#!/bin/bash

echo "=== Migrating to Modular Configuration ==="

# Create directories
mkdir -p caddy/sites-enabled

# Extract services from current Caddyfile to individual files
echo "Extracting services from Caddyfile..."

# Create individual caddy files for each service
cat > caddy/sites-enabled/openwebui.caddy << 'EOF'
# Open WebUI
{$WEBUI_HOSTNAME} {
    reverse_proxy open-webui:8080
}
EOF

cat > caddy/sites-enabled/flowise.caddy << 'EOF'
# Flowise
{$FLOWISE_HOSTNAME} {
    reverse_proxy flowise:3001
}
EOF

cat > caddy/sites-enabled/langfuse.caddy << 'EOF'
# Langfuse
{$LANGFUSE_HOSTNAME} {
    reverse_proxy langfuse-web:3000
}
EOF

cat > caddy/sites-enabled/ollama.caddy << 'EOF'
# Ollama API
{$OLLAMA_HOSTNAME} {
    reverse_proxy ollama:11434
}
EOF

cat > caddy/sites-enabled/crawl4ai.caddy << 'EOF'
# Crawl4AI
{$CRAWL4AI_HOSTNAME} {
    reverse_proxy crawl4ai:11235
}
EOF

cat > caddy/sites-enabled/searxng.caddy << 'EOF'
# SearXNG
{$SEARXNG_HOSTNAME} {
    encode zstd gzip
    
    @api {
        path /config
        path /healthz
        path /stats/errors
        path /stats/checker
    }
    @search {
        path /search
    }
    @imageproxy {
        path /image_proxy
    }
    @static {
        path /static/*
    }
    
    header {
        Content-Security-Policy "upgrade-insecure-requests; default-src 'none'; script-src 'self'; style-src 'self' 'unsafe-inline'; form-action 'self' https://github.com/searxng/searxng/issues/new; font-src 'self'; frame-ancestors 'self'; base-uri 'self'; connect-src 'self' https://overpass-api.de; img-src * data:; frame-src https://www.youtube-nocookie.com https://player.vimeo.com https://www.dailymotion.com https://www.deezer.com https://www.mixcloud.com https://w.soundcloud.com https://embed.spotify.com;"
        Permissions-Policy "accelerometer=(),camera=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),payment=(),usb=()"
        Referrer-Policy "no-referrer"
        Strict-Transport-Security "max-age=31536000"
        X-Content-Type-Options "nosniff"
        X-Robots-Tag "noindex, noarchive, nofollow"
        -Server
    }
    
    header @api {
        Access-Control-Allow-Methods "GET, OPTIONS"
        Access-Control-Allow-Origin "*"
    }
    
    route {
        header Cache-Control "max-age=0, no-store"
        header @search Cache-Control "max-age=5, private"
        header @imageproxy Cache-Control "max-age=604800, public"
        header @static Cache-Control "max-age=31536000, public, immutable"
    }
    
    reverse_proxy searxng:8080 {
        header_up X-Forwarded-Port {http.request.port}
        header_up X-Real-IP {http.request.remote.host}
        header_up Connection "close"
    }
}
EOF

cat > caddy/sites-enabled/listmonk.caddy << 'EOF'
# ListMonk
{$LISTMONK_HOSTNAME} {
    reverse_proxy listmonk:9000
}
EOF

cat > caddy/sites-enabled/neo4j.caddy << 'EOF'
# Neo4j
{$NEO4J_HOSTNAME} {
    reverse_proxy neo4j-knowledge:7474
}
EOF

cat > caddy/sites-enabled/postiz.caddy << 'EOF'
# Postiz
{$POSTIZ_HOSTNAME} {
    reverse_proxy postiz-mcp-server:8080
}
EOF

cat > caddy/sites-enabled/twenty.caddy << 'EOF'
# Twenty CRM
{$TWENTY_HOSTNAME} {
    reverse_proxy twenty-server-1:3000
}
EOF

echo "✅ Created individual Caddy files in caddy/sites-enabled/"
echo ""
echo "Next steps:"
echo "1. Update docker-compose.yml to use Caddyfile.main:"
echo "   volumes:"
echo "     - ./Caddyfile.main:/etc/caddy/Caddyfile:ro"
echo "     - ./caddy:/etc/caddy/caddy:ro"
echo ""
echo "2. To add a new service, create a new file in caddy/sites-enabled/"
echo "3. Reload Caddy: docker exec caddy caddy reload"