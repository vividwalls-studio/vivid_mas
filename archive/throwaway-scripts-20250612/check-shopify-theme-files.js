const { spawn } = require('child_process');
const readline = require('readline');

const DROPLET_IP = '157.230.13.13';
const SSH_KEY = `${process.env.HOME}/.ssh/digitalocean`;
const THEME_ID = '176582885663';

// Create SSH command
const sshCommand = 'ssh';
const sshArgs = [
    '-i', SSH_KEY,
    `root@${DROPLET_IP}`,
    'cd /opt/mcp-servers/shopify-mcp-server && node build/index.js'
];

console.log('🔄 Connecting to Shopify MCP server...');

const mcpProcess = spawn(sshCommand, sshArgs, {
    stdio: ['pipe', 'pipe', 'pipe']
});

const rl = readline.createInterface({
    input: mcpProcess.stdout
});

let requestId = 1;
const filesToCheck = [
    'sections/main-product.liquid',
    'assets/vividwalls-product.css',
    'assets/vividwalls-product.js'
];

// Send initialization request
const initRequest = {
    jsonrpc: "2.0",
    method: "initialize",
    params: {
        protocolVersion: "2024-11-05",
        capabilities: {},
        clientInfo: {
            name: "shopify-theme-checker",
            version: "1.0.0"
        }
    },
    id: requestId++
};

console.log('📤 Sending initialization request...');
mcpProcess.stdin.write(JSON.stringify(initRequest) + '\n');

// Track responses
let currentFileIndex = 0;
const fileContents = {};

rl.on('line', (line) => {
    try {
        const response = JSON.parse(line);
        
        if (response.error) {
            console.error('❌ Error:', response.error.message);
            return;
        }
        
        if (response.id === 1) {
            console.log('✅ Initialization successful!');
            // Start checking files
            checkNextFile();
        } else if (response.result && response.result.content) {
            // This is a file content response
            const fileName = filesToCheck[currentFileIndex - 1];
            fileContents[fileName] = response.result.content;
            console.log(`✅ Retrieved ${fileName} (${response.result.content.length} bytes)`);
            
            if (currentFileIndex < filesToCheck.length) {
                checkNextFile();
            } else {
                // All files checked, display results
                displayResults();
                mcpProcess.kill();
                process.exit(0);
            }
        }
    } catch (e) {
        console.error('Failed to parse response:', e.message);
    }
});

function checkNextFile() {
    const fileName = filesToCheck[currentFileIndex];
    console.log(`\n📋 Checking ${fileName}...`);
    
    const toolRequest = {
        jsonrpc: "2.0",
        method: "tools/call",
        params: {
            name: "get_theme_file",
            arguments: {
                themeId: THEME_ID,
                filePath: fileName
            }
        },
        id: requestId++
    };
    
    mcpProcess.stdin.write(JSON.stringify(toolRequest) + '\n');
    currentFileIndex++;
}

function displayResults() {
    console.log('\n' + '='.repeat(80));
    console.log('📊 THEME FILE CHECK RESULTS');
    console.log('='.repeat(80));
    
    for (const [fileName, content] of Object.entries(fileContents)) {
        console.log(`\n📄 ${fileName}:`);
        if (content) {
            console.log(`   ✅ File exists (${content.length} bytes)`);
            // Show first few lines
            const lines = content.split('\n').slice(0, 5);
            console.log('   First 5 lines:');
            lines.forEach((line, i) => {
                console.log(`   ${i + 1}: ${line.substring(0, 80)}${line.length > 80 ? '...' : ''}`);
            });
        } else {
            console.log('   ❌ File not found');
        }
    }
}

// Error handling
mcpProcess.stderr.on('data', (data) => {
    const errorMsg = data.toString();
    if (!errorMsg.includes('passphrase')) {
        console.error('MCP Error:', errorMsg);
    }
});

mcpProcess.on('error', (error) => {
    console.error('Process error:', error);
    process.exit(1);
});

// Timeout after 30 seconds
setTimeout(() => {
    console.error('❌ Timeout: Operation took too long');
    mcpProcess.kill();
    process.exit(1);
}, 30000);