# All Containers Status Report

**Date**: July 11, 2025  
**Total Containers**: 37+ running

## ✅ Successfully Running Services

### Core Infrastructure (All Operational)
- **Caddy**: Reverse proxy (restarted with full config)
- **PostgreSQL Main**: n8n database (healthy)
- **Redis**: Main cache (healthy)
- **Qdrant**: Vector database

### Workflow & Automation (All Operational)
- **n8n**: Workflow engine (healthy)
- **n8n-import**: Import service (starting)

### CRM & Business Apps (All Operational)
- **Twenty CRM**: Server, database, redis (all healthy)
- **ListMonk**: Email marketing + database
- **WordPress**: Multisite + MySQL database

### AI/ML Services (All Operational)
- **Open WebUI**: Interface (healthy - but 502 error needs investigation)
- **Flowise**: AI workflows (200 OK)
- **Ollama**: Local LLM (200 OK)
- **Crawl4AI**: Web scraping (healthy, 307 redirect)
- **Langfuse**: LLM observability (200 OK)

### E-commerce (In Progress)
- **Medusa**: Backend (starting up)
- **Medusa Storefront**: Frontend (running in dev mode)

### Supabase Stack (Mostly Operational)
- **Kong**: API Gateway (healthy)
- **Database**: PostgreSQL (healthy)
- **Auth**: Authentication (restarting - needs investigation)
- **Storage**: File storage (restarting - needs investigation)
- **Realtime**: WebSocket service (starting)
- **REST**: PostgREST API
- **Studio**: Admin interface (healthy)
- **Meta**: Database metadata (healthy)
- **Edge Functions**: Serverless functions
- **Pooler**: Connection pooling (starting)
- **Analytics**: Log analytics
- **ImgProxy**: Image optimization (healthy)
- **Vector**: Log collection (healthy)

### Other Services
- **Neo4j**: Knowledge graph (200 OK)
- **SearXNG**: Search engine (502 - needs investigation)
- **ClickHouse**: Analytics database (unhealthy - needs investigation)
- **MinIO**: Object storage

## 🔄 Services Needing Attention

1. **Supabase Auth & Storage**: Restarting loop - may need configuration check
2. **Open WebUI**: Running but returning 502
3. **SearXNG**: Restarting with exit code 127
4. **ClickHouse**: Marked as unhealthy
5. **Medusa**: Still starting up

## 📊 Service Access URLs

All services accessible via HTTPS:
- n8n: https://n8n.vividwalls.blog ✅
- Twenty CRM: https://twenty.vividwalls.blog ✅
- ListMonk: https://listmonk.vividwalls.blog ✅
- Flowise: https://flowise.vividwalls.blog ✅
- Langfuse: https://langfuse.vividwalls.blog ✅
- Neo4j: https://neo4j.vividwalls.blog ✅
- Ollama: https://ollama.vividwalls.blog ✅
- WordPress: https://wordpress.vividwalls.blog (500 error)
- Studio: https://studio.vividwalls.blog ✅

## 🎯 Next Steps

1. Investigate and fix services in restart loops
2. Check Open WebUI configuration
3. Wait for Medusa to complete startup
4. Verify Postiz deployment (still downloading)
5. Configure WordPress initial setup

## 📈 Resource Usage

- **Disk**: 139GB/155GB (90% - previously 99%)
- **Containers**: 37+ running
- **Networks**: All on `vivid_mas` network
- **Ports**: All critical ports allocated