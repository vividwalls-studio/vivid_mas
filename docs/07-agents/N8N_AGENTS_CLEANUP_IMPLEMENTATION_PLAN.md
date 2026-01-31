# N8N Agents Directory Cleanup and Implementation Plan

## Overview

This document provides a detailed, actionable plan for cleaning up the n8n agents directory, removing duplicates, organizing workflows, and creating missing capabilities to achieve 85%+ system completeness.

**Current State**: 51.5% complete, 84 files, no organization  
**Target State**: 85%+ complete, ~55 organized workflows, clear structure

## Phase 0: Preparation and Backup (Day 1)

### 0.1 Create Full Backup
```bash
# Create timestamped backup
cd /Volumes/SeagatePortableDrive/Projects/vivid_mas
cp -r services/agents services/agents.backup.$(date +%Y%m%d_%H%M%S)

# Create git branch for changes
git checkout -b feature/agent-directory-cleanup
git add services/agents.backup.*
git commit -m "Backup: Pre-cleanup agent workflows"
```

### 0.2 Set Up New Directory Structure
```bash
# Create the new organizational structure
cd services/agents
mkdir -p workflows/{core/{orchestration,delegation,monitoring},domains/{sales,marketing,social_media,operations,customer_experience,product,analytics,technology,finance},integrations/{external/shopify,internal/{database,mcp}},utilities/{data-processing/{knowledge-extraction,research},automation,lead-generation}}

# Create directory README files
echo "# Core Workflows\nCentral orchestration and control workflows" > workflows/core/README.md
echo "# Domain Workflows\nDepartment-specific agent workflows" > workflows/domains/README.md
echo "# Integration Workflows\nExternal and internal system integrations" > workflows/integrations/README.md
echo "# Utility Workflows\nSupport tools and automation utilities" > workflows/utilities/README.md
```

### 0.3 Fix Invalid JSON Files
```bash
# Fix copywriting_knowledge_gatherer_agent.json (line 273 column 409)
# Fix technology_automation_knowledge_gatherer_agent.json (line 231 column 1048)
# Use a JSON validator to identify and fix syntax errors
```

## Phase 1: Duplicate Removal (Day 2)

### 1.1 Remove Safe Duplicates (15 files)
```bash
# Run the duplicate removal script
python scripts/remove_duplicate_workflows.py

# Files to be removed:
# - normalized_update_data.json
# - final_research_reports_supabase_node.json
# - director_id_mappings.json
# - business_manager_current.json
# - streamlined_supabase_research_reports_node.json
# - updated_research_reports_supabase_node.json
# - corrected_research_reports_supabase_node.json
# - Various duplicate knowledge gatherer agents
```

### 1.2 Handle Version Variants (18 files)

#### Business Manager Consolidation
```bash
# Keep: business_manager_updated_complete.json
# Archive: Business Manager Agent.json, business_manager_workflow.json, business_manager_current.json

# Extract features to merge:
# - Telegram configuration from Business Manager Agent.json
# - Schedule triggers from business_manager_workflow.json
```

#### Marketing Director Consolidation
```bash
# Keep: marketing_director_agent.json
# Archive: Marketing Director Agent (1).json, marketing_director_mcp_workflow.json, marketing_director_mcp_integration_example.json

# Extract features to merge:
# - Additional workflow tools from (1) version
# - MCP configurations from mcp_workflow version
```

#### Sales Director Consolidation
```bash
# Keep: sales_director_agent_enhanced.json
# Archive: sales_director_agent.json

# Extract features to merge:
# - Vector store configuration from original
# - Documentation notes from original
```

### 1.3 Create Feature Merge Scripts
```python
# scripts/merge_workflow_features.py
import json

def merge_telegram_config(keeper_file, source_file):
    """Extract Telegram configuration from source and merge into keeper"""
    # Implementation here
    
def merge_mcp_config(keeper_file, source_file):
    """Extract MCP configurations and merge"""
    # Implementation here
```

