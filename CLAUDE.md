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