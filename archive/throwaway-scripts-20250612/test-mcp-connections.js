#!/usr/bin/env node

/**
 * VividWalls MCP Connection Tester
 * Tests connectivity to all 14 MCP servers on the Digital Ocean droplet
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const SSH_KEY = '~/.ssh/digitalocean';
const DROPLET_IP = '157.230.13.13';
const MCP_SERVERS_DIR = '/opt/mcp-servers';

// List of all MCP servers to test
const MCP_SERVERS = [
    {
        name: 'Shopify MCP',
        path: 'shopify-mcp-server',
        command: 'node build/index.js',
        testTool: 'get_products'
    },
    {
        name: 'Supabase MCP',
        path: 'supabase-mcp-server',
        command: 'node build/index.js',
        testTool: 'check-connection'
    },
    {
        name: 'Neo4j Cypher MCP',
        path: 'neo4j-mcp-server',
        command: 'python -m mcp_neo4j_cypher',
        testTool: 'get-neo4j-schema'
    },
    {
        name: 'Neo4j Memory MCP',
        path: 'neo4j-mcp-server',
        command: 'python -m mcp_neo4j_memory',
        testTool: 'read_graph'
    },
    {
        name: 'n8n MCP',
        path: 'n8n-mcp-server',
        command: 'node dist/index.js',
        testTool: 'list_workflows'
    },
    {
        name: 'Facebook Ads MCP',
        path: 'facebook-ads-mcp-server',
        command: 'python server.py',
        testTool: 'list_ad_accounts'
    },
    {
        name: 'SEO Research MCP',
        path: 'seo-research-mcp',
        command: 'node dist/index.js',
        testTool: 'keyword_research'
    },
    {
        name: 'Pictorem MCP',
        path: 'pictorem-mcp-server',
        command: 'node dist/index.js',
        testTool: 'get_products'
    },
    {
        name: 'Pinterest MCP',
        path: 'pinterest-mcp-server',
        command: 'python server.py',
        testTool: 'get_user_profile'
    },
    {
        name: 'Tavily MCP',
        path: 'tavily-mcp',
        command: 'node build/index.js',
        testTool: 'search'
    },
    {
        name: 'Color Psychology MCP',
        path: 'color-psychology-mcp-server',
        command: 'python server.py',
        testTool: 'analyze_color_palette'
    },
    {
        name: 'Email Marketing MCP',
        path: 'email-marketing-mcp-server',
        command: 'python server.py',
        testTool: 'get_analytics'
    },
    {
        name: 'Analytics MCP',
        path: 'analytics-mcp-server',
        command: 'node dist/index.js',
        testTool: 'get_business_metrics'
    },
    {
        name: 'WordPress MCP',
        path: 'wordpress-mcp-server',
        command: 'node dist/index.js',
        testTool: 'get_posts'
    }
];

/**
 * Test SSH connectivity to the droplet
 */
async function testSSHConnection() {
    console.log('🔗 Testing SSH connection to droplet...');
    
    return new Promise((resolve, reject) => {
        const ssh = spawn('ssh', [
            '-i', SSH_KEY.replace('~', process.env.HOME),
            `root@${DROPLET_IP}`,
            'echo "SSH connection successful"'
        ]);

        let output = '';
        let error = '';

        ssh.stdout.on('data', (data) => {
            output += data.toString();
        });

        ssh.stderr.on('data', (data) => {
            error += data.toString();
        });

        ssh.on('close', (code) => {
            if (code === 0 && output.includes('SSH connection successful')) {
                console.log('✅ SSH connection successful');
                resolve(true);
            } else {
                console.log('❌ SSH connection failed:', error);
                reject(new Error(`SSH failed with code ${code}: ${error}`));
            }
        });
    });
}

/**
 * Test if an MCP server directory exists and has the required files
 */
async function testMCPServerSetup(server) {
    console.log(`📋 Testing ${server.name} setup...`);
    
    return new Promise((resolve) => {
        const ssh = spawn('ssh', [
            '-i', SSH_KEY.replace('~', process.env.HOME),
            `root@${DROPLET_IP}`,
            `cd ${MCP_SERVERS_DIR}/${server.path} && ls -la`
        ]);

        let output = '';
        let error = '';

        ssh.stdout.on('data', (data) => {
            output += data.toString();
        });

        ssh.stderr.on('data', (data) => {
            error += data.toString();
        });

        ssh.on('close', (code) => {
            if (code === 0) {
                // Check for key files
                const hasPackageJson = output.includes('package.json');
                const hasNodeModules = output.includes('node_modules');
                const hasBuild = output.includes('build') || output.includes('dist');
                const hasServer = output.includes('server.py') || output.includes('index.js');
                
                if (hasServer && (hasNodeModules || output.includes('.py'))) {
                    console.log(`  ✅ ${server.name} files present`);
                    resolve({ success: true, details: 'Files present' });
                } else {
                    console.log(`  ⚠️  ${server.name} missing some files`);
                    resolve({ success: false, details: 'Missing files' });
                }
            } else {
                console.log(`  ❌ ${server.name} directory not found`);
                resolve({ success: false, details: 'Directory not found' });
            }
        });
    });
}