## Phase 2: Core Workflow Migration (Day 3-4)

### 2.1 Migrate Business Manager
```bash
# Rename and move to proper location
mv business_manager_updated_complete.json workflows/core/orchestration/business_manager_agent.json

# Update workflow metadata
# - Set proper ID
# - Update name to "Business Manager Agent"
# - Add description
# - Fix internal references
```

### 2.2 Migrate Orchestration Subworkflows
```bash
# Move core workflows
mv strategic_orchestrator.json workflows/core/orchestration/
mv stakeholder_communications.json workflows/core/orchestration/

# Move delegation workflows  
mv campaign_coordination.json workflows/core/delegation/
mv workflow_automation.json workflows/core/delegation/

# Move monitoring workflows
mv performance_analytics.json workflows/core/monitoring/
mv budget_optimization.json workflows/core/monitoring/
```

### 2.3 Update Core Workflow IDs and References
```python
# scripts/update_workflow_ids.py
import json
import uuid

def update_workflow_id(filepath):
    with open(filepath, 'r') as f:
        workflow = json.load(f)
    
    # Generate new ID if missing
    if not workflow.get('id') or workflow['id'] == 'no_id':
        workflow['id'] = str(uuid.uuid4())
    
    # Update internal references
    # Implementation here
```

## Phase 3: Director Agent Restoration (Day 5-7)

### 3.1 Restore Missing Directors
```bash
# Marketing Director
mv marketing_director_agent.json workflows/domains/marketing/

# Sales Director (use enhanced version)
mv sales_director_agent_enhanced.json workflows/domains/sales/sales_director_agent.json

# Analytics Director
mv analytics_director_agent.json workflows/domains/analytics/

# Finance Director  
mv finance_director_agent.json workflows/domains/finance/

# Operations Director
mv operations_director_agent.json workflows/domains/operations/

# Customer Experience Director
mv customer_experience_director_agent.json workflows/domains/customer_experience/

# Product Director
mv product_director_agent.json workflows/domains/product/

# Technology Director
mv technology_director_agent.json workflows/domains/technology/

# Social Media Director (use version 2)
mv "Social Media Director Agent (2).json" workflows/domains/social_media/social_media_director_agent.json
```

### 3.2 Validate Director Configurations
- Ensure each director has proper MCP access
- Verify PostgreSQL memory configuration
- Check vector store connections
- Update team member references

## Phase 4: Create Missing Agents (Week 2)

### 4.1 Create Data Analytics Agent (CRITICAL - Single Source of Truth)

```json
{
  "name": "Data Analytics Agent",
  "description": "Central data hub providing single source of truth for all metrics",
  "nodes": [
    {
      "type": "@n8n/n8n-nodes-langchain.agent",
      "name": "Data Analytics Agent",
      "parameters": {
        "systemMessage": "You are the Data Analytics Agent, the single source of truth for all VividWalls metrics..."
      }
    },
    {
      "type": "n8n-nodes-mcp.mcpClientTool",
      "name": "Marketing Analytics Aggregator",
      "parameters": {
        "serverName": "marketing-analytics-aggregator"
      }
    },
    {
      "type": "n8n-nodes-mcp.mcpClientTool", 
      "name": "Shopify Direct Access",
      "parameters": {
        "serverName": "shopify-mcp-server"
      }
    }
  ]
}
```

### 4.2 Create Budget Management Agent

```json
{
  "name": "Budget Management Agent",
  "description": "Financial planning and budget tracking specialist",
  "nodes": [
    {
      "type": "@n8n/n8n-nodes-langchain.agent",
      "name": "Budget Manager",
      "parameters": {
        "systemMessage": "You are the Budget Management Agent responsible for financial planning..."
      }
    }
  ]
}
```

### 4.3 Create ROI Analysis Agent

