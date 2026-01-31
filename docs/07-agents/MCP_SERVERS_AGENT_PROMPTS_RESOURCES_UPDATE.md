# MCP Servers Agent Prompts & Resources Update

This document contains the additional MCP server documentation to be added to the Agent-Specific Prompt & Resource Servers section of MCP_SERVERS_COMPLETE_DOCUMENTATION.md.

## Agent-Specific Prompt & Resource Servers (Additional)

### 22. Content Strategy Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/content-strategy-prompts`, `/opt/mcp-servers/agents/content-strategy-resource`
- **Purpose:** Enables comprehensive content planning, audits, topic clustering, and multi-channel distribution strategies.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Optional: `PORT`, `LOG_LEVEL`

**Prompts Server Tools:**
- `content-planning`: Creates editorial calendars aligned with business objectives
- `content-audit`: Conducts content audits with gap analysis
- `topic-clustering`: Develops topic clusters for SEO
- `content-performance-analysis`: Analyzes content performance with optimization strategies
- `seo-content-strategy`: Develops SEO-focused content strategies
- `multi-channel-distribution`: Creates distribution strategies across channels

**Resource Server Resources:**
- `content://brand/voice-guidelines`: Brand voice and tone guidelines
- `content://pillars/themes`: Core content pillars and themes
- `content://templates/editorial-calendar`: Editorial calendar structures
- `content://metrics/performance`: KPIs and scoring methodology
- `content://topics/clusters`: SEO-optimized topic clusters
- `content://distribution/channels`: Channel-specific strategies

### 23. Copy Editor Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/copy-editor-prompts`, `/opt/mcp-servers/agents/copy-editor-resource`
- **Purpose:** Provides comprehensive copy editing capabilities including grammar checking, brand voice alignment, and multi-channel adaptation.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Optional: `PORT`, `LOG_LEVEL`

**Prompts Server Tools:**
- `copy-editor-grammar-style`: Grammar and style consistency checking
- `copy-editor-tone-consistency`: Tone and voice alignment analysis
- `copy-editor-clarity-improvement`: Content clarity enhancement
- `copy-editor-seo-optimization`: SEO optimization while maintaining quality
- `copy-editor-brand-voice`: Brand voice compliance checking
- `copy-editor-fact-checking`: Fact verification and validation
- `copy-editor-structure-analysis`: Content structure optimization
- `copy-editor-multichannel-adaptation`: Multi-channel content adaptation

**Resource Server Resources:**
- `style-guide`: Comprehensive writing style guidelines
- `editing-checklist`: Step-by-step editing process
- `brand-glossary`: VividWalls brand terminology
- `grammar-rules`: Common grammar rules and error prevention
- `seo-practices`: SEO optimization guidelines
- `readability-guidelines`: Readability and accessibility standards

### 24. Copy Writer Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/copy-writer-prompts`, `/opt/mcp-servers/agents/copy-writer-resource`
- **Purpose:** Generates compelling, conversion-focused copy across all marketing channels while maintaining brand voice.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Optional: `PORT`, `LOG_LEVEL`

**Prompts Server Tools:**
- `product-description`: Creates compelling product descriptions for wall art
- `landing-page-copy`: Writes conversion-focused landing pages
- `social-media-captions`: Creates platform-optimized social captions
- `email-copy`: Writes engaging email campaigns
- `ad-copy`: Creates high-performing digital ad copy
- `blog-article`: Writes comprehensive blog articles

**Resource Server Resources:**
- `copy://templates/headlines`: Proven headline formulas and power words
- `copy://templates/cta-buttons`: High-converting CTA button text
- `copy://templates/value-propositions`: Segment-specific value propositions
- `copy://style-guide/tone-variations`: Brand voice adaptations by context
- `copy://formulas/product-descriptions`: Structured product copy approaches
- `copy://examples/high-performing`: Real copy examples with performance data

### 25. Email Marketing Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/email-marketing-prompts`, `/opt/mcp-servers/agents/email-marketing-resource`
- **Purpose:** Creates, optimizes, and manages email campaigns with audience segmentation and performance tracking.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Optional: `PORT`, `LOG_LEVEL`

**Prompts Server Tools:**
- `email-campaign-creation`: Creates comprehensive email campaigns with optimized messaging
- `email-sequence-planning`: Designs multi-email sequences for customer nurturing
- `email-performance-optimization`: Analyzes metrics and provides optimization recommendations
- `email-template-design`: Creates email template designs for various campaign types
- `email-list-segmentation`: Develops segmentation strategies for targeted messaging

**Resource Server Resources:**
- `email://templates/gallery`: Pre-designed email templates for various campaigns
- `email://performance/benchmarks`: Industry benchmarks and historical metrics
- `email://segments/profiles`: Detailed profiles of email segments
- `email://content/subject-lines`: Database of tested subject lines with performance
- `email://automation/workflows`: Pre-built email automation templates
- `email://copywriting/frameworks`: Proven copywriting formulas for email

### 26. Keyword Agent Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/keyword-agent-prompts`, `/opt/mcp-servers/agents/keyword-agent-resource`
- **Purpose:** Provides comprehensive keyword research capabilities for SEO optimization and content planning.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Prompts: `PORT` (default: 3018)
  - Resource: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `PORT` (default: 3019)