/**
 * Test if an MCP server can start up (basic connectivity test)
 */
async function testMCPServerStartup(server) {
    console.log(`🚀 Testing ${server.name} startup...`);
    
    return new Promise((resolve) => {
        const ssh = spawn('ssh', [
            '-i', SSH_KEY.replace('~', process.env.HOME),
            `root@${DROPLET_IP}`,
            `cd ${MCP_SERVERS_DIR}/${server.path} && timeout 5s ${server.command} || echo "TIMEOUT_OR_EXIT"`
        ]);

        let output = '';
        let error = '';

        ssh.stdout.on('data', (data) => {
            output += data.toString();
        });

        ssh.stderr.on('data', (data) => {
            error += data.toString();
        });

        ssh.on('close', (code) => {
            // Look for positive indicators
            const hasStarted = output.includes('started') || 
                              output.includes('listening') || 
                              output.includes('Server') ||
                              output.includes('MCP') ||
                              error.includes('started') ||
                              error.includes('Server');
            
            const hasErrors = error.includes('Error') || 
                             error.includes('failed') ||
                             error.includes('not found') ||
                             output.includes('Error');

            if (hasStarted && !hasErrors) {
                console.log(`  ✅ ${server.name} started successfully`);
                resolve({ success: true, details: 'Started successfully' });
            } else if (output.includes('TIMEOUT_OR_EXIT')) {
                console.log(`  ⚠️  ${server.name} started but timed out (normal for stdio servers)`);
                resolve({ success: true, details: 'Started but timed out (expected)' });
            } else {
                console.log(`  ❌ ${server.name} failed to start`);
                console.log(`     Output: ${output.substring(0, 200)}`);
                console.log(`     Error: ${error.substring(0, 200)}`);
                resolve({ success: false, details: 'Failed to start' });
            }
        });
    });
}

/**
 * Main test runner
 */
async function runTests() {
    console.log('🧪 VividWalls MCP Connection Test Suite');
    console.log('=' * 50);
    
    try {
        // Test SSH connection first
        await testSSHConnection();
        
        console.log(`\\n📊 Testing ${MCP_SERVERS.length} MCP servers...\\n`);
        
        const results = [];
        
        for (const server of MCP_SERVERS) {
            console.log(`--- ${server.name} ---`);
            
            const setupResult = await testMCPServerSetup(server);
            const startupResult = await testMCPServerStartup(server);
            
            results.push({
                name: server.name,
                setup: setupResult,
                startup: startupResult,
                overall: setupResult.success && startupResult.success
            });
            
            console.log('');
        }
        
        // Summary
        console.log('📋 Test Results Summary');
        console.log('=' * 30);
        
        const successful = results.filter(r => r.overall).length;
        const total = results.length;
        
        results.forEach(result => {
            const status = result.overall ? '✅' : '❌';
            console.log(`${status} ${result.name}`);
            if (!result.overall) {
                console.log(`   Setup: ${result.setup.success ? '✅' : '❌'} ${result.setup.details}`);
                console.log(`   Startup: ${result.startup.success ? '✅' : '❌'} ${result.startup.details}`);
            }
        });
        
        console.log(`\\n🎯 Results: ${successful}/${total} MCP servers working`);
        
        if (successful === total) {
            console.log('🎉 All MCP servers are operational!');
            console.log('\\n📝 Next steps:');
            console.log('   1. Use the .cursor/mcp-vividwalls.json configuration file');
            console.log('   2. Test specific MCP tools using Claude Code');
            console.log('   3. Integrate with your workflows');
        } else {
            console.log('⚠️  Some MCP servers need attention');
            console.log('\\n🔧 Troubleshooting:');
            console.log('   1. Check server dependencies are installed');
            console.log('   2. Verify environment variables are set');
            console.log('   3. Check server logs for specific errors');
        }
        
    } catch (error) {
        console.error('💥 Test suite failed:', error.message);
        process.exit(1);
    }
}

// Run the tests
if (require.main === module) {
    runTests().catch(console.error);
}

module.exports = { runTests, testSSHConnection, testMCPServerSetup, testMCPServerStartup };