```json
{
  "name": "ROI Analysis Agent",
  "description": "Return on investment calculations and analysis",
  "nodes": [
    {
      "type": "@n8n/n8n-nodes-langchain.agent",
      "name": "ROI Analyst",
      "parameters": {
        "systemMessage": "You are the ROI Analysis Agent, specializing in calculating return on investment..."
      }
    }
  ]
}
```

### 4.4 Create System Monitoring Agent

```json
{
  "name": "System Monitoring Agent",
  "description": "Infrastructure and system health monitoring",
  "nodes": [
    {
      "type": "@n8n/n8n-nodes-langchain.agent",
      "name": "System Monitor",
      "parameters": {
        "systemMessage": "You are the System Monitoring Agent responsible for infrastructure health..."
      }
    }
  ]
}
```

### 4.5 Create Integration Management Agent

```json
{
  "name": "Integration Management Agent",
  "description": "Manages connections between systems and services",
  "nodes": [
    {
      "type": "@n8n/n8n-nodes-langchain.agent",
      "name": "Integration Manager",
      "parameters": {
        "systemMessage": "You are the Integration Management Agent overseeing all system connections..."
      }
    }
  ]
}
```

## Phase 5: Domain Agent Organization (Week 2-3)

### 5.1 Sales Domain
```bash
# Move sales agents
mv b2b_sales_agent.json workflows/domains/sales/
mv hospitality_sales_agent.json workflows/domains/sales/
mv corporate_sales_agent.json workflows/domains/sales/
mv healthcare_sales_agent.json workflows/domains/sales/
mv retail_sales_agent.json workflows/domains/sales/
```

### 5.2 Marketing Domain
```bash
# Move marketing agents
mv campaign_agent.json workflows/domains/marketing/
mv content_strategy_agent.json workflows/domains/marketing/
mv "Content Strategy Agent Strategic.json" workflows/domains/marketing/content_strategy_agent_strategic.json
mv copy_writer_agent.json workflows/domains/marketing/
mv copy_editor_agent.json workflows/domains/marketing/
mv keyword_agent.json workflows/domains/marketing/
mv marketing_research_agent.json workflows/domains/marketing/
mv Email_Marketing_Agent.json workflows/domains/marketing/email_marketing_agent.json
```

### 5.3 Social Media Domain
```bash
# Move social platform agents
mv instagram_agent.json workflows/domains/social_media/
mv facebook_agent.json workflows/domains/social_media/
mv pinterest_agent.json workflows/domains/social_media/
```

### 5.4 Other Domains
```bash
# Customer Experience
mv customer_service_agent.json workflows/domains/customer_experience/
mv customer_relationship_agent.json workflows/domains/customer_experience/

# Product
mv color_analysis_agent.json workflows/domains/product/
mv pictorem_agent.json workflows/domains/product/

# Analytics
mv data_insights_agent.json workflows/domains/analytics/
```

## Phase 6: Integration Organization (Week 3)

### 6.1 External Integrations
```bash
# Shopify
mv shopify_agent.json workflows/integrations/external/shopify/
```

### 6.2 Internal Integrations
```bash
# Database integrations
mv *supabase*.json workflows/integrations/internal/database/

# MCP examples
mv *mcp*.json workflows/integrations/internal/mcp/
```

## Phase 7: Utility Consolidation (Week 4)

### 7.1 Create Knowledge Gatherer Template
```python
# scripts/create_knowledge_template.py
def create_template():
    template = {
        "name": "Knowledge Gatherer Template",
        "description": "Configurable template for domain-specific knowledge extraction",
        "parameters": {
            "domain": "${DOMAIN}",
            "vectorCollection": "${VECTOR_COLLECTION}",
            "extractionPrompt": "${EXTRACTION_PROMPT}"
        },
        "nodes": [
            # Standard knowledge extraction nodes
        ]
    }
    return template
```

### 7.2 Consolidate Knowledge Gatherers
```bash
# Create template
python scripts/create_knowledge_template.py > workflows/utilities/data-processing/knowledge-extraction/knowledge_gatherer_template.json

# Archive individual gatherers
mkdir archive/knowledge_gatherers
mv *knowledge_gatherer*.json archive/knowledge_gatherers/
```

