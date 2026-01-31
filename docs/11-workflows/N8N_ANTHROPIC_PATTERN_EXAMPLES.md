# n8n Implementation of Anthropic Patterns

## Overview

This document provides concrete n8n workflow examples implementing Anthropic's agent patterns for the VividWalls MAS optimization.

## 1. Routing Pattern Implementation

### Sales Router Workflow

```json
{
  "name": "Sales Operations Router",
  "nodes": [
    {
      "name": "Trigger",
      "type": "n8n-nodes-base.executeWorkflowTrigger",
      "position": [0, 0]
    },
    {
      "name": "Customer Classifier",
      "type": "n8n-nodes-base.code",
      "position": [200, 0],
      "parameters": {
        "jsCode": `
          const customer = $input.all()[0].json;
          
          // Classify customer based on data
          const classifiers = {
            hasHospitalDomain: (email) => email.includes('.health') || email.includes('hospital'),
            hasCorporateDomain: (email) => email.includes('.com') && !email.includes('gmail'),
            hasHotelIndicators: (data) => data.industry === 'hospitality' || data.company_type === 'hotel',
            isB2B: (data) => data.purchase_volume > 10 || data.tax_exempt === true
          };
          
          let segment = 'retail'; // default
          
          if (classifiers.hasHospitalDomain(customer.email)) {
            segment = 'healthcare';
          } else if (classifiers.hasCorporateDomain(customer.email)) {
            segment = 'corporate';
          } else if (classifiers.hasHotelIndicators(customer)) {
            segment = 'hospitality';
          } else if (classifiers.isB2B(customer)) {
            segment = 'b2b';
          }
          
          return {
            json: {
              ...customer,
              segment,
              routing_confidence: 0.85
            }
          };
        `
      }
    },
    {
      "name": "Load Persona Configuration",
      "type": "n8n-nodes-base.code",
      "position": [400, 0],
      "parameters": {
        "jsCode": `
          const segment = $input.all()[0].json.segment;
          
          const personas = {
            healthcare: {
              tone: "professional and compliant",
              focus: "healing environments, patient comfort",
              objections: ["infection control", "durability", "maintenance"],
              regulatory: ["HIPAA considerations", "fire ratings"]
            },
            corporate: {
              tone: "executive and ROI-focused",
              focus: "brand representation, employee satisfaction",
              objections: ["budget approval", "committee decisions", "brand guidelines"],
              approach: "consultative with data"
            },
            hospitality: {
              tone: "experiential and aesthetic",
              focus: "guest experience, ambiance creation",
              objections: ["durability", "cleaning requirements", "brand standards"],
              samples: "physical samples critical"
            }
          };
          
          return {
            json: {
              ...$input.all()[0].json,
              persona: personas[segment] || personas.retail
            }
          };
        `
      }
    },
    {
      "name": "Sales Specialist Agent",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [600, 0],
      "parameters": {
        "prompt": "={{ $fromAI('system_prompt') }}",
        "options": {
          "systemMessage": `You are a sales specialist for VividWalls premium wall art.
            
            Customer Segment: {{ $json.segment }}
            Persona Configuration: {{ JSON.stringify($json.persona) }}
            
            Adapt your communication style and approach based on the persona:
            - Tone: {{ $json.persona.tone }}
            - Focus Areas: {{ $json.persona.focus }}
            - Common Objections: {{ $json.persona.objections.join(', ') }}
            
            Customer Data: {{ JSON.stringify($json.customer) }}`
        }
      }
    }
  ]
}
```

## 2. Parallelization Pattern Implementation

### Marketing Campaign Parallel Execution

