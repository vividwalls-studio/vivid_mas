# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

1. Follow existing patterns in `services/mcp-servers/`
2. TypeScript servers use standard Node.js structure
3. Include comprehensive tests
4. Document available tools in README

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

### Prevention Rules:

1. **The ONLY source of truth** is `/root/vivid_mas/.env`
2. **Never hardcode the key** in docker-compose.yml
3. **Always use environment variable substitution**: `- N8N_ENCRYPTION_KEY` (without =)
4. **n8n auto-generates keys** if not properly configured, causing mismatches

### Current Production Key:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs
```

### Verification Commands:
```bash
# Check .env file
grep N8N_ENCRYPTION_KEY /root/vivid_mas/.env

# Check docker container (MUST match above!)
docker exec n8n printenv N8N_ENCRYPTION_KEY
```

### Fix Encryption Issues:
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

### Known Issues:
1. **Multiple backup .env files** contain old keys - ignore them
2. **Never change key** without re-entering all credentials in n8n UI
3. **Webhooks return 404** may indicate workflow is inactive, not key issue

## Critical: Docker Network Configuration

**CRITICAL**: All containers MUST be on the `vivid_mas` network. Network misconfigurations have caused multiple service failures.

### Network Rules:

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

### Network Verification:
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

### Database Connection Rules:

1. **CORRECT HOST**: n8n must use `DB_POSTGRESDB_HOST=postgres` (NOT `db`)
2. **MAIN POSTGRES**: The container named `postgres` (port 5433) contains production workflows
3. **PASSWORD**: Uses `${POSTGRES_PASSWORD}` from .env: `myqP9lSMLobnuIfkUpXQzZg07`
4. **NEVER USE**: Do not use supabase-db, twenty-db, or listmonk-postgres for n8n

### Database Verification:
```bash
# Verify workflows exist in correct database
docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) FROM workflow_entity;'
# Should return: 97

# Check n8n connection
docker exec n8n printenv | grep DB_POSTGRESDB_HOST
# Must show: DB_POSTGRESDB_HOST=postgres
```

### n8n Service Definition:
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

### Docker Compose Rules:

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

### When n8n Cannot Access MCP Servers:

1. **CHECK CONTAINER STATUS**: `docker ps | grep n8n`
2. **VERIFY NETWORK**: Container must be on `vivid_mas` network
3. **CHECK VOLUME MOUNT**: `docker exec n8n ls /opt/mcp-servers`
4. **NEVER CREATE NEW NETWORKS**: Fix existing network issues instead

### When n8n Shows Wrong/No Workflows:

1. **VERIFY DATABASE**: Check which PostgreSQL n8n is connected to
2. **COUNT WORKFLOWS**: `docker exec postgres psql -U postgres -d postgres -c 'SELECT COUNT(*) FROM workflow_entity;'`
3. **CHECK HOST CONFIG**: Must be `DB_POSTGRESDB_HOST=postgres`
4. **RESTART WITH CORRECT CONFIG**: Update docker-compose.yml then restart

### Emergency Recovery:

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

## Critical: What NOT to Do

1. **NEVER run containers with docker run** - Always use docker-compose
2. **NEVER create new networks** - All containers use `vivid_mas`
3. **NEVER remove postgres container** - It contains production workflows
4. **NEVER change encryption key** - Will lose access to credentials
5. **NEVER ignore network errors** - Fix them immediately
6. **NEVER assume default values** - Always verify actual configuration

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
1. Check n8n UI at http://localhost:5678
2. Review Langfuse traces
3. Examine Supabase logs
4. Check individual service logs with `docker logs`