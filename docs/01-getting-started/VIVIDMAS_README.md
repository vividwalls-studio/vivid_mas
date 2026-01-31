# VividWalls Multi-Agent System (MAS)

A sophisticated autonomous e-commerce platform for premium wall art, powered by a hierarchical AI agent architecture orchestrated through n8n workflows.

## 🚀 Recent Updates

### Decision Support Query Resource Server (NEW)

- **Location**: `/services/mcp-servers/agents/decision-support-queries/`
- **Purpose**: Provides predefined queries that traverse relational, graph, and vector databases
- **Integration**: Works with reasoning engine for intelligent decision synthesis
- **Available Queries**: 12 decision support queries across strategic, operational, and risk assessment categories

### Reasoning Engine Integration

- **Location**: `/services/mcp-servers/reasoning-engine/`
- **Features**:
  - Ontology-based logical inferencing via triple extrapolation
  - Multi-method reasoning (deductive, inductive, case-based, strategic, analytical)
  - Connections to vector store (Supabase), knowledge graph (Neo4j), and cache (Redis)
  - Integration layer for all agents at `/src/integration/`

### Agent Knowledge Infrastructure

- **Neo4j Knowledge Graph**: Deployed with full agent hierarchy (18 agents, 10 departments, 46 business entities)
- **Vector Embeddings**: Schema created in Supabase with pgvector extension
- **Memory Pipeline**: Redis → PostgreSQL/Vectors → Neo4j for short-term to long-term memory
- **Domain Knowledge**: Each agent has specialized access patterns and reasoning configurations

## 🏗️ System Architecture

### Agent Hierarchy

1. **Business Manager Agent** (Orchestrator)
   - Central coordinator overseeing all operations
   - Direct reports: 9 Director agents
   - MCP access: Telegram, Email, HTML Reports, Reasoning Engine

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
- **Neo4j** (port 7474): Knowledge graph and agent memory
- **Redis** (port 6379): Short-term memory cache
- **Ollama**: Local LLM platform
- **Open WebUI** (port 3000): ChatGPT-like interface
- **Qdrant** (port 6333): Vector store for RAG
- **Langfuse** (port 3002): LLM observability

### MCP (Model Context Protocol) Servers

Located in `services/mcp-servers/`, organized by function:

- `core/`: Essential services (Shopify, Neo4j, n8n, Stripe, SendGrid, Medusa)
- `analytics/`: KPI dashboards, business scorecards
- `social-media/`: Platform-specific integrations
- `creative/`: Design and content tools
- `sales/`: CRM and sales automation
- `agents/`: Agent-specific resources and prompts
- `reasoning-engine/`: Multi-method reasoning with database integration
- `agents/decision-support-queries/`: Predefined decision support queries

## 🆕 Decision Support Queries

### Available Query Resources

#### Strategic Decision Queries
1. **Market Expansion Analysis** (`decision://vividwalls/market-expansion-analysis`)
2. **Product Launch Feasibility** (`decision://vividwalls/product-launch-feasibility`)
3. **Customer Segment Opportunity** (`decision://vividwalls/customer-segment-opportunity`)

#### Operational Decision Queries
4. **Inventory Optimization** (`decision://vividwalls/inventory-optimization`)
5. **Pricing Strategy** (`decision://vividwalls/pricing-strategy-recommendation`)
6. **Channel Performance** (`decision://vividwalls/channel-performance-decision`)

#### Risk Assessment Queries
7. **Financial Risk Assessment** (`decision://vividwalls/financial-risk-assessment`)
8. **Customer Churn Prevention** (`decision://vividwalls/customer-churn-prevention`)
9. **Competitive Threat Analysis** (`decision://vividwalls/competitive-threat-analysis`)

### Query Response Format
```json
{
  "decision": {
    "recommendation": "Primary recommendation",
    "alternatives": ["Alt 1", "Alt 2"],
    "confidence": 0.85,
    "reasoning": "Explanation"
  },
  "supporting_data": {
    "vector_insights": [...],
    "graph_patterns": [...],
    "historical_data": [...]
  },
  "risks": [...],
  "opportunities": [...],
  "next_steps": [...]
}
```

