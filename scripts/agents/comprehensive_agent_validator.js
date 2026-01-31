#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { validateWorkflow } = require('../services/n8n/n8n-workflow-validator.js');

// Configuration
const WORKFLOW_DIRS = [
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core',
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/integrations',
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/processes',
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/specialized'
];

// Agent MCP Tool Mappings
const AGENT_MCP_TOOLS = {
  'MARKETING_director': {
    tools: ['postiz-mcp', 'facebook-ads-mcp', 'marketing-analytics-aggregator', 'linear-mcp'],
    prompts: 'marketing-director-prompts',
    resource: 'marketing-director-resource',
    vectorStore: { domain: 'marketing', agent_type: 'director' }
  },
  'SALES_director': {
    tools: ['shopify-mcp', 'twenty-mcp', 'stripe-mcp', 'linear-mcp'],
    prompts: 'sales-director-prompts',
    resource: 'sales-director-resource',
    vectorStore: { domain: 'sales', agent_type: 'director' }
  },
  'OPERATIONS_director': {
    tools: ['medusa-mcp', 'shopify-mcp', 'pictorem-mcp', 'linear-mcp'],
    prompts: 'operations-director-prompts',
    resource: 'operations-director-resource',
    vectorStore: { domain: 'operations', agent_type: 'director' }
  },
  'FINANCE_director': {
    tools: ['stripe-mcp', 'supabase-mcp', 'linear-mcp'],
    prompts: 'finance-director-prompts',
    resource: 'finance-director-resource',
    vectorStore: { domain: 'finance', agent_type: 'director' }
  },
  'ANALYTICS_director': {
    tools: ['supabase-mcp', 'kpi-dashboard-mcp', 'marketing-analytics-aggregator', 'linear-mcp'],
    prompts: 'analytics-director-prompts',
    resource: 'analytics-director-resource',
    vectorStore: { domain: 'analytics', agent_type: 'director' }
  },
  'TECHNOLOGY_director': {
    tools: ['n8n-mcp', 'wordpress-mcp', 'supabase-mcp', 'linear-mcp'],
    prompts: 'technology-director-prompts',
    resource: 'technology-director-resource',
    vectorStore: { domain: 'technology', agent_type: 'director' }
  },
  'CREATIVE_director': {
    tools: ['pictorem-mcp', 'image-picker-mcp', 'linear-mcp'],
    prompts: 'creative-director-prompts',
    resource: 'creative-director-resource',
    vectorStore: { domain: 'creative', agent_type: 'director' }
  },
  'PRODUCT_director': {
    tools: ['shopify-mcp', 'medusa-mcp', 'supabase-mcp', 'linear-mcp'],
    prompts: 'product-director-prompts',
    resource: 'product-director-resource',
    vectorStore: { domain: 'product', agent_type: 'director' }
  },
  'CUSTOMER_EXPERIENCE_director': {
    tools: ['twenty-mcp', 'listmonk-mcp', 'supabase-mcp', 'linear-mcp'],
    prompts: 'customer-experience-director-prompts',
    resource: 'customer-experience-director-resource',
    vectorStore: { domain: 'customer_experience', agent_type: 'director' }
  },
  'BUSINESS_MANAGEMENT_director': {
    tools: ['linear-mcp', 'supabase-mcp', 'kpi-dashboard-mcp'],
    prompts: 'business-manager-prompts',
    resource: 'business-manager-resource',
    vectorStore: { domain: 'business_management', agent_type: 'orchestrator' }
  }
};

// Generate webhook ID
function generateWebhookId() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Create MCP tool node
function createMCPToolNode(toolName, position, agentType) {
  return {
    "parameters": {
      "operation": "executeTool",
      "toolName": `={{ $fromAI('tool_name', 'Tool for ${toolName}') }}`,
      "toolParameters": `={{ $fromAI('tool_parameters', '${toolName} parameters in JSON format') }}`
    },
    "type": "n8n-nodes-mcp.mcpClient",
    "typeVersion": 1,
    "position": position,
    "id": `${toolName}-${Date.now()}`,
    "name": `${toolName.replace('-mcp', '').replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase())} MCP`,
    "credentials": {
      "mcpCredentialsApi": {
        "id": `${toolName}-credentials`,
        "name": `${toolName.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase())} MCP Server`
      }
    }
  };
}

