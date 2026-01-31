# MCP Servers Documentation Update - January 2025

## New MCP Servers Added

### 1. Twenty CRM MCP Server

**Location**: `/services/mcp-servers/core/twenty-mcp-server/`

**Status**: ✅ Fully operational and tested

**Key Features**:
- Complete GraphQL API integration
- 20+ tools for CRM operations
- Support for contacts, companies, opportunities, tasks, and notes
- Custom object support
- Webhook management
- Advanced search capabilities

**Configuration**:
```json
{
  "servers": {
    "twenty-crm": {
      "command": "node",
      "args": ["/path/to/twenty-mcp-server/build/index.js"],
      "env": {
        "TWENTY_API_URL": "https://crm.vividwalls.blog",
        "TWENTY_API_KEY": "your-api-key"
      }
    }
  }
}
```

### 2. Listmonk MCP Server

**Location**: `/services/mcp-servers/core/listmonk-mcp-server/`

**Status**: 🚧 Built and ready for deployment

**Key Features**:
- Complete email marketing automation
- Subscriber management with custom attributes
- List segmentation and management
- Campaign creation and scheduling
- Template system
- Transactional email support
- Built-in CRM sync tool for Twenty CRM integration
- Analytics and statistics

**Configuration**:
```json
{
  "servers": {
    "listmonk": {
      "command": "node",
      "args": ["/path/to/listmonk-mcp-server/build/index.js"],
      "env": {
        "LISTMONK_URL": "http://localhost:9000",
        "LISTMONK_USERNAME": "admin",
        "LISTMONK_PASSWORD": "your-password"
      }
    }
  }
}
```

## Integration Capabilities

### Twenty CRM ↔ Listmonk Integration

The two new MCP servers are designed to work together seamlessly:

1. **Contact Synchronization**
   - Sync Twenty CRM contacts to Listmonk subscribers
   - Map CRM tags to email lists
   - Maintain data consistency across platforms

2. **Marketing Automation**
   - Trigger email campaigns based on CRM events
   - Track engagement back to CRM contacts
   - Segment campaigns by CRM data

3. **Unified Customer View**
   - Twenty CRM as single source of truth
   - Email engagement tracked in CRM
   - Complete customer journey visibility

## Updated Agent Assignments

### Primary Users of Twenty CRM:
- Sales Director Agent
- All specialized Sales Agents (12 agents)
- Customer Experience Director Agent
- Marketing Director Agent (for lead tracking)

### Primary Users of Listmonk:
- Email Marketing Agent
- Marketing Director Agent
- Customer Experience Director Agent
- Sales Agents (for targeted campaigns)

## New Workflow Examples

### 1. Lead Nurture Campaign
```
Twenty CRM → Listmonk → Email Campaign → Engagement Tracking → Twenty CRM Update
```

### 2. Customer Onboarding
```
Opportunity Won (Twenty) → Add to Onboarding List (Listmonk) → Welcome Series → Task Creation (Twenty)
```

### 3. Segment Marketing
```
CRM Segmentation → List Mapping → Targeted Campaign → Performance Analytics
```

## Next Steps

1. **Deploy Listmonk** to the DigitalOcean infrastructure
2. **Configure Integration** between Twenty CRM and Listmonk
3. **Update n8n Workflows** to include new MCP servers
4. **Train Agents** on new tool capabilities
5. **Implement Sync Automation** for real-time updates

## Benefits

- **Enhanced CRM Capabilities**: Modern CRM replacing legacy Sales CRM
- **Professional Email Marketing**: Moving from basic SendGrid to full-featured Listmonk
- **Better Integration**: Purpose-built sync between CRM and email marketing
- **Improved Analytics**: Unified view of customer interactions
- **Scalability**: Both systems can handle growth

This update significantly enhances the VividWalls MAS capabilities for customer relationship management and email marketing automation.