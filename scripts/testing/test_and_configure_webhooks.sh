#!/bin/bash

# VividWalls MAS - Webhook Testing and Configuration Script
# This script tests and configures webhook endpoints for all agent workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "==========================================="
echo "VividWalls MAS Webhook Configuration"
echo "==========================================="
echo ""

# N8N configuration
N8N_URL="https://n8n.vividwalls.blog"
N8N_LOCAL="http://localhost:5678"

# Function to print section headers
print_section() {
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

# Function to test webhook endpoints
test_webhooks() {
    print_section "Testing Webhook Endpoints"
    
    ssh -i ~/.ssh/digitalocean root@157.230.13.13 << 'EOF'
    
    # Get all webhook IDs from active workflows
    echo "Retrieving webhook configurations..."
    
    docker exec postgres psql -U postgres -d postgres -t -c "
    SELECT DISTINCT 
        w.id as workflow_id,
        w.name as workflow_name,
        n.value->>'webhookId' as webhook_id,
        n.value->>'path' as webhook_path,
        n.value->>'httpMethod' as http_method
    FROM workflow_entity w,
         jsonb_array_elements(w.nodes::jsonb) n
    WHERE n.value->>'type' = 'n8n-nodes-base.webhook'
      AND w.active = true
      AND w.name LIKE '%Agent%'
      AND n.value->>'webhookId' IS NOT NULL
    ORDER BY w.name
    LIMIT 30;" > /tmp/webhooks.csv
    
    echo "Testing each webhook endpoint..."
    echo ""
    
    # Test each webhook
    while IFS='|' read -r workflow_id workflow_name webhook_id webhook_path http_method; do
        # Clean up the values
        workflow_id=$(echo "$workflow_id" | xargs)
        workflow_name=$(echo "$workflow_name" | xargs)
        webhook_id=$(echo "$webhook_id" | xargs)
        webhook_path=$(echo "$webhook_path" | xargs)
        http_method=$(echo "$http_method" | xargs)
        
        if [ ! -z "$webhook_id" ]; then
            echo "Testing: $workflow_name"
            echo "  Webhook ID: $webhook_id"
            echo "  Path: $webhook_path"
            echo "  Method: ${http_method:-POST}"
            
            # Test the webhook
            if [ "${http_method:-POST}" = "GET" ]; then
                response=$(curl -s -o /dev/null -w "%{http_code}" \
                    "http://localhost:5678/webhook/$webhook_id" 2>/dev/null)
            else
                response=$(curl -s -o /dev/null -w "%{http_code}" \
                    -X POST "http://localhost:5678/webhook/$webhook_id" \
                    -H "Content-Type: application/json" \
                    -d '{"test": true, "agent": "test"}' 2>/dev/null)
            fi
            
            if [ "$response" = "200" ] || [ "$response" = "201" ] || [ "$response" = "204" ]; then
                echo "  ✅ Status: $response - Working"
            elif [ "$response" = "404" ]; then
                echo "  ❌ Status: 404 - Not registered (needs activation in UI)"
            else
                echo "  ⚠️  Status: $response"
            fi
            echo ""
        fi
    done < /tmp/webhooks.csv
EOF
}

# Function to create webhook test HTML page
create_webhook_test_page() {
    print_section "Creating Webhook Test Interface"
    
    cat > /Volumes/SeagatePortableDrive/Projects/vivid_mas/webhook_test_interface.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VividWalls MAS - Webhook Test Interface</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        .webhook-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .webhook-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: #f9f9f9;
        }
        .webhook-card h3 {
            margin-top: 0;
            color: #667eea;
            font-size: 16px;
        }
        .webhook-info {
            font-size: 12px;
            color: #666;
            margin: 5px 0;
        }
        .test-button {
            background: #667eea;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
            width: 100%;
        }
        .test-button:hover {
            background: #5a67d8;
        }
        .status {
            margin-top: 10px;
            padding: 5px;
            border-radius: 4px;
            font-size: 12px;
        }
        .status.success {
            background: #d4edda;
            color: #155724;
        }
        .status.error {
            background: #f8d7da;
            color: #721c24;
        }
        .status.pending {
            background: #fff3cd;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 VividWalls MAS - Webhook Test Interface</h1>
        
        <div class="webhook-grid">
            <!-- Business Manager -->
            <div class="webhook-card">
                <h3>Business Manager Orchestrator</h3>
                <div class="webhook-info">ID: business-events</div>
                <div class="webhook-info">Method: POST</div>
                <button class="test-button" onclick="testWebhook('business-events', 'POST')">
                    Test Webhook
                </button>
                <div id="status-business-events" class="status"></div>
            </div>
            
            <!-- Marketing Director -->
            <div class="webhook-card">
                <h3>Marketing Director Agent</h3>
                <div class="webhook-info">ID: marketing-director-webhook</div>
                <div class="webhook-info">Method: POST</div>
                <button class="test-button" onclick="testWebhook('marketing-director-webhook', 'POST')">
                    Test Webhook
                </button>
                <div id="status-marketing-director-webhook" class="status"></div>
            </div>
            
            <!-- Sales Director -->
            <div class="webhook-card">
                <h3>Sales Director Agent</h3>
                <div class="webhook-info">ID: sales-director-webhook</div>
                <div class="webhook-info">Method: POST</div>
                <button class="test-button" onclick="testWebhook('sales-director-webhook', 'POST')">
                    Test Webhook
                </button>
                <div id="status-sales-director-webhook" class="status"></div>
            </div>
            
            <!-- Technology Director -->
            <div class="webhook-card">
                <h3>Technology Director Agent</h3>
                <div class="webhook-info">ID: technology-director-webhook</div>
                <div class="webhook-info">Method: POST</div>
                <button class="test-button" onclick="testWebhook('technology-director-webhook', 'POST')">
                    Test Webhook
                </button>
                <div id="status-technology-director-webhook" class="status"></div>
            </div>
            
            <!-- Finance Director -->
            <div class="webhook-card">
                <h3>Finance Director Agent</h3>
                <div class="webhook-info">ID: finance-director-webhook</div>
                <div class="webhook-info">Method: POST</div>
                <button class="test-button" onclick="testWebhook('finance-director-webhook', 'POST')">
                    Test Webhook
                </button>
                <div id="status-finance-director-webhook" class="status"></div>
            </div>
            
            <!-- Analytics Director -->
            <div class="webhook-card">
                <h3>Analytics Director Agent</h3>
                <div class="webhook-info">ID: analytics-data-insights-webhook</div>
                <div class="webhook-info">Method: POST</div>
                <button class="test-button" onclick="testWebhook('analytics-data-insights-webhook', 'POST')">
                    Test Webhook
                </button>
                <div id="status-analytics-data-insights-webhook" class="status"></div>
            </div>
        </div>
        
        <h2 style="margin-top: 40px;">📝 Test Results</h2>
        <div id="results" style="background: #f4f4f4; padding: 20px; border-radius: 8px; font-family: monospace; font-size: 12px; max-height: 400px; overflow-y: auto;">
            <p>Test results will appear here...</p>
        </div>
    </div>
    
    <script>
        const N8N_URL = 'https://n8n.vividwalls.blog';
        
        async function testWebhook(webhookId, method = 'POST') {
            const statusDiv = document.getElementById(`status-${webhookId}`);
            const resultsDiv = document.getElementById('results');
            
            // Show pending status
            statusDiv.className = 'status pending';
            statusDiv.textContent = 'Testing...';
            
            const testData = {
                test: true,
                timestamp: new Date().toISOString(),
                agent: 'test-interface',
                message: `Testing ${webhookId} webhook`,
                request: {
                    type: 'validation',
                    source: 'webhook-test-interface'
                }
            };
            
            try {
                const response = await fetch(`${N8N_URL}/webhook/${webhookId}`, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: method === 'POST' ? JSON.stringify(testData) : undefined
                });
                
                const timestamp = new Date().toLocaleTimeString();
                
                if (response.ok) {
                    const data = await response.text();
                    statusDiv.className = 'status success';
                    statusDiv.textContent = `✅ Success (${response.status})`;
                    
                    resultsDiv.innerHTML += `
<strong>[${timestamp}] ${webhookId}:</strong> Success (${response.status})
Response: ${data ? data.substring(0, 200) : 'No response body'}
---
`;
                } else if (response.status === 404) {
                    statusDiv.className = 'status error';
                    statusDiv.textContent = '❌ Not Registered (404)';
                    
                    resultsDiv.innerHTML += `
<strong>[${timestamp}] ${webhookId}:</strong> Not Registered (404)
Action Required: Open workflow in n8n UI and click "Execute workflow"
---
`;
                } else {
                    statusDiv.className = 'status error';
                    statusDiv.textContent = `⚠️ Error (${response.status})`;
                    
                    resultsDiv.innerHTML += `
<strong>[${timestamp}] ${webhookId}:</strong> Error (${response.status})
---
`;
                }
            } catch (error) {
                statusDiv.className = 'status error';
                statusDiv.textContent = '❌ Network Error';
                
                resultsDiv.innerHTML += `
<strong>[${new Date().toLocaleTimeString()}] ${webhookId}:</strong> Network Error
Error: ${error.message}
---
`;
            }
            
            // Auto-scroll results
            resultsDiv.scrollTop = resultsDiv.scrollHeight;
        }
        
        // Test all webhooks on page load
        async function testAllWebhooks() {
            const webhooks = [
                'business-events',
                'marketing-director-webhook',
                'sales-director-webhook',
                'technology-director-webhook',
                'finance-director-webhook',
                'analytics-data-insights-webhook'
            ];
            
            for (const webhook of webhooks) {
                await testWebhook(webhook, 'POST');
                await new Promise(resolve => setTimeout(resolve, 500)); // Small delay between tests
            }
        }
        
        // Add keyboard shortcut
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && e.ctrlKey) {
                testAllWebhooks();
            }
        });
    </script>