**Prompts Server Tools:**
- `keyword-research`: Comprehensive keyword research for high-value terms
- `search-intent-analysis`: Analyzes and categorizes keywords by intent
- `long-tail-keyword-discovery`: Discovers profitable long-tail opportunities
- `competitor-keyword-analysis`: Analyzes competitor keyword strategies
- `keyword-clustering`: Groups keywords into thematic clusters
- `local-seo-keywords`: Generates location-specific keywords

**Resource Server Resources:**
- `keyword-data`: Returns keyword research data by industry/niche
- `search-intent-data`: Analyzes search intent for keywords
- `long-tail-generator`: Generates long-tail keyword variations
- `competitor-data`: Returns competitor keyword analysis
- `clustering-algorithm`: Clusters keywords into semantic groups
- `local-keyword-data`: Returns location-specific keyword data

### 27. Marketing Campaign Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/marketing-campaign-prompts`, `/opt/mcp-servers/agents/marketing-campaign-resource`
- **Purpose:** Provides comprehensive campaign planning, coordination, and optimization capabilities for marketing campaigns.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Optional: `PORT` (defaults: 3020/3021)

**Prompts Server Tools:**
- `campaign-planning`: Comprehensive planning with objectives, audience, and messages
- `multi-channel-coordination`: Coordinates campaigns across multiple channels
- `campaign-budget-allocation`: Allocates and optimizes campaign budgets
- `campaign-timeline-milestones`: Creates timelines with key milestones
- `campaign-performance-tracking`: Tracks and analyzes performance metrics
- `campaign-optimization`: Optimizes ongoing campaigns based on data

**Resource Server Resources:**
- `campaign-brief-template`: Comprehensive campaign brief template
- `performance-benchmarks`: Industry performance benchmarks by channel
- `campaign-calendar`: Marketing calendar with seasonal opportunities
- `asset-libraries`: Marketing asset libraries and creative resources
- `channel-specifications`: Technical specs and best practices per channel
- `roi-calculators`: ROI calculation formulas and templates

### 28. Social Media Director Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/social-media-director-prompts`, `/opt/mcp-servers/agents/social-media-director-resource`
- **Purpose:** Orchestrates social media strategies across all platforms with comprehensive management capabilities.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** 
  - Prompts: `PORT` (default: 3022), `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`
  - Resource: Optional port configuration

**Prompts Server Tools:**
- `social-media-director-system`: System prompt for orchestrating strategies
- `social-media-strategy-development`: Develops comprehensive social strategies
- `platform-content-planning`: Platform-specific content planning templates
- `community-engagement`: Community engagement and management templates
- `social-listening-monitoring`: Social listening protocols and response strategies
- `influencer-collaboration`: Influencer partnership templates and frameworks
- `crisis-management`: Crisis management protocols with escalation paths
- `content-performance-analysis`: Performance analysis templates
- `social-media-policy-guidelines`: Social media policy and brand guidelines

**Resource Server Resources:**
- `social-media-director://frameworks/social-media-strategy`: Complete strategy framework
- `social-media-director://playbooks/platform-optimization`: Platform-specific optimization
- `social-media-director://strategies/influencer-marketing`: Influencer marketing guide
- `social-media-director://tools/content-calendar-system`: Advanced content calendar system
- `social-media-director://analytics/performance-measurement`: Analytics and ROI framework
- `social-media-director://crisis/management-protocols`: Crisis management protocols
- `social-media-director://emerging/platform-strategies`: Emerging platforms guide

### 29. Creative Director Prompts & Resource
- **Status:** Already Documented
- **Note:** Previously documented in the main documentation

### 30. Marketing Director Prompts & Resource
- **Status:** Already Documented
- **Note:** Previously documented in the main documentation

### 31. Marketing Research Prompts & Resource
- **Status:** Already Documented
- **Note:** Previously documented in the main documentation

### 32. Newsletter Agent Prompts
- **Status:** Already Documented
- **Note:** Previously documented in the main documentation

### 33. Image Picker Resource
- **Status:** Already Documented
- **Note:** Previously documented in the main documentation

## Summary of Newly Documented Servers

The following MCP servers have been added to the documentation:

1. **Content Strategy** (Prompts & Resource) - Content planning and optimization
2. **Copy Editor** (Prompts & Resource) - Copy editing and quality assurance
3. **Copy Writer** (Prompts & Resource) - Creative copywriting across channels
4. **Email Marketing** (Prompts & Resource) - Email campaign management
5. **Keyword Agent** (Prompts & Resource) - SEO keyword research and analysis
6. **Marketing Campaign** (Prompts & Resource) - Comprehensive campaign coordination
7. **Social Media Director** (Prompts & Resource) - Social media strategy orchestration

Each pair of servers (prompts and resource) works together to provide:
- **Prompts Server**: Structured templates for generating agent responses
- **Resource Server**: Knowledge base, templates, and data for informed decisions

These servers enable specialized agents to perform their tasks with consistency, leveraging best practices and proven frameworks specific to their domains.