### 7.3 Organize Task Agents
```bash
# Move task agents to automation utilities
mv task_agent_*.json workflows/utilities/automation/
```

### 7.4 Other Utilities
```bash
# Lead generation
mv lead-generation-workflow.json workflows/utilities/lead-generation/

# Research utilities
mv *research_report*.json workflows/utilities/data-processing/research/
```

## Phase 8: Validation and Testing (Week 5)

### 8.1 Validate All Workflows
```python
# scripts/validate_all_workflows.py
import os
import json

def validate_workflow(filepath):
    checks = {
        'has_id': False,
        'has_name': False,
        'has_nodes': False,
        'has_connections': False,
        'json_valid': False,
        'node_types_valid': False
    }
    
    # Implementation here
    return checks
```

### 8.2 Update Internal References
```python
# scripts/update_workflow_references.py
def update_references(old_path, new_path):
    # Search all workflows for references to old path
    # Update to new path
    pass
```

### 8.3 Test Critical Paths
1. Business Manager → Directors communication
2. Directors → Agents delegation
3. Agent → MCP tool access
4. Inter-agent communication
5. Database connections

## Phase 9: Documentation (Week 6)

### 9.1 Create Workflow Documentation
```markdown
# For each workflow create:
workflows/[category]/[workflow_name].md

## Contents:
- Purpose and responsibilities
- Input/output specifications
- MCP tools used
- Dependencies
- Communication patterns
- Testing procedures
```

### 9.2 Update Architecture Documentation
- Update MAS hierarchy diagram
- Document new agent relationships
- Create deployment guide
- Update troubleshooting guide

### 9.3 Create Migration Verification Checklist
```markdown
## Verification Checklist
- [ ] All 84 original files accounted for
- [ ] 15 exact duplicates removed
- [ ] 18 version variants consolidated
- [ ] All workflows have valid IDs
- [ ] All workflows properly categorized
- [ ] Missing agents created
- [ ] Internal references updated
- [ ] Critical paths tested
- [ ] Documentation complete
```

## Success Metrics

### Quantitative Metrics
- **File Count**: 84 → ~55 organized workflows
- **Completeness**: 51.5% → 85%+
- **Valid JSON**: 100% (from 97.6%)
- **Proper IDs**: 100% (from 0%)
- **Error Handling**: >50% (from 0%)

### Qualitative Metrics
- Clear organizational structure
- Consistent naming conventions
- Comprehensive documentation
- Easy to navigate and maintain
- Ready for CI/CD integration

## Risk Mitigation

### Backup Strategy
- Full backup before each phase
- Git commits after each major change
- Archive removed files, don't delete
- Test in staging environment first

### Rollback Plan
1. If issues occur, restore from backup
2. Identify specific problem workflows
3. Fix issues in isolation
4. Re-attempt migration

### Communication Plan
- Daily progress updates
- Phase completion notifications
- Issue escalation procedures
- Stakeholder sign-offs

## Timeline Summary

**Week 1**: Preparation, cleanup, core migration  
**Week 2**: Director restoration, create missing agents  
**Week 3**: Domain agent organization, integrations  
**Week 4**: Utility consolidation, template creation  
**Week 5**: Validation, testing, reference updates  
**Week 6**: Documentation, final verification

**Total Duration**: 6 weeks  
**End State**: Fully organized, 85%+ complete MAS

## Appendix: Scripts and Tools

All helper scripts are available in:
- `scripts/analyze_n8n_workflows.py` - Inventory analysis
- `scripts/analyze_workflow_duplicates.py` - Duplicate detection
- `scripts/analyze_workflow_organization.py` - Gap analysis
- `scripts/remove_duplicate_workflows.py` - Safe removal
- Additional scripts to be created as outlined above

---

**Last Updated**: 2025-07-15  
**Next Review**: After Phase 1 completion