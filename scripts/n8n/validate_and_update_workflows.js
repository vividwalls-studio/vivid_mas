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

// Human-in-the-loop pattern components
const WEBHOOK_RESPONSE_NODE = {
  "parameters": {
    "respondWith": "json",
    "responseBody": "={\n  \"xid\": \"{{ $execution.id}}\",\n  \"workflow\": \"{{ $workflow.name }}\",\n  \"timestamp\": \"{{ $now.toISO() }}\"\n}",
    "options": {}
  },
  "type": "n8n-nodes-base.respondToWebhook",
  "typeVersion": 1.1,
  "position": [300, 0],
  "id": "respond-with-execution-id",
  "name": "Respond with Execution ID"
};

const WAIT_NODE = {
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
  "position": [500, 0],
  "id": "wait-for-human-input",
  "name": "Wait for Human Input",
  "webhookId": "" // Will be generated
};

const STATUS_UPDATE_NODE = {
  "parameters": {
    "respondWith": "json",
    "responseBody": "{\n  \"status\": \"completed\",\n  \"xid\": \"{{ $execution.id }}\",\n  \"result\": \"{{ $json }}\"\n}",
    "options": {}
  },
  "type": "n8n-nodes-base.respondToWebhook",
  "typeVersion": 1.1,
  "position": [700, 0],
  "id": "respond-with-completion",
  "name": "Respond with Completion"
};

// Generate webhook ID
function generateWebhookId() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Check if workflow has webhook trigger
function hasWebhookTrigger(workflow) {
  return workflow.nodes && workflow.nodes.some(node => 
    node.type === 'n8n-nodes-base.webhook' && 
    (node.name === 'Webhook' || node.name === 'start' || node.name.toLowerCase().includes('trigger'))
  );
}

// Add human-in-the-loop pattern to workflow
function addHumanInLoopPattern(workflow) {
  if (!workflow.nodes) workflow.nodes = [];
  if (!workflow.connections) workflow.connections = {};

  // Find the webhook trigger node
  const webhookNode = workflow.nodes.find(node => 
    node.type === 'n8n-nodes-base.webhook' && 
    (node.name === 'Webhook' || node.name === 'start' || node.name.toLowerCase().includes('trigger'))
  );

  if (!webhookNode) {
    console.log(`  ⚠️  No webhook trigger found in workflow`);
    return workflow;
  }

  // Check if human-in-the-loop pattern already exists
  const hasWaitNode = workflow.nodes.some(node => 
    node.type === 'n8n-nodes-base.wait' && node.parameters.resume === 'webhook'
  );

  if (hasWaitNode) {
    console.log(`  ✓ Human-in-the-loop pattern already exists`);
    return workflow;
  }

  // Add response node after webhook
  const responseNode = JSON.parse(JSON.stringify(WEBHOOK_RESPONSE_NODE));
  responseNode.id = `${responseNode.id}-${Date.now()}`;
  responseNode.position = [
    webhookNode.position[0] + 200,
    webhookNode.position[1]
  ];

  // Add wait node
  const waitNode = JSON.parse(JSON.stringify(WAIT_NODE));
  waitNode.id = `${waitNode.id}-${Date.now()}`;
  waitNode.webhookId = generateWebhookId();
  waitNode.position = [
    responseNode.position[0] + 200,
    responseNode.position[1]
  ];

  // Find the first node that was connected to webhook
  const originalConnection = workflow.connections[webhookNode.name]?.main?.[0]?.[0];
  let nextNode = null;
  if (originalConnection) {
    nextNode = workflow.nodes.find(n => n.name === originalConnection.node);
  }

  // Add nodes to workflow
  workflow.nodes.push(responseNode);
  workflow.nodes.push(waitNode);

  // Update connections
  // 1. Webhook -> Response Node
  if (!workflow.connections[webhookNode.name]) {
    workflow.connections[webhookNode.name] = { main: [[]] };
  }
  workflow.connections[webhookNode.name].main[0] = [{
    node: responseNode.name,
    type: "main",
    index: 0
  }];

  // 2. Response Node -> Wait Node
  workflow.connections[responseNode.name] = {
    main: [[{
      node: waitNode.name,
      type: "main",
      index: 0
    }]]
  };

  // 3. Wait Node -> Original next node (if exists)
  if (nextNode) {
    workflow.connections[waitNode.name] = {
      main: [[{
        node: nextNode.name,
        type: "main",
        index: 0
      }]]
    };
  }

  // Add completion response node at the end if there's a clear endpoint
  const endNodes = findEndNodes(workflow);
  if (endNodes.length === 1) {
    const completionNode = JSON.parse(JSON.stringify(STATUS_UPDATE_NODE));
    completionNode.id = `${completionNode.id}-${Date.now()}`;
    completionNode.position = [
      endNodes[0].position[0] + 200,
      endNodes[0].position[1]
    ];
    
    workflow.nodes.push(completionNode);
    
    // Connect end node to completion node
    if (!workflow.connections[endNodes[0].name]) {
      workflow.connections[endNodes[0].name] = { main: [[]] };
    }
    workflow.connections[endNodes[0].name].main[0].push({
      node: completionNode.name,
      type: "main",
      index: 0
    });
  }

  console.log(`  ✓ Added human-in-the-loop pattern with webhook ID: ${waitNode.webhookId}`);
  return workflow;
}

