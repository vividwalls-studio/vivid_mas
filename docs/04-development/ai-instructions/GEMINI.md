# GEMINI.md

This file provides guidance to Gemini CLI (claude.ai/code) when working with code in this repository.

## Project Overview

VividWalls Multi-Agent System (MAS) is a sophisticated autonomous e-commerce platform for premium wall art. It uses a hierarchical AI agent architecture orchestrated through n8n workflows, with agents specialized for different business functions.

## Key Commands

### Starting Services

```bash
# For Nvidia GPU users
python start_services.py --profile gpu-nvidia

# For AMD GPU users on Linux
python start_services.py --profile gpu-amd

# For Mac/CPU users
python start_services.py --profile cpu

# For Mac users running Ollama locally
python start_services.py --profile none
```

### Docker Management

```bash
# Stop all services
docker compose -p localai -f docker-compose.yml --profile <your-profile> down

# Pull latest versions
docker compose -p localai -f docker-compose.yml --profile <your-profile> pull
```

### MCP Server Development

For TypeScript MCP servers (e.g., in `services/mcp-servers/core/shopify-mcp-server`):
```bash
npm install        # Install dependencies
npm run build      # Build TypeScript
npm run test       # Run tests
npm run lint       # Run ESLint
npm run typecheck  # Type checking
npm run dev        # Development mode
```

### Testing

- Individual MCP servers have their own test suites: `npm test`
- For watch mode: `npm run test:watch`
- For coverage: `npm run test:coverage`

## High-Level Architecture

### Agent Hierarchy

1. **Business Manager Agent** (Orchestrator)
   - Central coordinator overseeing all operations
   - Direct reports: 9 Director agents
   - MCP access: Telegram, Email, HTML Reports

2. **Director Level** (9 Directors)
   - Marketing Director (13 agents)
   - Sales Director (12 agents)
   - Operations Director (6 agents)
   - Customer Experience Director (6 agents)
   - Product Director (4 agents)
   - Finance Director (3 agents)
   - Analytics Director (4 agents)
   - Technology Director (3 agents)
   - Social Media Director (reports to Marketing)

3. **Specialized Agents** (~48 total)
   - Platform agents (Facebook, Instagram, Pinterest, Shopify, etc.)
   - Task agents (data extraction, analytics, calculations)
   - Sales agents (segment-specific: Hospitality, Corporate, Healthcare, etc.)

### Core Services

- **n8n** (port 5678): Workflow automation and agent orchestration
- **Supabase**: PostgreSQL database with vector capabilities
- **Ollama**: Local LLM platform
- **Open WebUI** (port 3000): ChatGPT-like interface
- **Qdrant** (port 6333): Vector store for RAG
- **Langfuse** (port 3002): LLM observability
- **Neo4j**: Knowledge graph and agent memory

### MCP (Model Context Protocol) Servers

Located in `services/mcp-servers/`, organized by function:
- `core/`: Essential services (Shopify, Neo4j, n8n, Stripe, SendGrid)
- `analytics/`: KPI dashboards, business scorecards
- `social-media/`: Platform-specific integrations
- `creative/`: Design and content tools
- `sales/`: CRM and sales automation

### Agent Workflows

N8N workflows in `services/n8n/agents/workflows/`:
- `core/`: Director-level agent workflows
- `subagents/`: Specialized agent workflows
- Prompts in `services/n8n/agents/prompts/`

## Development Guidelines

### Working with Agents

1. Each agent has:
   - System prompt defining its role and capabilities
   - Specific MCP server access based on responsibilities
   - Defined communication patterns with other agents

2. Agent modifications require updating:
   - Workflow JSON in n8n
   - System prompt in prompts directory
   - MCP server assignments if needed

### MCP Server Development

The project uses three types of MCP servers based on the Model Context Protocol standard:

#### 1. Tool-based MCP Servers

Located in `services/mcp-servers/core/` - provide executable functions for specific services.

**Structure Pattern:**

