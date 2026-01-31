#!/usr/bin/env node

/**
 * N8N Workflow Canvas Organization Script
 * Organizes all VividWalls MAS agent workflows with precise geometric alignment
 * and professional presentation in the n8n canvas
 */

const fs = require('fs');
const path = require('path');
const axios = require('axios');

// Configuration
const CONFIG = {
  n8nUrl: process.env.N8N_URL || 'https://n8n.vividwalls.blog',
  apiKey: process.env.N8N_API_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs',
  
  // Grid configuration
  grid: {
    horizontalSpacing: 200,  // Exactly 200px between nodes horizontally
    verticalSpacing: 150,     // Exactly 150px between nodes vertically
    startX: 100,              // Starting X position
    startY: 100,              // Starting Y position
    stickyNoteOffset: {       // Sticky note positioning relative to node
      x: 30,
      y: -120
    }
  },
  
  // Color coding for different agent types
  colors: {
    orchestrator: '#FF6B6B',     // Red - Business Manager
    director: '#4ECDC4',          // Teal - Director agents
    marketing: '#95E77E',         // Green - Marketing agents
    sales: '#FFD93D',             // Yellow - Sales agents
    operations: '#6BCB77',        // Light Green - Operations agents
    customerExperience: '#4D96FF', // Blue - Customer Experience agents
    finance: '#FFB6C1',           // Pink - Finance agents
    analytics: '#DDA0DD',         // Plum - Analytics agents
    product: '#FF8C00',           // Orange - Product agents
    technology: '#708090',        // Slate Gray - Technology agents
    creative: '#FF69B4',          // Hot Pink - Creative agents
    compliance: '#DC143C',        // Crimson - Compliance agents
    socialMedia: '#1DA1F2',       // Twitter Blue - Social Media agents
    utility: '#A9A9A9'            // Gray - Utility/Support agents
  },
  
  // Sticky note configuration
  stickyNote: {
    width: 300,
    minHeight: 150,
    backgroundColor: '#FFF3CD',
    borderColor: '#FFC107'
  }
};

// Agent hierarchy structure based on the compendium
const AGENT_HIERARCHY = {
  orchestrator: {
    name: 'Business Manager Agent',
    type: 'orchestrator',
    description: 'Central orchestrator and strategic decision maker',
    responsibilities: [
      'Achieve $30K+ monthly revenue from $2K investment',
      'Coordinate 10 Director agents',
      'Strategic alignment with VividWalls vision',
      'Executive reporting to stakeholder',
      'Resource allocation optimization'
    ]
  },
  
  directors: [
    {
      name: 'Marketing Director',
      type: 'director',
      description: 'Orchestrate comprehensive marketing campaigns',
      responsibilities: [
        'Achieve 15x ROI on marketing spend',
        'Build 3,000+ email subscriber base',
        'Daily social media presence',
        'AI-powered SEO strategy'
      ],
      subAgents: [
        'Social Media Director',
        'Creative Director',
        'Content Strategy Agent',
        'Copy Writer Agent',
        'Copy Editor Agent',
        'Email Marketing Agent',
        'SEO Agent',
        'A/B Testing Agent',
        'Campaign Analytics Agent'
      ]
    },
    {
      name: 'Sales Director',
      type: 'director',
      description: 'Deploy 13 specialized sales personas',
      responsibilities: [
        'Achieve 3.5%+ conversion rate',
        'Personalize customer journeys',
        'Dynamic pricing optimization',
        'CRM integration and lead scoring'
      ],
      subAgents: [
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
        'Millennial/Gen Z Agent',
        'Global Customer Agent'
      ]
    },
    {
      name: 'Operations Director',
      type: 'director',
      description: 'Manage supply chain and fulfillment',
      responsibilities: [
        'Optimize inventory levels',
        'Vendor relationship management',
        'Quality control assurance',
        'Print partner coordination'
      ],
      subAgents: [
        'Inventory Management Agent',
        'Fulfillment Agent',
        'Vendor Management Agent',
        'Quality Control Agent'
      ]
    },
    {
      name: 'Customer Experience Director',
      type: 'director',
      description: 'Optimize customer satisfaction',
      responsibilities: [
        'Monitor customer feedback',
        'Implement loyalty programs',
        'Seamless customer journey',
        'Maintain high NPS'
      ],
      subAgents: [
        'Customer Support Agent',
        'Satisfaction Monitoring Agent',
        'Feedback Analysis Agent',
        'Loyalty Program Agent'
      ]
    },
    {
      name: 'Finance Director',
      type: 'director',
      description: 'Financial planning and budget control',
      responsibilities: [
        'ROI optimization',
        'Cash flow monitoring',
        'Financial reporting',
        'Compliance assurance'
      ],
      subAgents: [
        'Budget Management Agent',
        'ROI Analysis Agent',
        'Cash Flow Agent',
        'Financial Reporting Agent'
      ]
    },
    {
      name: 'Analytics Director',
      type: 'director',
      description: 'Data insights and performance optimization',
      responsibilities: [
        'KPI tracking',
        'Business intelligence',
        'Performance monitoring',
        'Reporting dashboards'
      ],
      subAgents: [
        'Performance Analytics Agent',
        'Data Insights Agent',
        'KPI Tracking Agent',
        'Business Intelligence Agent'
      ]
    },
    {
      name: 'Product Director',
      type: 'director',
      description: 'Product strategy and market positioning',
      responsibilities: [
        'Market research',
        'Competitive analysis',
        'Product optimization',
        'Product-market fit'
      ],
      subAgents: [
        'Product Strategy Agent',
        'Market Research Agent',
        'Competitive Analysis Agent',
        'Product Development Agent'
      ]
    },
    {
      name: 'Technology Director',
      type: 'director',
      description: 'Technical infrastructure and innovation',
      responsibilities: [
        'System performance',
        'Security monitoring',
        'Platform integration',
        'Scalability assurance'
      ],
      subAgents: [
        'System Monitoring Agent',
        'Infrastructure Agent',
        'Security Agent',
        'Integration Agent'
      ]
    },
    {
      name: 'Creative Director',
      type: 'director',
      description: 'Visual identity and creative excellence',
      responsibilities: [
        'Design oversight',
        'Brand consistency',
        'Creative optimization',
        'Content coordination'
      ],
      subAgents: [
        'Visual Design Agent',
        'Content Creation Agent',
        'Brand Management Agent',
        'Creative Strategy Agent'
      ]
    },
    {
      name: 'Compliance & Risk Director',
      type: 'director',
      description: 'Risk management and compliance',
      responsibilities: [
        'Data privacy',
        'Regulatory compliance',
        'Risk assessment',
        'Crisis management'
      ],
      subAgents: [
        'Data Privacy Agent',
        'Regulatory Compliance Agent',
        'Risk Assessment Agent',
        'Crisis Management Agent'
      ]
    }
  ]
};

