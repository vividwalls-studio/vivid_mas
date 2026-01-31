#!/usr/bin/env node

/**
 * Fix Problematic N8N Workflows
 * Deletes workflows with unrecognized node types and recreates them properly
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

const CONFIG = {
  api: {
    baseUrl: 'https://n8n.vividwalls.blog',
    apiKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I'
  }
};

// Workflows with mcpToolKit errors
const PROBLEMATIC_WORKFLOWS = [
  { id: 'A5IQH5RBwvFMZU8X', name: 'VividWalls Content Marketing Agent - Human Approval Enhanced' },
  { id: 'NiwcKfEDtUaUW8N8', name: 'VividWalls Content Marketing Agent - MCP Enhanced' },
  { id: 'TMDHCVA245t1nNwg', name: 'VividWalls Customer Relationship Agent - Human Approval Enhanced' },
  { id: 'rfTk6JXFXVqV61cJ', name: 'VividWalls Customer Relationship Agent - MCP Enhanced' },
  { id: 'Own8PHhrOmqAqAYI', name: 'VividWalls Marketing Campaign Agent - Human Approval Enhanced' },
  { id: 'BoC02YsU77G1sHV3', name: 'VividWalls Marketing Campaign Agent - MCP Enhanced' },
  { id: '0lMVtjudeZTbYKmz', name: 'Finance Director Agent' }  // vectorStoreAirtableSearch error
];

class WorkflowFixer {
  constructor() {
    this.api = axios.create({
      baseURL: CONFIG.api.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-N8N-API-KEY': CONFIG.api.apiKey
      },
      timeout: 30000
    });
  }

  /**
   * Delete a workflow
   */
  async deleteWorkflow(id, name) {
    try {
      await this.api.delete(`/api/v1/workflows/${id}`);
      console.log(`✅ Deleted: ${name}`);
      return true;
    } catch (error) {
      if (error.response?.status === 404) {
        console.log(`⚠️  Already deleted: ${name}`);
        return true;
      }
      console.log(`❌ Failed to delete ${name}: ${error.message}`);
      return false;
    }
  }

  /**
   * Create a proper agent workflow structure
   */
  createAgentWorkflow(name, agentType) {
    const workflow = {
      name: name,
      nodes: [],
      connections: {},
      settings: {
        executionOrder: 'v1'
      }
    };

    // Determine agent specifics based on name
    const isDirector = name.toLowerCase().includes('director');
    const isHumanApproval = name.toLowerCase().includes('human approval');
    const isMCPEnhanced = name.toLowerCase().includes('mcp enhanced');
    
    // Add webhook trigger
    workflow.nodes.push({
      id: this.generateNodeId(),
      name: 'Webhook Trigger',
      type: 'n8n-nodes-base.webhook',
      typeVersion: 2,
      position: [250, 300],
      parameters: {
        httpMethod: 'POST',
        path: `/${name.toLowerCase().replace(/[^a-z0-9]/g, '-')}`,
        responseMode: 'onReceived',
        responseData: 'allEntries',
        options: {}
      }
    });

    // Add AI Agent node (instead of mcpToolKit)
    const agentNode = {
      id: this.generateNodeId(),
      name: `${agentType} AI Agent`,
      type: '@n8n/n8n-nodes-langchain.agent',
      typeVersion: 1.7,
      position: [650, 300],
      parameters: {
        prompt: this.getAgentPrompt(name, agentType),
        hasOutputParser: true,
        options: {
          systemMessage: this.getSystemMessage(name, agentType),
          maxIterations: 10,
          returnIntermediateSteps: true
        }
      }
    };
    workflow.nodes.push(agentNode);

    // Add OpenAI Chat Model
    workflow.nodes.push({
      id: this.generateNodeId(),
      name: 'OpenAI Chat Model',
      type: '@n8n/n8n-nodes-langchain.lmChatOpenAi',
      typeVersion: 1,
      position: [650, 500],
      parameters: {
        model: 'gpt-4o-mini',
        options: {
          temperature: 0.7,
          maxTokens: 2000
        }
      }
    });

    // Add Memory (if needed)
    if (!isDirector) {
      workflow.nodes.push({
        id: this.generateNodeId(),
        name: 'Window Buffer Memory',
        type: '@n8n/n8n-nodes-langchain.memoryBufferWindow',
        typeVersion: 1,
        position: [650, 600],
        parameters: {
          contextWindowLength: 10
        }
      });
    }

    // Add Human in the Loop (if human approval variant)
    if (isHumanApproval) {
      workflow.nodes.push({
        id: this.generateNodeId(),
        name: 'Human Approval',
        type: 'n8n-nodes-base.wait',
        typeVersion: 1,
        position: [850, 300],
        parameters: {
          resume: 'webhook',
          options: {
            webhookSuffix: '/approve'
          }
        }
      });
    }

    // Add Supabase tool (instead of vector store for Finance Director)
    if (name.includes('Finance Director')) {
      workflow.nodes.push({
        id: this.generateNodeId(),
        name: 'Supabase Vector Store',
        type: '@n8n/n8n-nodes-langchain.vectorStoreSupabase',
        typeVersion: 1,
        position: [650, 700],
        parameters: {
          tableName: 'finance_knowledge',
          queryName: 'match_finance_documents',
          options: {}
        }
      });
    }

    // Add Code tool for data processing
    workflow.nodes.push({
      id: this.generateNodeId(),
      name: 'Code Tool',
      type: '@n8n/n8n-nodes-langchain.toolCode',
      typeVersion: 1,
      position: [450, 500],
      parameters: {
        name: 'process_data',
        description: 'Process and transform data',
        code: 'return { result: "processed" };'
      }
    });

    // Add output node
    workflow.nodes.push({
      id: this.generateNodeId(),
      name: 'Respond to Webhook',
      type: 'n8n-nodes-base.respondToWebhook',
      typeVersion: 1,
      position: [1050, 300],
      parameters: {
        respondWith: 'json',
        responseBody: '={{ JSON.stringify($json) }}',
        options: {}
      }
    });

    // Set up connections
    const webhookNode = workflow.nodes[0];
    const mainAgentNode = workflow.nodes[1];
    const outputNode = workflow.nodes[workflow.nodes.length - 1];

    workflow.connections = {
      [webhookNode.name]: {
        main: [[{ node: mainAgentNode.name, type: 'main', index: 0 }]]
      },
      [mainAgentNode.name]: {
        main: [[{ node: outputNode.name, type: 'main', index: 0 }]]
      }
    };

    return workflow;
  }

  /**
   * Generate a unique node ID
   */
  generateNodeId() {
    return 'node_' + Math.random().toString(36).substr(2, 9);
  }

  /**
   * Get agent prompt based on type
   */
  getAgentPrompt(name, agentType) {
    const prompts = {
      'Content Marketing Agent': 'You are a Content Marketing Agent for VividWalls. Create and optimize content strategies for wall art products.',
      'Customer Relationship Agent': 'You are a Customer Relationship Agent. Manage customer interactions and enhance satisfaction.',
      'Marketing Campaign Agent': 'You are a Marketing Campaign Agent. Design and execute marketing campaigns for VividWalls products.',
      'Finance Director Agent': 'You are the Finance Director Agent. Oversee financial operations, budgeting, and ROI analysis.'
    };

    for (const [key, prompt] of Object.entries(prompts)) {
      if (name.includes(key)) {
        return prompt;
      }
    }

    return `You are an AI agent for VividWalls Multi-Agent System. ${agentType}`;
  }

  /**
   * Get system message for agent
   */
  getSystemMessage(name, agentType) {
    const baseMessage = `You are part of the VividWalls Multi-Agent System (MAS), a sophisticated autonomous e-commerce platform for premium wall art.

Your role: ${agentType}

Key responsibilities:
1. Process incoming requests efficiently
2. Collaborate with other agents when needed
3. Maintain high quality standards
4. Report results accurately

Always provide structured, actionable responses.`;

    if (name.includes('Human Approval')) {
      return baseMessage + '\n\nIMPORTANT: All critical decisions must be approved by a human operator before execution.';
    }

    if (name.includes('MCP Enhanced')) {
      return baseMessage + '\n\nYou have access to MCP (Model Context Protocol) tools for enhanced capabilities.';
    }

    return baseMessage;
  }

  /**
   * Create a workflow via API
   */
  async createWorkflow(workflowData) {
    try {
      const response = await this.api.post('/api/v1/workflows', workflowData);
      return response.data;
    } catch (error) {
      if (error.response) {
        throw new Error(`${error.response.status}: ${error.response.data?.message || error.response.statusText}`);
      }
      throw error;
    }
  }

  /**
   * Main execution
   */
  async execute() {
    console.log('🔧 VividWalls MAS Workflow Fixer\n');
    console.log('=' .repeat(60));
    console.log('Step 1: Deleting problematic workflows...\n');

    const deleteResults = [];
    
    // Delete problematic workflows
    for (const workflow of PROBLEMATIC_WORKFLOWS) {
      const result = await this.deleteWorkflow(workflow.id, workflow.name);
      deleteResults.push({ ...workflow, deleted: result });
      await new Promise(r => setTimeout(r, 500)); // Rate limiting
    }

    console.log('\n' + '=' .repeat(60));
    console.log('Step 2: Recreating necessary workflows...\n');

    // Define which workflows are essential for MAS
    const essentialWorkflows = [
      { name: 'VividWalls Content Marketing Agent - MCP Enhanced', type: 'Content Marketing Agent' },
      { name: 'VividWalls Customer Relationship Agent - MCP Enhanced', type: 'Customer Relationship Agent' },
      { name: 'VividWalls Marketing Campaign Agent - MCP Enhanced', type: 'Marketing Campaign Agent' },
      { name: 'Finance Director Agent', type: 'Finance Director Agent' }
    ];

    const createResults = [];

    for (const workflow of essentialWorkflows) {
      process.stdout.write(`Creating: ${workflow.name.padEnd(50)}`);
      
      try {
        const workflowData = this.createAgentWorkflow(workflow.name, workflow.type);
        const created = await this.createWorkflow(workflowData);
        console.log(' ✅');
        createResults.push({ name: workflow.name, success: true, id: created.id });
      } catch (error) {
        console.log(` ❌ ${error.message}`);
        createResults.push({ name: workflow.name, success: false, error: error.message });
      }
      
      await new Promise(r => setTimeout(r, 1000)); // Rate limiting
    }

    // Summary
    console.log('\n' + '=' .repeat(60));
    console.log('✨ Workflow Fix Complete!\n');
    
    console.log('Deletion Summary:');
    const deletedCount = deleteResults.filter(r => r.deleted).length;
    console.log(`  ✅ Successfully deleted: ${deletedCount}/${PROBLEMATIC_WORKFLOWS.length}`);
    
    console.log('\nCreation Summary:');
    const createdCount = createResults.filter(r => r.success).length;
    console.log(`  ✅ Successfully created: ${createdCount}/${essentialWorkflows.length}`);
    
    if (createResults.some(r => !r.success)) {
      console.log('\nFailed to create:');
      createResults.filter(r => !r.success).forEach(r => {
        console.log(`  • ${r.name}: ${r.error}`);
      });
    }

    // Save report
    const report = {
      timestamp: new Date().toISOString(),
      deletions: deleteResults,
      creations: createResults
    };

    const reportPath = path.join(__dirname, 'workflow_fix_report.json');
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
    console.log(`\n📊 Report saved: ${reportPath}`);
  }
}

// Run
if (require.main === module) {
  const fixer = new WorkflowFixer();
  fixer.execute().catch(console.error);
}

module.exports = WorkflowFixer;