// Create prompt MCP node
function createPromptMCPNode(promptServer, position) {
  return {
    "parameters": {
      "operation": "getPrompt",
      "promptName": `={{ $fromAI('prompt_name', 'Select appropriate prompt') }}`
    },
    "type": "n8n-nodes-mcp.mcpClient",
    "typeVersion": 1,
    "position": position,
    "id": `${promptServer}-${Date.now()}`,
    "name": "Agent Prompts MCP",
    "credentials": {
      "mcpCredentialsApi": {
        "id": `${promptServer}-credentials`,
        "name": `${promptServer.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase())} MCP Server`
      }
    }
  };
}

// Create resource MCP node
function createResourceMCPNode(resourceServer, position) {
  return {
    "parameters": {
      "operation": "readResource",
      "resourceUri": `={{ $fromAI('resource_uri', 'Resource URI for agent data') }}`
    },
    "type": "n8n-nodes-mcp.mcpClient",
    "typeVersion": 1,
    "position": position,
    "id": `${resourceServer}-${Date.now()}`,
    "name": "Agent Resources MCP",
    "credentials": {
      "mcpCredentialsApi": {
        "id": `${resourceServer}-credentials`,
        "name": `${resourceServer.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase())} MCP Server`
      }
    }
  };
}

// Create vector store node
function createVectorStoreNode(metadata, position) {
  return {
    "parameters": {
      "mode": "retrieve-as-tool",
      "toolDescription": `Domain knowledge for ${metadata.domain} ${metadata.agent_type}`,
      "tableName": {
        "__rl": true,
        "value": "agent_domain_knowledge",
        "mode": "list"
      },
      "options": {
        "metadata": {
          "metadataValues": [
            {
              "name": "domain",
              "value": `={{ $fromAI('domain', '${metadata.domain}') }}`
            },
            {
              "name": "agent_type",
              "value": `={{ $fromAI('agent_type', '${metadata.agent_type}') }}`
            }
          ]
        }
      }
    },
    "type": "@n8n/n8n-nodes-langchain.vectorStoreSupabase",
    "typeVersion": 1.3,
    "position": position,
    "id": `vector-store-${Date.now()}`,
    "name": "Agent Domain Vector Store",
    "credentials": {
      "supabaseApi": {
        "id": "supabase-credentials",
        "name": "Supabase account"
      }
    }
  };
}

// Create workflow execution node
function createWorkflowExecutionNode(position, agentName) {
  return {
    "parameters": {
      "workflowId": `={{ $fromAI('subagent_workflow_id', 'ID of subagent workflow to execute') }}`,
      "workflowInputs": {
        "values": {
          "request": "={{ $json.request }}",
          "context": "={{ $json.context }}",
          "pattern": "={{ $json.pattern }}",
          "requester": agentName.toLowerCase().replace('_director', ''),
          "sessionId": "={{ $json.sessionId }}"
        }
      },
      "options": {
        "waitForSubWorkflow": `={{ $fromAI('wait_mode', 'false for async parallel execution, true for sequential') }}`
      }
    },
    "type": "n8n-nodes-base.executeWorkflow",
    "typeVersion": 1,
    "position": position,
    "id": `execute-subagent-${Date.now()}`,
    "name": "Execute Subagent Workflow"
  };
}

// Create human-in-the-loop nodes
function createHumanInLoopNodes(workflow, agentName) {
  const nodes = [];
  
  // 1. Initial response with execution ID
  const responseNode = {
    "parameters": {
      "respondWith": "json",
      "responseBody": `{
  "xid": "{{ $execution.id }}",
  "workflow": "{{ $workflow.name }}",
  "agent": "${agentName}",
  "timestamp": "{{ $now.toISO() }}",
  "status": "pending_review"
}`,
      "options": {}
    },
    "type": "n8n-nodes-base.respondToWebhook",
    "typeVersion": 1.1,
    "position": [300, 100],
    "id": `respond-with-xid-${Date.now()}`,
    "name": "Respond with Execution ID"
  };
  
  // 2. Wait for request review
  const waitRequestNode = {
    "parameters": {
      "resume": "webhook",
      "httpMethod": "POST",
      "options": {
        "responseHeaders": {
          "entries": [
            {
              "name": "Content-Type",
              "value": "application/json"
            }
          ]
        }
      }
    },
    "type": "n8n-nodes-base.wait",
    "typeVersion": 1.1,
    "position": [500, 100],
    "id": `wait-request-review-${Date.now()}`,
    "name": "Wait for Request Review",
    "webhookId": generateWebhookId()
  };
  
  // 3. Wait for delegation approval
  const waitDelegationNode = {
    "parameters": {
      "resume": "webhook",
      "httpMethod": "POST",
      "options": {
        "responseData": {
          "delegation_plan": "={{ $json.delegationPlan }}",
          "subagents": "={{ $json.selectedSubagents }}",
          "estimated_time": "={{ $json.estimatedTime }}"
        }
      }
    },
    "type": "n8n-nodes-base.wait",
    "typeVersion": 1.1,
    "position": [700, 100],
    "id": `wait-delegation-approval-${Date.now()}`,
    "name": "Wait for Delegation Approval",
    "webhookId": generateWebhookId()
  };
  
  // 4. Wait for response review
  const waitResponseNode = {
    "parameters": {
      "resume": "webhook",
      "httpMethod": "POST",
      "options": {
        "responseData": {
          "aggregated_results": "={{ $json.results }}",
          "recommendations": "={{ $json.recommendations }}"
        }
      }
    },
    "type": "n8n-nodes-base.wait",
    "typeVersion": 1.1,
    "position": [900, 100],
    "id": `wait-response-review-${Date.now()}`,
    "name": "Wait for Response Review",
    "webhookId": generateWebhookId()
  };
  
  return [responseNode, waitRequestNode, waitDelegationNode, waitResponseNode];
}

