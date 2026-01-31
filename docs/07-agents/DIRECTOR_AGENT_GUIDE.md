# Director Agent Implementation Guide

## Overview

Director agents are the second tier in the VividWalls MAS hierarchy, reporting directly to the Business Manager and overseeing specialized agents in their domains. This guide provides detailed implementation patterns and best practices.

## Director Responsibilities

### Core Functions
1. **Domain Leadership**: Strategic oversight of specific business area
2. **Agent Coordination**: Managing specialized agents in their domain
3. **Decision Making**: Authority for domain-specific decisions
4. **Cross-Department Collaboration**: Working with other directors
5. **Escalation Management**: Elevating critical issues to Business Manager

## Standard Director Workflow Structure

### 1. Multiple Entry Points
```json
{
  "nodes": [
    {
      "name": "When Executed by Another Workflow",
      "type": "n8n-nodes-base.executeWorkflowTrigger",
      "description": "Called by Business Manager or other directors"
    },
    {
      "name": "When chat message received",
      "type": "@n8n/n8n-nodes-langchain.chatTrigger",
      "description": "Direct chat interface"
    },
    {
      "name": "Director Webhook",
      "type": "n8n-nodes-base.webhook",
      "description": "External API access"
    }
  ]
}
```

### 2. Context Loading
```javascript
// Standard context loader for directors
const context = {
  role: 'marketing_director',
  requester: $input.all()[0].json.requester || 'unknown',
  sessionId: $input.all()[0].json.sessionId || generateSessionId(),
  requestType: $input.all()[0].json.requestType,
  domain: 'marketing',
  authorityLevel: 'director',
  timestamp: new Date().toISOString()
};

// Load domain configuration
const domainConfig = await loadDomainConfig(context.domain);
const availableAgents = domainConfig.agents;
const mcpTools = domainConfig.mcpTools;
```

### 3. Request Analysis and Routing
```javascript
// Analyze request to determine handling strategy
const analysis = {
  complexity: assessComplexity(request),
  requiredCapabilities: identifyCapabilities(request),
  crossDepartment: requiresCrossDepartment(request),
  specialistNeeded: determineSpecialist(request)
};

// Route based on analysis
if (analysis.crossDepartment) {
  return routeToCrossDepartment(analysis);
} else if (analysis.specialistNeeded) {
  return delegateToSpecialist(analysis.specialistNeeded);
} else {
  return handleDirectly(request);
}
```

### 4. AI Agent Configuration
```javascript
// Director-level system prompt template
const systemPrompt = `
You are the ${context.domain} Director for VividWalls, a premium wall art company.

Your responsibilities:
- Strategic oversight of ${context.domain} operations
- Managing ${availableAgents.length} specialized agents
- Making domain-level decisions
- Coordinating with other directors when needed
- Escalating critical issues to the Business Manager

Available specialized agents:
${availableAgents.map(a => `- ${a.name}: ${a.description}`).join('\n')}

You have director-level authority to:
- Approve decisions within ${domainConfig.authorityLimits}
- Access comprehensive ${context.domain} data
- Direct specialized agents
- Initiate cross-department collaboration

Current context:
- Session: ${context.sessionId}
- Requester: ${context.requester}
- Request type: ${context.requestType}
`;
```

## Director-Specific Patterns

### 1. Marketing Director Pattern
```javascript
// Specialized for marketing operations
const marketingDirector = {
  domainExperts: [
    'content-strategy-agent',
    'campaign-manager-agent',
    'seo-specialist-agent',
    'social-media-coordinator-agent'
  ],
  
  routingLogic: (request) => {
    if (request.type === 'campaign') {
      return 'campaign-manager-agent';
    } else if (request.type === 'content') {
      return 'content-strategy-agent';
    }
    // ... additional routing
  },
  
  mcpTools: [
    'marketing-analytics-aggregator',
    'shopify-mcp-server',
    'social-media-tools'
  ]
};
```

### 2. Sales Director Pattern
```javascript
// Enhanced with persona management
const salesDirector = {
  personaSpecialists: {
    'hospitality': 'hospitality-sales-agent',
    'corporate': 'corporate-sales-agent',
    'healthcare': 'healthcare-sales-agent',
    'retail': 'retail-sales-agent',
    'residential': 'residential-sales-agent'
  },
  
  loadPersona: (customerId) => {
    const customerProfile = getCustomerProfile(customerId);
    return personaSpecialists[customerProfile.segment];
  },
  
  pricingAuthority: {
    discountLimit: 0.25,
    volumeThreshold: 10000,
    approvalRequired: false
  }
};
```

### 3. Analytics Director Pattern
```javascript
// Data-centric operations
const analyticsDirector = {
  dataSources: [
    'data-analytics-agent', // Single source of truth
    'marketing-analytics-aggregator',
    'business-scorecard-agent'
  ],
  
  aggregateData: async (request) => {
    const sources = identifyDataSources(request);
    const data = await Promise.all(
      sources.map(source => fetchFromAgent(source))
    );
    return consolidateData(data);
  },
  
  reportGeneration: {
    formats: ['dashboard', 'pdf', 'csv', 'api'],
    scheduling: ['realtime', 'daily', 'weekly', 'monthly']
  }
};
```

## Cross-Director Communication

### 1. Direct Communication
```javascript
// Marketing Director needs sales data
const salesData = await $executeWorkflow('sales-director-agent', {
  request: 'provide-quarterly-performance',
  requester: 'marketing-director',
  purpose: 'campaign-planning',
  format: 'summary'
});
```