/**
 * Calculate grid position for a node based on its index in the hierarchy
 */
function calculateNodePosition(level, index, totalInLevel) {
  const { grid } = CONFIG;
  
  // Calculate row (Y position)
  const y = grid.startY + (level * (grid.verticalSpacing * 2));
  
  // Calculate column (X position) - center the nodes in each row
  const totalWidth = (totalInLevel - 1) * grid.horizontalSpacing;
  const startX = grid.startX + (2000 - totalWidth) / 2; // Center in a 2000px wide canvas
  const x = startX + (index * grid.horizontalSpacing);
  
  return { x, y };
}

/**
 * Create sticky note content in Markdown format
 */
function createStickyNoteContent(agent) {
  let content = `## ${agent.name}\n\n`;
  content += `**Role:** ${agent.description}\n\n`;
  
  if (agent.responsibilities && agent.responsibilities.length > 0) {
    content += `**Key Responsibilities:**\n`;
    agent.responsibilities.forEach(resp => {
      content += `- ${resp}\n`;
    });
  }
  
  if (agent.subAgents && agent.subAgents.length > 0) {
    content += `\n**Manages ${agent.subAgents.length} Agents:**\n`;
    agent.subAgents.forEach(subAgent => {
      content += `- ${subAgent}\n`;
    });
  }
  
  if (agent.integrations) {
    content += `\n**Integrations:**\n`;
    agent.integrations.forEach(integration => {
      content += `- ${integration}\n`;
    });
  }
  
  return content;
}

/**
 * Get color for agent type
 */
function getAgentColor(agentType, agentName) {
  // Special cases based on agent name
  if (agentName.includes('Marketing')) return CONFIG.colors.marketing;
  if (agentName.includes('Sales')) return CONFIG.colors.sales;
  if (agentName.includes('Operations')) return CONFIG.colors.operations;
  if (agentName.includes('Customer')) return CONFIG.colors.customerExperience;
  if (agentName.includes('Finance')) return CONFIG.colors.finance;
  if (agentName.includes('Analytics')) return CONFIG.colors.analytics;
  if (agentName.includes('Product')) return CONFIG.colors.product;
  if (agentName.includes('Technology')) return CONFIG.colors.technology;
  if (agentName.includes('Creative')) return CONFIG.colors.creative;
  if (agentName.includes('Compliance') || agentName.includes('Risk')) return CONFIG.colors.compliance;
  if (agentName.includes('Social Media')) return CONFIG.colors.socialMedia;
  
  // Default by type
  return CONFIG.colors[agentType] || CONFIG.colors.utility;
}

