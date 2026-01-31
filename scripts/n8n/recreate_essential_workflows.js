#!/usr/bin/env node

/**
 * Recreate Essential N8N Workflows
 * Creates the 4 essential workflows that were deleted
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

class WorkflowCreator {
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

    // Generate consistent IDs
    const webhookId = this.generateNodeId();
    const agentId = this.generateNodeId();
    const chatModelId = this.generateNodeId();
    const memoryId = this.generateNodeId();
    const codeToolId = this.generateNodeId();
    const outputId = this.generateNodeId();
    const vectorStoreId = this.generateNodeId();

    // Add webhook trigger
    const webhookNode = {
      id: webhookId,
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
    };
    workflow.nodes.push(webhookNode);

    // Add AI Agent node
    const agentNode = {
      id: agentId,
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
    const chatModelNode = {
      id: chatModelId,
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
    };
    workflow.nodes.push(chatModelNode);

    // Add Memory (for non-director agents)
    if (!name.includes('Director')) {
      const memoryNode = {
        id: memoryId,
        name: 'Window Buffer Memory',
        type: '@n8n/n8n-nodes-langchain.memoryBufferWindow',
        typeVersion: 1,
        position: [650, 600],
        parameters: {
          contextWindowLength: 10
        }
      };
      workflow.nodes.push(memoryNode);
    }

    // Add Supabase Vector Store for Finance Director
    if (name.includes('Finance Director')) {
      const vectorNode = {
        id: vectorStoreId,
        name: 'Supabase Vector Store',
        type: '@n8n/n8n-nodes-langchain.vectorStoreSupabase',
        typeVersion: 1,
        position: [650, 700],
        parameters: {
          tableName: 'finance_knowledge',
          queryName: 'match_finance_documents',
          options: {}
        }
      };
      workflow.nodes.push(vectorNode);
    }

    // Add Code tool
    const codeToolNode = {
      id: codeToolId,
      name: 'Code Tool',
      type: '@n8n/n8n-nodes-langchain.toolCode',
      typeVersion: 1,
      position: [450, 500],
      parameters: {
        name: 'process_data',
        description: 'Process and transform data for the agent',
        code: `// Process input data
const input = $input.all();
const result = {
  processed: true,
  timestamp: new Date().toISOString(),
  data: input
};
return result;`
      }
    };
    workflow.nodes.push(codeToolNode);

    // Add output node
    const outputNode = {
      id: outputId,
      name: 'Respond to Webhook',
      type: 'n8n-nodes-base.respondToWebhook',
      typeVersion: 1,
      position: [1050, 300],
      parameters: {
        respondWith: 'json',
        responseBody: '={{ JSON.stringify($json) }}',
        options: {}
      }
    };
    workflow.nodes.push(outputNode);

    // Set up connections
    workflow.connections = {
      [webhookNode.name]: {
        main: [[{ node: agentNode.name, type: 'main', index: 0 }]]
      },
      [agentNode.name]: {
        main: [[{ node: outputNode.name, type: 'main', index: 0 }]]
      }
    };

    return workflow;
  }

  /**
   * Generate a unique node ID
   */
  generateNodeId() {
    return Math.random().toString(36).substring(2, 15);
  }

  /**
   * Get agent prompt based on type
   */
  getAgentPrompt(name, agentType) {
    const prompts = {
      'Content Marketing Agent': `You are a Content Marketing Agent for VividWalls, a premium wall art e-commerce platform.

Your responsibilities:
- Create engaging content strategies for wall art products
- Optimize content for SEO and conversion
- Develop compelling product descriptions
- Coordinate with other marketing agents

Input: {{ $json.query }}
Context: {{ $json.context }}

Provide a structured response with actionable recommendations.`,
      
      'Customer Relationship Agent': `You are a Customer Relationship Agent for VividWalls.

Your responsibilities:
- Manage customer interactions and inquiries
- Enhance customer satisfaction and retention
- Handle feedback and complaints professionally
- Coordinate with fulfillment and support teams

Customer Query: {{ $json.query }}
Customer Data: {{ $json.customerData }}

Provide empathetic, solution-oriented responses.`,
      
      'Marketing Campaign Agent': `You are a Marketing Campaign Agent for VividWalls.

Your responsibilities:
- Design and execute marketing campaigns
- Coordinate multi-channel marketing efforts
- Analyze campaign performance
- Optimize for ROI and conversions

Campaign Request: {{ $json.campaign }}
Target Audience: {{ $json.audience }}

Provide a comprehensive campaign strategy.`,
      
      'Finance Director Agent': `You are the Finance Director Agent overseeing VividWalls financial operations.

Your responsibilities:
- Monitor financial KPIs and metrics
- Oversee budgeting and forecasting
- Analyze ROI for marketing and operations
- Report to Business Manager Agent
- Manage financial risk assessment

Financial Query: {{ $json.query }}
Department: {{ $json.department }}

Provide data-driven financial insights and recommendations.`
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

System Architecture:
- Business Manager Agent (Orchestrator)
- 9 Director Agents (including you if you're a Director)
- 48+ Specialized Agents

Communication Protocol:
1. Receive requests via webhook
2. Process using available tools and knowledge
3. Coordinate with other agents when needed
4. Return structured JSON responses

Quality Standards:
- Maintain professional communication
- Provide data-driven insights
- Ensure accuracy in all responses
- Follow VividWalls brand guidelines

Your specific role: ${agentType}`;

    if (name.includes('MCP Enhanced')) {
      return baseMessage + `

Enhanced Capabilities:
- Access to Model Context Protocol (MCP) tools
- Direct integration with external services
- Advanced data processing capabilities
- Real-time system access`;
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
    console.log('🎨 VividWalls MAS Essential Workflow Creator\n');
    console.log('=' .repeat(60));
    console.log('Creating 4 essential workflows for the MAS...\n');

    // Define essential workflows
    const essentialWorkflows = [
      { name: 'VividWalls Content Marketing Agent - MCP Enhanced', type: 'Content Marketing Agent' },
      { name: 'VividWalls Customer Relationship Agent - MCP Enhanced', type: 'Customer Relationship Agent' },
      { name: 'VividWalls Marketing Campaign Agent - MCP Enhanced', type: 'Marketing Campaign Agent' },
      { name: 'Finance Director Agent', type: 'Finance Director Agent' }
    ];

    const results = [];

    for (const workflow of essentialWorkflows) {
      process.stdout.write(`Creating: ${workflow.name.padEnd(60)}`);
      
      try {
        const workflowData = this.createAgentWorkflow(workflow.name, workflow.type);
        const created = await this.createWorkflow(workflowData);
        console.log(' ✅');
        results.push({ 
          name: workflow.name, 
          success: true, 
          id: created.id,
          nodeCount: workflowData.nodes.length
        });
      } catch (error) {
        console.log(` ❌ ${error.message}`);
        results.push({ 
          name: workflow.name, 
          success: false, 
          error: error.message 
        });
      }
      
      await new Promise(r => setTimeout(r, 1000)); // Rate limiting
    }

    // Summary
    console.log('\n' + '=' .repeat(60));
    console.log('✨ Workflow Creation Complete!\n');
    
    const successCount = results.filter(r => r.success).length;
    console.log(`Results:`)
    console.log(`  ✅ Successfully created: ${successCount}/${essentialWorkflows.length}`);
    
    if (successCount > 0) {
      console.log('\nCreated workflows:');
      results.filter(r => r.success).forEach(r => {
        console.log(`  • ${r.name} (ID: ${r.id}, Nodes: ${r.nodeCount})`);
      });
    }
    
    if (results.some(r => !r.success)) {
      console.log('\nFailed to create:');
      results.filter(r => !r.success).forEach(r => {
        console.log(`  • ${r.name}: ${r.error}`);
      });
    }

    // Save report
    const report = {
      timestamp: new Date().toISOString(),
      target: CONFIG.api.baseUrl,
      results: results
    };

    const reportPath = path.join(__dirname, 'essential_workflows_created.json');
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
    console.log(`\n📊 Report saved: ${reportPath}`);
  }
}

// Run
if (require.main === module) {
  const creator = new WorkflowCreator();
  creator.execute().catch(console.error);
}

module.exports = WorkflowCreator;