// Enhanced system prompt with tool instructions
function createEnhancedSystemPrompt(agentType, mcpTools) {
  const toolDescriptions = mcpTools.tools.map(tool => 
    `- ${tool}: Use for ${tool.replace('-mcp', '').replace(/-/g, ' ')} operations`
  ).join('\\n');
  
  return `You are the ${agentType.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())} for VividWalls with advanced capabilities.

AVAILABLE TOOLS AND THEIR USAGE:

MCP TOOLS:
${toolDescriptions}
- linear-mcp: Create and track tasks across teams

WORKFLOW EXECUTION:
- execute_workflow: Delegate tasks to subagents
- Use async (waitForSubWorkflow: false) for parallel independent tasks
- Use sync (waitForSubWorkflow: true) when results are needed sequentially

VECTOR STORE:
- Query domain knowledge before making decisions
- Filter by metadata: domain="${mcpTools.vectorStore.domain}", agent_type="${mcpTools.vectorStore.agent_type}"
- Use for context and best practices retrieval

PROMPTS & RESOURCES:
- Use ${mcpTools.prompts} for standardized communication templates
- Access ${mcpTools.resource} for configuration and business rules

DECISION PROCESS:
1. Analyze request complexity and required domains
2. Query vector store for relevant context
3. Determine if self-handling or delegation needed
4. Choose execution pattern:
   - routing: Single domain, direct handling
   - parallelization: Multiple independent tasks
   - orchestrator-workers: Complex coordinated efforts
   - evaluator-optimizer: Quality-critical iterations
5. Select appropriate tools and/or subagents
6. Execute with proper error handling
7. Aggregate and validate results

DELEGATION GUIDELINES:
- Delegate when task requires specialized domain expertise
- Use parallel execution for independent subtasks
- Monitor progress and handle failures
- Aggregate results before responding

Always provide clear reasoning for your decisions and maintain audit trail.`;
}

// Check if workflow has required components
function checkWorkflowComponents(workflow, agentType) {
  const issues = [];
  const mcpConfig = AGENT_MCP_TOOLS[agentType];
  
  if (!mcpConfig) {
    return { issues: [`No MCP configuration found for ${agentType}`], missing: {} };
  }
  
  // Check for MCP tools
  const existingTools = [];
  const missingTools = [];
  
  mcpConfig.tools.forEach(tool => {
    const hasNode = workflow.nodes?.some(node => 
      node.type === 'n8n-nodes-mcp.mcpClient' && 
      (node.name?.toLowerCase().includes(tool.replace('-mcp', '')) || 
       node.credentials?.mcpCredentialsApi?.id?.includes(tool))
    );
    
    if (hasNode) {
      existingTools.push(tool);
    } else {
      missingTools.push(tool);
    }
  });
  
  // Check for prompt MCP
  const hasPromptMCP = workflow.nodes?.some(node => 
    node.type === 'n8n-nodes-mcp.mcpClient' && 
    node.parameters?.operation === 'getPrompt'
  );
  
  // Check for resource MCP
  const hasResourceMCP = workflow.nodes?.some(node => 
    node.type === 'n8n-nodes-mcp.mcpClient' && 
    node.parameters?.operation === 'readResource'
  );
  
  // Check for vector store
  const hasVectorStore = workflow.nodes?.some(node => 
    node.type === '@n8n/n8n-nodes-langchain.vectorStoreSupabase'
  );
  
  // Check for workflow execution
  const hasWorkflowExecution = workflow.nodes?.some(node => 
    node.type === 'n8n-nodes-base.executeWorkflow' &&
    node.name?.toLowerCase().includes('subagent')
  );
  
  // Check for wait nodes
  const hasWaitNodes = workflow.nodes?.some(node => 
    node.type === 'n8n-nodes-base.wait' && 
    node.parameters?.resume === 'webhook'
  );
  
  return {
    issues,
    missing: {
      tools: missingTools,
      prompts: !hasPromptMCP,
      resources: !hasResourceMCP,
      vectorStore: !hasVectorStore,
      workflowExecution: !hasWorkflowExecution,
      humanInLoop: !hasWaitNodes
    },
    existing: {
      tools: existingTools
    }
  };
}

