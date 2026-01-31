# Agent Terminology Update

## Standardized Terminology for VividWalls MAS

### Previous Terminology (Confusing)
- "Virtual Agents" vs "Execution Agents"
- "Physical Agents" vs "Virtual Agents"
- "Consolidated Agents" vs "Specialized Agents"

### New Standardized Terminology

#### 1. **Director Agents**
- **Definition**: The orchestrating n8n workflows that manage departments
- **Examples**: Sales Director Agent, Marketing Director Agent, Analytics Director Agent
- **Count**: ~9 director-level workflows
- **Characteristics**:
  - Actual n8n workflows that execute
  - Have decision-making capabilities
  - Can embody multiple specialist personas
  - Coordinate with other directors

#### 2. **Specialist Agents**
- **Definition**: The specialized roles/personas that Directors can embody
- **Examples**: Corporate Sales Specialist, Healthcare Sales Specialist, Hospitality Sales Specialist
- **Count**: 48+ specialist roles
- **Characteristics**:
  - Personas within Director workflows
  - Specific knowledge domains
  - Industry-specific communication styles
  - Not separate workflows

#### 3. **Platform Agents**
- **Definition**: Direct integration agents for external platforms
- **Examples**: Instagram Agent, Facebook Agent, Shopify Agent
- **Characteristics**:
  - Handle platform-specific APIs
  - Manage rate limits and authentication
  - Report to relevant Directors

#### 4. **Orchestrator Agent**
- **Definition**: The top-level Business Manager Agent
- **Single Instance**: Business Manager Agent
- **Characteristics**:
  - Coordinates all Directors
  - Strategic decision making
  - Stakeholder communication

## Architecture with New Terminology

```
Business Manager Agent (Orchestrator)
├── Director Agents (9 Orchestrating Workflows)
│   ├── Sales Director Agent
│   │   ├── Commercial Specialist Personas (5)
│   │   │   ├── Corporate Sales Specialist
│   │   │   ├── Healthcare Sales Specialist
│   │   │   ├── Hospitality Sales Specialist
│   │   │   ├── Retail Sales Specialist
│   │   │   └── Real Estate Sales Specialist
│   │   ├── Residential Specialist Personas (5)
│   │   │   ├── Homeowner Sales Specialist
│   │   │   ├── Renter Sales Specialist
│   │   │   ├── Interior Designer Sales Specialist
│   │   │   ├── Art Collector Sales Specialist
│   │   │   └── Gift Buyer Sales Specialist
│   │   └── Digital Specialist Personas (2)
│   │       ├── Millennial/Gen Z Sales Specialist
│   │       └── Global Customer Sales Specialist
│   │
│   ├── Marketing Director Agent
│   │   └── Marketing Specialist Personas
│   │
│   ├── Analytics Director Agent
│   │   ├── Performance Analytics Specialist
│   │   └── Data Insights Specialist
│   │
│   └── [Other Director Agents...]
│
└── Platform Agents (Direct Integrations)
    ├── Shopify Agent
    ├── Instagram Agent
    ├── Facebook Agent
    └── Pinterest Agent
```

## Implementation with New Terminology

### Director Agent Enhancement
```python
class SalesDirectorAgent:
    """
    Sales Director Agent - Orchestrating n8n workflow
    Can embody multiple Specialist Agent personas
    """
    def __init__(self):
        self.specialist_personas = {
            'corporate': CorporateSalesSpecialist(),
            'healthcare': HealthcareSalesSpecialist(),
            'hospitality': HospitalitySalesSpecialist()
        }
    
    def handle_request(self, request):
        # Detect which specialist persona to use
        specialist = self.detect_specialist_need(request)
        
        # Embody the specialist persona
        return self.specialist_personas[specialist].process(request)
```

### Specialist Agent Definition
```python
class CorporateSalesSpecialist:
    """
    Corporate Sales Specialist - A persona within Sales Director Agent
    Not a separate workflow, but specialized knowledge and behavior
    """
    def __init__(self):
        self.knowledge_base = "corporate_sales_kb"
        self.communication_style = "professional_consultative"
        self.tools = ["shopify_b2b", "quote_generator", "contract_manager"]
```

## Benefits of New Terminology

1. **Clarity**: Clear distinction between workflows and personas
2. **Hierarchy**: Reflects actual organizational structure
3. **Accuracy**: All agents are digital, no physical/virtual confusion
4. **Consistency**: Aligns with business terminology

## Migration Notes

### Documentation Updates Required:
1. PLAN.md - Update to use Director/Specialist terminology
2. Virtual Agent Framework - Rename to "Specialist Persona Framework"
3. Consolidation Plan - Update to "Director Enhancement Plan"
4. All workflow JSONs - Update descriptions

### Code Updates Required:
1. Variable names: `virtual_agent_id` → `specialist_persona_id`
2. Class names: `VirtualAgentRegistry` → `SpecialistPersonaRegistry`
3. Function names: `load_virtual_agent()` → `load_specialist_persona()`

## Summary

The new terminology provides a clearer mental model:
- **Director Agents**: The managers (actual n8n workflows)
- **Specialist Agents**: The experts they can become (personas)
- **Platform Agents**: The tool operators (API integrations)
- **Orchestrator Agent**: The CEO (Business Manager)

This aligns with both the technical implementation and business understanding.