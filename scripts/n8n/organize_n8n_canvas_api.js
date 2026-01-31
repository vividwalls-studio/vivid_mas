#!/usr/bin/env node

/**
 * N8N Workflow Canvas Organization Script - API Version
 * Connects directly to n8n API to organize workflows in real-time
 * Implements precise geometric alignment and professional presentation
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  // n8n API Configuration
  api: {
    baseUrl: process.env.N8N_URL || 'https://n8n.vividwalls.blog',
    apiKey: process.env.N8N_API_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }
  },
  
  // Canvas Layout Configuration
  layout: {
    canvasWidth: 4000,           // Total canvas width
    canvasHeight: 3000,          // Total canvas height
    
    // Grid system for perfect alignment
    grid: {
      horizontalSpacing: 200,     // Exactly 200px between nodes horizontally
      verticalSpacing: 150,       // Exactly 150px between nodes vertically
      nodeWidth: 150,             // Standard node width
      nodeHeight: 100,            // Standard node height
      padding: 50                 // Canvas edge padding
    },
    
    // Hierarchical levels
    levels: {
      orchestrator: { y: 100, centered: true },
      directors: { y: 400, distributed: true },
      specialized: { y: 700, grouped: true },
      subAgents: { y: 1000, grouped: true },
      utilities: { y: 1300, grouped: true }
    }
  },
  
  // Visual Styling
  styling: {
    // Node colors by agent type
    nodeColors: {
      'business-manager': '#FF6B6B',      // Red - Central orchestrator
      'marketing-director': '#4ECDC4',     // Teal
      'sales-director': '#FFD93D',         // Yellow
      'operations-director': '#6BCB77',    // Light Green
      'customer-director': '#4D96FF',      // Blue
      'finance-director': '#FFB6C1',       // Pink
      'analytics-director': '#DDA0DD',     // Plum
      'product-director': '#FF8C00',       // Orange
      'technology-director': '#708090',    // Slate Gray
      'creative-director': '#FF69B4',      // Hot Pink
      'social-director': '#1DA1F2',        // Twitter Blue
      'compliance-director': '#DC143C',    // Crimson
      
      // Specialized agent colors
      'marketing-agent': '#95E77E',        // Light Green
      'sales-agent': '#FFA500',            // Orange
      'operations-agent': '#32CD32',       // Lime Green
      'customer-agent': '#87CEEB',         // Sky Blue
      'finance-agent': '#FFC0CB',          // Light Pink
      'analytics-agent': '#E6E6FA',        // Lavender
      'product-agent': '#FFE4B5',          // Moccasin
      'technology-agent': '#B0C4DE',       // Light Steel Blue
      'creative-agent': '#FFB6C1',         // Light Pink
      'social-agent': '#00CED1',           // Dark Turquoise
      'utility-agent': '#D3D3D3',          // Light Gray
      'integration-agent': '#C0C0C0'       // Silver
    },
    
    // Sticky note styling
    stickyNotes: {
      width: 300,
      minHeight: 150,
      maxHeight: 400,
      backgroundColor: '#FFF9E6',
      borderColor: '#FFD700',
      fontSize: 12,
      padding: 15,
      offset: { x: -330, y: 0 }  // Position to the left of nodes
    }
  },
  
  // Agent categorization patterns
  agentPatterns: {
    orchestrator: ['business manager', 'orchestrator', 'central'],
    directors: ['director'],
    marketing: ['marketing', 'email', 'seo', 'campaign', 'content', 'copy', 'creative'],
    sales: ['sales', 'hospitality', 'corporate', 'healthcare', 'retail', 'residential', 'commercial'],
    operations: ['operations', 'inventory', 'fulfillment', 'vendor', 'logistics', 'supply'],
    customer: ['customer', 'support', 'feedback', 'satisfaction', 'loyalty', 'experience'],
    finance: ['finance', 'budget', 'roi', 'cash', 'accounting', 'financial'],
    analytics: ['analytics', 'data', 'kpi', 'performance', 'insights', 'intelligence'],
    product: ['product', 'catalog', 'development', 'strategy', 'research'],
    technology: ['technology', 'system', 'infrastructure', 'security', 'integration', 'monitoring'],
    creative: ['creative', 'design', 'visual', 'brand', 'content creation'],
    social: ['facebook', 'instagram', 'pinterest', 'twitter', 'linkedin', 'tiktok', 'youtube', 'social'],
    utility: ['utility', 'helper', 'tool', 'service', 'support', 'task']
  }
};

class N8NCanvasOrganizer {
  constructor() {
    this.workflows = [];
    this.nodeGroups = {};
    this.connectionMap = new Map();
    this.axios = axios.create({
      baseURL: CONFIG.api.baseUrl,
      headers: {
        ...CONFIG.api.headers,
        'X-N8N-API-KEY': CONFIG.api.apiKey
      }
    });
  }
  
  /**
   * Fetch all workflows from n8n
   */
  async fetchWorkflows() {
    try {
      console.log('📡 Fetching workflows from n8n API...');
      const response = await this.axios.get('/api/v1/workflows');
      this.workflows = response.data.data || [];
      console.log(`   ✅ Found ${this.workflows.length} workflows`);
      return this.workflows;
    } catch (error) {
      console.error('❌ Failed to fetch workflows:', error.message);
      throw error;
    }
  }
  
  /**
   * Categorize agent by name patterns
   */
  categorizeAgent(nodeName) {
    const lowerName = nodeName.toLowerCase();
    
    // Check each category pattern
    for (const [category, patterns] of Object.entries(CONFIG.agentPatterns)) {
      if (patterns.some(pattern => lowerName.includes(pattern))) {
        return category;
      }
    }
    
    return 'utility'; // Default category
  }
  
  /**
   * Get node color based on categorization
   */
  getNodeColor(nodeName) {
    const category = this.categorizeAgent(nodeName);
    const lowerName = nodeName.toLowerCase();
    
    // Check for specific director types
    if (lowerName.includes('director')) {
      for (const [key, color] of Object.entries(CONFIG.styling.nodeColors)) {
        if (key.includes('director') && lowerName.includes(key.split('-')[0])) {
          return color;
        }
      }
    }
    
    // Check for specific agent types
    for (const [key, color] of Object.entries(CONFIG.styling.nodeColors)) {
      if (key.includes(category)) {
        return color;
      }
    }
    
    return CONFIG.styling.nodeColors['utility-agent'];
  }
  
  /**
   * Calculate optimal grid position
   */
  calculateGridPosition(level, index, totalInLevel) {
    const { grid, canvasWidth } = CONFIG.layout;
    const levelConfig = CONFIG.layout.levels[level] || { y: 1500, distributed: true };
    
    // Calculate Y position based on level
    const y = levelConfig.y;
    
    // Calculate X position with centering
    let x;
    if (levelConfig.centered && totalInLevel === 1) {
      // Center single nodes
      x = canvasWidth / 2;
    } else if (levelConfig.distributed) {
      // Distribute evenly across canvas
      const totalWidth = (totalInLevel - 1) * grid.horizontalSpacing;
      const startX = (canvasWidth - totalWidth) / 2;
      x = startX + (index * grid.horizontalSpacing);
    } else if (levelConfig.grouped) {
      // Group nodes by category
      const groupWidth = Math.min(totalInLevel * grid.horizontalSpacing, canvasWidth - (grid.padding * 2));
      const startX = (canvasWidth - groupWidth) / 2;
      x = startX + (index * grid.horizontalSpacing);
    } else {
      // Default grid positioning
      x = grid.padding + (index * grid.horizontalSpacing);
    }
    
    // Ensure positions are within canvas bounds
    x = Math.max(grid.padding, Math.min(x, canvasWidth - grid.padding - grid.nodeWidth));
    y = Math.max(grid.padding, Math.min(y, CONFIG.layout.canvasHeight - grid.padding - grid.nodeHeight));
    
    return { x: Math.round(x), y: Math.round(y) };
  }
  
  /**
   * Create sticky note content
   */
  createStickyNoteMarkdown(node, category) {
    const agentInfo = this.getAgentInfo(node.name);
    
    let markdown = `# ${node.name}\n\n`;
    markdown += `**Category:** ${category.charAt(0).toUpperCase() + category.slice(1)}\n\n`;
    
    if (agentInfo.role) {
      markdown += `**Role:** ${agentInfo.role}\n\n`;
    }
    
    if (agentInfo.responsibilities && agentInfo.responsibilities.length > 0) {
      markdown += `## Responsibilities\n`;
      agentInfo.responsibilities.forEach(resp => {
        markdown += `- ${resp}\n`;
      });
      markdown += '\n';
    }
    
    if (agentInfo.integrations && agentInfo.integrations.length > 0) {
      markdown += `## Integrations\n`;
      agentInfo.integrations.forEach(integration => {
        markdown += `- ${integration}\n`;
      });
      markdown += '\n';
    }
    
    if (agentInfo.mcpServers && agentInfo.mcpServers.length > 0) {
      markdown += `## MCP Servers\n`;
      agentInfo.mcpServers.forEach(server => {
        markdown += `- ${server}\n`;
      });
      markdown += '\n';
    }
    
    // Add workflow metadata
    markdown += `---\n`;
    markdown += `*Workflow ID: ${node.id || 'N/A'}*\n`;
    markdown += `*Type: ${node.type}*\n`;
    markdown += `*Position: [${node.position?.[0] || 0}, ${node.position?.[1] || 0}]*`;
    
    return markdown;
  }
  
  /**
   * Get agent information based on name
   */
  getAgentInfo(nodeName) {
    const info = {
      role: '',
      responsibilities: [],
      integrations: [],
      mcpServers: []
    };
    
    const lowerName = nodeName.toLowerCase();
    
    // Business Manager specific info
    if (lowerName.includes('business manager')) {
      info.role = 'Central orchestrator and strategic decision maker';
      info.responsibilities = [
        'Achieve $30K+ monthly revenue',
        'Coordinate 10 Director agents',
        'Strategic alignment',
        'Executive reporting',
        'Resource optimization'
      ];
      info.mcpServers = ['Telegram MCP', 'Email MCP', 'HTML Report MCP'];
    }
    
    // Marketing Director specific info
    else if (lowerName.includes('marketing') && lowerName.includes('director')) {
      info.role = 'Orchestrate comprehensive marketing campaigns';
      info.responsibilities = [
        'Achieve 15x ROI on marketing',
        'Build 3,000+ email subscribers',
        'Daily social media presence',
        'AI-powered SEO strategy'
      ];
      info.mcpServers = ['SendGrid MCP', 'Shopify MCP', 'Analytics MCP'];
    }
    
    // Sales Director specific info
    else if (lowerName.includes('sales') && lowerName.includes('director')) {
      info.role = 'Deploy 13 specialized sales personas';
      info.responsibilities = [
        'Achieve 3.5%+ conversion rate',
        'Personalize customer journeys',
        'Dynamic pricing optimization',
        'CRM integration'
      ];
      info.mcpServers = ['Twenty CRM MCP', 'Stripe MCP', 'Shopify MCP'];
    }
    
    // Add more agent-specific information as needed...
    
    return info;
  }
  
  /**
   * Organize workflow nodes with geometric precision
   */
  async organizeWorkflow(workflow) {
    if (!workflow.nodes || workflow.nodes.length === 0) {
      console.log(`   ⚠️  No nodes in workflow: ${workflow.name}`);
      return workflow;
    }
    
    console.log(`   🎨 Organizing: ${workflow.name} (${workflow.nodes.length} nodes)`);
    
    // Categorize all nodes
    const categorizedNodes = {
      orchestrator: [],
      directors: [],
      specialized: [],
      subAgents: [],
      utilities: []
    };
    
    // Track sticky notes separately
    const stickyNotes = [];
    const regularNodes = [];
    
    workflow.nodes.forEach(node => {
      if (node.type === 'n8n-nodes-base.stickyNote') {
        // Skip existing sticky notes, we'll recreate them
        return;
      }
      
      regularNodes.push(node);
      const category = this.categorizeAgent(node.name);
      
      // Determine hierarchical level
      if (category === 'orchestrator' || node.name.toLowerCase().includes('business manager')) {
        categorizedNodes.orchestrator.push(node);
      } else if (node.name.toLowerCase().includes('director')) {
        categorizedNodes.directors.push(node);
      } else if (['marketing', 'sales', 'operations', 'customer', 'finance', 'analytics', 'product', 'technology', 'creative', 'social'].includes(category)) {
        categorizedNodes.specialized.push(node);
      } else if (node.name.toLowerCase().includes('agent')) {
        categorizedNodes.subAgents.push(node);
      } else {
        categorizedNodes.utilities.push(node);
      }
    });
    
    // Position nodes by level with geometric precision
    const updatedNodes = [];
    
    // Level 0: Orchestrator
    categorizedNodes.orchestrator.forEach((node, index) => {
      const position = this.calculateGridPosition('orchestrator', index, categorizedNodes.orchestrator.length);
      node.position = [position.x, position.y];
      node.color = this.getNodeColor(node.name);
      updatedNodes.push(node);
      
      // Create sticky note
      const stickyNote = this.createStickyNote(node, 'orchestrator', position);
      updatedNodes.push(stickyNote);
    });
    
    // Level 1: Directors
    categorizedNodes.directors.forEach((node, index) => {
      const position = this.calculateGridPosition('directors', index, categorizedNodes.directors.length);
      node.position = [position.x, position.y];
      node.color = this.getNodeColor(node.name);
      updatedNodes.push(node);
      
      // Create sticky note
      const stickyNote = this.createStickyNote(node, 'director', position);
      updatedNodes.push(stickyNote);
    });
    
    // Level 2: Specialized Agents
    categorizedNodes.specialized.forEach((node, index) => {
      const position = this.calculateGridPosition('specialized', index, categorizedNodes.specialized.length);
      node.position = [position.x, position.y];
      node.color = this.getNodeColor(node.name);
      updatedNodes.push(node);
      
      // Create sticky note
      const category = this.categorizeAgent(node.name);
      const stickyNote = this.createStickyNote(node, category, position);
      updatedNodes.push(stickyNote);
    });
    
    // Level 3: Sub-Agents
    categorizedNodes.subAgents.forEach((node, index) => {
      const position = this.calculateGridPosition('subAgents', index, categorizedNodes.subAgents.length);
      node.position = [position.x, position.y];
      node.color = this.getNodeColor(node.name);
      updatedNodes.push(node);
      
      // Create sticky note
      const category = this.categorizeAgent(node.name);
      const stickyNote = this.createStickyNote(node, category, position);
      updatedNodes.push(stickyNote);
    });
    
    // Level 4: Utilities
    categorizedNodes.utilities.forEach((node, index) => {
      const position = this.calculateGridPosition('utilities', index, categorizedNodes.utilities.length);
      node.position = [position.x, position.y];
      node.color = this.getNodeColor(node.name);
      updatedNodes.push(node);
      
      // Create sticky note
      const stickyNote = this.createStickyNote(node, 'utility', position);
      updatedNodes.push(stickyNote);
    });
    
    // Update workflow with organized nodes
    workflow.nodes = updatedNodes;
    
    // Ensure no overlapping by validating positions
    this.validateNoOverlap(workflow.nodes);
    
    return workflow;
  }
  
  /**
   * Create a sticky note for a node
   */
  createStickyNote(node, category, position) {
    const { stickyNotes } = CONFIG.styling;
    
    return {
      type: 'n8n-nodes-base.stickyNote',
      typeVersion: 1,
      name: `Note_${node.name.replace(/[^a-zA-Z0-9]/g, '_')}`,
      position: [
        position.x + stickyNotes.offset.x,
        position.y + stickyNotes.offset.y
      ],
      parameters: {
        content: this.createStickyNoteMarkdown(node, category),
        width: stickyNotes.width,
        height: Math.min(stickyNotes.maxHeight, Math.max(stickyNotes.minHeight, 
          150 + (this.getAgentInfo(node.name).responsibilities.length * 20)))
      }
    };
  }
  
  /**
   * Validate no nodes overlap
   */
  validateNoOverlap(nodes) {
    const positions = new Set();
    const overlaps = [];
    
    nodes.forEach(node => {
      if (node.position) {
        const posKey = `${Math.round(node.position[0] / 50) * 50}_${Math.round(node.position[1] / 50) * 50}`;
        if (positions.has(posKey) && node.type !== 'n8n-nodes-base.stickyNote') {
          overlaps.push(node.name);
          // Adjust position slightly to avoid overlap
          node.position[0] += CONFIG.layout.grid.horizontalSpacing / 2;
        }
        positions.add(posKey);
      }
    });
    
    if (overlaps.length > 0) {
      console.log(`   ⚠️  Adjusted overlapping nodes: ${overlaps.join(', ')}`);
    }
  }
  
  /**
   * Update workflow via API
   */
  async updateWorkflow(workflow) {
    try {
      const response = await this.axios.put(
        `/api/v1/workflows/${workflow.id}`,
        workflow
      );
      return response.data;
    } catch (error) {
      console.error(`   ❌ Failed to update workflow ${workflow.name}:`, error.message);
      throw error;
    }
  }
  
  /**
   * Main execution function
   */
  async execute() {
    console.log('🚀 N8N Canvas Organization - API Version\n');
    console.log('=' .repeat(60));
    
    try {
      // Fetch all workflows
      await this.fetchWorkflows();
      
      if (this.workflows.length === 0) {
        console.log('⚠️  No workflows found');
        return;
      }
      
      console.log(`\n📊 Processing ${this.workflows.length} workflows...\n`);
      
      let successCount = 0;
      let errorCount = 0;
      const results = [];
      
      // Process each workflow
      for (const workflowSummary of this.workflows) {
        try {
          // Fetch full workflow details
          console.log(`\n📁 Processing: ${workflowSummary.name}`);
          const fullWorkflow = await this.axios.get(`/api/v1/workflows/${workflowSummary.id}`);
          const workflow = fullWorkflow.data;
          
          // Organize the workflow
          const organizedWorkflow = await this.organizeWorkflow(workflow);
          
          // Update the workflow
          await this.updateWorkflow(organizedWorkflow);
          
          successCount++;
          console.log(`   ✅ Successfully organized and updated`);
          
          results.push({
            name: workflow.name,
            id: workflow.id,
            status: 'success',
            nodeCount: workflow.nodes?.length || 0
          });
        } catch (error) {
          errorCount++;
          console.error(`   ❌ Error: ${error.message}`);
          
          results.push({
            name: workflowSummary.name,
            id: workflowSummary.id,
            status: 'error',
            error: error.message
          });
        }
      }
      
      // Generate summary report
      console.log('\n' + '='.repeat(60));
      console.log('✨ Canvas Organization Complete!\n');
      console.log(`   Total Workflows: ${this.workflows.length}`);
      console.log(`   ✅ Successfully Organized: ${successCount}`);
      console.log(`   ❌ Errors: ${errorCount}`);
      console.log('='.repeat(60));
      
      // Save detailed report
      const report = {
        timestamp: new Date().toISOString(),
        summary: {
          total: this.workflows.length,
          success: successCount,
          errors: errorCount
        },
        configuration: {
          canvasWidth: CONFIG.layout.canvasWidth,
          canvasHeight: CONFIG.layout.canvasHeight,
          horizontalSpacing: CONFIG.layout.grid.horizontalSpacing,
          verticalSpacing: CONFIG.layout.grid.verticalSpacing,
          levels: Object.keys(CONFIG.layout.levels)
        },
        results: results
      };
      
      const reportPath = path.join(__dirname, 'canvas_organization_api_report.json');
      fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
      console.log(`\n📊 Detailed report saved to: ${reportPath}`);
      
    } catch (error) {
      console.error('\n❌ Fatal error:', error.message);
      process.exit(1);
    }
  }
}

// Execute if run directly
if (require.main === module) {
  const organizer = new N8NCanvasOrganizer();
  organizer.execute().catch(console.error);
}

module.exports = N8NCanvasOrganizer;