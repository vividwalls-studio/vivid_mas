# Consolidated Agent Architecture for VividMAS

## Executive Summary

This plan implements a **Consolidated Agent Architecture** that maintains 48+ specialized agent capabilities while streamlining execution through enhanced Director agents. This approach reduces coordination complexity while preserving the specialized expertise required for each business function.

## Architecture Overview

### Three-Layer Architecture

```
Specialized Agent Layer (48+ Agent Personas)
    ↕️
Director Agent Layer (9 Enhanced Directors)
    ↕️
Infrastructure Layer (Databases, APIs, MCP Tools)
```

### Key Concepts

1. **Director Agents**: The primary n8n workflow agents that orchestrate operations
2. **Specialized Agent Personas**: Role-specific capabilities embedded within Directors
3. **Task Agents**: Existing specialized agents for specific operations (e.g., social media platforms)

## Agent Taxonomy

### 1. Director Agents (9 Total)
Primary orchestration agents with enhanced capabilities:

```yaml
director_agent:
  type: "director"
  name: "Sales Director"
  workflow_id: "sales_director_workflow"
  capabilities:
    - multi_persona_support
    - dynamic_role_switching
    - specialized_knowledge_access
  personas:
    - corporate_sales_specialist
    - healthcare_sales_specialist
    - hospitality_sales_specialist
    - retail_sales_specialist
    - designer_partnership_specialist
```

### 2. Specialized Agent Personas (48+ Total)
Lightweight role definitions activated within Directors:

```yaml
specialized_persona:
  name: "Corporate Sales Specialist"
  parent_director: "Sales Director"
  activation_context:
    keywords: ["corporate", "B2B", "enterprise", "bulk"]
    customer_type: "business"
  knowledge_base: "corporate_sales_kb"
  communication_style:
    tone: "professional, consultative"
    expertise: ["B2B sales", "contract negotiation", "bulk pricing"]
```

### 3. Task Agents (Existing)
Specialized workflow agents for specific tasks:
- Platform agents (Instagram, Facebook, Pinterest)
- Analytics task agents
- Communication task agents

## Implementation Architecture

### Enhanced Director Agent Structure

```javascript
class EnhancedDirectorAgent {
  constructor(config) {
    this.name = config.name;
    this.type = "director";
    this.personas = this.loadPersonas();
    this.activePersona = null;
    this.knowledgeBases = new Map();
  }
  
  async processRequest(request) {
    // 1. Detect appropriate persona
    const persona = this.detectPersona(request);
    
    // 2. Activate persona context
    await this.activatePersona(persona);
    
    // 3. Process with specialized knowledge
    return await this.executeWithPersona(request);
  }
  
  detectPersona(request) {
    // Match request to appropriate specialized persona
    for (const persona of this.personas) {
      if (this.matchesActivationRules(request, persona.rules)) {
        return persona;
      }
    }
    return this.defaultPersona;
  }
}
```

### Database Schema Updates

#### Existing Agents Table Enhancement
```sql
-- Add persona support to existing agents table
ALTER TABLE agents ADD COLUMN IF NOT EXISTS personas JSONB DEFAULT '[]'::jsonb;
ALTER TABLE agents ADD COLUMN IF NOT EXISTS active_persona VARCHAR(255);
ALTER TABLE agents ADD COLUMN IF NOT EXISTS persona_knowledge_bases JSONB DEFAULT '{}'::jsonb;

-- Create specialized personas table
CREATE TABLE IF NOT EXISTS agent_personas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  director_agent_id UUID NOT NULL REFERENCES agents(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  activation_rules JSONB NOT NULL,
  knowledge_base_id VARCHAR(255),
  communication_style JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(director_agent_id, name)
);

-- Track persona usage
CREATE TABLE IF NOT EXISTS persona_activations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  director_agent_id UUID NOT NULL REFERENCES agents(id),
  persona_name VARCHAR(255) NOT NULL,
  activation_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  request_context JSONB,
  success BOOLEAN DEFAULT true,
  response_time_ms INTEGER
);
```

### Neo4j Schema Updates

```cypher
// Update existing Agent nodes to support personas
MATCH (a:Agent {type: 'director'})
SET a.enhanced = true,
    a.supports_personas = true,
    a.max_personas = 15;

// Create SpecializedPersona nodes
CREATE (sp:SpecializedPersona {
  id: 'corp_sales_persona',
  name: 'Corporate Sales Specialist',
  director: 'Sales Director',
  created_at: datetime()
});

// Link personas to directors
MATCH (sp:SpecializedPersona), (d:Agent)
WHERE sp.director = d.name
CREATE (sp)-[:EMBEDDED_IN]->(d);

// Create knowledge relationships
MATCH (sp:SpecializedPersona), (k:Knowledge)
WHERE k.domain = sp.specialty
CREATE (sp)-[:ACCESSES]->(k);
```

## Implementation Phases

### Phase 1: Sales Director Enhancement (Week 1-2)

1. **Update Sales Director Workflow**
```yaml
# n8n workflow configuration
nodes:
  - name: "Persona Detector"
    type: "code"
    code: |
      const personas = {
        corporate: {
          keywords: ['corporate', 'B2B', 'enterprise'],
          knowledge: 'corporate_sales_kb'
        },
        healthcare: {
          keywords: ['medical', 'hospital', 'clinic'],
          knowledge: 'healthcare_sales_kb'
        }
      };
      
      // Detect and activate appropriate persona
      const detected = detectPersona($input.message, personas);
      $json.activePersona = detected;
      
  - name: "AI Agent"
    type: "agent"
    system_message: |
      You are the Sales Director Agent.
      Active Persona: {{ $json.activePersona.name }}
      Specialized Knowledge: {{ $json.activePersona.knowledge }}
      
      Respond with the expertise and tone appropriate for {{ $json.activePersona.name }}.
```