// Find nodes that have no outgoing connections
function findEndNodes(workflow) {
  const endNodes = [];
  workflow.nodes.forEach(node => {
    const hasOutgoing = workflow.connections[node.name]?.main?.[0]?.length > 0;
    if (!hasOutgoing && node.type !== 'n8n-nodes-base.respondToWebhook') {
      endNodes.push(node);
    }
  });
  return endNodes;
}

// Process a single workflow file
async function processWorkflowFile(filePath) {
  console.log(`\nProcessing: ${path.basename(filePath)}`);
  
  try {
    // Read workflow
    const content = fs.readFileSync(filePath, 'utf8');
    const workflow = JSON.parse(content);
    
    // Validate workflow
    console.log('  Validating workflow...');
    const validationResults = validateWorkflow(workflow, {
      strictness: 'medium'
    });
    
    // Report validation results
    if (validationResults.passed) {
      console.log('  ✓ Workflow passed all validations');
    } else {
      console.log(`  ⚠️  Found ${validationResults.totalIssues} issues:`);
      Object.entries(validationResults.results).forEach(([category, result]) => {
        if (result.issues.length > 0) {
          console.log(`    ${category}:`);
          result.issues.forEach(issue => console.log(`      - ${issue}`));
        }
      });
    }
    
    // Check and add human-in-the-loop pattern
    console.log('  Checking human-in-the-loop pattern...');
    const updatedWorkflow = addHumanInLoopPattern(workflow);
    
    // Extract webhook URLs
    const webhookUrls = [];
    updatedWorkflow.nodes.forEach(node => {
      if (node.type === 'n8n-nodes-base.webhook' && node.webhookId) {
        webhookUrls.push({
          name: node.name,
          webhookId: node.webhookId,
          path: node.parameters?.path || node.webhookId
        });
      }
      if (node.type === 'n8n-nodes-base.wait' && node.webhookId) {
        webhookUrls.push({
          name: node.name,
          webhookId: node.webhookId,
          type: 'wait'
        });
      }
    });
    
    if (webhookUrls.length > 0) {
      console.log('  Webhook URLs:');
      webhookUrls.forEach(webhook => {
        const baseUrl = webhook.type === 'wait' ? 
          'http://localhost:5678/webhook-waiting' : 
          'http://localhost:5678/webhook';
        console.log(`    - ${webhook.name}: ${baseUrl}/${webhook.webhookId}`);
      });
    }
    
    // Save updated workflow
    const backupPath = filePath.replace('.json', '.backup.json');
    fs.copyFileSync(filePath, backupPath);
    fs.writeFileSync(filePath, JSON.stringify(updatedWorkflow, null, 2));
    console.log(`  ✓ Workflow updated (backup saved as ${path.basename(backupPath)})`);
    
    return {
      file: filePath,
      validationResults,
      webhookUrls,
      updated: true
    };
    
  } catch (error) {
    console.error(`  ❌ Error processing workflow: ${error.message}`);
    return {
      file: filePath,
      error: error.message,
      updated: false
    };
  }
}

// Main function
async function main() {
  console.log('VividWalls MAS Workflow Validator and Updater');
  console.log('=============================================\n');
  
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
  
  const successful = results.filter(r => r.updated && !r.error).length;
  const failed = results.filter(r => r.error).length;
  const total = results.length;
  
  console.log(`Total workflows processed: ${total}`);
  console.log(`Successfully updated: ${successful}`);
  console.log(`Failed: ${failed}`);
  
  // List all webhook URLs
  console.log('\n\n🔗 All Webhook URLs');
  console.log('─'.repeat(60));
  
  results.forEach(result => {
    if (result.webhookUrls && result.webhookUrls.length > 0) {
      console.log(`\n${path.basename(result.file)}:`);
      result.webhookUrls.forEach(webhook => {
        const baseUrl = webhook.type === 'wait' ? 
          'http://localhost:5678/webhook-waiting' : 
          'http://localhost:5678/webhook';
        console.log(`  ${webhook.name}: ${baseUrl}/${webhook.webhookId}`);
      });
    }
  });
  
  console.log('\n✅ Process complete!');
}

// Run the script
if (require.main === module) {
  main().catch(console.error);
}

module.exports = { processWorkflowFile, addHumanInLoopPattern };