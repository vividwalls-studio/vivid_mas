#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const { promisify } = require('util');
const execAsync = promisify(exec);

const WORKFLOW_DIRS = [
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/core',
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/integrations',
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/processes',
  '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/specialized'
];

// Map workflow names to existing IDs in n8n
const WORKFLOW_ID_MAP = {
  'Marketing Director - Pattern Aware': 'at1EQMQgpxKNNXBD',
  'Business Manager Agent': 'JmIg9sAxJo9FasR4',
  'Finance Director - Enhanced with Budget Integration': '0lMVtjudeZTbYKmz',
  // Add more mappings as needed
};

async function uploadWorkflows() {
  console.log('Starting workflow upload process...\n');
  
  const results = {
    uploaded: [],
    failed: [],
    skipped: []
  };

  for (const dir of WORKFLOW_DIRS) {
    console.log(`\nProcessing directory: ${dir}`);
    console.log('─'.repeat(60));
    
    if (!fs.existsSync(dir)) {
      console.log(`⚠️  Directory not found: ${dir}`);
      continue;
    }
    
    const files = fs.readdirSync(dir).filter(f => f.endsWith('.json') && !f.includes('.backup'));
    
    for (const file of files) {
      const filePath = path.join(dir, file);
      
      try {
        const workflow = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        const workflowName = workflow.name;
        
        console.log(`\nProcessing: ${file}`);
        console.log(`  Workflow: ${workflowName}`);
        
        // Check if this is a director workflow that was enhanced
        if (!file.includes('_director_')) {
          console.log('  ⚠️  Skipping non-director workflow');
          results.skipped.push(file);
          continue;
        }
        
        // Find existing workflow ID
        const existingId = WORKFLOW_ID_MAP[workflowName];
        if (!existingId) {
          console.log('  ⚠️  No existing workflow ID found, would create new');
          // For now, skip workflows without existing IDs
          results.skipped.push(file);
          continue;
        }
        
        // Create a minimal update payload with just the essential changes
        const updatePayload = {
          name: workflow.name,
          nodes: workflow.nodes,
          connections: workflow.connections,
          settings: workflow.settings || {},
          staticData: workflow.staticData || null,
          pinData: workflow.pinData || {}
        };
        
        // Save to temporary file for upload
        const tempFile = `/tmp/${file}`;
        fs.writeFileSync(tempFile, JSON.stringify(updatePayload, null, 2));
        
        console.log(`  ✓ Prepared update for workflow ID: ${existingId}`);
        console.log(`  ℹ️  Enhanced with:`);
        
        // Count enhancements
        const mcpTools = workflow.nodes.filter(n => n.type === '@n8n/n8n-nodes-langchain.mcp');
        const vectorStores = workflow.nodes.filter(n => n.type === '@n8n/n8n-nodes-langchain.vectorStoreSupabase');
        const waitNodes = workflow.nodes.filter(n => n.type === 'n8n-nodes-base.waitWebhook');
        const workflowExec = workflow.nodes.filter(n => n.type === 'n8n-nodes-base.executeWorkflow');
        
        console.log(`     - ${mcpTools.length} MCP tool connections`);
        console.log(`     - ${vectorStores.length} vector store connections`);
        console.log(`     - ${waitNodes.length} wait nodes (human-in-the-loop)`);
        console.log(`     - ${workflowExec.length} workflow execution nodes`);
        
        results.uploaded.push({
          file,
          workflowId: existingId,
          enhancements: {
            mcpTools: mcpTools.length,
            vectorStores: vectorStores.length,
            waitNodes: waitNodes.length,
            workflowExec: workflowExec.length
          }
        });
        
        // Clean up temp file
        if (fs.existsSync(tempFile)) {
          fs.unlinkSync(tempFile);
        }
        
      } catch (error) {
        console.log(`  ❌ Error: ${error.message}`);
        results.failed.push({ file, error: error.message });
      }
    }
  }
  
  // Summary
  console.log('\n' + '═'.repeat(60));
  console.log('Upload Summary');
  console.log('═'.repeat(60));
  console.log(`✓ Ready to upload: ${results.uploaded.length}`);
  console.log(`⚠️  Skipped: ${results.skipped.length}`);
  console.log(`❌ Failed: ${results.failed.length}`);
  
  if (results.uploaded.length > 0) {
    console.log('\nWorkflows ready for upload:');
    results.uploaded.forEach(item => {
      console.log(`  - ${item.file} → ID: ${item.workflowId}`);
    });
    
    console.log('\n📝 Manual Upload Instructions:');
    console.log('1. Go to n8n UI at https://n8n.vividwalls.blog');
    console.log('2. For each workflow listed above:');
    console.log('   a. Open the workflow by ID');
    console.log('   b. Click "Settings" → "Import from File"');
    console.log('   c. Select the enhanced workflow file');
    console.log('   d. Save the workflow');
    console.log('\nAlternatively, use the n8n CLI or API for bulk updates.');
  }
  
  // Save results
  const resultsPath = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows/upload_results.json';
  fs.writeFileSync(resultsPath, JSON.stringify(results, null, 2));
  console.log(`\n📄 Results saved to: ${resultsPath}`);
}

// Run the upload process
uploadWorkflows().catch(console.error);