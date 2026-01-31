# Specialized Persona MCP Integration Guide

## Overview

This guide details how to integrate the Consolidated Agent Architecture with MCP servers, enabling Director agents to dynamically switch between specialized personas while leveraging existing infrastructure.

## Architecture Integration

```
Director Agents (9) with Specialized Personas (48+)
    ↓
MCP Tool Access:
    - Supabase MCP → Persona definitions and knowledge
    - Neo4j MCP → Agent relationships and knowledge graphs
    - Domain-specific MCPs → Specialized tools per persona
    ↓
Infrastructure Layer
```

## 1. Supabase MCP Integration

### Loading Specialized Personas

Using the Supabase MCP Server to retrieve persona definitions:

```javascript
// In Director agent workflow (n8n Code node)
const loadPersonas = async () => {
  // Get director agent ID
  const directorName = 'SalesDirectorAgent';
  const { data: director } = await $tools.supabase.execute({
    tool: "query-table",
    arguments: {
      table: "agents",
      filter: { name: directorName },
      limit: 1
    }
  });
  
  // Load personas for this director
  const { data: personas } = await $tools.supabase.execute({
    tool: "query-table",
    arguments: {
      table: "agent_personas",
      filter: { 
        director_agent_id: director[0].id,
        is_active: true
      }
    }
  });
  
  return personas;
};
```

### Detecting Appropriate Persona

```javascript
// Persona detection based on request
const detectPersona = async (request, personas) => {
  const requestText = request.message?.toLowerCase() || '';
  
  // Use Supabase function for intelligent matching
  const { data: match } = await $tools.supabase.execute({
    tool: "execute-sql",
    arguments: {
      sql: "SELECT * FROM detect_persona($1, $2)",
      params: [requestText, director[0].id]
    }
  });
  
  if (match && match.length > 0) {
    return personas.find(p => p.name === match[0].persona_name);
  }
  
  // Fallback to keyword matching
  for (const persona of personas) {
    const keywords = persona.activation_rules?.keywords || [];
    if (keywords.some(keyword => requestText.includes(keyword))) {
      return persona;
    }
  }
  
  return personas[0]; // Default persona
};
```

### Retrieving Persona Knowledge

```javascript
// Get specialized knowledge for active persona
const getPersonaKnowledge = async (persona, query) => {
  // Generate embedding for the query
  const embedding = await generateEmbedding(query);
  
  // Search persona's knowledge base
  const { data: knowledge } = await $tools.supabase.execute({
    tool: "execute-sql",
    arguments: {
      sql: "SELECT * FROM search_persona_knowledge($1, $2, $3)",
      params: [embedding, persona.knowledge_base_id, 5]
    }
  });
  
  return knowledge.map(k => k.content).join('\n\n');
};
```

## 2. Neo4j MCP Integration

### Query Persona Relationships

```javascript
// Using Neo4j Cypher MCP
const getPersonaContext = async (personaName) => {
  const result = await $tools.neo4j_cypher.execute({
    tool: "execute_query",
    arguments: {
      query: `
        MATCH (sp:SpecializedPersona {name: $personaName})
        OPTIONAL MATCH (sp)-[:USES_KNOWLEDGE]->(kb:PersonaKnowledge)
        OPTIONAL MATCH (sp)-[:INHERITS_KNOWLEDGE]->(c:Concept)
        OPTIONAL MATCH (sp)-[:SHARES_INSIGHTS_WITH]-(peer:SpecializedPersona)
        RETURN sp, 
               collect(DISTINCT kb.topics) as knowledge_topics,
               collect(DISTINCT c.name) as inherited_concepts,
               collect(DISTINCT peer.name) as peer_personas
      `,
      parameters: { personaName: personaName }
    }
  });
  
  return result;
};
```

### Store Persona Interactions

```javascript
// Log successful persona interactions
const logPersonaInteraction = async (persona, request, response) => {
  await $tools.neo4j_cypher.execute({
    tool: "execute_query",
    arguments: {
      query: `
        MATCH (sp:SpecializedPersona {id: $personaId})
        CREATE (i:Interaction {
          timestamp: datetime(),
          request_type: $requestType,
          success: $success,
          confidence: $confidence
        })
        CREATE (sp)-[:HAD_INTERACTION]->(i)
      `,
      parameters: {
        personaId: persona.id,
        requestType: detectRequestType(request),
        success: true,
        confidence: response.confidence || 0.9
      }
    }
  });
};
```

