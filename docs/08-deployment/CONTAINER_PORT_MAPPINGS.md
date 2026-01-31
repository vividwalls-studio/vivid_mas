# Container Port Mappings

**Date:** January 5, 2025  
**Environment:** Production (DigitalOcean Droplet)

## Port Assignment Summary

### Web Services (Public Access via Caddy)

| Service | Container Name | Internal Port | External Port | Caddy URL |
|---------|---------------|---------------|---------------|-----------|
| Caddy (Reverse Proxy) | caddy | 80, 443 | 80, 443 | - |
| n8n | n8n | 5678 | 5678 | n8n.vividwalls.blog |
| Open WebUI | open-webui | 8080 | 3000 | openwebui.vividwalls.blog |
| Flowise | flowise | 3001 | 3001 | flowise.vividwalls.blog |
| Twenty CRM | twenty-server-1 | 3000 | 3010 | twenty.vividwalls.blog |
| Postiz | postiz | 5000 | 5000 | postiz.vividwalls.blog |
| WordPress | wordpress-multisite | 80 | 8080 | wordpress.vividwalls.blog |
| Neo4j Browser | neo4j-knowledge | 7474 | 7474 | neo4j.vividwalls.blog |
| SearXNG | searxng | 8080 | 8085 | searxng.vividwalls.blog |
| ListMonk | listmonk | 9000 | 9003 (localhost only) | listmonk.vividwalls.blog |
| Crawl4AI | crawl4ai | 11235 | 11235 | crawl4ai.vividwalls.blog |

### Database Services

| Service | Container Name | Internal Port | External Port | Access |
|---------|---------------|---------------|---------------|--------|
| Main PostgreSQL | postgres | 5432 | 5433 | External |
| Supabase PostgreSQL | supabase-db | 5432 | - | Internal only |
| Supabase Pooler | supabase-pooler | 5432, 6543 | 5432, 6543 | External |
| Twenty PostgreSQL | twenty-db-1 | 5432 | - | Internal only |
| Postiz PostgreSQL | postiz-postgres | 5432 | - | Internal only |
| ListMonk PostgreSQL | listmonk-postgres | 5432 | - | Internal only |
| WordPress MySQL | wordpress-mysql | 3306 | 3307 | External |

### Supabase Stack

| Service | Container Name | Internal Port | External Port | Access |
|---------|---------------|---------------|---------------|--------|
| Kong API Gateway | supabase-kong | 8000, 8443 | 8000, 8443 | External |
| Studio | supabase-studio | 3000 | - | Via Kong |
| Auth | supabase-auth | - | - | Via Kong |
| Storage | supabase-storage | 5000 | - | Via Kong |
| REST API | supabase-rest | 3000 | - | Via Kong |
| Realtime | realtime-dev.supabase-realtime | - | - | Via Kong |
| Analytics | supabase-analytics | 4000 | 4000 | External |
| Meta | supabase-meta | 8080 | - | Internal |
| ImgProxy | supabase-imgproxy | 8080 | - | Internal |
| Vector | supabase-vector | - | - | Internal |

### Other Services

| Service | Container Name | Internal Port | External Port | Access |
|---------|---------------|---------------|---------------|--------|
| Redis (main) | redis | 6379 | - | Internal |
| WordPress Redis | wordpress-redis | 6379 | 6380 | External |
| Qdrant Vector DB | qdrant | 6333, 6334 | 6333 | External |
| Neo4j Bolt | neo4j-knowledge | 7687 | 7687 | External |
| ClickHouse | vivid_mas-clickhouse-1 | 8123, 9000 | 8123, 9000 | Localhost only |
| MinIO | vivid_mas-minio-1 | 9000, 9001 | 9090, 9091 | Mixed |

## Port Conflicts Found

✅ **No port conflicts detected!** Each container has unique external port assignments.

## Caddy Configuration Issues

### 1. Postiz Misconfiguration
- **Current Caddy config:** `reverse_proxy postiz-mcp-server:8080`
- **Should be:** `reverse_proxy postiz:5000`
- **Status:** Returns 502 Bad Gateway

### 2. ListMonk Limited Access
- **Port:** Only exposed on localhost (127.0.0.1:9003)
- **Issue:** Not accessible externally, might cause Caddy issues
- **Solution:** Either expose on all interfaces or ensure Caddy can reach localhost

## Port Usage Summary

### Used External Ports
- **80, 443**: Caddy (HTTP/HTTPS)
- **3000**: Open WebUI
- **3001**: Flowise
- **3010**: Twenty CRM
- **3307**: WordPress MySQL
- **4000**: Supabase Analytics
- **5000**: Postiz
- **5432**: Supabase Pooler
- **5433**: Main PostgreSQL
- **5678**: n8n
- **6333**: Qdrant
- **6380**: WordPress Redis
- **6543**: Supabase Pooler (alternative)
- **7474**: Neo4j Browser
- **7687**: Neo4j Bolt
- **8000**: Supabase Kong
- **8080**: WordPress
- **8085**: SearXNG
- **8123**: ClickHouse (localhost)
- **8443**: Supabase Kong (HTTPS)
- **9000**: ClickHouse (localhost)
- **9003**: ListMonk (localhost)
- **9090**: MinIO
- **9091**: MinIO Console (localhost)
- **11235**: Crawl4AI

## Recommendations

1. **Fix Postiz Caddy configuration** to use correct container name and port
2. **Review ListMonk exposure** - currently only on localhost which may cause issues
3. **Document internal service communication** - many services communicate internally without exposed ports
4. **Monitor port usage** - system is using many ports, ensure firewall rules are appropriate

## Security Notes

- Several services are bound to localhost only (127.0.0.1), which is good for security
- All public services go through Caddy with HTTPS
- Database services mostly use internal networking except where external access is required