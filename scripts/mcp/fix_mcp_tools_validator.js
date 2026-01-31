#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Configuration for each agent type
const AGENT_MCP_CONFIG = {
  'MARKETING_director': {
    tools: ['postiz-mcp', 'facebook-ads-mcp', 'marketing-analytics-aggregator', 'linear-mcp'],
    prompts: 'marketing-director-prompts',
    resource: 'marketing-director-resource',
    vectorStore: { domain: 'marketing', agentType: 'director' }
  },
  'BUSINESS_MANAGEMENT_director': {
    tools: ['sendgrid-mcp', 'stripe-mcp', 'shopify-mcp', 'n8n-mcp', 'supabase-mcp', 'kpi-dashboard-mcp', 'linear-mcp'],
    prompts: 'business-manager-prompts',
    resource: 'business-manager-resource',
    vectorStore: { domain: 'business', agentType: 'director' }
  },
  'SALES_director': {
    tools: ['shopify-mcp', 'stripe-mcp', 'sendgrid-mcp', 'twenty-mcp', 'linear-mcp'],
    prompts: 'sales-director-prompts',
    resource: null,
    vectorStore: { domain: 'sales', agentType: 'director' }
  },
  'FINANCE_director': {
    tools: ['stripe-mcp', 'shopify-mcp', 'supabase-mcp', 'linear-mcp'],
    prompts: 'finance-director-prompts',
    resource: null,
    vectorStore: { domain: 'finance', agentType: 'director' }
  },
  'OPERATIONS_director': {
    tools: ['shopify-mcp', 'pictorem-mcp', 'linear-mcp'],
    prompts: 'operations-director-prompts',
    resource: null,
    vectorStore: { domain: 'operations', agentType: 'director' }
  },
  'CUSTOMER_EXPERIENCE_director': {
    tools: ['sendgrid-mcp', 'twenty-mcp', 'shopify-mcp', 'linear-mcp'],
    prompts: 'customer-experience-director-prompts',
    resource: null,
    vectorStore: { domain: 'customer_experience', agentType: 'director' }
  },
  'PRODUCT_director': {
    tools: ['shopify-mcp', 'supabase-mcp', 'linear-mcp'],
    prompts: 'product-director-prompts',
    resource: null,
    vectorStore: { domain: 'product', agentType: 'director' }
  },
  'ANALYTICS_director': {
    tools: ['supabase-mcp', 'marketing-analytics-aggregator', 'linear-mcp'],
    prompts: 'analytics-director-prompts',
    resource: null,
    vectorStore: { domain: 'analytics', agentType: 'director' }
  },
  'TECHNOLOGY_director': {
    tools: ['n8n-mcp', 'supabase-mcp', 'wordpress-mcp', 'linear-mcp'],
    prompts: 'technology-director-prompts',
    resource: null,
    vectorStore: { domain: 'technology', agentType: 'director' }
  },
  'CREATIVE_director': {
    tools: ['shopify-mcp', 'image-picker-mcp', 'linear-mcp'],
    prompts: 'creative-director-prompts',
    resource: null,
    vectorStore: { domain: 'creative', agentType: 'director' }
  }
};

// Create MCP tool node with correct structure
function createMCPToolNode(toolName, position) {
  const nodeId = `mcp-${toolName}-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  return {
    "parameters": {
      "method": "listTools",
      "mcpServerName": toolName
    },
    "id": nodeId,
    "name": `${toolName.replace('-mcp', '').replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase())} Tools`,
    "type": "@n8n/n8n-nodes-langchain.mcp",
    "typeVersion": 1,
    "position": position
  };
}

// Create prompt MCP node
function createPromptMCPNode(promptName, position) {
  const nodeId = `mcp-prompt-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  return {
    "parameters": {
      "method": "listPrompts",
      "mcpServerName": promptName
    },
    "id": nodeId,
    "name": "Agent Prompts",
    "type": "@n8n/n8n-nodes-langchain.mcp",
    "typeVersion": 1,
    "position": position
  };
}

