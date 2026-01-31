# Agent Files Cleanup Plan

## Duplicate Patterns Identified

### 1. Business Manager Agent Duplicates
- `workflows/core/business_manager_agent.json` (CURRENT)
- `workflows/core/business_manager_strategic_orchestrator_updated.json`
- `workflows/core/business_manager_subagents_architecture.json`
- `workflows/archived_workflows/2025-01-archive/business-operations/business_manager_agent.json`
- `workflows/archived_workflows/2025-01-archive/core/business_manager_agent_enhanced_documentation.json`
- `workflows/archived_workflows/2025-01-archive/core/business_manager_agent_original.json`
- `workflows/archived_workflows/2025-01-archive/core/business_manager_agent_updated.json`

### 2. Director Agents with Multiple Versions
Each director has 2-3 versions:
- `*_director_agent.json` (original)
- `*_director_agent_updated.json` 
- `*_director_agent_enhanced.json`

Examples:
- Finance Director: 3 versions
- Operations Director: 3 versions
- Marketing Director: 3 versions
- Technology Director: 3 versions
- Product Director: 3 versions
- Sales Director: 2 versions
- Creative Director: 3 versions
- Social Media Director: 4 versions
- Customer Experience Director: 2 versions
- Analytics Director: 2 versions

### 3. Subagent Duplicates
Multiple versions in `core/subagents/`:
- budget_optimization_workflow.json
- budget_optimization_updated.json
- v2/budget_optimization_complete.json

Same pattern for:
- campaign_coordination
- performance_analytics
- stakeholder_communications
- workflow_automation
- strategic_orchestrator

### 4. Integration Agent Duplicates
- `shopify_agent.json` vs `shopify_agent_updated.json`
- `pictorem_agent_node.json` vs `pictorem_agent_node_updated.json`
- `color_analysis_agent.json` vs `color_analysis_agent_updated.json`

### 5. Import/API Files (Should be in different location)
These don't belong in workflows:
- `api_create_*.json` files
- `import_*.json` files

## Recommended Actions

### 1. Keep Only Latest Versions
For each agent, identify and keep only the most recent/enhanced version:
- Use `*_enhanced.json` if it exists
- Otherwise use `*_updated.json` if it exists
- Otherwise keep the base `*.json` file

### 2. Archive Structure
```
services/n8n/agents/
├── workflows/
│   ├── core/                    # Core director agents
│   ├── business-operations/     # Business function directors
│   ├── customer-sales/          # Sales and customer agents
│   ├── marketing/               # Marketing team agents
│   ├── social-media/           # Social media agents
│   ├── integrations/           # Platform integration agents
│   ├── system/                 # System utility workflows
│   └── vividwalls-specific/    # Company-specific workflows
├── archive/
│   ├── 2025-01-backup/         # Current duplicates
│   └── version-history/        # Previous versions
└── import-templates/           # Import and API creation files
```

### 3. Cleanup Steps

#### Step 1: Create Backup
```bash
# Create full backup before cleanup
tar -czf agents_backup_$(date +%Y%m%d_%H%M%S).tar.gz /path/to/agents/
```

#### Step 2: Move Import/API Files
Move these to `import-templates/`:
- All `api_create_*.json` files
- All `import_*.json` files

#### Step 3: Archive Old Versions
Move to `archive/2025-01-backup/`:
- All `*_updated.json` files (if `*_enhanced.json` exists)
- All base versions (if updated/enhanced exists)
- All v1 subagents (if v2 exists)

#### Step 4: Rename Enhanced to Standard Names
- `*_director_agent_enhanced.json` → `*_director_agent.json`
- Remove version suffixes from filenames

#### Step 5: Clean Subagents
Keep only v2 versions and rename:
- `v2/*_complete.json` → `*.json`
- Remove v2 directory

## Final Structure (After Cleanup)

```
workflows/
├── core/
│   ├── business_manager_agent.json
│   └── subagents/
│       ├── budget_optimization.json
│       ├── campaign_coordination.json
│       ├── performance_analytics.json
│       ├── stakeholder_communications.json
│       ├── strategic_orchestrator.json
│       └── workflow_automation.json
├── business-operations/
│   ├── analytics_director_agent.json
│   ├── finance_director_agent.json
│   ├── operations_director_agent.json
│   ├── product_director_agent.json
│   └── technology_director_agent.json
├── customer-sales/
│   ├── customer_experience_director_agent.json
│   ├── customer_service_agent.json
│   ├── orders_fulfillment_agent.json
│   └── sales_director_agent.json
├── marketing/
│   ├── marketing_director_agent.json
│   ├── creative_director_agent.json
│   ├── content_strategy_agent.json
│   └── [other marketing agents]
├── sales/
│   ├── hospitality_sales_agent.json
│   ├── corporate_sales_agent.json
│   ├── healthcare_sales_agent.json
│   └── retail_sales_agent.json
├── social-media/
│   ├── social_media_director_agent.json
│   ├── facebook_agent.json
│   ├── instagram_agent.json
│   └── pinterest_agent.json
└── integrations/
    ├── shopify_agent.json
    ├── pictorem_agent_node.json
    └── color_analysis_agent.json
```

## Version Selection Guide

### How to Choose Which Version to Keep:
1. **Check file modification dates** - Newest is usually best
2. **Check file size** - Enhanced versions are typically larger
3. **Look for sticky notes** - Enhanced versions have 18-19 sticky notes
4. **Check for MCP integration** - Latest versions use MCP nodes
5. **Verify completeness** - Enhanced versions have all required components

## Validation After Cleanup

1. **Count Check**: Should have ~30-35 unique agent files (not 100+)
2. **No Duplicates**: Each agent should have only one file
3. **Clear Naming**: No version suffixes in filenames
4. **Proper Organization**: Files in correct directories
5. **Archive Complete**: All old versions safely archived

---

*Created: 2025-06-26*
*Purpose: Clean up duplicate agent JSON files*
*Status: Ready for execution*