```json
{
  "name": "Campaign Parallel Execution",
  "nodes": [
    {
      "name": "Campaign Brief",
      "type": "n8n-nodes-base.executeWorkflowTrigger",
      "position": [0, 0]
    },
    {
      "name": "Split for Parallel",
      "type": "n8n-nodes-base.splitOut",
      "position": [200, 0],
      "parameters": {
        "options": {
          "outputs": 4
        }
      }
    },
    {
      "name": "Email Creation",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, -200],
      "parameters": {
        "prompt": "Create email campaign for: {{ $json.campaign_brief }}",
        "options": {
          "systemMessage": "You are an email marketing specialist. Create compelling email content."
        }
      }
    },
    {
      "name": "Social Media Content",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, -50],
      "parameters": {
        "prompt": "Create social media posts for: {{ $json.campaign_brief }}",
        "options": {
          "systemMessage": "You are a social media expert. Create platform-specific content."
        }
      }
    },
    {
      "name": "Landing Page Copy",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, 50],
      "parameters": {
        "prompt": "Write landing page copy for: {{ $json.campaign_brief }}",
        "options": {
          "systemMessage": "You are a conversion copywriter. Create high-converting landing page content."
        }
      }
    },
    {
      "name": "SEO Keywords",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, 200],
      "parameters": {
        "prompt": "Research SEO keywords for: {{ $json.campaign_brief }}",
        "options": {
          "systemMessage": "You are an SEO specialist. Identify high-value keywords."
        }
      }
    },
    {
      "name": "Merge Results",
      "type": "n8n-nodes-base.merge",
      "position": [600, 0],
      "parameters": {
        "mode": "combine",
        "combinationMode": "mergeByPosition",
        "options": {}
      }
    },
    {
      "name": "Aggregate Campaign Assets",
      "type": "n8n-nodes-base.code",
      "position": [800, 0],
      "parameters": {
        "jsCode": `
          const inputs = $input.all();
          
          return {
            json: {
              campaign_id: inputs[0].json.campaign_id,
              created_at: new Date().toISOString(),
              assets: {
                email: inputs[0].json.output,
                social: inputs[1].json.output,
                landing: inputs[2].json.output,
                keywords: inputs[3].json.output
              },
              status: 'ready_for_review'
            }
          };
        `
      }
    }
  ]
}
```

## 3. Evaluator-Optimizer Pattern Implementation

### Content Quality Loop

```json
{
  "name": "Content Evaluator-Optimizer",
  "nodes": [
    {
      "name": "Content Request",
      "type": "n8n-nodes-base.executeWorkflowTrigger",
      "position": [0, 0]
    },
    {
      "name": "Initial Content Generation",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [200, 0],
      "parameters": {
        "prompt": "Create content based on: {{ $json.brief }}",
        "options": {
          "systemMessage": "You are a content creator for VividWalls. Create engaging product descriptions."
        }
      }
    },
    {
      "name": "Quality Evaluator",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, 0],
      "parameters": {
        "prompt": "Evaluate this content for quality:\n\n{{ $json.content }}\n\nScore 0-100 and provide specific feedback.",
        "options": {
          "systemMessage": `You are a content quality evaluator. Assess:
            1. Brand voice alignment (20 points)
            2. SEO optimization (20 points)
            3. Emotional appeal (20 points)
            4. Technical accuracy (20 points)
            5. Call-to-action effectiveness (20 points)
            
            Return JSON: { score: number, feedback: string[], improvements: string[] }`
        }
      }
    },
    {
      "name": "Check Quality Threshold",
      "type": "n8n-nodes-base.if",
      "position": [600, 0],
      "parameters": {
        "conditions": {
          "number": [
            {
              "value1": "={{ $json.score }}",
              "operation": "largerEqual",
              "value2": 85
            }
          ]
        }
      }
    },
    {
      "name": "Content Optimizer",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, 200],
      "parameters": {
        "prompt": "Improve this content based on feedback:\n\nOriginal: {{ $json.content }}\n\nFeedback: {{ $json.feedback }}\n\nSuggested improvements: {{ $json.improvements }}",
        "options": {
          "systemMessage": "You are a content optimization specialist. Improve content while maintaining voice."
        }
      }
    },
    {
      "name": "Loop Controller",
      "type": "n8n-nodes-base.code",
      "position": [600, 200],
      "parameters": {
        "jsCode": `
          const iteration = $input.all()[0].json.iteration || 0;
          const maxIterations = 3;
          
          if (iteration >= maxIterations) {
            // Force accept after max iterations
            return {
              json: {
                ...$input.all()[0].json,
                forced_complete: true,
                final_score: $input.all()[0].json.score
              }
            };
          }
          
          return {
            json: {
              ...$input.all()[0].json,
              iteration: iteration + 1
            }
          };
        `
      }
    }
  ]
}
```