## 3. Enhanced Director Implementation

### Sales Director with Persona Support

```yaml
# In n8n Agent node configuration

system_message: |
  You are the Sales Director with multiple specialized personas.
  
  ## Current Configuration
  Director Name: {{ $json.director_name }}
  Active Persona: {{ $json.active_persona.name }}
  Persona Description: {{ $json.active_persona.description }}
  
  ## Persona Characteristics
  Communication Style: {{ $json.active_persona.communication_style }}
  Expertise Areas: {{ $json.active_persona.expertise }}
  
  ## Available Knowledge
  {{ $json.persona_knowledge }}
  
  ## Response Guidelines
  1. Embody the characteristics of {{ $json.active_persona.name }}
  2. Use domain-specific terminology from your expertise areas
  3. Maintain the appropriate tone and formality level
  4. Reference relevant knowledge when applicable
  
  ## Available MCP Tools
  - shopify_mcp: Product and order management
  - supabase_mcp: Data queries and knowledge retrieval  
  - neo4j_cypher_mcp: Relationship queries
  - linear_mcp: Task management

tools:
  - shopify_mcp
  - supabase_mcp
  - neo4j_cypher_mcp
  - linear_mcp
```

### Complete Workflow Structure

```javascript
// Pre-agent Code node: Initialize and detect persona
const initializePersona = async () => {
  // Load director info
  const director = await loadDirector($json.director_name);
  
  // Load available personas
  const personas = await loadPersonas(director.id);
  
  // Detect best matching persona
  const selectedPersona = await detectPersona($input.item.json, personas);
  
  // Get persona-specific knowledge
  const knowledge = await getPersonaKnowledge(
    selectedPersona, 
    $input.item.json.message
  );
  
  // Get Neo4j context
  const context = await getPersonaContext(selectedPersona.name);
  
  return {
    director_name: director.name,
    director_id: director.id,
    active_persona: selectedPersona,
    persona_knowledge: knowledge,
    persona_context: context,
    request: $input.item.json
  };
};

$json = await initializePersona();
```

### Post-agent Code node: Track performance

```javascript
// Track persona activation
const trackActivation = async () => {
  const startTime = $json.start_time;
  const responseTime = Date.now() - startTime;
  
  // Log to Supabase
  await $tools.supabase.execute({
    tool: "insert-data",
    arguments: {
      table: "persona_activations",
      data: {
        director_agent_id: $json.director_id,
        persona_name: $json.active_persona.name,
        request_context: {
          message: $json.request.message,
          type: $json.request.type
        },
        confidence_score: $json.agent_response.confidence || 0.85,
        success: true,
        response_time_ms: responseTime,
        session_id: $json.session_id
      }
    }
  });
  
  // Log to Neo4j for relationship tracking
  await logPersonaInteraction(
    $json.active_persona,
    $json.request,
    $json.agent_response
  );
};

await trackActivation();
```

## 4. Cross-Persona Knowledge Sharing

### Finding Related Personas

```javascript
// When a persona needs help from peers
const findRelatedPersonas = async (currentPersona, topic) => {
  const result = await $tools.neo4j_cypher.execute({
    tool: "execute_query",
    arguments: {
      query: `
        MATCH (current:SpecializedPersona {id: $personaId})
        MATCH (other:SpecializedPersona)-[:USES_KNOWLEDGE]->(kb:PersonaKnowledge)
        WHERE ANY(t IN kb.topics WHERE t CONTAINS $topic)
          AND other.id <> current.id
        RETURN other.name as persona_name,
               other.parent_director as director,
               kb.topics as expertise
        LIMIT 3
      `,
      parameters: {
        personaId: currentPersona.id,
        topic: topic
      }
    }
  });
  
  return result;
};
```

## 5. Dynamic Tool Assignment

### Persona-Specific Tool Access