/**
 * Update workflow with organized canvas layout
 */
async function updateWorkflowLayout(workflow) {
  const nodes = workflow.nodes || [];
  const updatedNodes = [];
  
  // Level 0: Business Manager (Orchestrator)
  const orchestratorNode = nodes.find(n => 
    n.name.toLowerCase().includes('business manager') || 
    n.name.toLowerCase().includes('orchestrator')
  );
  
  if (orchestratorNode) {
    const position = calculateNodePosition(0, 0, 1);
    orchestratorNode.position = [position.x, position.y];
    orchestratorNode.color = CONFIG.colors.orchestrator;
    
    // Add sticky note
    const stickyNote = {
      type: 'n8n-nodes-base.stickyNote',
      name: `Note_${orchestratorNode.name}`,
      position: [
        position.x + CONFIG.grid.stickyNoteOffset.x,
        position.y + CONFIG.grid.stickyNoteOffset.y
      ],
      parameters: {
        content: createStickyNoteContent(AGENT_HIERARCHY.orchestrator),
        width: CONFIG.stickyNote.width,
        height: CONFIG.stickyNote.minHeight
      }
    };
    updatedNodes.push(stickyNote);
    updatedNodes.push(orchestratorNode);
  }
  
  // Level 1: Director Agents
  const directorNodes = nodes.filter(n => 
    n.name.toLowerCase().includes('director') && 
    !n.name.toLowerCase().includes('orchestrator')
  );
  
  directorNodes.forEach((node, index) => {
    const position = calculateNodePosition(1, index, directorNodes.length);
    node.position = [position.x, position.y];
    
    // Find matching director config
    const directorConfig = AGENT_HIERARCHY.directors.find(d => 
      node.name.toLowerCase().includes(d.name.toLowerCase().split(' ')[0])
    );
    
    if (directorConfig) {
      node.color = getAgentColor('director', directorConfig.name);
      
      // Add sticky note
      const stickyNote = {
        type: 'n8n-nodes-base.stickyNote',
        name: `Note_${node.name}`,
        position: [
          position.x + CONFIG.grid.stickyNoteOffset.x,
          position.y + CONFIG.grid.stickyNoteOffset.y
        ],
        parameters: {
          content: createStickyNoteContent(directorConfig),
          width: CONFIG.stickyNote.width,
          height: CONFIG.stickyNote.minHeight + (directorConfig.subAgents ? directorConfig.subAgents.length * 20 : 0)
        }
      };
      updatedNodes.push(stickyNote);
    }
    
    updatedNodes.push(node);
  });
  
  // Level 2+: Specialized Agents (grouped by type)
  const specializedAgents = nodes.filter(n => 
    !n.name.toLowerCase().includes('director') && 
    !n.name.toLowerCase().includes('orchestrator') &&
    !n.type.includes('stickyNote')
  );
  
  // Group agents by category
  const agentGroups = {
    marketing: [],
    sales: [],
    operations: [],
    customerExperience: [],
    finance: [],
    analytics: [],
    product: [],
    technology: [],
    creative: [],
    socialMedia: [],
    utility: []
  };
  
  specializedAgents.forEach(agent => {
    const name = agent.name.toLowerCase();
    if (name.includes('marketing') || name.includes('email') || name.includes('seo') || name.includes('campaign')) {
      agentGroups.marketing.push(agent);
    } else if (name.includes('sales') || name.includes('hospitality') || name.includes('corporate') || name.includes('retail')) {
      agentGroups.sales.push(agent);
    } else if (name.includes('operation') || name.includes('inventory') || name.includes('fulfillment') || name.includes('vendor')) {
      agentGroups.operations.push(agent);
    } else if (name.includes('customer') || name.includes('support') || name.includes('feedback')) {
      agentGroups.customerExperience.push(agent);
    } else if (name.includes('finance') || name.includes('budget') || name.includes('roi')) {
      agentGroups.finance.push(agent);
    } else if (name.includes('analytics') || name.includes('data') || name.includes('kpi')) {
      agentGroups.analytics.push(agent);
    } else if (name.includes('product') || name.includes('catalog')) {
      agentGroups.product.push(agent);
    } else if (name.includes('technology') || name.includes('system') || name.includes('infrastructure')) {
      agentGroups.technology.push(agent);
    } else if (name.includes('creative') || name.includes('design') || name.includes('brand')) {
      agentGroups.creative.push(agent);
    } else if (name.includes('facebook') || name.includes('instagram') || name.includes('pinterest') || name.includes('social')) {
      agentGroups.socialMedia.push(agent);
    } else {
      agentGroups.utility.push(agent);
    }
  });
  
  // Position specialized agents in their groups
  let currentLevel = 2;
  Object.entries(agentGroups).forEach(([groupName, agents]) => {
    if (agents.length > 0) {
      agents.forEach((agent, index) => {
        const position = calculateNodePosition(currentLevel, index, agents.length);
        agent.position = [position.x, position.y];
        agent.color = CONFIG.colors[groupName];
        
        // Add simple sticky note for specialized agents
        const stickyNote = {
          type: 'n8n-nodes-base.stickyNote',
          name: `Note_${agent.name}`,
          position: [
            position.x + CONFIG.grid.stickyNoteOffset.x,
            position.y + CONFIG.grid.stickyNoteOffset.y
          ],
          parameters: {
            content: `## ${agent.name}\n\n**Type:** ${groupName.charAt(0).toUpperCase() + groupName.slice(1)} Agent\n\n**Integration:** Part of the VividWalls MAS`,
            width: CONFIG.stickyNote.width,
            height: CONFIG.stickyNote.minHeight
          }
        };
        updatedNodes.push(stickyNote);
        updatedNodes.push(agent);
      });
      currentLevel++;
    }
  });
  
  // Update the workflow object
  workflow.nodes = updatedNodes;
  return workflow;
}