## 4. Orchestrator-Workers Pattern

### Business Manager Orchestration

```json
{
  "name": "Business Manager Orchestrator",
  "nodes": [
    {
      "name": "Incoming Request",
      "type": "n8n-nodes-base.webhook",
      "position": [0, 0],
      "parameters": {
        "path": "business-manager",
        "method": "POST"
      }
    },
    {
      "name": "Request Analyzer",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [200, 0],
      "parameters": {
        "prompt": "Analyze this request and determine required capabilities: {{ JSON.stringify($json) }}",
        "options": {
          "systemMessage": `You are the Business Manager orchestrator. Analyze requests and return:
            {
              "primary_domain": "marketing|sales|operations|analytics|finance",
              "required_capabilities": ["capability1", "capability2"],
              "parallel_possible": true|false,
              "estimated_complexity": "simple|moderate|complex",
              "recommended_agents": ["agent1", "agent2"]
            }`
        }
      }
    },
    {
      "name": "Parallel or Sequential",
      "type": "n8n-nodes-base.if",
      "position": [400, 0],
      "parameters": {
        "conditions": {
          "boolean": [
            {
              "value1": "={{ $json.parallel_possible }}",
              "value2": true
            }
          ]
        }
      }
    },
    {
      "name": "Parallel Worker Dispatch",
      "type": "n8n-nodes-base.code",
      "position": [600, -100],
      "parameters": {
        "jsCode": `
          const agents = $input.all()[0].json.recommended_agents;
          const request = $input.all()[0].json.original_request;
          
          // Create parallel execution plan
          const executions = agents.map(agent => ({
            workflowId: agent,
            data: {
              ...request,
              orchestrator_id: $execution.id,
              agent_role: agent
            }
          }));
          
          return executions.map(exec => ({ json: exec }));
        `
      }
    },
    {
      "name": "Execute Workers",
      "type": "n8n-nodes-base.executeWorkflow",
      "position": [800, -100],
      "parameters": {
        "workflowId": "={{ $json.workflowId }}",
        "workflowData": "={{ $json.data }}"
      }
    },
    {
      "name": "Sequential Coordinator",
      "type": "n8n-nodes-base.code",
      "position": [600, 100],
      "parameters": {
        "jsCode": `
          // Sequential execution with context passing
          const agents = $input.all()[0].json.recommended_agents;
          let context = $input.all()[0].json.original_request;
          const results = [];
          
          for (const agent of agents) {
            // Each agent would be called here with accumulated context
            // This is simplified - in practice use Execute Workflow nodes
            results.push({
              agent,
              context,
              timestamp: new Date().toISOString()
            });
            
            // Update context with results for next agent
            context = { ...context, previous_results: results };
          }
          
          return { json: { sequential_results: results } };
        `
      }
    },
    {
      "name": "Result Aggregator",
      "type": "n8n-nodes-base.code",
      "position": [1000, 0],
      "parameters": {
        "jsCode": `
          const results = $input.all();
          
          // Aggregate results from all workers
          const aggregated = {
            request_id: results[0].json.orchestrator_id,
            timestamp: new Date().toISOString(),
            execution_type: results[0].json.parallel_possible ? 'parallel' : 'sequential',
            results: results.map(r => ({
              agent: r.json.agent_role || r.json.agent,
              output: r.json.output || r.json,
              execution_time: r.json.execution_time
            })),
            summary: "Aggregated results from worker agents"
          };
          
          return { json: aggregated };
        `
      }
    }
  ]
}
```

## 5. Autonomous Agent Pattern

### Self-Directed Campaign Manager

