#!/usr/bin/env node

/**
 * Minimal N8N Canvas Organizer - Only updates node positions
 * Works with n8n API without modifying node properties
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

const CONFIG = {
  api: {
    baseUrl: 'https://n8n.vividwalls.blog',
    apiKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I'
  },
  layout: {
    horizontalSpacing: 200,
    verticalSpacing: 150,
    canvasWidth: 6000,
    levelSpacing: 400,
    startX: 100,
    startY: 100
  }
};

class MinimalCanvasOrganizer {
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
    
    this.results = {
      success: [],
      errors: [],
      skipped: []
    };
  }
  
  /**
   * Categorize node by name to determine hierarchy level
   */
  getNodeLevel(nodeName) {
    const name = nodeName.toLowerCase();
    
    // Level 0: Business Manager / Orchestrator
    if (name.includes('business manager') || name.includes('orchestrator')) {
      return 0;
    }
    
    // Level 1: Directors
    if (name.includes('director')) {
      return 1;
    }
    
    // Level 2: Marketing/Social Media agents
    if (name.includes('marketing') || name.includes('social') || 
        name.includes('facebook') || name.includes('instagram') || 
        name.includes('pinterest') || name.includes('campaign')) {
      return 2;
    }
    
    // Level 3: Sales agents
    if (name.includes('sales') || name.includes('hospitality') || 
        name.includes('corporate') || name.includes('healthcare') || 
        name.includes('retail')) {
      return 3;
    }
    
    // Level 4: Operations/Support agents
    if (name.includes('operation') || name.includes('customer') || 
        name.includes('support') || name.includes('fulfillment')) {
      return 4;
    }
    
    // Level 5: Other specialized agents
    if (name.includes('agent')) {
      return 5;
    }
    
    // Level 6: Utilities and other nodes
    return 6;
  }
  
  /**
   * Calculate position for node
   */
  calculatePosition(level, index, totalInLevel) {
    const { horizontalSpacing, levelSpacing, canvasWidth, startX, startY } = CONFIG.layout;
    
    // Y position based on level
    const y = startY + (level * levelSpacing);
    
    // X position - center the row
    const rowWidth = (totalInLevel - 1) * horizontalSpacing;
    const centerX = canvasWidth / 2;
    const startRowX = centerX - (rowWidth / 2);
    const x = startRowX + (index * horizontalSpacing);
    
    return [Math.round(x), Math.round(y)];
  }
  
  /**
   * Organize workflow nodes - only update positions
   */
  organizeWorkflow(workflow) {
    if (!workflow.nodes || workflow.nodes.length === 0) {
      return null;
    }
    
    // Group nodes by level
    const nodesByLevel = {};
    
    workflow.nodes.forEach(node => {
      // Skip sticky notes - don't modify them
      if (node.type === 'n8n-nodes-base.stickyNote') {
        return;
      }
      
      const level = this.getNodeLevel(node.name);
      if (!nodesByLevel[level]) {
        nodesByLevel[level] = [];
      }
      nodesByLevel[level].push(node);
    });
    
    // Update positions only
    Object.keys(nodesByLevel).sort((a, b) => a - b).forEach(level => {
      const nodes = nodesByLevel[level];
      nodes.forEach((node, index) => {
        const newPosition = this.calculatePosition(
          parseInt(level),
          index,
          nodes.length
        );
        
        // Only update position, don't add any other properties
        node.position = newPosition;
      });
    });
    
    return workflow;
  }
  
  /**
   * Fetch workflow from API
   */
  async getWorkflow(id) {
    try {
      const response = await this.api.get(`/api/v1/workflows/${id}`);
      return response.data.data || response.data;
    } catch (error) {
      if (error.response?.status === 404) {
        return null;
      }
      throw error;
    }
  }
  
  /**
   * Update workflow via API
   */
  async updateWorkflow(workflow) {
    try {
      // Only send the truly editable fields
      // Based on the errors, it seems only nodes, connections, name and settings are editable
      const updatePayload = {
        name: workflow.name,
        nodes: workflow.nodes,
        connections: workflow.connections || {},
        settings: workflow.settings || {}
      };
      
      // Don't include tags - they're read-only
      
      const response = await this.api.put(
        `/api/v1/workflows/${workflow.id}`,
        updatePayload
      );
      
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
    console.log('🎨 Minimal N8N Canvas Organizer\n');
    console.log('Configuration:');
    console.log(`  • Grid: ${CONFIG.layout.horizontalSpacing}px × ${CONFIG.layout.verticalSpacing}px`);
    console.log(`  • Levels: 7 hierarchical levels`);
    console.log(`  • Target: ${CONFIG.api.baseUrl}`);
    console.log('=' .repeat(60) + '\n');
    
    try {
      // Get all workflows
      console.log('📡 Fetching workflows...');
      const response = await this.api.get('/api/v1/workflows');
      const workflows = response.data.data || response.data || [];
      
      // Filter for agent workflows
      const agentWorkflows = workflows.filter(w => {
        const name = w.name.toLowerCase();
        return name.includes('agent') || 
               name.includes('director') || 
               name.includes('manager') ||
               name.includes('vividwalls');
      });
      
      console.log(`Found ${agentWorkflows.length} agent workflows\n`);
      
      // Process each workflow
      for (const summary of agentWorkflows) {
        process.stdout.write(`${summary.name.padEnd(60, '.')}`);
        
        try {
          // Get full workflow
          const workflow = await this.getWorkflow(summary.id);
          
          if (!workflow) {
            console.log(' [NOT FOUND]');
            this.results.skipped.push(summary.name);
            continue;
          }
          
          if (!workflow.nodes || workflow.nodes.length === 0) {
            console.log(' [NO NODES]');
            this.results.skipped.push(summary.name);
            continue;
          }
          
          // Organize nodes
          const organized = this.organizeWorkflow(workflow);
          
          if (!organized) {
            console.log(' [SKIP]');
            this.results.skipped.push(summary.name);
            continue;
          }
          
          // Update workflow
          await this.updateWorkflow(organized);
          
          console.log(' ✅');
          this.results.success.push(summary.name);
          
        } catch (error) {
          console.log(` ❌ ${error.message}`);
          this.results.errors.push({
            name: summary.name,
            error: error.message
          });
        }
        
        // Small delay
        await new Promise(r => setTimeout(r, 100));
      }
      
      // Summary
      console.log('\n' + '=' .repeat(60));
      console.log('✨ Organization Complete!\n');
      console.log(`Results:`);
      console.log(`  ✅ Success: ${this.results.success.length}`);
      console.log(`  ❌ Errors: ${this.results.errors.length}`);
      console.log(`  ⏭️  Skipped: ${this.results.skipped.length}`);
      
      if (this.results.success.length > 0) {
        console.log('\n✅ Successfully organized:');
        this.results.success.forEach(name => {
          console.log(`  • ${name}`);
        });
      }
      
      if (this.results.errors.length > 0) {
        console.log('\n❌ Errors:');
        this.results.errors.forEach(err => {
          console.log(`  • ${err.name}: ${err.error}`);
        });
      }
      
      // Save report
      const report = {
        timestamp: new Date().toISOString(),
        target: CONFIG.api.baseUrl,
        configuration: CONFIG.layout,
        results: this.results
      };
      
      const reportPath = path.join(__dirname, 'minimal_organizer_report.json');
      fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
      console.log(`\n📊 Report: ${reportPath}`);
      
    } catch (error) {
      console.error('\n❌ Fatal error:', error.message);
      process.exit(1);
    }
  }
}

// Run
if (require.main === module) {
  const organizer = new MinimalCanvasOrganizer();
  organizer.execute().catch(console.error);
}

module.exports = MinimalCanvasOrganizer;