/**
 * Main function to organize all workflows
 */
async function organizeWorkflows() {
  console.log('🎨 Starting N8N Canvas Organization for VividWalls MAS...\n');
  
  const workflowsDir = path.join(__dirname, '../services/n8n/agents/workflows');
  const categories = ['core', 'marketing', 'sales', 'operations', 'customer_experience', 
                     'finance', 'analytics', 'product', 'social_media', 'integrations'];
  
  let totalWorkflows = 0;
  let updatedWorkflows = 0;
  
  for (const category of categories) {
    const categoryPath = path.join(workflowsDir, category);
    
    if (!fs.existsSync(categoryPath)) {
      console.log(`⚠️  Category directory not found: ${category}`);
      continue;
    }
    
    const files = fs.readdirSync(categoryPath).filter(f => f.endsWith('.json'));
    console.log(`\n📁 Processing ${category} (${files.length} workflows)...`);
    
    for (const file of files) {
      const filePath = path.join(categoryPath, file);
      totalWorkflows++;
      
      try {
        const workflow = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        
        // Update workflow layout
        const updatedWorkflow = await updateWorkflowLayout(workflow);
        
        // Save updated workflow
        fs.writeFileSync(filePath, JSON.stringify(updatedWorkflow, null, 2));
        
        updatedWorkflows++;
        console.log(`   ✅ ${file} - Layout optimized`);
      } catch (error) {
        console.error(`   ❌ ${file} - Error: ${error.message}`);
      }
    }
  }
  
  console.log('\n' + '='.repeat(60));
  console.log(`✨ Canvas Organization Complete!`);
  console.log(`   Total Workflows: ${totalWorkflows}`);
  console.log(`   Successfully Updated: ${updatedWorkflows}`);
  console.log(`   Failed: ${totalWorkflows - updatedWorkflows}`);
  console.log('='.repeat(60));
  
  // Create summary report
  const report = {
    timestamp: new Date().toISOString(),
    totalWorkflows,
    updatedWorkflows,
    failedWorkflows: totalWorkflows - updatedWorkflows,
    configuration: {
      horizontalSpacing: CONFIG.grid.horizontalSpacing,
      verticalSpacing: CONFIG.grid.verticalSpacing,
      stickyNoteWidth: CONFIG.stickyNote.width,
      colorScheme: Object.keys(CONFIG.colors)
    }
  };
  
  fs.writeFileSync(
    path.join(__dirname, 'canvas_organization_report.json'),
    JSON.stringify(report, null, 2)
  );
  
  console.log('\n📊 Report saved to: canvas_organization_report.json');
}

// Run the organization
if (require.main === module) {
  organizeWorkflows().catch(console.error);
}

module.exports = { organizeWorkflows, updateWorkflowLayout, calculateNodePosition };