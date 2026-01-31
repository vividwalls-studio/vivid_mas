# N8N Workflow Renaming Guide - Manual Implementation

## Current Status

The automated renaming script has identified 61 workflows that need to be renamed according to our new nomenclature standard. Due to n8n API limitations, these need to be renamed manually through the UI.

## New Nomenclature Benefits

The new naming system provides:

### 🔍 **Searchability**
- Find all VividWalls workflows: Search `VW-*`
- Find all marketing workflows: Search `*-MKT-*`
- Find all webhook handlers: Search `*-WEBHOOK-*`
- Find all director agents: Search `*-DIR-*`

### 📊 **Organization**
- Workflows sort logically by client → department → function
- Related workflows appear together
- Clear hierarchy at a glance

### 🚀 **Scalability**
- Consistent pattern for hundreds of workflows
- Easy to add new categories
- Multi-client support built-in

## Renaming Map - Priority Workflows

### 🔴 High Priority - Director Agents (10 workflows)

| Current Name | New Name | Type |
|-------------|----------|------|
| Business Manager | **VW-BM-DIR-Orchestrator** | Main Orchestrator |
| Business Manager Agent | **VW-BM-DIR-Orchestrator** | Main Orchestrator |
| Marketing Director Agent | **VW-MKT-DIR-Main** | Director |
| Sales Director Agent | **VW-SLS-DIR-Main** | Director |
| Operations Director Agent | **VW-OPS-DIR-Main** | Director |
| Customer Experience Director Agent | **VW-CX-DIR-Main** | Director |
| Finance Director Agent | **VW-FIN-DIR-Main** | Director |
| Analytics Director Agent | **VW-ANL-DIR-Main** | Director |
| Technology Director Agent | **VW-TECH-DIR-Main** | Director |
| Social Media Director | **VW-SOC-DIR-Main** | Director |

### 🟡 Medium Priority - Agent Workflows (20 workflows)

| Current Name | New Name |
|-------------|----------|
| Marketing Campaign Agent | **VW-MKT-AGENT-Campaign** |
| Marketing Research Agent | **VW-MKT-AGENT-Research** |
| Content Strategy Agent | **VW-MKT-AGENT-Strategy** |
| Data Analytics Agent | **VW-ANL-AGENT-DataAnalysis** |
| Facebook Agent | **VW-SOC-AGENT-Facebook** |
| Instagram Agent | **VW-SOC-AGENT-Instagram** |
| Shopify Agent | **VW-INT-AGENT-Shopify** |
| Knowledge Management Agent | **VW-DATA-AGENT-Knowledge** |
| Art Trend Intelligence | **VW-ANL-AGENT-TrendAnalysis** |
| Creative Director Agent | **VW-MKT-DIR-Creative** |

### 🟢 Low Priority - Test/Demo Workflows (15 workflows)

| Current Name | New Name |
|-------------|----------|
| My workflow | **TEST-UTIL-Unnamed-001** |
| My workflow 2 | **TEST-UTIL-Unnamed-002** |
| My workflow 3 | **TEST-UTIL-Unnamed-003** |
| Test Workflow from MCP | **TEST-UTIL-MCP-Integration** |
| Debug Test Workflow | **TEST-UTIL-Debug** |
| WordPress Chatbot with OpenAI | **DEMO-INT-API-WordPress-Chat** |

## How to Rename Workflows Manually

### Step 1: Access n8n
1. Go to https://n8n.vividwalls.blog
2. Navigate to Workflows page

### Step 2: Rename Each Workflow
1. **Find the workflow** in the list
2. **Click the three dots** menu (⋮) next to the workflow
3. Select **"Settings"** or **"Rename"**
4. **Enter the new name** from the mapping table
5. **Save** the changes

### Step 3: Apply Tags (Optional but Recommended)
While renaming, also apply appropriate tags:
- Primary tag (VividWalls-MAS, DesignThru-AI, etc.)
- Status tag (Production, Development, etc.)
- Functional tags (Webhook, Agent-Workflow, etc.)

## Quick Copy-Paste List

