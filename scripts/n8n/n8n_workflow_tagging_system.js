#!/usr/bin/env node

/**
 * N8N Workflow Tagging System Implementation
 * This script sets up a comprehensive tagging strategy for n8n workflows
 */

const axios = require('axios');

// Configuration
const N8N_URL = 'https://n8n.vividwalls.blog/api/v1';
const API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I';

const headers = {
  'X-N8N-API-KEY': API_KEY,
  'Content-Type': 'application/json'
};

// Tag Definitions
const TAG_CATEGORIES = {
  // Primary Category Tags
  PRIMARY: [
    { name: 'VividWalls-MAS', description: 'VividWalls Multi-Agent System workflows' },
    { name: 'DesignThru-AI', description: 'DesignThru AI client workflows' },
    { name: 'N8N-Course-Demo', description: 'Course demonstration workflows' }
  ],
  
  // Secondary Classification Tags
  CLASSIFICATION: [
    { name: 'Production', description: 'Live client workflows in production' },
    { name: 'Development', description: 'Workflows under development' },
    { name: 'Template', description: 'Reusable workflow templates' },
    { name: 'Archive', description: 'Completed or deprecated workflows' }
  ],
  
  // Functional Tags
  FUNCTIONAL: [
    { name: 'Data-Processing', description: 'Data transformation and processing workflows' },
    { name: 'API-Integration', description: 'External API integration workflows' },
    { name: 'Automation', description: 'Business process automation workflows' },
    { name: 'Notification', description: 'Alert and notification workflows' },
    { name: 'Webhook', description: 'Webhook-triggered workflows' },
    { name: 'Scheduled', description: 'Time-based scheduled workflows' },
    { name: 'Agent-Workflow', description: 'AI agent orchestration workflows' },
    { name: 'MCP-Integration', description: 'Model Context Protocol integrated workflows' }
  ],
  
  // Department/Agent Tags
  DEPARTMENT: [
    { name: 'Business-Manager', description: 'Business Manager agent workflows' },
    { name: 'Marketing', description: 'Marketing department workflows' },
    { name: 'Sales', description: 'Sales department workflows' },
    { name: 'Operations', description: 'Operations department workflows' },
    { name: 'Customer-Experience', description: 'Customer experience workflows' },
    { name: 'Product', description: 'Product management workflows' },
    { name: 'Finance', description: 'Finance department workflows' },
    { name: 'Analytics', description: 'Analytics and reporting workflows' },
    { name: 'Technology', description: 'Technology and IT workflows' },
    { name: 'Social-Media', description: 'Social media management workflows' }
  ]
};

// Workflow naming conventions
const NAMING_CONVENTIONS = {
  // VividWalls MAS Agent Workflows
  'VividWalls-Business-Manager': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Business-Manager'],
  'VividWalls-Marketing-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Marketing'],
  'VividWalls-Sales-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Sales'],
  'VividWalls-Operations-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Operations'],
  'VividWalls-Customer-Experience-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Customer-Experience'],
  'VividWalls-Product-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Product'],
  'VividWalls-Finance-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Finance'],
  'VividWalls-Analytics-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Analytics'],
  'VividWalls-Technology-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Technology'],
  'VividWalls-Social-Media-Director': ['VividWalls-MAS', 'Production', 'Agent-Workflow', 'Social-Media'],
  
  // Integration Workflows
  'VividWalls-Shopify': ['VividWalls-MAS', 'Production', 'API-Integration'],
  'VividWalls-Stripe': ['VividWalls-MAS', 'Production', 'API-Integration', 'Finance'],
  'VividWalls-SendGrid': ['VividWalls-MAS', 'Production', 'API-Integration', 'Notification'],
  'VividWalls-Supabase': ['VividWalls-MAS', 'Production', 'Data-Processing'],
  
  // Webhook Workflows
  'webhook': ['Webhook'],
  'scheduled': ['Scheduled'],
  
  // Demo and Template Workflows
  'example': ['N8N-Course-Demo', 'Template'],
  'demo': ['N8N-Course-Demo'],
  'template': ['Template'],
  'test': ['Development']
};

/**
 * Create tags in n8n
 */
async function createTags() {
  console.log('Creating tags in n8n...\n');
  
  const allTags = [
    ...TAG_CATEGORIES.PRIMARY,
    ...TAG_CATEGORIES.CLASSIFICATION,
    ...TAG_CATEGORIES.FUNCTIONAL,
    ...TAG_CATEGORIES.DEPARTMENT
  ];
  
  const createdTags = [];
  
  for (const tag of allTags) {
    try {
      const response = await axios.post(
        `${N8N_URL}/tags`,
        { name: tag.name },
        { headers }
      );
      createdTags.push(response.data);
      console.log(`✅ Created tag: ${tag.name}`);
    } catch (error) {
      if (error.response?.status === 409) {
        console.log(`ℹ️  Tag already exists: ${tag.name}`);
      } else {
        console.error(`❌ Failed to create tag ${tag.name}:`, error.message);
      }
    }
  }
  
  return createdTags;
}

/**
 * Get all workflows
 */
async function getWorkflows() {
  try {
    const response = await axios.get(`${N8N_URL}/workflows`, { headers });
    return response.data.data || [];
  } catch (error) {
    console.error('Failed to fetch workflows:', error.message);
    return [];
  }
}