// Create resource MCP node
function createResourceMCPNode(resourceName, position) {
  const nodeId = `mcp-resource-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  return {
    "parameters": {
      "method": "listResources",
      "mcpServerName": resourceName
    },
    "id": nodeId,
    "name": "Agent Resources",
    "type": "@n8n/n8n-nodes-langchain.mcp",
    "typeVersion": 1,
    "position": position
  };
}

// Process a workflow file
async function processWorkflowFile(filePath) {
  const fileName = path.basename(filePath);
  console.log(`\nProcessing: ${fileName}`);
  
  // Determine agent type from filename
  const match = fileName.match(/^([A-Z_]+)_director_/);
  if (!match) {
    console.log('  ⚠️  Not a director workflow, skipping');
    return;
  }
  
  const agentType = `${match[1]}_director`;
  const mcpConfig = AGENT_MCP_CONFIG[agentType];
  
  if (!mcpConfig) {
    console.log(`  ⚠️  No MCP configuration for ${agentType}`);
    return;
  }
  
  // Read workflow
  const workflow = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  
  // Find AI agent node
  const aiNode = workflow.nodes?.find(node => 
    node.type === '@n8n/n8n-nodes-langchain.agent'
  );
  
  if (!aiNode) {
    console.log('  ⚠️  No AI agent node found');
    return;
  }
  
  // Check for existing MCP tools
  const existingMCPNodes = workflow.nodes.filter(node => 
    node.type === '@n8n/n8n-nodes-langchain.mcp'
  );
  
  console.log(`  Current MCP nodes: ${existingMCPNodes.length}`);
  console.log(`  Required MCP tools: ${mcpConfig.tools.length}`);
  
  // Find the position to add new nodes
  const aiNodePos = aiNode.position || [500, 300];
  let nextY = aiNodePos[1] + 150;
  
  // Add MCP tool nodes
  const newNodes = [];
  const toolConnections = [];
  
  mcpConfig.tools.forEach((tool, index) => {
    const toolExists = existingMCPNodes.some(node => 
      node.parameters?.mcpServerName === tool
    );
    
    if (!toolExists) {
      const toolNode = createMCPToolNode(tool, [aiNodePos[0] + 200 + (index * 150), nextY]);
      newNodes.push(toolNode);
      toolConnections.push({
        node: toolNode.id,
        type: "ai_tool",
        index: 0
      });
      console.log(`  ✓ Added MCP tool: ${tool}`);
    }
  });
  
  // Add prompt MCP if needed
  if (mcpConfig.prompts) {
    const promptExists = existingMCPNodes.some(node => 
      node.parameters?.mcpServerName === mcpConfig.prompts
    );
    
    if (!promptExists) {
      const promptNode = createPromptMCPNode(mcpConfig.prompts, [aiNodePos[0] + 200, nextY + 100]);
      newNodes.push(promptNode);
      toolConnections.push({
        node: promptNode.id,
        type: "ai_tool",
        index: 0
      });
      console.log(`  ✓ Added prompt MCP: ${mcpConfig.prompts}`);
    }
  }
  
  // Add resource MCP if needed
  if (mcpConfig.resource) {
    const resourceExists = existingMCPNodes.some(node => 
      node.parameters?.mcpServerName === mcpConfig.resource
    );
    
    if (!resourceExists) {
      const resourceNode = createResourceMCPNode(mcpConfig.resource, [aiNodePos[0] + 350, nextY + 100]);
      newNodes.push(resourceNode);
      toolConnections.push({
        node: resourceNode.id,
        type: "ai_tool",
        index: 0
      });
      console.log(`  ✓ Added resource MCP: ${mcpConfig.resource}`);
    }
  }
  
  if (newNodes.length > 0) {
    // Create backup
    const backupPath = filePath.replace('.json', `.backup-${Date.now()}.json`);
    fs.writeFileSync(backupPath, JSON.stringify(workflow, null, 2));
    console.log(`  📁 Backup saved: ${path.basename(backupPath)}`);
    
    // Add new nodes to workflow
    workflow.nodes = [...workflow.nodes, ...newNodes];
    
    // Update connections
    if (!workflow.connections[aiNode.id]) {
      workflow.connections[aiNode.id] = {};
    }
    if (!workflow.connections[aiNode.id].ai_tool) {
      workflow.connections[aiNode.id].ai_tool = [[]];
    }
    workflow.connections[aiNode.id].ai_tool[0].push(...toolConnections);
    
    // Save updated workflow
    fs.writeFileSync(filePath, JSON.stringify(workflow, null, 2));
    console.log(`  ✅ Workflow updated with ${newNodes.length} new MCP nodes`);
  } else {
    console.log('  ℹ️  All required MCP nodes already present');
  }
}

// Main function
async function main() {
  console.log('VividWalls MAS - MCP Tool Fixer');
  console.log('================================\n');
  
  const workflowDir = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core';
  
  if (!fs.existsSync(workflowDir)) {
    console.error(`❌ Directory not found: ${workflowDir}`);
    process.exit(1);
  }
  
  const files = fs.readdirSync(workflowDir).filter(f => 
    f.endsWith('.json') && 
    !f.includes('.backup') &&
    f.includes('_director_')
  );
  
  console.log(`Found ${files.length} director workflows to process\n`);
  
  for (const file of files) {
    await processWorkflowFile(path.join(workflowDir, file));
  }
  
  console.log('\n✅ MCP tool fixing complete!');
}

// Run the fixer
main().catch(console.error);