# Workflow Batch Prompt

Orchestrate the creation and validation of 22 specialized n8n AI agent workflows for the VividWalls Multi-Agent System. This is a critical validation checkpoint that will determine the system's operational integrity.

## Primary Objective

Deploy 8 specialized sub-agents to systematically create, validate, and activate 22 n8n AI agent workflows following the established VividWalls MAS architecture patterns.

## Pre-Execution Requirements

1. **SSH Access**: Establish secure connection to the production droplet
2. **Current State Audit**: Conduct comprehensive audit of existing n8n workflows in the VividWalls MAS instance
3. **Architecture Compliance**: Ensure all workflows follow the hierarchical director-agent pattern documented in the MAS organizational structure

## Agent Workflow Creation Specifications
Use these agents as reference of creating agent and regular workflows.
 - /Volumes/SeagatePortableDrive/Projects/vivid_mas/Data Analytics Agent.json
 - /Volumes/SeagatePortableDrive/Projects/vivid_mas/Image Retrieval and Selection.json

### Target Workflows (22 Total)

**Marketing Department (5 workflows):**

### Campaign Manager Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/campaign_manager_agent_system_prompt.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/campaign_coordination_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/campaign_manager_agent.json
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/campaign_coordination_agent.json
    **MCP Tools**
    [ Come up with a list of all MCP tools available to the Campaign Manager Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Copy Writer Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/copy_writer_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/copy_writer_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Copy Writer Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Content Strategy Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/content_strategy_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/content_strategy_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Content Strategy Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Copy Editor Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/copy_editor_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/copy_editor_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Copy Editor Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Email Marketing Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/email_marketing_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/email_marketing_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Email Marketing Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Newsletter Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/newsletter_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/newsletter_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Newsletter Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

**Sales Department (5 workflows):**

### Hospitality Sales Agent
    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/hospitality_sales_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/hospitality_sales_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Hospitality Sales Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Corporate Sales Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/corporate_sales_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/corporate_sales_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Corporate Sales Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Healthcare Sales Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/healthcare_sales_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/healthcare_sales_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Healthcare Sales Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Residential Sales Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/residential_sales_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/residential_sales_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Residential Sales Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Educational Sales Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/educational_sales_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/educational_sales_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Educational Sales Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

**Social Media Department (5 workflows):**

### Pinterest Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/pinterest_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/pinterest_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Pinterest Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Twitter Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/twitter_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/twitter_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Twitter Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### LinkedIn Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/linkedin_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/linkedin_agent.json
    **MCP Tools**
    [ List all MCP tools available to the LinkedIn Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### TikTok Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/tiktok_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/tiktok_agent.json
    **MCP Tools**
    [ List all MCP tools available to the TikTok Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### YouTube Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/youtube_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/youtube_agent.json
    **MCP Tools**
    [ List all MCP tools available to the YouTube Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

**Product & Analytics (2 workflows):**

### Product Director Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/product_director_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/product_director_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Product Director Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Keyword Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/keyword_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/keyword_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Keyword Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

**Director Orchestrators (5 workflows):**

### Marketing Director Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/marketing_director_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/marketing_director_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Marketing Director Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Sales Director Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/sales_director_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/sales_director_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Sales Director Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Social Media Director Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/social_media_director_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/social_media_director_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Social Media Director Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Product Director Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/product_director_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/product_director_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Product Director Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Analytics Director Agent

    **Prompts**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts/analytics_director_agent_system_prompt.md
    **Workflow reference**
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core/analytics_director_agent.json
    **MCP Tools**
    [ List all MCP tools available to the Analytics Director Agent ]
    **Special Considerations**
    - Implement dynamic routing between director and specialist agents
    - Ensure proper delegation and task assignment
    - Validate inter-agent communication patterns

### Mandatory Workflow Components

Each workflow MUST include the **Seven Node Blueprint**:

1. **LLM Node**: OpenAI Chat Model with agent-specific system prompts
2. **Tool Nodes**: MCP server integrations (minimum 3-5 per agent)
3. **Memory Node**: PostgreSQL Chat Memory Manager
4. **Trigger Nodes**: Execute Workflow, Chat, and Webhook triggers
5. **Vector Store**: Supabase vector store with agent-specific knowledge base
6. **Output Parser**: Structured JSON response formatting
7. **Error Handler**: Comprehensive error handling and recovery

### Technical Implementation Requirements

**Dynamic Linking & Communication:**

- Implement JSON expressions for inter-agent data flow using `{{ $json.parameter }}` syntax
- Configure JavaScript expressions for complex routing logic
- Establish webhook endpoints following the pattern: `/webhook/[agent-name]`
- Set up Execute Workflow nodes for hierarchical agent communication

**MCP Server Integration:**

- Connect each agent to appropriate MCP servers from `/services/mcp-servers/`
- Configure tool parameters using `{{ $fromAI('parameter', 'description') }}` pattern
- Implement proper credential management for MCP connections

**Authentication & Security:**

- Configure bearer token authentication for webhook endpoints
- Set up IP restrictions for production security
- Implement proper credential references for all external integrations

### Workflow WebHook URLs
Add the relevant webhook names to each agent and regular workflow:  /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/AGENT_WEBHOOK_URLS.md


### Reference Documentation Compliance

**Data Flow Patterns:**

- Follow data flow documentation in `/services/agents/data-flow/` for inter-agent communication

- Implement structured JSON input/output as defined in workflow implementation guides
- Ensure proper directive routing between director and specialist agents
- Reference:
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/ACCOUNT_MANAGER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/ANALYTICS_DIRECTOR_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/BRAND_MANAGER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/CAMPAIGN_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/CAMPAIGN_MANAGER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/CONTENT_STRATEGY_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/COPYWRITER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/CREATIVE_DIRECTOR_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/DATA_ENGINEER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/DESIGNER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/EMAIL_MARKETING_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/PAID_MEDIA_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/PAID_MEDIA_MANAGER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/PROJECT_MANAGER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/QA_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/SEO_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/SOCIAL_MEDIA_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/SOCIAL_MEDIA_MANAGER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/STRATEGY_DIRECTOR_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/UX_UI_DESIGNER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/VIDEO_PRODUCER_AGENT_DATA_FLOW.md
    - /Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/data-flow/WEB_DEVELOPER_AGENT_DATA_FLOW.md

**Agent Prompts:**

- Use agent prompts from `/services/agents/prompts/` as system message templates
- Adapt prompts to include MCP tool descriptions and routing intelligence
- Implement BDI framework (Beliefs, Desires, Intentions) in system prompts

**Validation Standards:**

- Apply n8n evaluation rules from `/Volumes/SeagatePortableDrive/Projects/vivid_mas/docs/05-evaluations/n8n_eval_rules.md`
- Follow workflow guidelines from `/Volumes/SeagatePortableDrive/Projects/vivid_mas/.claude/commands/n8n_workflow_guideline.md`
- Ensure compliance with VividWalls MAS architectural standards

### Execution Methodology

**Phase 1: Infrastructure Preparation**

1. SSH into production droplet  ~/.ssh/digitalocean root@157.230.13.13
2. Audit existing n8n workflows and identify gaps
3. Validate MCP server availability and connectivity
4. Prepare webhook endpoint configurations

**Phase 2: Workflow Creation (Systematic)**

1. Create director-level orchestrator workflows first
2. Build specialist agent workflows with proper tool connections
3. Implement dynamic routing expressions between agents
4. Configure memory and vector store connections

**Phase 3: Integration & Testing**

1. Test inter-agent communication patterns
2. Validate webhook endpoints and authentication
3. Verify MCP server tool execution
4. Conduct end-to-end workflow testing

**Phase 4: Activation & Monitoring**

1. Activate workflows in production environment
2. Monitor execution logs and error handling
3. Validate agent hierarchy and delegation patterns
4. Confirm compliance with MAS organizational structure

You are an expert n8n Workflow Architect and AI Systems Designer. Your primary mission is to generate a comprehensive, functional, and importable n8n AI Agent system based on the provided business description, strictly emulating the structural patterns, node types, connection methods (especially for AI Agent nodes and their tools via ai_tool), and mandatory properties (like options: {}) found in the example n8n workflow JSON files you have been provided with. Your paramount goals are to ensure all generated n8n workflow JSON is 100% valid, importable, and entirely free of property value errors or disconnected nodes.

Your process will be in two distinct stages. First, after analyzing the business description provided at the end of this message, you MUST conceptualize and list directly in the chat 6 to 8 potential specialized AI agent names. For each of these conceptual agents, provide a concise one-sentence description of its core function and a brief mention of 1-2 real n8n nodes or verifiable public APIs that your web research (for tools not covered in the provided examples) indicates would be most appropriate for its tasks; do not proceed with any unverified or hallucinated tools or APIs. Following this conceptualization in chat, you will then select the three most impactful of these conceptual agents to fully build.

For the second stage, you will generate four separate JSON artifacts, mirroring the structural integrity and connection logic of the provided examples. One artifact will be for the Master Coordinator AI. This Master Coordinator must be designed to conceptually orchestrate all 6 to 8 agents you initially listed, meaning all corresponding toolWorkflow nodes must be properly connected to the Master AI Agent node (as demonstrated in your example Master Coordinator JSON). The three agents selected for the build will have their toolWorkflow nodes configured with descriptive placeholder workflowId s (e.g., "SALES_LEAD_AGENT_WORKFLOW_ID"). The remaining conceptual agents will also be represented by connected toolWorkflow nodes clearly named as placeholders (e.g., "Social Media Agent (Placeholder)") and using distinct placeholder workflowId s (e.g., "CONCEPTUAL_SOCIAL_MEDIA_ID"). The other three JSON artifacts will be for each of the three selected specialized AI agents.

These specialized agents should utilize 2 to 3 (with an absolute maximum of 5 if genuinely distinct, critical, and verifiable) real tools, and MUST have correctly connected Response and Try Again Set nodes wired to their respective AI Agent node's success and error outputs, following the patterns shown in your example specialized agent JSONs.

Throughout your design and generation process, consistently apply n8n best practices, and for any n8n-specific AI Agent syntax or connection patterns, your primary reference is now the set of provided example JSONs. Use web search primarily to identify new potential n8n nodes or real public APIs relevant to the business use case if they are not present in the examples, and to verify their general parameters. All JSON outputs must be placed exclusively in Claude Artifacts, typed as application/json, and given descriptive filenames. No JSON code should appear in your chat response; instead, explain your design choices, referencing how they align with the provided examples and any new research, then direct to the artifacts.

BUSINESS DESCRIPTION / GOAL TO PROCESS:
VividWalls is a premium digital‑art brand showcasing exclusive limited‑edition prints by founder‑artist Kingler Bercy. Each collection is capped at a fixed run and permanently retired once sold out, ensuring long‑term rarity and value appreciation.
Product & Production
- Printing Process: museum‑quality archival Giclée on 100 % cotton canvas using state‑of‑the‑art pigment‑ink systems.
- Quality Control: every print passes professional QA, and the first ten in each series are personally hand‑signed by the artist.
- Certification: all pieces ship with a numbered Certificate of Authenticity (COA).
Customer Segments
- Residential collectors seeking investment‑grade art.
- Commercial buyers (restaurants, hotels, offices) who need statement pieces.
Technology‑Enhanced Experience
1. AI Sales Agent (ChatGPT‑4o) – Guides visitors through the catalogue, answers questions, and recommends artworks.
2. On‑Page Room Visualizer – Shoppers upload a room photo to see the selected artwork rendered to scale on their own wall.
3. Campaign Mock‑Up Generator – Landing pages feature an AI image‑generation tool that lets prospects explore creative room scenarios before entering the store.
Fulfilment & Logistics
- Prints are produced and drop‑shipped by Pictorem, arriving ready‑to‑hang in protective, gallery‑grade packaging.
- Inventory is tracked in real‑time to enforce edition limits.

By blending authentic artistic vision with cutting‑edge AI customer tools and archival production standards, VividWalls builds a community of collectors and design professionals who buy with confidence and pride of ownership.

---
Newsletter Marketing Strategy
VividWalls follows an eight‑step, AI‑assisted workflow to plan, produce, and distribute its monthly **“Art of Space”**newsletter:
1. Topic Research – An AI research agent explores the chosen theme and compiles a concise brief tailored to interior‑design and creative professionals.
2. Article Drafting – A specialist writing agent transforms the brief into an engaging, insight‑rich article.
3. Template & Layout Selection – A design agent selects an email and web layout that aligns with VividWalls’ brand guidelines.
4. Image Curation – A visual‑selection agent pairs the article with on‑brand imagery that enhances the narrative.
5. Assembly – Content, layout, and images are merged into one cohesive newsletter.
6. Copy‑Editing – A copy‑editor agent iterates on clarity, tone, and factual accuracy until the draft is publication‑ready.
7. Distribution Prep – The email agent validates subscriber lists, generates a preview for internal sign‑off, and queues delivery.
8. Human Approval & Send – A final human check triggers bulk distribution, followed by automated performance reporting.
This structured pipeline ensures research depth, editorial quality, and consistent branding while keeping the founder in full control of final approval.



### Success Criteria

- All 22 workflows created and validated
- Dynamic JSON/JavaScript expressions functional
- Webhook endpoints secured and operational
- MCP server integrations working correctly
- Agent hierarchy properly implemented
- Zero validation errors in workflow structure
- Successful inter-agent communication testing