// Add missing components to workflow
function addMissingComponents(workflow, agentType, missing) {
  const mcpConfig = AGENT_MCP_TOOLS[agentType];
  if (!mcpConfig) return workflow;
  
  // Find AI agent node
  const aiNode = workflow.nodes?.find(node => 
    node.type === '@n8n/n8n-nodes-langchain.agent'
  );
  
  if (!aiNode) {
    console.log('  ⚠️  No AI agent node found in workflow');
    return workflow;
  }
  
  let nextPosition = [aiNode.position[0] + 200, aiNode.position[1]];
  const newNodes = [];
  const aiToolConnections = [];
  
  // Add missing MCP tools
  missing.tools?.forEach((tool, index) => {
    const toolNode = createMCPToolNode(tool, 
      [nextPosition[0] + (index * 100), nextPosition[1] + 100], 
      agentType
    );
    newNodes.push(toolNode);
    aiToolConnections.push({
      node: toolNode.name,
      type: "ai_tool",
      index: 0
    });
  });
  
  // Add prompt MCP if missing
  if (missing.prompts) {
    const promptNode = createPromptMCPNode(mcpConfig.prompts, 
      [nextPosition[0], nextPosition[1] + 200]
    );
    newNodes.push(promptNode);
    aiToolConnections.push({
      node: promptNode.name,
      type: "ai_tool",
      index: 0
    });
  }
  
  // Add resource MCP if missing
  if (missing.resources) {
    const resourceNode = createResourceMCPNode(mcpConfig.resource, 
      [nextPosition[0] + 100, nextPosition[1] + 200]
    );
    newNodes.push(resourceNode);
    aiToolConnections.push({
      node: resourceNode.name,
      type: "ai_tool",
      index: 0
    });
  }
  
  // Add vector store if missing
  if (missing.vectorStore) {
    const vectorNode = createVectorStoreNode(mcpConfig.vectorStore, 
      [nextPosition[0], nextPosition[1] + 300]
    );
    newNodes.push(vectorNode);
    aiToolConnections.push({
      node: vectorNode.name,
      type: "ai_tool",
      index: 0
    });
    
    // Also need embeddings node for vector store
    const embeddingsNode = {
      "parameters": {
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.embeddingsOpenAi",
      "typeVersion": 1.2,
      "position": [nextPosition[0], nextPosition[1] + 400],
      "id": `embeddings-${Date.now()}`,
      "name": "Embeddings OpenAI",
      "credentials": {
        "openAiApi": {
          "id": "openai-credentials",
          "name": "OpenAi account"
        }
      }
    };
    newNodes.push(embeddingsNode);
    
    // Connect embeddings to vector store
    if (!workflow.connections) workflow.connections = {};
    workflow.connections[embeddingsNode.name] = {
      "ai_embedding": [[{
        node: vectorNode.name,
        type: "ai_embedding",
        index: 0
      }]]
    };
  }
  
  // Add workflow execution if missing
  if (missing.workflowExecution) {
    const execNode = createWorkflowExecutionNode(
      [nextPosition[0] + 200, nextPosition[1] + 100],
      agentType
    );
    newNodes.push(execNode);
    aiToolConnections.push({
      node: execNode.name,
      type: "ai_tool",
      index: 0
    });
  }
  
  // Add human-in-the-loop nodes if missing
  if (missing.humanInLoop) {
    const humanNodes = createHumanInLoopNodes(workflow, agentType);
    newNodes.push(...humanNodes);
    
    // Update connections for human-in-the-loop flow
    const webhookNode = workflow.nodes?.find(node => 
      node.type === 'n8n-nodes-base.webhook' || 
      node.type === 'n8n-nodes-base.executeWorkflowTrigger'
    );
    
    if (webhookNode) {
      // Webhook -> Response with XID
      if (!workflow.connections[webhookNode.name]) {
        workflow.connections[webhookNode.name] = { main: [[]] };
      }
      workflow.connections[webhookNode.name].main[0] = [{
        node: humanNodes[0].name, // Response node
        type: "main",
        index: 0
      }];
      
      // Response -> Wait for Review
      workflow.connections[humanNodes[0].name] = {
        main: [[{
          node: humanNodes[1].name, // Wait node
          type: "main",
          index: 0
        }]]
      };
      
      // Wait -> Request Analyzer (or next node)
      const nextNode = workflow.nodes?.find(node => 
        node.name?.includes('Analyze') || node.name?.includes('Request')
      );
      
      if (nextNode) {
        workflow.connections[humanNodes[1].name] = {
          main: [[{
            node: nextNode.name,
            type: "main",
            index: 0
          }]]
        };
      }
    }
  }
  
  // Add all new nodes to workflow
  workflow.nodes = [...(workflow.nodes || []), ...newNodes];
  
  // Update AI node connections
  if (aiToolConnections.length > 0) {
    if (!workflow.connections[aiNode.name]) {
      workflow.connections[aiNode.name] = {};
    }
    if (!workflow.connections[aiNode.name].ai_tool) {
      workflow.connections[aiNode.name].ai_tool = [[]];
    }
    workflow.connections[aiNode.name].ai_tool[0].push(...aiToolConnections);
  }
  
  // Update system prompt
  if (aiNode.parameters?.options?.systemMessage) {
    aiNode.parameters.options.systemMessage = createEnhancedSystemPrompt(agentType, mcpConfig);
  }
  
  return workflow;
}

// Process a single workflow file
async function processWorkflowFile(filePath) {
  console.log(`\nProcessing: ${path.basename(filePath)}`);
  
  try {
    // Read workflow
    const content = fs.readFileSync(filePath, 'utf8');
    const workflow = JSON.parse(content);
    
    // Determine agent type from filename
    const filename = path.basename(filePath);
    const agentMatch = filename.match(/^([A-Z_]+_director)/);
    const agentType = agentMatch ? agentMatch[1] : null;
    
    if (!agentType) {
      console.log('  ⚠️  Could not determine agent type from filename');
      return { file: filePath, updated: false };
    }
    
    console.log(`  Agent Type: ${agentType}`);
    
    // Check for missing components
    const componentCheck = checkWorkflowComponents(workflow, agentType);
    
    if (Object.values(componentCheck.missing).some(v => 
      v === true || (Array.isArray(v) && v.length > 0)
    )) {
      console.log('  Missing components:');
      if (componentCheck.missing.tools?.length > 0) {
        console.log(`    - MCP Tools: ${componentCheck.missing.tools.join(', ')}`);
      }
      if (componentCheck.missing.prompts) console.log('    - Prompt MCP Server');
      if (componentCheck.missing.resources) console.log('    - Resource MCP Server');
      if (componentCheck.missing.vectorStore) console.log('    - Vector Store');
      if (componentCheck.missing.workflowExecution) console.log('    - Subagent Workflow Execution');
      if (componentCheck.missing.humanInLoop) console.log('    - Human-in-the-Loop Wait Nodes');
      
      // Add missing components
      const updatedWorkflow = addMissingComponents(workflow, agentType, componentCheck.missing);
      
      // Save updated workflow
      const backupPath = filePath.replace('.json', '.backup.json');
      fs.copyFileSync(filePath, backupPath);
      fs.writeFileSync(filePath, JSON.stringify(updatedWorkflow, null, 2));
      console.log(`  ✓ Workflow updated (backup saved as ${path.basename(backupPath)})`);
      
      // Extract webhook URLs
      const webhookUrls = [];
      updatedWorkflow.nodes.forEach(node => {
        if (node.type === 'n8n-nodes-base.webhook' && node.webhookId) {
          webhookUrls.push({
            name: node.name,
            webhookId: node.webhookId,
            url: `/webhook/${node.webhookId}`
          });
        }
        if (node.type === 'n8n-nodes-base.wait' && node.webhookId) {
          webhookUrls.push({
            name: node.name,
            webhookId: node.webhookId,
            url: `/webhook-waiting/${node.webhookId}`
          });
        }
      });
      
      return {
        file: filePath,
        agentType,
        updated: true,
        webhookUrls,
        components: {
          existing: componentCheck.existing,
          added: componentCheck.missing
        }
      };
    } else {
      console.log('  ✓ All required components present');
      return {
        file: filePath,
        agentType,
        updated: false,
        components: componentCheck.existing
      };
    }
    
  } catch (error) {
    console.error(`  ❌ Error processing workflow: ${error.message}`);
    return {
      file: filePath,
      error: error.message,
      updated: false
    };
  }
}

// Generate webhook documentation
function generateWebhookDocumentation(results) {
  const docs = ['# VividWalls MAS Agent Webhook URLs\n'];
  docs.push('## Generated on: ' + new Date().toISOString() + '\n');
  
  results.forEach(result => {
    if (result.webhookUrls && result.webhookUrls.length > 0) {
      docs.push(`\n### ${result.agentType?.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}`);
      docs.push(`File: ${path.basename(result.file)}\n`);
      
      result.webhookUrls.forEach(webhook => {
        docs.push(`- **${webhook.name}**: \`${webhook.url}\``);
      });
    }
  });
  
  docs.push('\n## Dashboard Integration\n');
  docs.push('Use these webhook URLs to:');
  docs.push('1. Monitor pending human approvals');
  docs.push('2. Resume workflows after review');
  docs.push('3. Track agent execution status\n');
  
  return docs.join('\n');
}

// Main function
async function main() {
  console.log('VividWalls MAS Comprehensive Agent Validator');
  console.log('===========================================\n');
  
  const results = [];
  
  for (const dir of WORKFLOW_DIRS) {
    console.log(`\n📁 Processing directory: ${dir}`);
    console.log('─'.repeat(60));
    
    try {
      const files = fs.readdirSync(dir).filter(f => f.endsWith('.json'));
      
      for (const file of files) {
        const filePath = path.join(dir, file);
        const result = await processWorkflowFile(filePath);
        results.push(result);
      }
    } catch (error) {
      console.error(`Error reading directory ${dir}: ${error.message}`);
    }
  }
  
  // Summary
  console.log('\n\n📊 Summary');
  console.log('─'.repeat(60));
  
  const updated = results.filter(r => r.updated).length;
  const failed = results.filter(r => r.error).length;
  const total = results.length;
  
  console.log(`Total workflows processed: ${total}`);
  console.log(`Successfully updated: ${updated}`);
  console.log(`Already complete: ${total - updated - failed}`);
  console.log(`Failed: ${failed}`);
  
  // Component additions summary
  console.log('\n\n🔧 Components Added');
  console.log('─'.repeat(60));
  
  const componentSummary = {};
  results.filter(r => r.updated).forEach(result => {
    if (!componentSummary[result.agentType]) {
      componentSummary[result.agentType] = {
        tools: 0,
        prompts: 0,
        resources: 0,
        vectorStore: 0,
        workflowExecution: 0,
        humanInLoop: 0
      };
    }
    
    if (result.components?.added) {
      componentSummary[result.agentType].tools += result.components.added.tools?.length || 0;
      if (result.components.added.prompts) componentSummary[result.agentType].prompts++;
      if (result.components.added.resources) componentSummary[result.agentType].resources++;
      if (result.components.added.vectorStore) componentSummary[result.agentType].vectorStore++;
      if (result.components.added.workflowExecution) componentSummary[result.agentType].workflowExecution++;
      if (result.components.added.humanInLoop) componentSummary[result.agentType].humanInLoop++;
    }
  });
  
  Object.entries(componentSummary).forEach(([agent, counts]) => {
    console.log(`\n${agent.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}:`);
    Object.entries(counts).forEach(([component, count]) => {
      if (count > 0) {
        console.log(`  - ${component}: ${count}`);
      }
    });
  });
  
  // Generate webhook documentation
  const webhookDocs = generateWebhookDocumentation(results);
  const docsPath = path.join(path.dirname(WORKFLOW_DIRS[0]), 'AGENT_WEBHOOK_URLS.md');
  fs.writeFileSync(docsPath, webhookDocs);
  console.log(`\n\n📄 Webhook documentation saved to: ${docsPath}`);
  
  console.log('\n✅ Validation and enhancement complete!');
}

// Run the script
if (require.main === module) {
  main().catch(console.error);
}

module.exports = { processWorkflowFile, checkWorkflowComponents };