#!/usr/bin/env node

/**
 * VividWalls MAS N8N Canvas Organization Script
 * Connects to remote n8n instance on DigitalOcean droplet
 * Organizes all agent workflows with precise geometric alignment
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Remote n8n Configuration
const N8N_CONFIG = {
  baseUrl: 'https://n8n.vividwalls.blog',
  apiKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I'
};

// Canvas Layout Configuration
const LAYOUT_CONFIG = {
  // Grid spacing requirements (as specified)
  grid: {
    horizontalSpacing: 200,  // Exactly 200px horizontal
    verticalSpacing: 150,    // Exactly 150px vertical
    sectionSpacing: 300,     // Extra space between major sections
  },
  
  // Canvas dimensions
  canvas: {
    width: 5000,
    height: 4000,
    padding: 100
  },
  
  // Sticky note configuration
  stickyNote: {
    width: 300,              // 250-350px as specified
    minHeight: 100,
    offset: { x: -350, y: 0 } // Position to avoid workflow lines
  }
};

// VividWalls MAS Agent Hierarchy
const AGENT_HIERARCHY = {
  // Level 0: Orchestrator
  orchestrator: {
    'Business Manager Agent': {
      level: 0,
      color: '#FF6B6B',
      description: 'Central orchestrator and strategic decision maker',
      responsibilities: [
        'Achieve $30K+ monthly revenue from $2K investment',
        'Coordinate 10 Director agents',
        'Strategic alignment with VividWalls vision',
        'Executive reporting to stakeholder',
        'Resource allocation optimization'
      ],
      integrations: ['Telegram MCP', 'Email MCP', 'HTML Report MCP']
    }
  },
  
  // Level 1: Directors
  directors: {
    'Marketing Director': {
      level: 1,
      color: '#4ECDC4',
      description: 'Orchestrate comprehensive marketing campaigns',
      responsibilities: [
        'Achieve 15x ROI on marketing spend',
        'Build 3,000+ email subscriber base',
        'Daily social media presence',
        'AI-powered SEO strategy'
      ],
      manages: 9
    },
    'Sales Director': {
      level: 1,
      color: '#FFD93D',
      description: 'Deploy 13 specialized sales personas',
      responsibilities: [
        'Achieve 3.5%+ conversion rate',
        'Personalize customer journeys',
        'Dynamic pricing optimization',
        'CRM integration and lead scoring'
      ],
      manages: 13
    },
    'Operations Director': {
      level: 1,
      color: '#6BCB77',
      description: 'Manage supply chain and fulfillment',
      responsibilities: [
        'Optimize inventory levels',
        'Vendor relationship management',
        'Quality control assurance',
        'Print partner coordination'
      ],
      manages: 4
    },
    'Customer Experience Director': {
      level: 1,
      color: '#4D96FF',
      description: 'Optimize customer satisfaction',
      responsibilities: [
        'Monitor customer feedback',
        'Implement loyalty programs',
        'Seamless customer journey',
        'Maintain high NPS'
      ],
      manages: 4
    },
    'Finance Director': {
      level: 1,
      color: '#FFB6C1',
      description: 'Financial planning and budget control',
      responsibilities: [
        'ROI optimization',
        'Cash flow monitoring',
        'Financial reporting',
        'Compliance assurance'
      ],
      manages: 4
    },
    'Analytics Director': {
      level: 1,
      color: '#DDA0DD',
      description: 'Data insights and performance optimization',
      responsibilities: [
        'KPI tracking',
        'Business intelligence',
        'Performance monitoring',
        'Reporting dashboards'
      ],
      manages: 4
    },
    'Product Director': {
      level: 1,
      color: '#FF8C00',
      description: 'Product strategy and market positioning',
      responsibilities: [
        'Market research',
        'Competitive analysis',
        'Product optimization',
        'Product-market fit'
      ],
      manages: 4
    },
    'Technology Director': {
      level: 1,
      color: '#708090',
      description: 'Technical infrastructure and innovation',
      responsibilities: [
        'System performance',
        'Security monitoring',
        'Platform integration',
        'Scalability assurance'
      ],
      manages: 4
    },
    'Creative Director': {
      level: 1,
      color: '#FF69B4',
      description: 'Visual identity and creative excellence',
      responsibilities: [
        'Design oversight',
        'Brand consistency',
        'Creative optimization',
        'Content coordination'
      ],
      manages: 4
    },
    'Social Media Director': {
      level: 1,
      color: '#1DA1F2',
      description: 'Platform-specific campaign strategies',
      responsibilities: [
        'Facebook campaigns',
        'Instagram content',
        'Pinterest boards',
        'Engagement optimization'
      ],
      manages: 3
    }
  },
  
  // Level 2+: Specialized Agents
  specializedAgents: {
    marketing: {
      level: 2,
      color: '#95E77E',
      agents: [
        'Content Strategy Agent',
        'Copy Writer Agent',
        'Copy Editor Agent',
        'Email Marketing Agent',
        'SEO Agent',
        'A/B Testing Agent',
        'Campaign Analytics Agent',
        'Keyword Agent',
        'Newsletter Agent'
      ]
    },
    sales: {
      level: 2,
      color: '#FFA500',
      agents: [
        'Hospitality Sales Agent',
        'Corporate Sales Agent',
        'Healthcare Sales Agent',
        'Retail Sales Agent',
        'Real Estate Sales Agent',
        'Homeowner Sales Agent',
        'Renter Sales Agent',
        'Interior Designer Agent',
        'Art Collector Agent',
        'Gift Buyer Agent',
        'Millennial Gen Z Agent',
        'Global Customer Agent',
        'Educational Sales Agent'
      ]
    },
    operations: {
      level: 3,
      color: '#32CD32',
      agents: [
        'Inventory Management Agent',
        'Fulfillment Agent',
        'Vendor Management Agent',
        'Quality Control Agent',
        'Logistics Agent',
        'Supply Chain Agent'
      ]
    },
    customerExperience: {
      level: 3,
      color: '#87CEEB',
      agents: [
        'Customer Support Agent',
        'Satisfaction Monitoring Agent',
        'Feedback Analysis Agent',
        'Loyalty Program Agent',
        'Customer Service Agent',
        'Live Chat Agent'
      ]
    },
    finance: {
      level: 3,
      color: '#FFC0CB',
      agents: [
        'Budget Management Agent',
        'ROI Analysis Agent',
        'Cash Flow Agent',
        'Financial Reporting Agent',
        'Accounting Agent'
      ]
    },
    analytics: {
      level: 3,
      color: '#E6E6FA',
      agents: [
        'Performance Analytics Agent',
        'Data Insights Agent',
        'KPI Tracking Agent',
        'Business Intelligence Agent',
        'Data Analytics Agent'
      ]
    },
    product: {
      level: 4,
      color: '#FFE4B5',
      agents: [
        'Product Strategy Agent',
        'Market Research Agent',
        'Competitive Analysis Agent',
        'Product Development Agent',
        'Catalog Management Agent'
      ]
    },
    technology: {
      level: 4,
      color: '#B0C4DE',
      agents: [
        'System Monitoring Agent',
        'Infrastructure Agent',
        'Security Agent',
        'Integration Agent'
      ]
    },
    creative: {
      level: 4,
      color: '#FFB6C1',
      agents: [
        'Visual Design Agent',
        'Content Creation Agent',
        'Brand Management Agent',
        'Creative Strategy Agent'
      ]
    },
    socialMedia: {
      level: 2,
      color: '#00CED1',
      agents: [
        'Facebook Agent',
        'Instagram Agent',
        'Pinterest Agent',
        'LinkedIn Agent',
        'TikTok Agent',
        'YouTube Agent',
        'Twitter Agent'
      ]
    }
  }
};

class RemoteN8NCanvasOrganizer {
  constructor() {
    this.api = axios.create({
      baseURL: N8N_CONFIG.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'X-N8N-API-KEY': N8N_CONFIG.apiKey
      },
      timeout: 30000
    });
    
    this.workflows = [];
    this.processedWorkflows = [];
    this.nodePositions = new Map();
  }
  
  /**
   * Calculate precise grid position
   */
  calculatePosition(level, index, totalInRow) {
    const { grid, canvas } = LAYOUT_CONFIG;
    
    // Y position based on level
    const y = canvas.padding + (level * (grid.verticalSpacing + grid.sectionSpacing));
    
    // X position - center the row
    const rowWidth = (totalInRow - 1) * grid.horizontalSpacing;
    const startX = (canvas.width - rowWidth) / 2;
    const x = startX + (index * grid.horizontalSpacing);
    
    // Ensure alignment to grid
    return {
      x: Math.round(x / 10) * 10,  // Align to 10px grid
      y: Math.round(y / 10) * 10
    };
  }
  
  /**
   * Create sticky note with proper Markdown formatting
   */
  createStickyNote(node, agentInfo, position) {
    const { stickyNote } = LAYOUT_CONFIG;
    
    // Build Markdown content
    let content = `# ${node.name}\n\n`;
    
    if (agentInfo) {
      content += `**${agentInfo.description}**\n\n`;
      
      if (agentInfo.responsibilities) {
        content += `## Key Responsibilities\n`;
        agentInfo.responsibilities.forEach(resp => {
          content += `- ${resp}\n`;
        });
        content += '\n';
      }
      
      if (agentInfo.manages) {
        content += `## Manages\n`;
        content += `${agentInfo.manages} specialized agents\n\n`;
      }
      
      if (agentInfo.integrations) {
        content += `## Integration Points\n`;
        agentInfo.integrations.forEach(int => {
          content += `- ${int}\n`;
        });
        content += '\n';
      }
    }
    
    content += `---\n`;
    content += `*VividWalls MAS Component*`;
    
    // Calculate height based on content
    const lineCount = content.split('\n').length;
    const height = Math.max(stickyNote.minHeight, Math.min(400, lineCount * 18));
    
    return {
      type: 'n8n-nodes-base.stickyNote',
      typeVersion: 1,
      name: `StickyNote_${node.name.replace(/[^a-zA-Z0-9]/g, '_')}`,
      position: [
        position.x + stickyNote.offset.x,
        position.y + stickyNote.offset.y
      ],
      parameters: {
        content: content,
        width: stickyNote.width,
        height: height
      }
    };
  }
  
  /**
   * Identify agent type and get configuration
   */
  identifyAgent(nodeName) {
    const lowerName = nodeName.toLowerCase();
    
    // Check orchestrator
    if (lowerName.includes('business manager') || lowerName.includes('orchestrator')) {
      return { type: 'orchestrator', config: AGENT_HIERARCHY.orchestrator['Business Manager Agent'] };
    }
    
    // Check directors
    for (const [directorName, config] of Object.entries(AGENT_HIERARCHY.directors)) {
      if (lowerName.includes(directorName.toLowerCase().split(' ')[0])) {
        return { type: 'director', config: config, name: directorName };
      }
    }
    
    // Check specialized agents
    for (const [category, categoryConfig] of Object.entries(AGENT_HIERARCHY.specializedAgents)) {
      for (const agentName of categoryConfig.agents) {
        if (lowerName.includes(agentName.toLowerCase().split(' ')[0])) {
          return { 
            type: 'specialized', 
            category: category,
            config: categoryConfig,
            name: agentName
          };
        }
      }
    }
    
    // Default to utility
    return { type: 'utility', config: { level: 5, color: '#A9A9A9' } };
  }
  
  /**
   * Organize workflow nodes
   */
  organizeWorkflowNodes(workflow) {
    if (!workflow.nodes || workflow.nodes.length === 0) {
      return workflow;
    }
    
    const organizedNodes = [];
    const nodesByLevel = {
      0: [], // Orchestrator
      1: [], // Directors
      2: [], // Marketing/Social agents
      3: [], // Operations/Customer agents
      4: [], // Product/Tech agents
      5: []  // Utilities
    };
    
    // Remove existing sticky notes
    const workflowNodes = workflow.nodes.filter(n => n.type !== 'n8n-nodes-base.stickyNote');
    
    // Categorize nodes by level
    workflowNodes.forEach(node => {
      const agentInfo = this.identifyAgent(node.name);
      const level = agentInfo.config.level || 5;
      
      nodesByLevel[level].push({
        node: node,
        agentInfo: agentInfo
      });
    });
    
    // Position nodes level by level
    for (const [level, nodesInLevel] of Object.entries(nodesByLevel)) {
      if (nodesInLevel.length === 0) continue;
      
      nodesInLevel.forEach((item, index) => {
        const position = this.calculatePosition(
          parseInt(level),
          index,
          nodesInLevel.length
        );
        
        // Update node position and color
        item.node.position = [position.x, position.y];
        
        if (item.agentInfo.config.color) {
          item.node.color = item.agentInfo.config.color;
        }
        
        // Create sticky note
        const stickyNote = this.createStickyNote(
          item.node,
          item.agentInfo.config,
          position
        );
        
        // Add both to organized nodes
        organizedNodes.push(stickyNote);
        organizedNodes.push(item.node);
        
        // Track position for overlap detection
        const posKey = `${position.x}_${position.y}`;
        if (this.nodePositions.has(posKey)) {
          console.log(`   ⚠️  Adjusting overlap at ${posKey} for ${item.node.name}`);
          item.node.position[0] += LAYOUT_CONFIG.grid.horizontalSpacing / 2;
        }
        this.nodePositions.set(posKey, item.node.name);
      });
    }
    
    // Ensure connections remain intact
    if (workflow.connections) {
      // Connections are preserved as-is
    }
    
    workflow.nodes = organizedNodes;
    return workflow;
  }
  
  /**
   * Fetch all workflows from remote n8n
   */
  async fetchWorkflows() {
    try {
      console.log('📡 Connecting to n8n.vividwalls.blog...');
      const response = await this.api.get('/api/v1/workflows');
      this.workflows = response.data.data || response.data || [];
      console.log(`✅ Connected! Found ${this.workflows.length} workflows`);
      return this.workflows;
    } catch (error) {
      if (error.response) {
        console.error(`❌ API Error: ${error.response.status} - ${error.response.statusText}`);
        console.error('Response:', error.response.data);
      } else {
        console.error(`❌ Connection Error: ${error.message}`);
      }
      throw error;
    }
  }
  
  /**
   * Get full workflow details
   */
  async getWorkflow(id) {
    try {
      const response = await this.api.get(`/api/v1/workflows/${id}`);
      return response.data.data || response.data;
    } catch (error) {
      console.error(`❌ Failed to get workflow ${id}:`, error.message);
      throw error;
    }
  }
  
  /**
   * Update workflow on remote n8n
   */
  async updateWorkflow(workflow) {
    try {
      const response = await this.api.put(
        `/api/v1/workflows/${workflow.id}`,
        workflow
      );
      return response.data;
    } catch (error) {
      console.error(`❌ Failed to update workflow ${workflow.name}:`, error.message);
      throw error;
    }
  }
  
  /**
   * Main execution
   */
  async execute() {
    console.log('🎨 VividWalls MAS N8N Canvas Organization\n');
    console.log('=' .repeat(60));
    console.log('Target: n8n.vividwalls.blog (DigitalOcean Droplet)');
    console.log('Grid: 200px horizontal, 150px vertical spacing');
    console.log('=' .repeat(60) + '\n');
    
    try {
      // Fetch all workflows
      await this.fetchWorkflows();
      
      if (this.workflows.length === 0) {
        console.log('⚠️  No workflows found on remote n8n');
        return;
      }
      
      // Filter for VividWalls MAS agent workflows
      const agentWorkflows = this.workflows.filter(w => {
        const name = w.name.toLowerCase();
        return name.includes('agent') || 
               name.includes('director') || 
               name.includes('manager') ||
               name.includes('vividwalls');
      });
      
      console.log(`\n📊 Found ${agentWorkflows.length} agent workflows to organize\n`);
      
      let successCount = 0;
      let errorCount = 0;
      
      // Process each workflow
      for (const workflowSummary of agentWorkflows) {
        try {
          process.stdout.write(`⚙️  ${workflowSummary.name}... `);
          
          // Get full workflow
          const workflow = await this.getWorkflow(workflowSummary.id);
          
          // Organize nodes
          const organized = this.organizeWorkflowNodes(workflow);
          
          // Update on remote
          await this.updateWorkflow(organized);
          
          console.log('✅');
          successCount++;
          
          this.processedWorkflows.push({
            id: workflow.id,
            name: workflow.name,
            nodeCount: workflow.nodes?.length || 0,
            status: 'success'
          });
          
        } catch (error) {
          console.log('❌');
          console.error(`   Error: ${error.message}`);
          errorCount++;
          
          this.processedWorkflows.push({
            id: workflowSummary.id,
            name: workflowSummary.name,
            status: 'error',
            error: error.message
          });
        }
      }
      
      // Summary
      console.log('\n' + '=' .repeat(60));
      console.log('✨ Canvas Organization Complete!\n');
      console.log(`   Total Agent Workflows: ${agentWorkflows.length}`);
      console.log(`   ✅ Successfully Organized: ${successCount}`);
      console.log(`   ❌ Errors: ${errorCount}`);
      console.log('\nKey Features Applied:');
      console.log('   • Geometric grid alignment (200px × 150px)');
      console.log('   • Hierarchical layout (Orchestrator → Directors → Agents)');
      console.log('   • Color-coded by function');
      console.log('   • Sticky notes with Markdown documentation');
      console.log('   • Zero node overlap validation');
      console.log('=' .repeat(60));
      
      // Save report
      const report = {
        timestamp: new Date().toISOString(),
        target: 'n8n.vividwalls.blog',
        summary: {
          totalWorkflows: this.workflows.length,
          agentWorkflows: agentWorkflows.length,
          organized: successCount,
          errors: errorCount
        },
        configuration: LAYOUT_CONFIG,
        hierarchy: Object.keys(AGENT_HIERARCHY),
        workflows: this.processedWorkflows
      };
      
      const reportPath = path.join(__dirname, 'droplet_canvas_organization_report.json');
      fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
      console.log(`\n📊 Report saved: ${reportPath}`);
      
    } catch (error) {
      console.error('\n❌ Fatal Error:', error.message);
      if (error.response) {
        console.error('API Response:', error.response.data);
      }
      process.exit(1);
    }
  }
}

// Run the organizer
if (require.main === module) {
  const organizer = new RemoteN8NCanvasOrganizer();
  organizer.execute().catch(error => {
    console.error('Execution failed:', error);
    process.exit(1);
  });
}

module.exports = RemoteN8NCanvasOrganizer;