### 2. Coordinated Operations
```javascript
// Multi-director collaboration
const projectTeam = [
  'marketing-director',
  'sales-director',
  'product-director'
];

const coordinatedAction = await Promise.all(
  projectTeam.map(director => 
    $executeWorkflow(`${director}-agent`, {
      action: 'new-product-launch',
      productId: 'wp-12345',
      phase: 'planning'
    })
  )
);
```

## MCP Tool Integration

### 1. Domain-Specific Tools
```javascript
// Marketing Director MCP tools
const marketingTools = [
  {
    name: 'marketing-analytics-aggregator',
    purpose: 'Consolidated marketing metrics',
    access: 'read'
  },
  {
    name: 'content-generator',
    purpose: 'AI content creation',
    access: 'read-write'
  },
  {
    name: 'social-media-scheduler',
    purpose: 'Post scheduling',
    access: 'read-write'
  }
];
```

### 2. Shared Tools
```javascript
// Tools available to all directors
const sharedTools = [
  'supabase-mcp-server',  // Database access
  'linear-mcp-server',    // Task management
  'stripe-mcp-server',    // Financial data
  'shopify-mcp-server'    // E-commerce data
];
```

## Memory and Context Management

### 1. Session Memory
```javascript
// PostgreSQL chat memory configuration
const memoryConfig = {
  sessionKey: `${context.domain}_director_${context.sessionId}`,
  tableName: 'agent_chat_memory',
  contextWindow: 20, // messages
  ttl: 86400 // 24 hours
};
```

### 2. Long-term Memory
```javascript
// Vector store for domain knowledge
const knowledgeStore = {
  collection: `${context.domain}_director_knowledge`,
  embedding: 'text-embedding-3-small',
  topK: 10,
  scoreThreshold: 0.7
};
```

## Error Handling and Escalation

### 1. Error Categories
```javascript
const errorHandling = {
  'specialist-unavailable': {
    action: 'fallback-to-director',
    notify: false
  },
  'authority-exceeded': {
    action: 'escalate-to-business-manager',
    notify: true
  },
  'cross-department-conflict': {
    action: 'coordinate-with-peer',
    notify: true
  },
  'data-inconsistency': {
    action: 'validate-with-analytics',
    notify: true
  }
};
```

### 2. Escalation Flow
```javascript
// Escalate to Business Manager
if (requiresEscalation(issue)) {
  const escalation = await $executeWorkflow('business-manager-agent', {
    type: 'escalation',
    from: context.role,
    issue: issue,
    recommendedAction: proposeAction(issue),
    urgency: assessUrgency(issue)
  });
  
  return handleEscalationResponse(escalation);
}
```

## Performance Monitoring

### 1. Director Metrics
```javascript
const directorMetrics = {
  responseTime: measureResponseTime(),
  decisionAccuracy: trackDecisionOutcomes(),
  agentUtilization: monitorAgentUsage(),
  crossDepartmentCollaboration: countCollaborations(),
  escalationRate: calculateEscalations()
};

// Store metrics
await storeMetrics('director_performance', directorMetrics);
```

### 2. Domain Health
```javascript
const domainHealth = {
  activeAgents: countActiveAgents(),
  queueDepth: checkQueueSizes(),
  errorRate: calculateErrorRate(),
  slaCompliance: checkSLAMetrics()
};
```

## Implementation Checklist

### Required Components
- [ ] Execute Workflow Trigger
- [ ] Chat Trigger (optional)
- [ ] Webhook Trigger (optional)
- [ ] Context Loader (Code node)
- [ ] Request Router (If node)
- [ ] AI Agent with System Prompt
- [ ] Memory (PostgreSQL)
- [ ] MCP Tool connections
- [ ] Response Handler
- [ ] Error Handler

### Configuration Requirements
- [ ] Unique workflow ID
- [ ] Descriptive name
- [ ] Domain-specific system prompt
- [ ] Appropriate MCP tools
- [ ] Memory configuration
- [ ] Specialist agent mappings
- [ ] Authority limits defined

### Testing Requirements
- [ ] Unit tests for routing logic
- [ ] Integration tests with specialists
- [ ] Cross-director communication tests
- [ ] Escalation flow tests
- [ ] Performance benchmarks

## Best Practices

1. **Clear Authority Boundaries**: Define what directors can approve vs. escalate
2. **Efficient Routing**: Minimize hops to specialist agents
3. **Context Preservation**: Maintain context across agent calls
4. **Graceful Degradation**: Handle specialist failures elegantly
5. **Audit Trail**: Log all director-level decisions
6. **Performance Monitoring**: Track response times and accuracy
7. **Regular Calibration**: Update routing rules based on outcomes

## Common Pitfalls

1. **Over-centralization**: Don't make directors bottlenecks
2. **Under-delegation**: Let specialists handle routine tasks
3. **Context Loss**: Preserve context in multi-agent flows
4. **Circular Dependencies**: Avoid director-to-director loops
5. **Authority Confusion**: Clear escalation thresholds

## Advanced Patterns

### 1. Parallel Specialist Execution
```javascript
// Execute multiple specialists concurrently
const parallelResults = await Promise.all([
  $executeWorkflow('content-agent', contentRequest),
  $executeWorkflow('seo-agent', seoRequest),
  $executeWorkflow('social-agent', socialRequest)
]);
```

### 2. Conditional Specialist Chains
```javascript
// Chain specialists based on results
const initialResult = await executeSpecialist('lead-qualifier');
if (initialResult.qualified) {
  const quoteResult = await executeSpecialist('quote-generator');
  if (quoteResult.approved) {
    return await executeSpecialist('order-processor');
  }
}
```

### 3. Dynamic Team Assembly
```javascript
// Assemble team based on request
const team = assembleTeam(request.requirements);
const results = await coordinateTeam(team, request);
return aggregateTeamResults(results);
```