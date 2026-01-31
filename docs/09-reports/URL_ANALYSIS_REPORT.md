# URL Analysis Report - n8n Workflows

## Summary

This report analyzes all workflow files in the n8n services directory to identify files containing URLs and links.

### Overall Statistics
- **Total workflow files with webhooks**: 23+ files
- **Total files with localhost URLs**: 21+ files  
- **Total files with external HTTPS URLs**: 14+ files

## Directory Structure Analyzed
1. `/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/`
2. `/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/workflows/`

## Types of URLs Found

### 1. Webhook Endpoints
Most workflow files contain webhook configurations using n8n's webhook nodes:
- **Pattern**: `webhookId: "[workflow-name]-webhook"`
- **Common webhooks**:
  - sales-chat-webhook
  - business-manager-webhook
  - content-approval-webhook
  - campaign-approval-webhook
  - analytics-webhook

### 2. Localhost URLs (Internal Services)
Many workflows connect to local services:
- **n8n API**: `http://localhost:5678/webhook/[endpoint]`
- **Local LLM**: `http://localhost:3000/v1/chat/completions`
- **Vector Database**: `http://localhost:5432/api/vector_search`
- **Chat Storage**: `http://localhost:5432/api/chat_interactions`
- **Neo4j**: `http://neo4j-mcp-server:7474`

### 3. External API Endpoints
Several workflows integrate with external services:

#### Social Media APIs
- **Reddit API**: `https://api.reddit.com/r/[subreddit]/hot.json`
  - Found in: knowledge_graph_expansion_workflow.json
  - Subreddits: marketing, datascience, socialmedia, copywriting, ecommerce, etc.

#### Communication APIs
- **Telegram Bot API**: `https://api.telegram.org/bot{{ $credentials.telegramApi.token }}/sendMessage`
  - Found in: Human approval workflows (Content Marketing, Customer Relationship, Marketing Campaign)

#### Analytics APIs
- **Google Trends**: `https://trends.google.com/trends/api/dailytrends`
  - Found in: knowledge_graph_expansion_workflow.json

#### E-commerce APIs
- **Shopify**: `https://{{$credentials.shopifyApi.shopUrl}}`
  - Found in: vividwalls-inventory-metafield-sync.json

### 4. Internal Domain References
- **VividWalls domain**: `https://vividwalls.com` or `https://n8n.vividwalls.com`
  - Found in various marketing and customer-facing workflows

## Files with Significant External URLs

### Agent Workflows (`/agents/workflows/`)
1. **knowledge_graph_expansion_workflow.json**
   - Reddit API endpoints for trending topics
   - Google Trends API
   
2. **color_analysis_agent.json**
   - Example artwork URL: `https://example.com/artwork.jpg`

3. **Social Media Agents** (Facebook, Instagram, Pinterest)
   - Contains social media platform references

### Main Workflows (`/workflows/`)
1. **VividWalls-Content-Marketing-Human-Approval-Agent.json**
   - Telegram Bot API
   - VividWalls domain references

2. **VividWalls-Customer-Relationship-Human-Approval-Agent.json**
   - Telegram Bot API
   - Customer portal links

3. **VividWalls-Marketing-Campaign-Human-Approval-Agent.json**
   - Telegram Bot API
   - Campaign tracking URLs

4. **vividwalls-inventory-metafield-sync.json**
   - Shopify API endpoints

## Security Considerations

1. **Credentials**: Most external API calls use n8n's credential system (`{{ $credentials.serviceName }}`)
2. **Internal Services**: Heavy use of localhost URLs suggests microservices architecture
3. **Webhook Security**: Each workflow has unique webhook IDs for secure communication

## Recommendations

1. **URL Management**: Consider centralizing external URLs in environment variables
2. **API Version Control**: Some APIs may need version pinning
3. **Monitoring**: Implement monitoring for external API dependencies
4. **Documentation**: Maintain a service registry for all localhost endpoints