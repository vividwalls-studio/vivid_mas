#!/usr/bin/env node

/**
 * N8N Workflow Renaming System
 * Implements standardized nomenclature for all workflows
 */

const axios = require('axios');

// Configuration
const N8N_URL = 'https://n8n.vividwalls.blog/api/v1';
const API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I';

const headers = {
  'X-N8N-API-KEY': API_KEY,
  'Content-Type': 'application/json'
};

// Naming mappings
const NAMING_MAPPINGS = {
  // Director Agents
  'Business Manager': 'VW-BM-DIR-Orchestrator',
  'Business Manager Agent': 'VW-BM-DIR-Orchestrator',
  'Business Manager Agent Orchestration': 'VW-BM-DIR-Orchestrator',
  'Marketing Director Agent': 'VW-MKT-DIR-Main',
  'Marketing Director': 'VW-MKT-DIR-Main',
  'Sales Director Agent': 'VW-SLS-DIR-Main',
  'Sales Director': 'VW-SLS-DIR-Main',
  'Operations Director Agent': 'VW-OPS-DIR-Main',
  'Operations Director': 'VW-OPS-DIR-Main',
  'Customer Experience Director Agent': 'VW-CX-DIR-Main',
  'Customer Experience Director': 'VW-CX-DIR-Main',
  'Product Director Agent': 'VW-PRD-DIR-Main',
  'Product Director': 'VW-PRD-DIR-Main',
  'Finance Director Agent': 'VW-FIN-DIR-Main',
  'Finance Director': 'VW-FIN-DIR-Main',
  'Analytics Director Agent': 'VW-ANL-DIR-Main',
  'Analytics Director': 'VW-ANL-DIR-Main',
  'Technology Director Agent': 'VW-TECH-DIR-Main',
  'Technology Director': 'VW-TECH-DIR-Main',
  'Social Media Director': 'VW-SOC-DIR-Main',
  'Social Media Director Agent': 'VW-SOC-DIR-Main',
  'Creative Director Agent': 'VW-MKT-DIR-Creative',
  
  // Marketing Agents
  'Marketing Campaign Agent': 'VW-MKT-AGENT-Campaign',
  'VividWalls Marketing Campaign Agent - MCP Enhanced': 'VW-MKT-AGENT-Campaign-MCP',
  'VividWalls Marketing Campaign Agent - Human Approval Enhanced': 'VW-MKT-AGENT-Campaign-Approval',
  'Marketing Research Agent': 'VW-MKT-AGENT-Research',
  'VividWalls Marketing Research Agent': 'VW-MKT-AGENT-Research',
  'Content Marketing Agent': 'VW-MKT-AGENT-Content',
  'VividWalls Content Marketing Agent - MCP Enhanced': 'VW-MKT-AGENT-Content-MCP',
  'VividWalls Content Marketing Agent - Human Approval Enhanced': 'VW-MKT-AGENT-Content-Approval',
  'Content Strategy Agent': 'VW-MKT-AGENT-Strategy',
  'Email Marketing Agent': 'VW-MKT-AGENT-Email',
  'Keyword Agent': 'VW-MKT-AGENT-Keyword',
  'Data Analytics Agent': 'VW-ANL-AGENT-DataAnalysis',
  
  // Customer Experience Agents
  'VividWalls Customer Relationship Agent - MCP Enhanced': 'VW-CX-AGENT-Relationship-MCP',
  'VividWalls Customer Relationship Agent - Human Approval Enhanced': 'VW-CX-AGENT-Relationship-Approval',
  'Customer Service Agent': 'VW-CX-AGENT-Service',
  
  // Social Media Agents
  'Facebook Agent': 'VW-SOC-AGENT-Facebook',
  'Instagram Agent': 'VW-SOC-AGENT-Instagram',
  'Pinterest Agent': 'VW-SOC-AGENT-Pinterest',
  'Twitter Agent': 'VW-SOC-AGENT-Twitter',
  
  // Integration Workflows
  'VividWalls Shopify': 'VW-INT-API-Shopify-Sync',
  'Shopify Agent': 'VW-INT-AGENT-Shopify',
  'VividWalls Stripe': 'VW-INT-API-Stripe-Payment',
  'VividWalls SendGrid': 'VW-INT-API-SendGrid-Email',
  'VividWalls Supabase': 'VW-INT-API-Supabase-Data',
  
  // Processing Workflows
  'Order Fulfillment Workflow': 'VW-OPS-PROC-OrderFulfillment',
  'VividWalls Orders Fulfillment Agent': 'VW-OPS-AGENT-OrderFulfillment',
  'VividWalls Database Integration & Search': 'VW-DATA-PROC-DatabaseSearch',
  'VividWalls Artwork Color Analysis & Extraction': 'VW-DATA-PROC-ColorAnalysis',
  'VividWalls Artwork Color Analysis via MCP Agent': 'VW-DATA-PROC-ColorAnalysis-MCP',
  'Image Retrieval & Selection': 'VW-DATA-PROC-ImageRetrieval',
  'Art Trend Intelligence': 'VW-ANL-AGENT-TrendAnalysis',
  
  // Knowledge Management
  'Knowledge Management Agent': 'VW-DATA-AGENT-Knowledge',
  'Knowledge Gatherer Agent': 'VW-DATA-AGENT-Gatherer',
  
  // Frontend/UI
  'VividWalls Frontend Agent Hub': 'VW-INT-WEBHOOK-FrontendHub',
  'VividWalls Agent Webhook Test': 'VW-TEST-WEBHOOK-AgentTest',
  
  // Documentation
  'VividWalls Complete MCP Servers Documentation': 'VW-UTIL-DOC-MCPServers',
  'Documentation': 'VW-UTIL-DOC-General',
  
  // Demo Workflows
  'WordPress Chatbot with OpenAI': 'DEMO-INT-API-WordPress-Chat',
  'chatbot-workflow': 'DEMO-INT-WEBHOOK-Chatbot',
  'V1 ocal RAG AI Agent': 'DEMO-DATA-AGENT-RAG-v1',
  'V2 Supabase RAG AI Agent': 'DEMO-DATA-AGENT-RAG-v2',
  
  // Deal Flow Workflows (PE/Finance)
  'Deal Flow': 'DT-FIN-PROC-DealFlow',
  'PE Deal Flow Workflow - v5': 'DT-FIN-PROC-DealFlow-v5',
  'PR_Deal Flow V3': 'DT-FIN-PROC-DealFlow-v3',
  '🏦 PE Deal Intake': 'DT-FIN-WEBHOOK-DealIntake',
  'Deal Flow Proposal Validation': 'DT-FIN-PROC-ProposalValidation',
  'Equity Deal Workflow': 'DT-FIN-PROC-EquityDeal',
  'Pitch Book Submission Workflow + Frontend': 'DT-FIN-WEBHOOK-PitchBook',
  
  // Test Workflows
  'Test Workflow from MCP': 'TEST-UTIL-MCP-Integration',
  'Debug Test Workflow': 'TEST-UTIL-Debug',
  'Screenshot_Analyzer': 'TEST-DATA-PROC-Screenshot',
  'Creative Content Generator': 'TEST-MKT-AGENT-Creative',
  
  // Generic/Unnamed Workflows
  'My workflow': 'TEST-UTIL-Unnamed-001',
  'My workflow 2': 'TEST-UTIL-Unnamed-002',
  'My workflow 3': 'TEST-UTIL-Unnamed-003',
  'My workflow 4': 'TEST-UTIL-Unnamed-004',
  'My workflow 5': 'TEST-UTIL-Unnamed-005',
  'My workflow 6': 'TEST-UTIL-Unnamed-006',
  'workflow-df': 'TEST-UTIL-DataFrame'
};

