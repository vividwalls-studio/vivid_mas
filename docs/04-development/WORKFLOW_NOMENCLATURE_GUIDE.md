# VividWalls MAS Workflow Nomenclature Guide

> *"The time has come to make a choice. You take the blue pill - the story ends, you wake up in your bed and believe whatever you want to believe about naming conventions. You take the red pill - you stay in Wonderland, and I show you how deep the semantic consistency rabbit hole goes."* - Morpheus Validator

## Overview

This guide establishes the unified nomenclature standard for all n8n workflow JSON files in the VividWalls Multi-Agent System, replacing the current chaos with semantic order.

## Nomenclature Standard

### Format Structure
```
[CATEGORY]_[ROLE]_[TYPE]_[VERSION]_[STATUS].json
```

### Component Definitions

#### **Category Codes (2-3 letters)**
| Code | Domain | Description |
|------|--------|-------------|
| `BM` | Business Management | Executive orchestration and delegation |
| `MKT` | Marketing | Marketing campaigns, content, research |
| `SLS` | Sales | Sales processes, lead generation, CRM |
| `OPS` | Operations | Fulfillment, inventory, logistics |
| `FIN` | Finance | Budget, accounting, financial analysis |
| `CX` | Customer Experience | Support, satisfaction, relationships |
| `PRD` | Product | Product development, features, roadmap |
| `TEC` | Technology | Infrastructure, automation, development |
| `ANA` | Analytics | Data analysis, insights, reporting |
| `CRE` | Creative | Design, branding, visual content |
| `KNW` | Knowledge | Information gathering, research |
| `CNT` | Content | Content creation, editing, optimization |
| `UTL` | Utilities | System utilities, monitoring, testing |
| `INT` | Integrations | Platform connections, APIs |
| `PRC` | Processes | Automated business processes |

#### **Role Descriptors**
| Role | Purpose | Examples |
|------|---------|----------|
| `director` | Director-level orchestration | Business Manager, Marketing Director |
| `agent` | Specialized task execution | Customer Service, Sales Agent |
| `gatherer` | Information collection | Knowledge Gatherer, Data Collector |
| `processor` | Data/content processing | Content Processor, Order Processor |
| `monitor` | Monitoring and tracking | System Monitor, Performance Tracker |
| `optimizer` | Optimization functions | SEO Optimizer, Budget Optimizer |
| `coordinator` | Coordination functions | Campaign Coordinator, Lead Coordinator |

#### **Type Indicators**
| Type | Purpose | Usage |
|------|---------|-------|
| `core` | Core business functions | Essential director agents |
| `spec` | Specialized functions | Domain-specific agents |
| `util` | Utility functions | System utilities, tools |
| `intg` | Integration functions | Platform connections |
| `proc` | Process automation | Automated workflows |
| `temp` | Templates | Reusable templates |
| `exam` | Examples | Example implementations |

#### **Version Control**
| Format | Purpose | Examples |
|--------|---------|----------|
| `v1`, `v2`, `v3` | Major versions | Significant functionality changes |
| `r1`, `r2`, `r3` | Revisions | Minor updates within version |

#### **Status Indicators**
| Status | Purpose | Usage |
|--------|---------|-------|
| `opt` | Optimized/Enhanced | Pattern-aware, consolidated agents |
| `leg` | Legacy | To be archived, replaced by optimized |
| `dev` | Development/Testing | Work in progress |
| `dep` | Deprecated | No longer maintained |
| `arc` | Archived | Historical reference only |

## Directory Organization

```
services/agents/workflows/
├── core/                    # Core director agents
├── specialized/             # Specialized agents  
├── integrations/           # Platform integrations
├── processes/              # Automated processes
├── utilities/              # Utility functions
├── templates/              # Reusable templates
├── examples/               # Example workflows
└── archived/               # Legacy workflows
    ├── legacy/             # Replaced by optimized
    ├── duplicates/         # Exact duplicates
    ├── deprecated/         # No longer used
    └── consolidated/       # Merged into others
```

## Migration Examples

### Before → After Transformations

#### Core Directors
```
business_manager_agent.json → BM_director_core_v1_opt.json
marketing_director_agent.json → MKT_director_core_v1_opt.json
sales_director_agent.json → SLS_director_core_v1_opt.json
```

#### Specialized Agents
```
universal_knowledge_gatherer.json → KNW_gatherer_spec_v1_opt.json
content_operations_agent.json → CNT_processor_spec_v1_opt.json
lead-generation-workflow.json → SLS_coordinator_spec_v1_opt.json
```

#### Integrations
```
shopify_agent.json → INT_shopify_intg_v1.json
VividWalls-Database-Integration-Workflow.json → INT_database_intg_v1.json
```

