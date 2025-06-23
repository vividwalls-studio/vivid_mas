#!/usr/bin/env node
/**
 * Test Runner for Business Manager KPI Dashboard
 * 
 * This script runs all tests and provides a summary of the test results
 */

import { execSync } from 'child_process';
import { existsSync } from 'fs';
import path from 'path';

interface TestSuite {
  name: string;
  description: string;
  command: string;
  critical: boolean;
}

const testSuites: TestSuite[] = [
  {
    name: 'Unit Tests - Business Manager KPIs',
    description: 'Tests core Business Manager KPI functionality',
    command: 'npm run test:unit',
    critical: true
  },
  {
    name: 'Integration Tests - MCP Server',
    description: 'Tests MCP server tool integration',
    command: 'npm run test:integration',
    critical: true
  },
  {
    name: 'Crisis Monitoring Tests',
    description: 'Tests crisis trigger detection and alerts',
    command: 'npm run test:crisis',
    critical: true
  },
  {
    name: 'Stakeholder Report Tests',
    description: 'Tests report generation functionality',
    command: 'npm run test:report',
    critical: false
  }
];

console.log('🧪 Running Business Manager KPI Dashboard Tests\n');
console.log('=' .repeat(60));

let totalPassed = 0;
let totalFailed = 0;
const results: { suite: string; passed: boolean; error?: string }[] = [];

// Check if we're in the correct directory
const packageJsonPath = path.join(process.cwd(), 'package.json');
if (!existsSync(packageJsonPath)) {
  console.error('❌ Error: package.json not found. Please run from the project root.');
  process.exit(1);
}

// Run each test suite
for (const suite of testSuites) {
  console.log(`\n📋 ${suite.name}`);
  console.log(`   ${suite.description}`);
  console.log('-'.repeat(60));
  
  try {
    const output = execSync(suite.command, { 
      encoding: 'utf8',
      stdio: 'pipe'
    });
    
    // Parse test results from output
    const passMatch = output.match(/Tests:\s+(\d+)\s+passed/);
    const failMatch = output.match(/Tests:\s+(\d+)\s+failed/);
    
    const passed = passMatch ? parseInt(passMatch[1]) : 0;
    const failed = failMatch ? parseInt(failMatch[1]) : 0;
    
    if (failed === 0 && passed > 0) {
      console.log(`✅ PASSED: ${passed} tests`);
      totalPassed += passed;
      results.push({ suite: suite.name, passed: true });
    } else {
      throw new Error(`${failed} tests failed`);
    }
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    console.log(`❌ FAILED: ${errorMessage}`);
    totalFailed++;
    results.push({ 
      suite: suite.name, 
      passed: false, 
      error: errorMessage 
    });
    
    if (suite.critical) {
      console.log('\n⚠️  Critical test suite failed. Stopping test run.');
      break;
    }
  }
}

// Generate summary report
console.log('\n' + '='.repeat(60));
console.log('📊 TEST SUMMARY');
console.log('='.repeat(60));

results.forEach(result => {
  const status = result.passed ? '✅' : '❌';
  const message = result.passed ? 'PASSED' : `FAILED: ${result.error}`;
  console.log(`${status} ${result.suite}: ${message}`);
});

console.log('\n' + '-'.repeat(60));
console.log(`Total Test Suites: ${results.length}`);
console.log(`Passed: ${results.filter(r => r.passed).length}`);
console.log(`Failed: ${results.filter(r => !r.passed).length}`);

// Run coverage report if all tests passed
if (totalFailed === 0) {
  console.log('\n📈 Running coverage report...');
  try {
    execSync('npm run test:coverage', { stdio: 'inherit' });
  } catch (error) {
    console.log('⚠️  Coverage report generation failed');
  }
}

// Exit with appropriate code
const exitCode = totalFailed > 0 ? 1 : 0;
console.log('\n' + '='.repeat(60));
console.log(exitCode === 0 ? '✅ All tests passed!' : '❌ Some tests failed.');
process.exit(exitCode);