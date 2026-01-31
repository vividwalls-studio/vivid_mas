#!/bin/bash
set -e

# Create Python script to update n8n MCP config
cat > /tmp/update_email_mcp.py << 'PYTHON_SCRIPT'
import json

# Read current config
with open('/opt/mcp-servers/n8n-mcp-config.json', 'r') as f:
    config = json.load(f)

# Add email marketing prompts server
config['mcpServers']['email-marketing-prompts'] = {
    'name': 'Email Marketing Prompts Server',
    'description': 'Provides prompt templates and query generation for email marketing campaigns',
    'command': 'node',
    'args': ['/opt/mcp-servers/email-marketing-prompts/dist/index.js'],
    'cwd': '/opt/mcp-servers/email-marketing-prompts',
    'env': {
        'LOG_LEVEL': 'info'
    }
}

# Add email marketing resource server
config['mcpServers']['email-marketing-resource'] = {
    'name': 'Email Marketing Resource Server',
    'description': 'Provides customer segmentation data and resources for email marketing',
    'command': 'node',
    'args': ['/opt/mcp-servers/email-marketing-resource/dist/index.js'],
    'cwd': '/opt/mcp-servers/email-marketing-resource',
    'env': {
        'LOG_LEVEL': 'info'
    }
}

# Add ListMonk server
config['mcpServers']['listmonk-mcp'] = {
    'name': 'ListMonk Email Marketing Server',
    'description': 'Email marketing and subscriber management via ListMonk',
    'command': 'node',
    'args': ['/opt/mcp-servers/listmonk-mcp-server/build/index.js'],
    'cwd': '/opt/mcp-servers/listmonk-mcp-server',
    'env': {
        'LISTMONK_URL': 'http://localhost:9003',
        'LISTMONK_USERNAME': 'admin',
        'LISTMONK_PASSWORD': 'listmonk'
    }
}

# Add Twenty CRM server
config['mcpServers']['twenty-crm'] = {
    'name': 'Twenty CRM MCP Server',
    'description': 'Twenty CRM integration for customer relationship management',
    'command': 'node',
    'args': ['/opt/mcp-servers/twenty-mcp-server/build/index.js'],
    'cwd': '/opt/mcp-servers/twenty-mcp-server',
    'env': {
        'TWENTY_API_KEY': '${MCP_TWENTY_API_KEY}',
        'TWENTY_API_URL': 'https://crm.vividwalls.blog'
    }
}

# Write updated config
with open('/opt/mcp-servers/n8n-mcp-config.json', 'w') as f:
    json.dump(config, f, indent=2)

print('Email marketing and CRM MCP servers added to n8n configuration')

# Print the server list
print('\nMCP Servers now configured:')
for key in sorted(config['mcpServers'].keys()):
    print(f'  - {key}')
PYTHON_SCRIPT

# Upload and execute on droplet
echo "Updating n8n MCP configuration..."
scp -i ~/.ssh/digitalocean /tmp/update_email_mcp.py root@157.230.13.13:/tmp/
ssh -i ~/.ssh/digitalocean root@157.230.13.13 "python3 /tmp/update_email_mcp.py && rm /tmp/update_email_mcp.py"

echo "Configuration updated successfully!"