// Pattern-based renaming rules
const PATTERN_RULES = [
  {
    pattern: /^Test Workflow \d+$/,
    rename: (name) => `TEST-UTIL-AutoTest-${name.match(/\d+/)[0]}`
  },
  {
    pattern: /^Workflow to Delete \d+$/,
    rename: (name) => `TEST-UTIL-ToDelete-${name.match(/\d+/)[0]}`
  },
  {
    pattern: /^VividWalls (.+)$/,
    rename: (name) => {
      const specific = name.replace('VividWalls ', '').replace(/ /g, '');
      return `VW-UTIL-Legacy-${specific}`;
    }
  }
];

/**
 * Get new name for workflow
 */
function getNewWorkflowName(currentName) {
  // Check direct mappings first
  if (NAMING_MAPPINGS[currentName]) {
    return NAMING_MAPPINGS[currentName];
  }
  
  // Check pattern rules
  for (const rule of PATTERN_RULES) {
    if (rule.pattern.test(currentName)) {
      return rule.rename(currentName);
    }
  }
  
  // If no mapping found, create a generic name
  console.log(`⚠️  No mapping for: "${currentName}"`);
  
  // Try to intelligently create a name
  const nameLower = currentName.toLowerCase();
  
  // Determine prefix
  let prefix = 'TEST';
  if (nameLower.includes('vividwalls') || nameLower.includes('vivid')) {
    prefix = 'VW';
  } else if (nameLower.includes('designthru')) {
    prefix = 'DT';
  } else if (nameLower.includes('demo') || nameLower.includes('example')) {
    prefix = 'DEMO';
  } else if (nameLower.includes('template')) {
    prefix = 'TPL';
  }
  
  // Determine category
  let category = 'UTIL';
  if (nameLower.includes('market')) category = 'MKT';
  else if (nameLower.includes('sales')) category = 'SLS';
  else if (nameLower.includes('operation')) category = 'OPS';
  else if (nameLower.includes('customer')) category = 'CX';
  else if (nameLower.includes('product')) category = 'PRD';
  else if (nameLower.includes('finance')) category = 'FIN';
  else if (nameLower.includes('analytic')) category = 'ANL';
  else if (nameLower.includes('tech')) category = 'TECH';
  else if (nameLower.includes('social')) category = 'SOC';
  else if (nameLower.includes('data')) category = 'DATA';
  else if (nameLower.includes('integrat')) category = 'INT';
  
  // Determine function
  let func = 'PROC';
  if (nameLower.includes('director')) func = 'DIR';
  else if (nameLower.includes('agent')) func = 'AGENT';
  else if (nameLower.includes('webhook')) func = 'WEBHOOK';
  else if (nameLower.includes('schedule') || nameLower.includes('cron')) func = 'SCHED';
  else if (nameLower.includes('api')) func = 'API';
  else if (nameLower.includes('sync')) func = 'SYNC';
  else if (nameLower.includes('import')) func = 'IMPORT';
  else if (nameLower.includes('export')) func = 'EXPORT';
  else if (nameLower.includes('report')) func = 'REPORT';
  
  // Clean up the specific part
  let specific = currentName
    .replace(/vividwalls?/gi, '')
    .replace(/director/gi, '')
    .replace(/agent/gi, '')
    .replace(/workflow/gi, '')
    .replace(/\s+/g, '')
    .replace(/[^a-zA-Z0-9]/g, '');
  
  if (specific.length > 15) {
    specific = specific.substring(0, 15);
  }
  
  return `${prefix}-${category}-${func}-${specific || 'Unnamed'}`;
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
 * Rename a workflow
 */
async function renameWorkflow(workflow, newName) {
  try {
    // Skip if name is already correct
    if (workflow.name === newName) {
      console.log(`✓ Already correct: ${workflow.name}`);
      return { success: true, skipped: true };
    }
    
    // Get full workflow data
    const fullWorkflowResponse = await axios.get(
      `${N8N_URL}/workflows/${workflow.id}`,
      { headers }
    );
    const fullWorkflow = fullWorkflowResponse.data;
    
    // Update the name
    const updateData = {
      ...fullWorkflow,
      name: newName
    };
    
    await axios.put(
      `${N8N_URL}/workflows/${workflow.id}`,
      updateData,
      { headers }
    );
    
    console.log(`✅ Renamed: "${workflow.name}" → "${newName}"`);
    return { success: true, oldName: workflow.name, newName };
    
  } catch (error) {
    console.error(`❌ Failed to rename "${workflow.name}": ${error.message}`);
    return { success: false, error: error.message };
  }
}

/**
 * Generate renaming report
 */
function generateReport(results) {
  console.log('\n' + '='.repeat(60));
  console.log('WORKFLOW RENAMING SUMMARY');
  console.log('='.repeat(60));
  
  const successful = results.filter(r => r.success && !r.skipped);
  const skipped = results.filter(r => r.skipped);
  const failed = results.filter(r => !r.success);
  
  console.log(`Total workflows: ${results.length}`);
  console.log(`Successfully renamed: ${successful.length}`);
  console.log(`Already correct: ${skipped.length}`);
  console.log(`Failed to rename: ${failed.length}`);
  
  if (successful.length > 0) {
    console.log('\n✅ Successfully Renamed:');
    console.log('-'.repeat(40));
    successful.forEach(r => {
      console.log(`  ${r.oldName} → ${r.newName}`);
    });
  }
  
  if (failed.length > 0) {
    console.log('\n❌ Failed Renamings:');
    console.log('-'.repeat(40));
    failed.forEach(r => {
      console.log(`  ${r.workflow}: ${r.error}`);
    });
  }
  
  console.log('\n' + '='.repeat(60));
}

/**
 * Preview mode - show what would be renamed
 */
async function previewRenames() {
  console.log('\n📋 PREVIEW MODE - Showing proposed renames:');
  console.log('='.repeat(60));
  
  const workflows = await getWorkflows();
  const renames = [];
  
  for (const workflow of workflows) {
    const newName = getNewWorkflowName(workflow.name);
    if (workflow.name !== newName) {
      renames.push({ old: workflow.name, new: newName });
      console.log(`  "${workflow.name}"`);
      console.log(`  → "${newName}"`);
      console.log();
    }
  }
  
  console.log(`\nTotal workflows to rename: ${renames.length}`);
  console.log('='.repeat(60));
  
  return renames.length > 0;
}

/**
 * Main execution
 */
async function main() {
  console.log('🚀 N8N Workflow Renaming System');
  console.log('='.repeat(60));
  
  const args = process.argv.slice(2);
  const isPreview = args.includes('--preview');
  const forceRename = args.includes('--force');
  
  try {
    if (isPreview) {
      // Preview mode only
      const hasRenames = await previewRenames();
      if (hasRenames) {
        console.log('\nTo apply these renames, run without --preview flag');
      }
      return;
    }
    
    // Get all workflows
    console.log('\n🔍 Fetching workflows...');
    const workflows = await getWorkflows();
    console.log(`Found ${workflows.length} workflows\n`);
    
    if (!forceRename) {
      // Show preview first
      console.log('Showing preview of changes...\n');
      const hasRenames = await previewRenames();
      
      if (!hasRenames) {
        console.log('No workflows need renaming!');
        return;
      }
      
      console.log('\n⚠️  This will rename workflows in n8n.');
      console.log('To proceed, run with --force flag');
      console.log('Example: node n8n_workflow_renaming_system.js --force');
      return;
    }
    
    // Perform renaming
    console.log('\n✏️  Renaming workflows...\n');
    const results = [];
    
    for (const workflow of workflows) {
      const newName = getNewWorkflowName(workflow.name);
      const result = await renameWorkflow(workflow, newName);
      results.push({ ...result, workflow: workflow.name });
    }
    
    // Generate report
    generateReport(results);
    
    console.log('\n✅ Renaming process complete!');
    console.log('\nNext steps:');
    console.log('1. Review renamed workflows in n8n UI');
    console.log('2. Update any external references to workflow names');
    console.log('3. Update documentation with new naming convention');
    
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
  NAMING_MAPPINGS,
  PATTERN_RULES,
  getNewWorkflowName,
  getWorkflows,
  renameWorkflow
};