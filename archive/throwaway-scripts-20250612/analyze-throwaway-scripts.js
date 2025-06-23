#!/usr/bin/env node

import fs from 'fs';
import path from 'path';

// Categories of scripts
const categories = {
  oneTime: {
    name: 'One-Time Scripts (Can be archived)',
    patterns: [
      'fix-', 'debug-', 'test-', 'check-', 'analyze-', 'create-',
      'diagnose-', 'final-', 'temp-', 'corrections', 'Screenshot'
    ],
    files: []
  },
  deployment: {
    name: 'Deployment Scripts (One-time, specific deployments)',
    patterns: ['deploy-', 'upload-'],
    files: []
  },
  dataProcessing: {
    name: 'Data Processing Scripts (One-time imports/exports)',
    patterns: ['update_', 'fix_csv', 'reorder_', 'variant_', 'fill_', 'create_product'],
    files: []
  },
  persistent: {
    name: 'Persistent Scripts (Keep for ongoing use)',
    patterns: ['generate_', 'preview-', 'simple-'],
    files: []
  },
  documentation: {
    name: 'Documentation (Keep)',
    patterns: ['.md', '_GUIDE', '_SUMMARY'],
    files: []
  },
  unknown: {
    name: 'Unknown/Review Needed',
    patterns: [],
    files: []
  }
};

// Get all files in root directory
const rootFiles = fs.readdirSync('.').filter(file => {
  const stat = fs.statSync(file);
  return stat.isFile() && !file.startsWith('.');
});

// Categorize files
rootFiles.forEach(file => {
  let categorized = false;
  
  // Check each category
  for (const [key, category] of Object.entries(categories)) {
    for (const pattern of category.patterns) {
      if (file.toLowerCase().includes(pattern.toLowerCase())) {
        category.files.push(file);
        categorized = true;
        break;
      }
    }
    if (categorized) break;
  }
  
  // If not categorized, add to unknown
  if (!categorized) {
    // Check file extension for special cases
    const ext = path.extname(file);
    if (['.py', '.js', '.cjs', '.sh'].includes(ext)) {
      // Read first few lines to determine purpose
      try {
        const content = fs.readFileSync(file, 'utf8');
        const firstLines = content.split('\n').slice(0, 10).join('\n').toLowerCase();
        
        if (firstLines.includes('shopify') || firstLines.includes('upload') || 
            firstLines.includes('deploy') || firstLines.includes('theme')) {
          categories.deployment.files.push(file);
        } else if (firstLines.includes('csv') || firstLines.includes('inventory') || 
                   firstLines.includes('variant')) {
          categories.dataProcessing.files.push(file);
        } else {
          categories.unknown.files.push(file);
        }
      } catch (e) {
        categories.unknown.files.push(file);
      }
    } else if (['.png', '.jpg', '.jpeg'].includes(ext)) {
      categories.oneTime.files.push(file);
    } else {
      categories.unknown.files.push(file);
    }
  }
});

// Generate report
console.log('=== THROWAWAY SCRIPTS ANALYSIS ===\n');

let totalOneTime = 0;
let totalPersistent = 0;

for (const [key, category] of Object.entries(categories)) {
  if (category.files.length > 0) {
    console.log(`\n${category.name}:`);
    console.log('─'.repeat(50));
    
    category.files.sort().forEach(file => {
      const stat = fs.statSync(file);
      const size = (stat.size / 1024).toFixed(1) + 'KB';
      const date = stat.mtime.toISOString().split('T')[0];
      console.log(`  ${file.padEnd(50)} ${size.padStart(8)} ${date}`);
    });
    
    console.log(`  Total: ${category.files.length} files`);
    
    if (key === 'persistent' || key === 'documentation') {
      totalPersistent += category.files.length;
    } else if (key !== 'unknown') {
      totalOneTime += category.files.length;
    }
  }
}

console.log('\n' + '='.repeat(60));
console.log(`SUMMARY:`);
console.log(`  One-time/Throwaway scripts: ${totalOneTime} files`);
console.log(`  Persistent scripts to keep: ${totalPersistent} files`);
console.log(`  Unknown (need review): ${categories.unknown.files.length} files`);
console.log('='.repeat(60));

// Generate cleanup script
const cleanupScript = `#!/bin/bash
# Auto-generated cleanup script for throwaway files

echo "🧹 Cleaning up throwaway scripts..."

# Create archive directory
mkdir -p archive/throwaway-scripts-$(date +%Y%m%d)

# Archive one-time scripts
${categories.oneTime.files.map(f => `mv "${f}" archive/throwaway-scripts-$(date +%Y%m%d)/ 2>/dev/null || true`).join('\n')}

# Archive deployment scripts
${categories.deployment.files.map(f => `mv "${f}" archive/throwaway-scripts-$(date +%Y%m%d)/ 2>/dev/null || true`).join('\n')}

# Archive data processing scripts
${categories.dataProcessing.files.map(f => `mv "${f}" archive/throwaway-scripts-$(date +%Y%m%d)/ 2>/dev/null || true`).join('\n')}

echo "✅ Archived ${totalOneTime} throwaway scripts"
echo "📁 Location: archive/throwaway-scripts-$(date +%Y%m%d)/"
`;

fs.writeFileSync('cleanup-throwaway-scripts.sh', cleanupScript);
console.log('\n✅ Generated cleanup script: cleanup-throwaway-scripts.sh');
console.log('   Run: chmod +x cleanup-throwaway-scripts.sh && ./cleanup-throwaway-scripts.sh'); 