```typescript
// package.json
{
  "name": "service-mcp-server",
  "type": "module",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.4.1",
    "zod": "^3.24.1"  // For schema validation
  }
}

// src/index.ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "service-name-tools",
  version: "1.0.0"
});

// Define tools with schemas
server.tool(
  "tool-name",
  "Tool description",
  {
    param1: z.string().describe("Parameter description"),
    param2: z.number().optional().describe("Optional parameter")
  },
  async ({ param1, param2 }) => {
    // Tool implementation
    return {
      content: [{ type: "text", text: JSON.stringify(result) }]
    };
  }
);
```

**Examples:** shopify-mcp-server, stripe-mcp-server, supabase-mcp-server

#### 2. Prompt-based MCP Servers

Located in `services/mcp-servers/agents/` - provide reusable prompt templates.

**Structure Pattern:**

```typescript
// src/prompts.ts
import { PromptDefinition } from '@modelcontextprotocol/sdk'

export const promptName: PromptDefinition = {
  name: 'prompt-identifier',
  description: 'What this prompt does',
  template: `
    Prompt template with {{variable}} placeholders
    Can include tool invocations:
    <invoke name="tool-name">
      {"param": "{{value}}"}
    </invoke>
  `
}

// src/index.ts
import { createServer } from "@modelcontextprotocol/sdk"
import * as prompts from "./prompts"

createServer({ 
  prompts: Object.values(prompts), 
  port: +PORT 
})
```

**Examples:** marketing-director-prompts, business-manager-prompts

#### 3. Resource-based MCP Servers

Located in `services/mcp-servers/agents/` - provide read-only data access.

**Structure Pattern:**

```typescript
// src/resource.ts
import { ResourceDefinition } from '@modelcontextprotocol/sdk'

export const resourceName: ResourceDefinition = {
  name: 'resource-identifier',
  description: 'What data this resource provides',
  async read(context) {
    // Fetch data (e.g., from Supabase)
    const data = await fetchData(context.parameters);
    return {
      mimeType: 'application/json',
      content: JSON.stringify(data)
    };
  }
}

// src/index.ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { createServer } from "./server.js";

const server = createServer(); // Creates server with resources
```

**Examples:** marketing-director-resource, business-manager-resource

#### Common Patterns

1. **TypeScript Configuration:**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./build" or "./dist",
    "rootDir": "./src",
    "strict": true
  }
}
```

1. **Testing:** Use Jest with TypeScript support
2. **Transport:** Default to StdioServerTransport for n8n integration
3. **Error Handling:** Return structured error responses
4. **Environment Variables:** Load with dotenv for configuration

### Database Schema

The MAS uses PostgreSQL (via Supabase) with tables for:

- Agents configuration
- Agent knowledge/memory
- Communication logs
- Business data

Access via PostgREST API or direct connection.

## SSH Access

For deployment to DigitalOcean droplet:

```bash
ssh -i ~/.ssh/digitalocean root@157.230.13.13
# Passphrase: freedom
```

GitHub SSH key:

```bash
# SSH key location: ~/.ssh/vividwalls_github
# Passphrase: freedom
# Add to SSH agent: ssh-add ~/.ssh/vividwalls_github
```

## Critical: n8n Encryption Key Management

**CRITICAL**: n8n encryption key issues have occurred 12+ times. The root cause is n8n auto-generating keys when environment variable is not properly set.

### Prevention Rules

1. **The ONLY source of truth** is `/root/vivid_mas/.env`
2. **Never hardcode the key** in docker-compose.yml
3. **Always use environment variable substitution**: `- N8N_ENCRYPTION_KEY` (without =)
4. **n8n auto-generates keys** if not properly configured, causing mismatches

### Current Production Key

```text
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs
```

### Verification Commands

```bash
# Check .env file
grep N8N_ENCRYPTION_KEY /root/vivid_mas/.env

# Check docker container (MUST match above!)
docker exec n8n printenv N8N_ENCRYPTION_KEY
```

### Fix Encryption Issues

```bash
# Stop n8n
docker stop n8n