2. **Create Persona Definitions**
```sql
-- Insert Sales Director personas
INSERT INTO agent_personas (director_agent_id, name, activation_rules, knowledge_base_id)
SELECT 
  a.id,
  'Corporate Sales Specialist',
  '{"keywords": ["corporate", "B2B", "enterprise"], "min_order_value": 5000}',
  'corporate_sales_kb'
FROM agents a WHERE a.name = 'SalesDirectorAgent';
```

### Phase 2: Knowledge Base Integration (Week 3-4)

1. **Segment-Specific Knowledge Bases**
```sql
-- Create knowledge bases if not exists
INSERT INTO knowledge_bases (id, name, description, agent_type)
VALUES 
  ('corporate_sales_kb', 'Corporate Sales Knowledge', 'B2B strategies and enterprise sales', 'sales'),
  ('healthcare_sales_kb', 'Healthcare Sales Knowledge', 'Medical compliance and healthcare sales', 'sales')
ON CONFLICT (id) DO NOTHING;
```

2. **Knowledge Retrieval Pattern**
```javascript
// In Director agent workflow
async function getPersonaKnowledge(persona, query) {
  const kb = knowledgeBases[persona.knowledge_base_id];
  
  // Generate embedding
  const embedding = await generateEmbedding(query);
  
  // Search knowledge base
  const results = await searchKnowledge(embedding, kb.id);
  
  return results.map(r => r.content).join('\n');
}
```

### Phase 3: Resilience Implementation (Week 5-6)

1. **Circuit Breaker Pattern**
```javascript
class DirectorCircuitBreaker {
  constructor(director) {
    this.director = director;
    this.failures = 0;
    this.threshold = 3;
    this.timeout = 60000;
    this.state = 'CLOSED';
  }
  
  async execute(request) {
    if (this.state === 'OPEN' && !this.canRetry()) {
      // Fallback to base director capabilities
      return this.fallbackExecution(request);
    }
    
    try {
      const result = await this.director.processRequest(request);
      this.reset();
      return result;
    } catch (error) {
      this.recordFailure();
      throw error;
    }
  }
}
```

2. **Clarification Protocols**
```yaml
clarification_rules:
  ambiguity_threshold: 0.7
  max_clarifications: 2
  templates:
    segment_unclear: "I can help with {detected_options}. Which area are you interested in?"
    missing_info: "To provide the best assistance, could you specify {required_field}?"
```

### Phase 4: Full Rollout (Week 7-8)

Apply the same pattern to other directors:

- **Marketing Director**: Content, Social Media, Email, SEO personas
- **Analytics Director**: Performance, Predictive, Real-time personas
  - MCPs: Marketing Analytics Aggregator, Analytics Director Prompts/Resource, Data Analytics Prompts/Resource
- **Operations Director**: Inventory, Fulfillment, Supply Chain personas
- **Customer Experience Director**: Support, Success, Retention personas

## Monitoring and Analytics

### Performance Tracking
```sql
CREATE VIEW director_performance AS
SELECT 
  d.name as director,
  COUNT(DISTINCT pa.persona_name) as personas_used,
  AVG(pa.response_time_ms) as avg_response_time,
  COUNT(pa.id) as total_activations,
  SUM(CASE WHEN pa.success THEN 1 ELSE 0 END)::FLOAT / COUNT(*) as success_rate
FROM agents d
JOIN persona_activations pa ON d.id = pa.director_agent_id
WHERE d.type = 'director'
  AND pa.activation_time > NOW() - INTERVAL '24 hours'
GROUP BY d.name;
```

### Usage Analytics
```sql
-- Most used personas
SELECT 
  persona_name,
  COUNT(*) as usage_count,
  AVG(response_time_ms) as avg_response
FROM persona_activations
WHERE activation_time > NOW() - INTERVAL '7 days'
GROUP BY persona_name
ORDER BY usage_count DESC;
```

## Benefits of This Architecture

1. **Reduced Complexity**: 9 directors vs 48+ separate agents
2. **Maintained Specialization**: All 48+ specialized capabilities preserved
3. **Better Resource Usage**: Shared infrastructure and knowledge
4. **Improved Reliability**: Fewer points of failure
5. **Easier Maintenance**: Update personas without changing workflows
6. **Dynamic Scaling**: Add new personas without new agents

## Migration Checklist

- [ ] Update database schema with persona support
- [ ] Enhance Sales Director with persona capabilities
- [ ] Create persona definitions for all specializations
- [ ] Set up knowledge bases for each persona
- [ ] Implement resilience patterns
- [ ] Update monitoring dashboards
- [ ] Test persona switching
- [ ] Document new architecture
- [ ] Train team on new patterns
- [ ] Archive unnecessary workflow files

## Success Metrics

- **Agent Count**: 48+ → 9 directors + existing task agents
- **Coordination Messages**: -70% reduction
- **Response Time**: <2s for 95% of requests
- **Specialization Quality**: No degradation
- **System Uptime**: >99.5%

---

Last Updated: 2025-06-26
Version: 2.0
Architecture: Consolidated Agent Model with Specialized Personas