</body>
</html>
HTML
    
    echo -e "${GREEN}✓ Webhook test interface created${NC}"
    echo "Open in browser: file:///Volumes/SeagatePortableDrive/Projects/vivid_mas/webhook_test_interface.html"
}

# Function to generate webhook activation guide
generate_activation_guide() {
    print_section "Generating Webhook Activation Guide"
    
    cat > /Volumes/SeagatePortableDrive/Projects/vivid_mas/WEBHOOK_ACTIVATION_GUIDE.md << 'GUIDE'
# VividWalls MAS - Webhook Activation Guide

## Quick Activation Steps

### 1. Access n8n UI
- URL: https://n8n.vividwalls.blog
- Login with your credentials

### 2. Activate Webhooks for Each Agent

#### Business Manager Orchestrator
1. Open workflow: "Business Manager Agent Orchestration"
2. Click the webhook node
3. Click "Listen for Test Event" or "Execute workflow"
4. The webhook URL will be: `https://n8n.vividwalls.blog/webhook/business-events`

#### Marketing Director Agent
1. Open workflow: "Marketing Director Agent"
2. Click the webhook node
3. Click "Listen for Test Event"
4. The webhook URL will be: `https://n8n.vividwalls.blog/webhook/marketing-director-webhook`

#### Sales Director Agent
1. Open workflow: "Sales Director Agent"
2. Click the webhook node
3. Click "Listen for Test Event"
4. The webhook URL will be: `https://n8n.vividwalls.blog/webhook/sales-director-webhook`

### 3. Test Webhook Registration

Use the test interface or curl:

```bash
# Test Business Manager
curl -X POST https://n8n.vividwalls.blog/webhook/business-events \
  -H "Content-Type: application/json" \
  -d '{"test": true, "message": "Testing Business Manager"}'

# Test Marketing Director
curl -X POST https://n8n.vividwalls.blog/webhook/marketing-director-webhook \
  -H "Content-Type: application/json" \
  -d '{"test": true, "message": "Testing Marketing Director"}'
```

### 4. Production Activation

After testing, activate for production:

1. In each workflow, find the webhook node
2. Click on it to open settings
3. Toggle "Production" mode
4. Save the workflow
5. The webhook is now permanently active

## Webhook Endpoints Reference

| Agent | Webhook ID | URL |
|-------|------------|-----|
| Business Manager | business-events | https://n8n.vividwalls.blog/webhook/business-events |
| Marketing Director | marketing-director-webhook | https://n8n.vividwalls.blog/webhook/marketing-director-webhook |
| Sales Director | sales-director-webhook | https://n8n.vividwalls.blog/webhook/sales-director-webhook |
| Technology Director | technology-director-webhook | https://n8n.vividwalls.blog/webhook/technology-director-webhook |
| Operations Director | operations-director-webhook | https://n8n.vividwalls.blog/webhook/operations-director-webhook |
| Finance Director | finance-director-webhook | https://n8n.vividwalls.blog/webhook/finance-director-webhook |
| Analytics Director | analytics-data-insights-webhook | https://n8n.vividwalls.blog/webhook/analytics-data-insights-webhook |
| Customer Experience | customer-experience-webhook | https://n8n.vividwalls.blog/webhook/customer-experience-webhook |
| Product Director | product-director-webhook | https://n8n.vividwalls.blog/webhook/product-director-webhook |
| Creative Director | creative-director-webhook | https://n8n.vividwalls.blog/webhook/creative-director-webhook |

## Troubleshooting

### Webhook Returns 404
- Workflow is not active
- Webhook not registered (needs UI activation)
- Wrong webhook ID

### Webhook Returns 500
- Workflow has errors
- Check n8n logs: `docker logs n8n --tail 100`

### Webhook No Response
- Check if n8n is running: `docker ps | grep n8n`
- Check network connectivity
- Verify SSL certificate

## Automation Script

To test all webhooks at once:

```bash
#!/bin/bash
webhooks=(
    "business-events"
    "marketing-director-webhook"
    "sales-director-webhook"
    "technology-director-webhook"
    "operations-director-webhook"
    "finance-director-webhook"
)

for webhook in "${webhooks[@]}"; do
    echo "Testing $webhook..."
    curl -s -o /dev/null -w "%{http_code}" \
        -X POST "https://n8n.vividwalls.blog/webhook/$webhook" \
        -H "Content-Type: application/json" \
        -d '{"test": true}'
    echo ""
done
```

---
*Generated by VividWalls MAS Configuration System*
GUIDE
    
    echo -e "${GREEN}✓ Webhook activation guide created${NC}"
}

# Main execution
main() {
    echo "Starting webhook configuration process..."
    echo ""
    
    test_webhooks
    create_webhook_test_page
    generate_activation_guide
    
    echo ""
    echo -e "${GREEN}==========================================="
    echo "Webhook Configuration Complete!"
    echo "==========================================="
    echo ""
    echo "Resources created:"
    echo "1. Webhook test interface: webhook_test_interface.html"
    echo "2. Activation guide: WEBHOOK_ACTIVATION_GUIDE.md"
    echo ""
    echo "Next steps:"
    echo "1. Open n8n UI: https://n8n.vividwalls.blog"
    echo "2. Activate webhooks following the guide"
    echo "3. Test using the HTML interface"
    echo -e "${NC}"
}

# Run main function
main