# Remove auto-generated config
docker run --rm -v vivid_mas_n8n_storage:/data alpine rm -rf /data/.n8n/config

# Update .env with correct key
sed -i 's|^N8N_ENCRYPTION_KEY=.*|N8N_ENCRYPTION_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs|' /root/vivid_mas/.env

# Restart n8n
docker compose up -d n8n
```

### Known Issues

1. **Multiple backup .env files** contain old keys - ignore them
2. **Never change key** without re-entering all credentials in n8n UI
3. **Webhooks return 404** may indicate workflow is inactive, not key issue

## Critical: Docker Network Configuration

**CRITICAL**: All containers MUST be on the `vivid_mas` network. Network misconfigurations have caused multiple service failures.

### Network Rules

1. **ONLY ONE NETWORK**: All containers must use `vivid_mas` network
2. **NO DEFAULT NETWORKS**: Never use `bridge`, `default`, or create new networks
3. **CHECK BEFORE CHANGES**: Always verify network status before modifying containers
4. **NETWORK DEFINITION**: docker-compose.yml MUST include:
   ```yaml
   networks:
     default:
       name: vivid_mas
       external: true
   ```

### Network Verification

```bash
# Check container networks
docker ps -a --format 'table {{.Names}}\t{{.Networks}}'

# Move container to correct network
docker network connect vivid_mas <container_name>
docker network disconnect <wrong_network> <container_name>

# Remove unused networks (ONLY after moving all containers)
docker network rm <unused_network>
```

## Critical: n8n Database Configuration

**CRITICAL**: n8n MUST connect to the main PostgreSQL container named `postgres` which contains 97 workflows.

### Database Connection Rules

1. **CORRECT HOST**: n8n must use `DB_POSTGRESDB_HOST=postgres` (NOT `db`)
2. **MAIN POSTGRES**: The container named `postgres` (port 5433) contains production workflows
3. **PASSWORD**: Uses `${POSTGRES_PASSWORD}` from .env: `myqP9lSMLobnuIfkUpXQzZg07`
4. **NEVER USE**: Do not use supabase-db, twenty-db, or listmonk-postgres for n8n

### Database Verification

```bash
# Verify workflows exist in correct database
docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) FROM workflow_entity;'
# Should return: 97

# Check n8n connection
docker exec n8n printenv | grep DB_POSTGRESDB_HOST
# Must show: DB_POSTGRESDB_HOST=postgres
```

### n8n Service Definition

```yaml
x-n8n: &service-n8n
  image: n8nio/n8n:latest
  environment:
    - DB_TYPE=postgresdb
    - DB_POSTGRESDB_HOST=postgres  # CRITICAL: Must be 'postgres' not 'db'
    - DB_POSTGRESDB_USER=postgres
    - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
    - DB_POSTGRESDB_DATABASE=postgres
    - N8N_ENCRYPTION_KEY
```

## Critical: Docker Compose Configuration

**CRITICAL**: A working backup exists at `docker-compose.yml.working.backup`. Key requirements:

### Docker Compose Rules

1. **NO INCLUDES**: Remove any `include:` statements for non-existent files
2. **VOLUME MOUNTS**: n8n MUST have MCP servers mounted:
   ```yaml
   volumes:
     - n8n_storage:/home/node/.n8n
     - /opt/mcp-servers:/opt/mcp-servers:ro
     - ./n8n/backup:/backup
     - ./shared:/data/shared
   ```
3. **PROJECT NAME**: Use default project name (directory name) or specify explicitly
4. **STARTUP ORDER**: n8n depends on n8n-import completion (but skip if import fails)

## Critical: Service Recovery Procedures

### When n8n Cannot Access MCP Servers

1. **CHECK CONTAINER STATUS**: `docker ps | grep n8n`
2. **VERIFY NETWORK**: Container must be on `vivid_mas` network
3. **CHECK VOLUME MOUNT**: `docker exec n8n ls /opt/mcp-servers`
4. **NEVER CREATE NEW NETWORKS**: Fix existing network issues instead

### When n8n Shows Wrong/No Workflows

1. **VERIFY DATABASE**: Check which PostgreSQL n8n is connected to
2. **COUNT WORKFLOWS**: `docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) FROM workflow_entity;'`
3. **CHECK HOST CONFIG**: Must be `DB_POSTGRESDB_HOST=postgres`
4. **RESTART WITH CORRECT CONFIG**: Update docker-compose.yml then restart