```javascript
// Determine which MCP tools a persona should access
const getPersonaTools = (persona) => {
  const baseTools = ['supabase_mcp', 'neo4j_cypher_mcp'];
  
  const personaToolMap = {
    'Corporate Sales Specialist': ['shopify_mcp', 'linear_mcp', 'contract_mcp'],
    'Healthcare Sales Specialist': ['shopify_mcp', 'compliance_mcp'],
    'Social Media Manager': ['instagram_mcp', 'facebook_mcp', 'pinterest_mcp'],
    'Analytics Specialist': ['analytics_mcp', 'bigquery_mcp'],
    'Operations Specialist': ['inventory_mcp', 'shipping_mcp']
  };
  
  const specificTools = personaToolMap[persona.name] || [];
  return [...baseTools, ...specificTools];
};
```

## 6. Implementation Examples

### Example 1: Healthcare Sales Inquiry

```javascript
// Request: "We need artwork for our new medical center waiting rooms"

// 1. Persona Detection
const persona = "Healthcare Sales Specialist";

// 2. Knowledge Retrieval
const knowledge = await $tools.supabase.execute({
  tool: "execute-sql",
  arguments: {
    sql: `
      SELECT content FROM knowledge_entries 
      WHERE knowledge_base_id = 'healthcare_sales_kb'
      AND content ILIKE '%waiting room%' OR content ILIKE '%healing%'
      LIMIT 5
    `
  }
});

// 3. Response with persona characteristics
const response = {
  tone: "empathetic and professional",
  content: "I understand the importance of creating a calming environment...",
  suggestions: ["nature scenes", "abstract calming colors", "local landscapes"],
  compliance_notes: "All artwork can be printed on antimicrobial surfaces..."
};
```

### Example 2: Cross-Director Collaboration

```javascript
// Sales Director needs marketing materials
const requestMarketingHelp = async (topic) => {
  // Find Marketing Director's content specialist
  const marketingPersona = await findRelatedPersonas(
    $json.active_persona,
    'content creation'
  );
  
  // Create collaboration request
  await $tools.linear_mcp.execute({
    tool: "create-issue",
    arguments: {
      title: `Content needed: ${topic}`,
      description: `Sales persona ${$json.active_persona.name} needs marketing materials`,
      assignee: marketingPersona[0].director,
      labels: ['cross-director', 'content-request']
    }
  });
};
```

## 7. Monitoring and Analytics

### Real-time Persona Performance

```sql
-- Query via Supabase MCP
SELECT 
  ap.name as persona,
  COUNT(pa.id) as activations_today,
  AVG(pa.response_time_ms) as avg_response_time,
  AVG(pa.confidence_score) as avg_confidence
FROM agent_personas ap
JOIN persona_activations pa ON ap.name = pa.persona_name
WHERE pa.activation_time > CURRENT_DATE
GROUP BY ap.name
ORDER BY activations_today DESC;
```

### Knowledge Base Usage

```cypher
// Query via Neo4j MCP
MATCH (sp:SpecializedPersona)-[:HAD_INTERACTION]->(i:Interaction)
WHERE i.timestamp > datetime() - duration('P7D')
WITH sp, count(i) as interaction_count
MATCH (sp)-[:USES_KNOWLEDGE]->(kb:PersonaKnowledge)
RETURN sp.name as persona, 
       kb.name as knowledge_base,
       interaction_count,
       kb.topics as topics
ORDER BY interaction_count DESC
```

## 8. Best Practices

1. **Persona Consistency**: Cache active persona for session duration
2. **Knowledge Relevance**: Regularly update knowledge bases with new insights
3. **Tool Security**: Limit tool access based on persona responsibilities
4. **Performance**: Pre-load frequently used personas at startup
5. **Monitoring**: Track every persona switch and interaction

## 9. Troubleshooting

### Common Issues:

1. **Persona Not Detected**:
   ```javascript
   // Add debug logging
   console.log('Keywords searched:', keywords);
   console.log('Request text:', requestText);
   console.log('Matching personas:', matchingPersonas);
   ```

2. **Slow Knowledge Retrieval**:
   ```sql
   -- Check embedding index
   SELECT indexname, indexdef 
   FROM pg_indexes 
   WHERE tablename = 'knowledge_entries';
   ```

3. **MCP Connection Issues**:
   ```javascript
   // Test MCP connections
   try {
     await $tools.supabase.execute({ tool: "check-connection" });
     await $tools.neo4j_cypher.execute({ tool: "execute_query", arguments: { query: "RETURN 1" }});
   } catch (error) {
     console.error('MCP connection failed:', error);
   }
   ```

---

Last Updated: 2025-06-26
Version: 2.0