For easy copy-pasting, here are all the new names:

### Director Agents
```
VW-BM-DIR-Orchestrator
VW-MKT-DIR-Main
VW-SLS-DIR-Main
VW-OPS-DIR-Main
VW-CX-DIR-Main
VW-PRD-DIR-Main
VW-FIN-DIR-Main
VW-ANL-DIR-Main
VW-TECH-DIR-Main
VW-SOC-DIR-Main
```

### Marketing Agents
```
VW-MKT-AGENT-Campaign
VW-MKT-AGENT-Campaign-MCP
VW-MKT-AGENT-Campaign-Approval
VW-MKT-AGENT-Research
VW-MKT-AGENT-Content
VW-MKT-AGENT-Content-MCP
VW-MKT-AGENT-Content-Approval
VW-MKT-AGENT-Strategy
VW-MKT-DIR-Creative
```

### Customer Experience Agents
```
VW-CX-AGENT-Relationship-MCP
VW-CX-AGENT-Relationship-Approval
VW-CX-AGENT-Service
```

### Social Media Agents
```
VW-SOC-AGENT-Facebook
VW-SOC-AGENT-Instagram
VW-SOC-AGENT-Pinterest
VW-SOC-AGENT-Twitter
```

### Integration Workflows
```
VW-INT-API-Shopify-Sync
VW-INT-AGENT-Shopify
VW-INT-API-Stripe-Payment
VW-INT-API-SendGrid-Email
VW-INT-API-Supabase-Data
VW-INT-WEBHOOK-FrontendHub
```

### Data Processing
```
VW-DATA-PROC-DatabaseSearch
VW-DATA-PROC-ColorAnalysis
VW-DATA-PROC-ColorAnalysis-MCP
VW-DATA-PROC-ImageRetrieval
VW-DATA-AGENT-Knowledge
VW-OPS-PROC-OrderFulfillment
```

### Analytics
```
VW-ANL-AGENT-DataAnalysis
VW-ANL-AGENT-TrendAnalysis
```

## Progress Tracking

Use this checklist to track renaming progress:

### ⬜ Directors (0/10)
- [ ] Business Manager → VW-BM-DIR-Orchestrator
- [ ] Marketing Director → VW-MKT-DIR-Main
- [ ] Sales Director → VW-SLS-DIR-Main
- [ ] Operations Director → VW-OPS-DIR-Main
- [ ] Customer Experience Director → VW-CX-DIR-Main
- [ ] Product Director → VW-PRD-DIR-Main
- [ ] Finance Director → VW-FIN-DIR-Main
- [ ] Analytics Director → VW-ANL-DIR-Main
- [ ] Technology Director → VW-TECH-DIR-Main
- [ ] Social Media Director → VW-SOC-DIR-Main

### ⬜ Agents (0/20)
- [ ] Marketing Campaign Agent
- [ ] Marketing Research Agent
- [ ] Content Strategy Agent
- [ ] Data Analytics Agent
- [ ] Facebook Agent
- [ ] Instagram Agent
- [ ] Others...

## Verification

After renaming, verify the new system works:

1. **Test Search Patterns**
   - Search `VW-*` - Should show all VividWalls workflows
   - Search `*-DIR-*` - Should show all director agents
   - Search `*-MKT-*` - Should show all marketing workflows

2. **Check Sorting**
   - Workflows should sort logically
   - Related workflows should appear together

3. **Update References**
   - Update any documentation referencing old names
   - Update any external systems calling workflows by name

## Timeline

Recommended completion schedule:
- **Day 1**: Rename all Director agents (High Priority)
- **Day 2**: Rename active Agent workflows (Medium Priority)
- **Day 3**: Rename test/demo workflows (Low Priority)
- **Day 4**: Verification and documentation updates

## Support

The renaming script is available for reference at:
- `/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/n8n_workflow_renaming_system.js`

The full naming standards document is at:
- `/Volumes/SeagatePortableDrive/Projects/vivid_mas/docs/N8N_WORKFLOW_NAMING_STANDARDS.md`