## 🧠 Reasoning Engine Features

- **Ontology Triple Extrapolation**: Extract and infer relationships from knowledge graph
- **Multi-Method Reasoning**: Apply different reasoning approaches based on context
- **Database Integration**: Seamless access to vector, graph, and relational data
- **Agent-Specific Configuration**: Each agent has tailored reasoning capabilities
- **Explainable AI**: All reasoning steps are traceable and auditable

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Python 3.8+
- Node.js 16+
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/vividwalls-studio/vivid_mas.git
cd vivid_mas

# Copy environment variables
cp .env.example .env
# Edit .env with your credentials

# Start services
python start_services.py --profile cpu  # or gpu-nvidia, gpu-amd
```

### Key Commands

```bash
# Docker Management
docker compose -p localai -f docker-compose.yml --profile <profile> down
docker compose -p localai -f docker-compose.yml --profile <profile> pull
docker compose -p localai -f docker-compose.yml --profile <profile> up -d

# MCP Server Development
cd services/mcp-servers/[server-name]
npm install
npm run build
npm test
```

## 📚 Documentation

Comprehensive documentation available in `/docs/`:

- **Architecture**: `/docs/architecture/`
- **Implementation**: `/docs/implementation/`
- **Business Model**: `/docs/business/`
- **Technical Guides**: `/docs/technical/`
- **Monitoring**: `/docs/monitoring/`

Key documents:
- [Complete Setup Guide](docs/implementation/COMPLETE_SETUP_GUIDE.md)
- [Agent Hierarchy](docs/architecture/MAS_ORGANIZATIONAL_HIERARCHY.md)
- [MCP Servers Documentation](docs/technical/MCP_SERVERS_COMPLETE_DOCUMENTATION_UPDATED.md)
- [Decision Support Queries](services/mcp-servers/agents/decision-support-queries/README.md)
- [Reasoning Engine Integration](docs/AGENT_REASONING_ENGINE_INTEGRATION_COMPLETE.md)

## 🔐 Critical Configuration

### n8n Encryption Key
**CRITICAL**: The encryption key must remain consistent. Current production key:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs
```

### Docker Network
All containers MUST use the `vivid_mas` network. Never create new networks.

### Database Connections
- n8n uses `DB_POSTGRESDB_HOST=postgres` (NOT `db`)
- Supabase services use `supabase-db`
- Neo4j password: `vivid_mas_neo4j_2024_password`

## 🔧 Development

### Adding New Agents
1. Define agent in hierarchy
2. Create system prompt in `/services/n8n/agents/prompts/`
3. Build n8n workflow in `/services/n8n/agents/workflows/`
4. Assign appropriate MCP servers
5. Configure reasoning capabilities

### Creating MCP Servers
1. Use TypeScript template in `/services/mcp-servers/`
2. Implement tool/resource/prompt pattern
3. Add tests and documentation
4. Register with n8n configuration

### Adding Decision Support Queries
1. Define query in `/services/mcp-servers/agents/decision-support-queries/src/resources.ts`
2. Implement query logic in `/src/queries/`
3. Test multi-database traversal
4. Document usage examples

## 🌐 Access Points

Production services (when deployed):
- n8n: `https://n8n.vividwalls.blog`
- Open WebUI: `https://openwebui.vividwalls.blog`
- Neo4j Browser: `https://neo4j.vividwalls.blog`
- Supabase Studio: `https://studio.vividwalls.blog`

Local development:
- n8n: `http://localhost:5678`
- Open WebUI: `http://localhost:3000`
- Neo4j: `http://localhost:7474`
- Supabase: `http://localhost:8000`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is proprietary software owned by VividWalls Studio.

## 🆘 Support

- Technical issues: See `/docs/technical/`
- Architecture questions: See `/docs/architecture/`
- Implementation help: See `/docs/implementation/`

## 🔗 SSH Access

For deployment to DigitalOcean droplet:
```bash
ssh -i ~/.ssh/digitalocean root@157.230.13.13
# Passphrase: freedom
```

---

**VividWalls Multi-Agent System** - Autonomous AI-powered e-commerce at scale.