### Emergency Recovery

```bash
# If services were stopped incorrectly
cd /root/vivid_mas
docker-compose up -d  # This will restart all services

# If n8n is on wrong network
docker rm n8n
docker-compose up -d n8n --no-deps

# If database connection is wrong
sed -i 's/DB_POSTGRESDB_HOST=db/DB_POSTGRESDB_HOST=postgres/' docker-compose.yml
docker-compose up -d n8n --no-deps
```

## Critical: Caddy Configuration Management

**CRITICAL**: The Caddyfile manages SSL certificates and reverse proxy for ALL services. Configuration removal has occurred multiple times.

### Caddy Configuration Rules

1. **NEVER REMOVE EXISTING CONFIGURATIONS**: When adding new services, APPEND to Caddyfile, don't replace
2. **ALWAYS BACKUP FIRST**: Before any Caddyfile change: `cp Caddyfile Caddyfile.$(date +%Y%m%d_%H%M%S).backup`
3. **PRESERVE ALL SERVICES**: The complete list of required Caddy entries:
   ```
   - n8n.vividwalls.blog → localhost:5678
   - openwebui.vividwalls.blog → localhost:3000
   - flowise.vividwalls.blog → localhost:3001
   - langfuse.vividwalls.blog → localhost:3002
   - ollama.vividwalls.blog → localhost:11434
   - supabase.vividwalls.blog → localhost:8000
   - crm.vividwalls.blog → twenty-server-1:3000
   - listmonk.vividwalls.blog → listmonk:9000
   - studio.vividwalls.blog → supabase-studio:3000
   - neo4j.vividwalls.blog → neo4j-knowledge:7474
   - wordpress.vividwalls.blog → wordpress-multisite:80
   - crawl4ai.vividwalls.blog → localhost:11235
   - searxng.vividwalls.blog → localhost:8080
   ```
4. **NO ENVIRONMENT VARIABLES**: Use hardcoded domain names, not `{$VARIABLE}` syntax
5. **VERIFY BEFORE RELOAD**: Always check syntax before reloading: `docker exec caddy caddy validate --config /etc/caddy/Caddyfile`

### Adding New Service to Caddy

```bash
# 1. Backup current config
cp Caddyfile Caddyfile.backup

# 2. Add new service at END of file
echo "" >> Caddyfile
echo "# New Service Name" >> Caddyfile
echo "newservice.vividwalls.blog {" >> Caddyfile
echo "    reverse_proxy container-name:port" >> Caddyfile
echo "}" >> Caddyfile

# 3. Validate and reload
docker exec caddy caddy validate --config /etc/caddy/Caddyfile
docker-compose restart caddy
```

### Caddy Recovery Procedure

```bash
# If Caddy configuration is lost or corrupted:
cd /root/vivid_mas

# Find most recent complete backup
ls -la Caddyfile.* | grep -E "(complete|full|backup)"

# Restore from backup
cp Caddyfile.complete Caddyfile  # or appropriate backup

# Restart Caddy
docker-compose restart caddy

# Verify all services
docker logs caddy --tail 50
```

## Critical: What NOT to Do

1. **NEVER run containers with docker run** - Always use docker-compose
2. **NEVER create new networks** - All containers use `vivid_mas`
3. **NEVER remove postgres container** - It contains production workflows
4. **NEVER change encryption key** - Will lose access to credentials
5. **NEVER ignore network errors** - Fix them immediately
6. **NEVER assume default values** - Always verify actual configuration
7. **NEVER replace Caddyfile without preserving existing entries** - Always append new services
8. **NEVER use environment variables in Caddyfile** - Use hardcoded domain names