```json
{
  "name": "Autonomous Campaign Agent",
  "nodes": [
    {
      "name": "Campaign Objective",
      "type": "n8n-nodes-base.executeWorkflowTrigger",
      "position": [0, 0]
    },
    {
      "name": "Initialize Agent State",
      "type": "n8n-nodes-base.code",
      "position": [200, 0],
      "parameters": {
        "jsCode": `
          return {
            json: {
              objective: $input.all()[0].json,
              state: 'planning',
              plan: null,
              completed_steps: [],
              pending_steps: [],
              iterations: 0,
              max_iterations: 20
            }
          };
        `
      }
    },
    {
      "name": "Autonomous Decision Loop",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [400, 0],
      "parameters": {
        "prompt": "Current state: {{ JSON.stringify($json) }}\n\nDecide next action.",
        "options": {
          "systemMessage": `You are an autonomous campaign agent. Based on the current state:
            
            1. If state is 'planning', create a campaign plan
            2. If state is 'executing', determine next step
            3. If state is 'blocked', identify resolution
            4. If state is 'reviewing', assess progress
            
            You have access to these tools:
            - create_content: Generate campaign content
            - schedule_posts: Schedule social media
            - analyze_performance: Check metrics
            - request_approval: Get human approval
            
            Return: { next_action: 'tool_name', parameters: {}, new_state: 'state' }`
        }
      }
    },
    {
      "name": "Execute Tool",
      "type": "n8n-nodes-base.switch",
      "position": [600, 0],
      "parameters": {
        "dataType": "string",
        "value1": "={{ $json.next_action }}",
        "rules": {
          "rules": [
            {
              "value2": "create_content",
              "output": 0
            },
            {
              "value2": "schedule_posts",
              "output": 1
            },
            {
              "value2": "analyze_performance",
              "output": 2
            },
            {
              "value2": "request_approval",
              "output": 3
            },
            {
              "value2": "complete",
              "output": 4
            }
          ]
        }
      }
    },
    {
      "name": "Check Completion",
      "type": "n8n-nodes-base.if",
      "position": [800, 0],
      "parameters": {
        "conditions": {
          "string": [
            {
              "value1": "={{ $json.new_state }}",
              "operation": "equals",
              "value2": "complete"
            }
          ],
          "number": [
            {
              "value1": "={{ $json.iterations }}",
              "operation": "larger",
              "value2": "={{ $json.max_iterations }}"
            }
          ]
        },
        "combineOperation": "any"
      }
    },
    {
      "name": "Update State and Loop",
      "type": "n8n-nodes-base.code",
      "position": [600, 200],
      "parameters": {
        "jsCode": `
          const current = $input.all()[0].json;
          
          return {
            json: {
              ...current,
              state: current.new_state,
              completed_steps: [...current.completed_steps, current.next_action],
              iterations: current.iterations + 1,
              last_action_result: current.tool_result
            }
          };
        `
      }
    }
  ]
}
```

## Best Practices for Pattern Implementation

### 1. Error Handling
```javascript
// Add to all patterns
try {
  // Pattern implementation
} catch (error) {
  return {
    json: {
      error: error.message,
      fallback: 'default_action',
      timestamp: new Date().toISOString()
    }
  };
}
```

### 2. Performance Monitoring
```javascript
// Track execution time
const startTime = Date.now();
// ... execute pattern ...
const executionTime = Date.now() - startTime;

// Log to monitoring
await logMetrics({
  pattern: 'parallelization',
  execution_time_ms: executionTime,
  success: true
});
```

### 3. Context Preservation
```javascript
// Maintain context across patterns
const context = {
  session_id: $input.all()[0].json.session_id || generateId(),
  user_id: $input.all()[0].json.user_id,
  history: $input.all()[0].json.history || [],
  pattern_chain: ['routing', 'parallelization', 'evaluator']
};
```

## Migration Helper

### Pattern Detection Code
```javascript
// Detect which pattern to apply
function detectOptimalPattern(workflow) {
  const patterns = {
    routing: hasMultipleConditionalPaths(workflow),
    parallelization: hasIndependentBranches(workflow),
    evaluator_optimizer: hasQualityChecks(workflow),
    orchestrator_workers: hasCoordinationLogic(workflow),
    autonomous: hasDecisionLoops(workflow)
  };
  
  return Object.entries(patterns)
    .filter(([_, applicable]) => applicable)
    .map(([pattern, _]) => pattern);
}
```