/**
 * Determine tags for a workflow based on its name and properties
 */
function determineWorkflowTags(workflow) {
  const tags = new Set();
  const name = workflow.name.toLowerCase();
  
  // Check naming conventions
  for (const [pattern, tagList] of Object.entries(NAMING_CONVENTIONS)) {
    if (name.includes(pattern.toLowerCase())) {
      tagList.forEach(tag => tags.add(tag));
    }
  }
  
  // Check for webhook nodes
  if (workflow.nodes?.some(node => node.type?.includes('webhook'))) {
    tags.add('Webhook');
  }
  
  // Check for schedule triggers
  if (workflow.nodes?.some(node => node.type?.includes('schedule') || node.type?.includes('cron'))) {
    tags.add('Scheduled');
  }
  
  // Check for MCP nodes
  if (workflow.nodes?.some(node => node.type?.includes('mcp') || node.parameters?.tool?.includes('mcp'))) {
    tags.add('MCP-Integration');
  }
  
  // Check workflow status
  if (workflow.active) {
    if (!tags.has('Development') && !tags.has('Archive')) {
      tags.add('Production');
    }
  } else {
    if (!tags.has('Production')) {
      tags.add('Development');
    }
  }
  
  // Ensure primary category
  if (!tags.has('VividWalls-MAS') && !tags.has('DesignThru-AI') && !tags.has('N8N-Course-Demo')) {
    if (name.includes('vividwalls') || name.includes('vivid')) {
      tags.add('VividWalls-MAS');
    }
  }
  
  return Array.from(tags);
}

/**
 * Apply tags to a workflow
 */
async function applyTagsToWorkflow(workflowId, tags) {
  try {
    // Get existing workflow data
    const workflowResponse = await axios.get(`${N8N_URL}/workflows/${workflowId}`, { headers });
    const workflow = workflowResponse.data;
    
    // Update with new tags
    const updateData = {
      ...workflow,
      tags: tags
    };
    
    await axios.put(`${N8N_URL}/workflows/${workflowId}`, updateData, { headers });
    console.log(`✅ Tagged workflow: ${workflow.name} with [${tags.join(', ')}]`);
    return true;
  } catch (error) {
    console.error(`❌ Failed to tag workflow ${workflowId}:`, error.message);
    return false;
  }
}

/**
 * Audit and tag all workflows
 */
async function auditAndTagWorkflows() {
  console.log('\nAuditing and tagging workflows...\n');
  
  const workflows = await getWorkflows();
  console.log(`Found ${workflows.length} workflows to process\n`);
  
  const tagSummary = {
    total: workflows.length,
    tagged: 0,
    failed: 0,
    byTag: {}
  };
  
  for (const workflow of workflows) {
    const suggestedTags = determineWorkflowTags(workflow);
    
    if (suggestedTags.length > 0) {
      console.log(`\n📋 Workflow: ${workflow.name}`);
      console.log(`   Suggested tags: [${suggestedTags.join(', ')}]`);
      
      const success = await applyTagsToWorkflow(workflow.id, suggestedTags);
      
      if (success) {
        tagSummary.tagged++;
        suggestedTags.forEach(tag => {
          tagSummary.byTag[tag] = (tagSummary.byTag[tag] || 0) + 1;
        });
      } else {
        tagSummary.failed++;
      }
    }
  }
  
  return tagSummary;
}

/**
 * Generate tagging report
 */
function generateReport(summary) {
  console.log('\n' + '='.repeat(60));
  console.log('WORKFLOW TAGGING SUMMARY');
  console.log('='.repeat(60));
  console.log(`Total workflows: ${summary.total}`);
  console.log(`Successfully tagged: ${summary.tagged}`);
  console.log(`Failed to tag: ${summary.failed}`);
  console.log('\nTag Distribution:');
  console.log('-'.repeat(40));
  
  const sortedTags = Object.entries(summary.byTag)
    .sort((a, b) => b[1] - a[1]);
  
  for (const [tag, count] of sortedTags) {
    console.log(`  ${tag}: ${count} workflows`);
  }
  
  console.log('\n' + '='.repeat(60));
}

/**
 * Main execution
 */
async function main() {
  console.log('🚀 N8N Workflow Tagging System');
  console.log('='.repeat(60));
  
  try {
    // Step 1: Create tags
    console.log('\n📌 Step 1: Creating tags...');
    await createTags();
    
    // Step 2: Audit and tag workflows
    console.log('\n🔍 Step 2: Auditing and tagging workflows...');
    const summary = await auditAndTagWorkflows();
    
    // Step 3: Generate report
    console.log('\n📊 Step 3: Generating report...');
    generateReport(summary);
    
    console.log('\n✅ Tagging system implementation complete!');
    console.log('\nNext steps:');
    console.log('1. Review tagged workflows in n8n UI');
    console.log('2. Manually adjust any incorrect tags');
    console.log('3. Use tags to filter and organize workflows');
    console.log('4. Maintain tagging discipline for new workflows');
    
  } catch (error) {
    console.error('\n❌ Error:', error.message);
    process.exit(1);
  }
}

// Run if executed directly
if (require.main === module) {
  main();
}

module.exports = {
  TAG_CATEGORIES,
  NAMING_CONVENTIONS,
  createTags,
  getWorkflows,
  determineWorkflowTags,
  applyTagsToWorkflow,
  auditAndTagWorkflows
};