## Important Patterns

1. **Orchestrator-Workers**: Directors delegate to specialized agents
2. **Clean Boundaries**: Each agent owns its domain
3. **MCP Assignment**: Based on functional responsibility
4. **Bi-directional Communication**: Clear delegation and reporting

## Environment Variables

Key variables to configure:
- Database credentials (Supabase)
- API keys for external services
- MCP server configurations
- LLM provider settings

See `.env.example` for complete list.

## Testing Strategy

1. Unit tests for individual MCP servers
2. Integration tests for agent workflows
3. End-to-end tests for complete processes
4. Use Langfuse for LLM monitoring

## Common Tasks

### Adding a New Agent

1. Define agent in hierarchy
2. Create system prompt
3. Build n8n workflow
4. Assign appropriate MCP servers
5. Test integration with existing agents

### Updating MCP Servers

1. Make changes in appropriate directory
2. Run tests locally
3. Build and verify
4. Update n8n configuration if needed

### Debugging Workflows

1. Check n8n UI at <http://localhost:5678>
2. Review Langfuse traces
3. Examine Supabase logs
4. Check individual service logs with `docker logs`

## Docker Compose File Locations

### Main Orchestration
- **Primary**: `/root/vivid_mas/docker-compose.yml`
  - Includes: `./supabase/docker/docker-compose.yml`
  - Manages: Most core services (n8n, ollama, qdrant, open-webui, flowise, redis, neo4j, wordpress-mysql, clickhouse, minio)

### Service-Specific Compose Files

#### Supabase
- **Active**: `/home/vivid/vivid_mas/supabase/docker/docker-compose.yml`
- **Symlinked to**: `/root/vivid_mas/supabase/docker/docker-compose.yml`
- **Manages**: All Supabase services (auth, db, storage, realtime, rest, meta, studio, kong, analytics, vector, imgproxy, edge-functions, pooler)
- **Network**: vivid_mas (must be added to compose file)
- **CRITICAL**: Supabase services must use `supabase-db` as database host, not `db`

#### N8N
- **Config**: `/root/vivid_mas/services/n8n/docker/docker-compose.yml`
- **Note**: Currently managed by main docker-compose.yml

#### Caddy (Reverse Proxy)
- **Active**: `/root/vivid_mas/services/caddy/docker/docker-compose.yml`
- **Manages**: caddy container
- **Config**: `/root/vivid_mas/Caddyfile`

#### Twenty CRM
- **Active**: `/opt/twenty/packages/twenty-docker/docker-compose.yml`
- **Manages**: twenty-server-1, twenty-worker-1, twenty-db-1, twenty-redis-1

#### Postiz (Social Media)
- **Active**: `/opt/postiz/docker-compose.yml`
- **Manages**: postiz, postiz-postgres, postiz-redis

### Standalone Containers
- **postgres**: Main PostgreSQL for n8n (port 5433) - contains 102+ workflows
- **crawl4ai**: Web scraping service
- **searxng**: Search engine

### Service Compose Files (Available but not active)
Located in `/root/vivid_mas/services/*/docker/`:
- langfuse/docker/docker-compose.yml
- listmonk/docker/docker-compose.yml
- ollama/docker/docker-compose.yml
- wordpress/docker/docker-compose.yml

### Critical Notes
1. **All containers MUST use `vivid_mas` network**
2. **Supabase is in `/home/vivid/vivid_mas/supabase/docker/` NOT `/root/vivid_mas/`**
3. **Main compose uses `include:` for Supabase integration**
4. **Database host mappings**:
   - n8n → `postgres` (NOT `db`)
   - Supabase → `supabase-db` (NOT `db`)
   - Twenty → `twenty-db-1`
   - Postiz → `postiz-postgres`
