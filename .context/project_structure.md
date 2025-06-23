# VividWalls Multi-Agent System - Project Structure Analysis

## 📁 Comprehensive Directory Tree Overview

### Root Structure (Latest Analysis)
```
vivid_mas/
├── .claude/                          # Claude Code command templates (15 files)
├── .context/                         # Project analysis reports (6 files)
├── .cursor/                          # Cursor IDE configuration (75 rules)
├── archive/                          # Archived backups and temporary files
├── assets/                           # Screenshots and static resources
├── config/                           # Environment and service configurations
├── data/                             # Application data and exports
├── docs/                             # Comprehensive documentation (100+ files)
├── scripts/                          # Deployment and utility scripts (80+ scripts)
├── services/                         # Core application services
├── tasks/                            # Task management files
├── tests/                            # Unit and integration tests
├── theme/                            # UI theme components
└── workflows/                        # Business workflow definitions
```

### 🎯 Key Service Architecture (`services/`)

#### MCP Servers Layer (`services/mcp-servers/`)
```
mcp-servers/
├── analytics/
│   └── vividwalls-kpi-dashboard/     # Business intelligence dashboard
├── core/
│   ├── email-marketing-mcp-server/   # Customer engagement automation (Python)
│   ├── n8n-mcp-server/              # Workflow orchestration (TypeScript)
│   ├── shopify-mcp-server/          # E-commerce operations (TypeScript)
│   └── wordpress-mcp-server/        # Content management (TypeScript)
├── creative/
│   ├── color-psychology-mcp-server/ # AI art analysis (Python)
│   └── pictorem-mcp-server/         # Print-on-demand fulfillment (TypeScript)
├── research/
│   ├── seo-research-mcp/            # Market research tools (TypeScript)
│   └── tavily-mcp/                  # Web research capabilities (TypeScript)
└── social-media/
    ├── facebook-ads-mcp-server/     # Advertising automation (Python)
    └── pinterest-mcp-server/        # Visual marketing platform (Python)
```

#### N8N Workflow Engine (`services/n8n/`)
```
n8n/
├── agents/                          # AI agent definitions (12 specialized agents)
├── backup/                          # Workflow backups (3 versions)
├── config/                          # MCP integration configurations
├── data/shared/                     # Shared data files (CSV, Q&A datasets)
├── scripts/                         # Processing utilities
└── workflows/                       # Business automation workflows (20+ files)
```

### 🚀 Key Infrastructure Services (18 Docker Containers Running)

**Core AI & Automation Stack:**
- **n8n** (localhost:5678) - Workflow automation platform
- **Open WebUI** (localhost:3000) - AI chat interface
- **Flowise** (localhost:3001) - No-code AI agent builder
- **Ollama** (localhost:11434) - Local LLM server
- **Supabase** (localhost:8000) - Database-as-a-service with authentication

**Supporting Services:**
- **PostgreSQL** - Primary database with pgvector for embeddings
- **Qdrant** (localhost:6333) - Vector database
- **SearXNG** (localhost:8080) - Privacy-focused search engine
- **Langfuse** (localhost:3002) - LLM observability platform
- **Caddy** - Reverse proxy with automatic HTTPS
- **MinIO** (localhost:9090) - S3-compatible object storage

### 📊 Business Logic Components

**E-commerce Integration:**
- Shopify store management and order processing
- Pictorem print-on-demand fulfillment with VividWalls pricing logic
- Customer lifecycle management and segmentation

**Marketing Automation:**
- Pinterest visual marketing and rich pins
- Email marketing campaigns and automation sequences
- Facebook/Instagram advertising management
- WordPress content management for Art of Space blog

**AI & Data Processing:**
- 1,860 vector embeddings for artwork recommendations
- 553 product records with comprehensive analysis
- Multi-agent coordination and decision-making systems

### 🔧 New Files Since Last Analysis

**Recent Additions (Notable):**
- `MCP_DEPLOYMENT_FINAL_STATUS.md` - Complete MCP server deployment status
- `VIVIDWALLS_MAS_IMPLEMENTATION_COMPLETE.md` - Full agent system implementation
- `n8n/agents/MCP_TOOLS_USAGE_GUIDE.md` - Comprehensive MCP tool documentation
- `n8n/agents/customer_relationship_agent_mcp.md` - Enhanced CRM agent with MCP tools
- `scripts/deploy-core-mcp-optimized.sh` - Optimized MCP deployment script
- `scripts/test-mcp-droplet-connectivity.sh` - MCP server connectivity testing

**Configuration Updates:**
- `.cursor/mcp.json` - Updated with hybrid architecture (droplet + local)
- Enhanced agent system prompts with detailed MCP tool integration
- Production-ready n8n workflow templates

### 🎯 Business Domain Focus

**VividWalls Art Print Business:**
- Limited edition art collections by curated artists
- Premium canvas print fulfillment through Pictorem
- Customer education on art collecting and investment value
- Multi-channel marketing across Pinterest, email, and social media

**Pricing Logic Implementation:**
- Pro Account Discount: 15% base discount from Pictorem
- Canvas Roll Discount: Additional 25% for canvas roll products
- VividWalls Markup: 106.5% markup on final discounted price

### 📈 Scale and Complexity

**File Count Analysis:**
- **Total Files**: 200+ excluding build artifacts and dependencies
- **MCP Servers**: 6 production-ready servers with 96 total business tools
- **n8n Workflows**: 17 automation workflows for complete business operations
- **Agent Prompts**: 6 comprehensive AI agent system prompts
- **Scripts**: 40+ deployment, testing, and automation scripts
- **Documentation**: 25+ technical and business documentation files

**Development Maturity:**
- Production Docker infrastructure with 18 running containers
- Comprehensive testing suites for critical integrations
- Automated deployment scripts for DigitalOcean droplet
- Multi-environment configuration management
- Professional documentation and README files

This project represents a sophisticated, production-ready AI automation system specifically designed for VividWalls' art print e-commerce business, with comprehensive multi-agent coordination and extensive third-party integrations.