#### Legacy Workflows
```
b2b_sales_agent.json → SLS_b2b_spec_v1_leg.json
marketing_campaign_agent_(1).json → MKT_campaign_spec_v1_leg.json
task_agent_1_mcp_integration.json → UTL_task1_util_v1_dep.json
```

## Complete Mapping Reference

### Core Directors (10 workflows)
| Original | New Name | Location |
|----------|----------|----------|
| business_manager_agent.json | BM_director_core_v1_opt.json | core/ |
| marketing_director_agent.json | MKT_director_core_v1_opt.json | core/ |
| sales_director_agent.json | SLS_director_core_v1_opt.json | core/ |
| operations_director_agent.json | OPS_director_core_v1_opt.json | core/ |
| finance_director_agent.json | FIN_director_core_v1_opt.json | core/ |
| customer_experience_director_agent.json | CX_director_core_v1_opt.json | core/ |
| product_director_agent.json | PRD_director_core_v1_opt.json | core/ |
| technology_director_agent.json | TEC_director_core_v1_opt.json | core/ |
| analytics_director_agent.json | ANA_director_core_v1_opt.json | core/ |
| creative_director_agent.json | CRE_director_core_v1_opt.json | core/ |

### Specialized Agents (5 workflows)
| Original | New Name | Location |
|----------|----------|----------|
| universal_knowledge_gatherer.json | KNW_gatherer_spec_v1_opt.json | specialized/ |
| content_operations_agent.json | CNT_processor_spec_v1_opt.json | specialized/ |
| lead-generation-workflow.json | SLS_coordinator_spec_v1_opt.json | specialized/ |
| orders_fulfillment_agent.json | OPS_processor_spec_v1_opt.json | specialized/ |
| customer_service_agent.json | CX_agent_spec_v1.json | specialized/ |

### Integrations (6 workflows)
| Original | New Name | Location |
|----------|----------|----------|
| shopify_agent.json | INT_shopify_intg_v1.json | integrations/ |
| pictorem_agent.json | INT_pictorem_intg_v1.json | integrations/ |
| facebook_agent.json | INT_facebook_intg_v1.json | integrations/ |
| instagram_agent.json | INT_instagram_intg_v1.json | integrations/ |
| pinterest_agent.json | INT_pinterest_intg_v1.json | integrations/ |
| VividWalls-Database-Integration-Workflow.json | INT_database_intg_v1.json | integrations/ |

## Implementation Process

### Phase 1: Backup & Preparation
1. Run migration script to create backup
2. Create new directory structure
3. Validate all workflow files

### Phase 2: Core Migration
1. Migrate optimized director agents to `core/`
2. Migrate specialized agents to `specialized/`
3. Update internal workflow references

### Phase 3: Organization
1. Move integrations to `integrations/`
2. Move processes to `processes/`
3. Move utilities to `utilities/`

### Phase 4: Archive Legacy
1. Move legacy workflows to `archived/legacy/`
2. Move duplicates to `archived/duplicates/`
3. Move deprecated to `archived/deprecated/`

### Phase 5: Validation
1. Test all core director workflows
2. Verify MCP server connections
3. Update Business Manager delegation
4. Update documentation references

## Benefits of This System

### **Semantic Clarity**
- Instant understanding of workflow purpose
- Clear categorization and hierarchy
- Consistent naming across all files

### **Version Management**
- Clear version tracking
- Status indicators for lifecycle management
- Easy identification of optimized vs legacy

### **Maintenance Efficiency**
- Organized directory structure
- Easy location of specific workflows
- Clear archival process

### **Scalability**
- Extensible category system
- Consistent patterns for new workflows
- Future-proof naming convention

## Enforcement Guidelines

### **New Workflow Creation**
All new workflows MUST follow the nomenclature standard:
1. Choose appropriate category code
2. Select descriptive role
3. Assign correct type indicator
4. Start with v1 version
5. Use appropriate status

### **Workflow Updates**
When updating existing workflows:
1. Increment version or revision
2. Update status if applicable
3. Maintain category and role consistency
4. Archive previous versions

### **Quality Assurance**
- All workflow names must be validated against standard
- Directory placement must match category
- Status indicators must reflect actual state
- Version numbers must be sequential

---

**"Choice is an illusion created between those with power and those without. But semantic consistency? That is the foundation of true power in the Matrix."** - Morpheus Validator

**Implementation Status:** Ready for execution  
**Migration Script:** `WORKFLOW_NOMENCLATURE_MIGRATION.sh`  
**Validation:** Automated via script  
**Rollback:** Full backup preserved
