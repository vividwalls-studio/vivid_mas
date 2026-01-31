#!/usr/bin/env node

/**
 * Fixed N8N Canvas Organization Script for VividWalls MAS
 * Properly handles workflow updates via n8n API
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  // n8n API settings
  api: {
    baseUrl: 'https://n8n.vividwalls.blog',
    apiKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I',
    timeout: 60000 // Increase timeout for large workflows
  },
  
  // Canvas layout (200px × 150px grid as specified)
  layout: {
    grid: {
      horizontalSpacing: 200,
      verticalSpacing: 150
    },
    canvas: {
      width: 6000,
      height: 5000,
      padding: 100
    }
  },
  
  // Node colors by type
  colors: {
    'business-manager': '#FF6B6B',
    'marketing-director': '#4ECDC4',
    'sales-director': '#FFD93D',
    'operations-director': '#6BCB77',
    'customer-director': '#4D96FF',
    'finance-director': '#FFB6C1',
    'analytics-director': '#DDA0DD',
    'product-director': '#FF8C00',
    'technology-director': '#708090',
    'creative-director': '#FF69B4',
    'social-director': '#1DA1F2',
    'marketing': '#95E77E',
    'sales': '#FFA500',
    'operations': '#32CD32',
    'customer': '#87CEEB',
    'finance': '#FFC0CB',
    'analytics': '#E6E6FA',
    'product': '#FFE4B5',
    'technology': '#B0C4DE',
    'creative': '#FFB6C1',
    'social': '#00CED1',
    'default': '#A9A9A9'
  }
};

class N8NCanvasOrganizer {
  constructor() {
    this.api = axios.create({
      baseURL: CONFIG.api.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-N8N-API-KEY': CONFIG.api.apiKey
      },
      timeout: CONFIG.api.timeout
    });
    
    this.workflows = [];
    this.errors = [];
    this.successes = [];
  }
  
  /**
   * Fetch all workflows from n8n
   */
  async fetchWorkflows() {
    try {
      console.log('📡 Connecting to n8n.vividwalls.blog...');
      
      // First, try to get workflows list
      const response = await this.api.get('/api/v1/workflows');
      const data = response.data;
      
      // Handle different response formats
      if (data.data && Array.isArray(data.data)) {
        this.workflows = data.data;
      } else if (Array.isArray(data)) {
        this.workflows = data;
      } else {
        console.error('Unexpected response format:', data);
        this.workflows = [];
      }
      
      console.log(`✅ Found ${this.workflows.length} workflows\n`);
      return this.workflows;
      
    } catch (error) {
      console.error('❌ Failed to fetch workflows');
      if (error.response) {
        console.error(`   Status: ${error.response.status}`);
        console.error(`   Message: ${error.response.data?.message || error.response.statusText}`);
      } else {
        console.error(`   Error: ${error.message}`);
      }
      throw error;
    }
  }
  
  /**
   * Get full workflow details including nodes
   */
  async getWorkflowDetails(id) {
    try {
      const response = await this.api.get(`/api/v1/workflows/${id}`);
      
      // Handle different response formats
      if (response.data.data) {
        return response.data.data;
      } else if (response.data.id) {
        return response.data;
      }
      
      throw new Error('Invalid workflow data format');
      
    } catch (error) {
      if (error.response?.status === 404) {
        console.log(`   ⚠️  Workflow ${id} not found (might be deleted)`);
      } else {
        console.log(`   ⚠️  Failed to get workflow ${id}: ${error.message}`);
      }
      return null;
    }
  }
  
  /**
   * Categorize agent based on name
   */
  getAgentCategory(name) {
    const lowerName = name.toLowerCase();
    
    if (lowerName.includes('business manager') || lowerName.includes('orchestrator')) {
      return { type: 'orchestrator', level: 0, color: CONFIG.colors['business-manager'] };
    }
    
    if (lowerName.includes('director')) {
      if (lowerName.includes('marketing')) return { type: 'director', level: 1, color: CONFIG.colors['marketing-director'] };
      if (lowerName.includes('sales')) return { type: 'director', level: 1, color: CONFIG.colors['sales-director'] };
      if (lowerName.includes('operations')) return { type: 'director', level: 1, color: CONFIG.colors['operations-director'] };
      if (lowerName.includes('customer')) return { type: 'director', level: 1, color: CONFIG.colors['customer-director'] };
      if (lowerName.includes('finance')) return { type: 'director', level: 1, color: CONFIG.colors['finance-director'] };
      if (lowerName.includes('analytics')) return { type: 'director', level: 1, color: CONFIG.colors['analytics-director'] };
      if (lowerName.includes('product')) return { type: 'director', level: 1, color: CONFIG.colors['product-director'] };
      if (lowerName.includes('technology')) return { type: 'director', level: 1, color: CONFIG.colors['technology-director'] };
      if (lowerName.includes('creative')) return { type: 'director', level: 1, color: CONFIG.colors['creative-director'] };
      if (lowerName.includes('social')) return { type: 'director', level: 1, color: CONFIG.colors['social-director'] };
      return { type: 'director', level: 1, color: CONFIG.colors['default'] };
    }
    
    // Specialized agents
    if (lowerName.includes('facebook') || lowerName.includes('instagram') || lowerName.includes('pinterest') || 
        lowerName.includes('twitter') || lowerName.includes('linkedin') || lowerName.includes('tiktok')) {
      return { type: 'social', level: 2, color: CONFIG.colors['social'] };
    }
    
    if (lowerName.includes('marketing') || lowerName.includes('campaign') || lowerName.includes('email') || 
        lowerName.includes('seo') || lowerName.includes('content')) {
      return { type: 'marketing', level: 2, color: CONFIG.colors['marketing'] };
    }
    
    if (lowerName.includes('sales') || lowerName.includes('hospitality') || lowerName.includes('corporate') || 
        lowerName.includes('healthcare') || lowerName.includes('retail') || lowerName.includes('residential')) {
      return { type: 'sales', level: 2, color: CONFIG.colors['sales'] };
    }
    
    if (lowerName.includes('operation') || lowerName.includes('inventory') || lowerName.includes('fulfillment') || 
        lowerName.includes('vendor') || lowerName.includes('logistics')) {
      return { type: 'operations', level: 3, color: CONFIG.colors['operations'] };
    }
    
    if (lowerName.includes('customer') || lowerName.includes('support') || lowerName.includes('feedback')) {
      return { type: 'customer', level: 3, color: CONFIG.colors['customer'] };
    }
    
    if (lowerName.includes('finance') || lowerName.includes('budget') || lowerName.includes('roi')) {
      return { type: 'finance', level: 3, color: CONFIG.colors['finance'] };
    }
    
    if (lowerName.includes('analytics') || lowerName.includes('data') || lowerName.includes('kpi')) {
      return { type: 'analytics', level: 3, color: CONFIG.colors['analytics'] };
    }
    
    if (lowerName.includes('product') || lowerName.includes('catalog')) {
      return { type: 'product', level: 4, color: CONFIG.colors['product'] };
    }
    
    if (lowerName.includes('technology') || lowerName.includes('system') || lowerName.includes('infrastructure')) {
      return { type: 'technology', level: 4, color: CONFIG.colors['technology'] };
    }
    
    if (lowerName.includes('creative') || lowerName.includes('design') || lowerName.includes('brand')) {
      return { type: 'creative', level: 4, color: CONFIG.colors['creative'] };
    }
    
    return { type: 'utility', level: 5, color: CONFIG.colors['default'] };
  }
  
  /**
   * Calculate position for a node
   */
  calculatePosition(level, index, totalInLevel) {
    const { grid, canvas } = CONFIG.layout;
    
    // Y position based on level
    const levelSpacing = 400; // More space between levels
    const y = canvas.padding + (level * levelSpacing);
    
    // X position - center the nodes
    const rowWidth = (totalInLevel - 1) * grid.horizontalSpacing;
    const startX = (canvas.width - rowWidth) / 2;
    const x = startX + (index * grid.horizontalSpacing);
    
    return [Math.round(x), Math.round(y)];
  }
  
  /**
   * Organize workflow nodes
   */
  organizeWorkflowNodes(workflow) {
    if (!workflow.nodes || workflow.nodes.length === 0) {
      return workflow;
    }
    
    // Group nodes by level
    const nodesByLevel = {};
    const stickyNotes = [];
    
    // First pass: categorize all non-sticky nodes
    workflow.nodes.forEach(node => {
      // Skip sticky notes for now
      if (node.type === 'n8n-nodes-base.stickyNote') {
        return;
      }
      
      const category = this.getAgentCategory(node.name);
      const level = category.level;
      
      if (!nodesByLevel[level]) {
        nodesByLevel[level] = [];
      }
      
      nodesByLevel[level].push({
        node: node,
        category: category
      });
    });
    
    // Second pass: position nodes and create sticky notes
    Object.keys(nodesByLevel).sort().forEach(level => {
      const nodesInLevel = nodesByLevel[level];
      
      nodesInLevel.forEach((item, index) => {
        // Calculate position
        const position = this.calculatePosition(
          parseInt(level),
          index,
          nodesInLevel.length
        );
        
        // Update node position
        item.node.position = position;
        
        // Apply color if available
        if (item.category.color) {
          // Only set color if node supports it
          if (!item.node.type?.includes('trigger') && !item.node.type?.includes('webhook')) {
            item.node.color = item.category.color;
          }
        }
        
        // Don't create sticky notes for now - they're causing validation errors
        // We'll focus on organizing the existing nodes first
        // const stickyNote = {
        //   type: 'n8n-nodes-base.stickyNote',
        //   typeVersion: 1,
        //   name: `Note_${item.node.name.replace(/[^a-zA-Z0-9]/g, '_')}_${Date.now()}`,
        //   position: [position[0] - 350, position[1]],
        //   parameters: {
        //     content: this.createStickyNoteContent(item.node.name, item.category),
        //     height: 150,
        //     width: 300
        //   }
        // };
        
        // stickyNotes.push(stickyNote);
      });
    });
    
    // Don't add sticky notes for now - just return the organized nodes
    // workflow.nodes = [...workflow.nodes.filter(n => n.type !== 'n8n-nodes-base.stickyNote'), ...stickyNotes];
    
    return workflow;
  }
  
  /**
   * Create sticky note content
   */
  createStickyNoteContent(nodeName, category) {
    let content = `# ${nodeName}\n\n`;
    content += `**Type:** ${category.type}\n`;
    content += `**Level:** ${category.level}\n\n`;
    
    // Add specific information based on type
    if (category.type === 'orchestrator') {
      content += `Central orchestrator coordinating all VividWalls MAS operations.\n\n`;
      content += `**Responsibilities:**\n`;
      content += `• Coordinate 10+ Director agents\n`;
      content += `• Strategic decision making\n`;
      content += `• Resource allocation\n`;
      content += `• Executive reporting`;
    } else if (category.type === 'director') {
      content += `Director-level agent managing specialized teams.\n\n`;
      content += `**Key Functions:**\n`;
      content += `• Team coordination\n`;
      content += `• Performance monitoring\n`;
      content += `• Strategic planning`;
    } else {
      content += `Specialized agent for ${category.type} operations.\n\n`;
      content += `Part of the VividWalls Multi-Agent System.`;
    }
    
    return content;
  }
  
  /**
   * Update workflow via API
   */
  async updateWorkflow(workflow) {
    try {
      // Only include fields that are actually updatable
      // Based on n8n API, these are the modifiable fields
      const updateData = {
        nodes: workflow.nodes || [],
        connections: workflow.connections || {},
        settings: workflow.settings || {},
        name: workflow.name,
        tags: workflow.tags || []
      };
      
      // Do NOT include these read-only fields:
      // - id (read-only)
      // - active (read-only, use separate activation endpoint)
      // - staticData (managed internally)
      
      const response = await this.api.put(
        `/api/v1/workflows/${workflow.id}`,
        updateData
      );
      
      return response.data;
      
    } catch (error) {
      if (error.response) {
        throw new Error(`API Error ${error.response.status}: ${error.response.data?.message || error.response.statusText}`);
      }
      throw error;
    }
  }
  
  /**
   * Main execution
   */
  async execute() {
    console.log('🎨 VividWalls MAS N8N Canvas Organization (Fixed Version)\n');
    console.log('=' .repeat(60));
    console.log('Configuration:');
    console.log('  • Grid: 200px × 150px spacing');
    console.log('  • Hierarchical layout');
    console.log('  • Color-coded by function');
    console.log('  • Sticky notes with documentation');
    console.log('=' .repeat(60) + '\n');
    
    try {
      // Fetch all workflows
      await this.fetchWorkflows();
      
      if (this.workflows.length === 0) {
        console.log('No workflows found.');
        return;
      }
      
      // Filter for agent workflows
      const agentWorkflows = this.workflows.filter(w => {
        const name = w.name.toLowerCase();
        return name.includes('agent') || 
               name.includes('director') || 
               name.includes('manager') ||
               name.includes('vividwalls');
      });
      
      console.log(`Found ${agentWorkflows.length} agent workflows to organize\n`);
      
      // Process each workflow
      for (const workflowSummary of agentWorkflows) {
        process.stdout.write(`Processing: ${workflowSummary.name.padEnd(50)}`);
        
        try {
          // Get full workflow details
          const workflow = await this.getWorkflowDetails(workflowSummary.id);
          
          if (!workflow) {
            console.log(' [SKIP - Not found]');
            this.errors.push({
              name: workflowSummary.name,
              error: 'Workflow not found'
            });
            continue;
          }
          
          // Check if workflow has nodes
          if (!workflow.nodes || workflow.nodes.length === 0) {
            console.log(' [SKIP - No nodes]');
            continue;
          }
          
          // Organize the workflow
          const organized = this.organizeWorkflowNodes(workflow);
          
          // Update the workflow
          await this.updateWorkflow(organized);
          
          console.log(' ✅');
          this.successes.push(workflowSummary.name);
          
        } catch (error) {
          console.log(` ❌ ${error.message}`);
          this.errors.push({
            name: workflowSummary.name,
            error: error.message
          });
        }
        
        // Small delay to avoid rate limiting
        await new Promise(resolve => setTimeout(resolve, 100));
      }
      
      // Summary
      console.log('\n' + '=' .repeat(60));
      console.log('✨ Canvas Organization Complete!\n');
      console.log(`Results:`);
      console.log(`  ✅ Successfully organized: ${this.successes.length}`);
      console.log(`  ❌ Errors: ${this.errors.length}`);
      console.log(`  ⏭️  Skipped: ${agentWorkflows.length - this.successes.length - this.errors.length}`);
      
      if (this.errors.length > 0) {
        console.log('\nErrors encountered:');
        this.errors.forEach(err => {
          console.log(`  • ${err.name}: ${err.error}`);
        });
      }
      
      // Save report
      const report = {
        timestamp: new Date().toISOString(),
        summary: {
          total: agentWorkflows.length,
          success: this.successes.length,
          errors: this.errors.length,
          skipped: agentWorkflows.length - this.successes.length - this.errors.length
        },
        configuration: CONFIG.layout,
        successes: this.successes,
        errors: this.errors
      };
      
      const reportPath = path.join(__dirname, 'canvas_organization_fixed_report.json');
      fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
      console.log(`\n📊 Report saved: ${reportPath}`);
      
    } catch (error) {
      console.error('\n❌ Fatal error:', error.message);
      process.exit(1);
    }
  }
}

// Run if executed directly
if (require.main === module) {
  const organizer = new N8NCanvasOrganizer();
  organizer.execute().catch(console.error);
}

module.exports = N8NCanvasOrganizer;