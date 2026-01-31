#!/bin/bash

# VividWalls MAS - Webhook Compliance Validation and Update Script
# This script validates and updates all n8n workflows for webhook integration compliance

set -e

echo "======================================="
echo "VividWalls MAS Webhook Compliance Check"
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
N8N_URL="http://localhost:5678"
N8N_API_KEY="${N8N_API_KEY}"
WORKFLOW_BACKUP_DIR="/root/vivid_mas/services/n8n/backup/$(date +%Y%m%d_%H%M%S)"

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

# Function to check webhook response node
check_webhook_response() {
    local workflow_json=$1
    local workflow_name=$2
    
    # Check for webhook response node
    has_webhook_response=$(echo "$workflow_json" | jq '[.nodes[] | select(.type == "n8n-nodes-base.respondToWebhook")] | length')
    
    # Check for immediate execution ID response
    has_execution_id=$(echo "$workflow_json" | jq '[.nodes[] | select(.type == "n8n-nodes-base.respondToWebhook") | .parameters.respondWith // "" | contains("executionId")] | any')
    
    if [ "$has_webhook_response" -gt 0 ]; then
        if [ "$has_execution_id" = "true" ]; then
            echo -e "  ├─ Webhook Response: ${GREEN}✅ (with execution ID)${NC}"
        else
            echo -e "  ├─ Webhook Response: ${YELLOW}⚠️  (missing execution ID)${NC}"
        fi
    else
        echo -e "  ├─ Webhook Response: ${RED}❌ (not found)${NC}"
    fi
}

# Function to check wait node for human-in-the-loop
check_wait_node() {
    local workflow_json=$1
    
    # Check for wait node
    has_wait=$(echo "$workflow_json" | jq '[.nodes[] | select(.type == "n8n-nodes-base.wait")] | length')
    
    # Check for webhook resume configuration
    has_webhook_resume=$(echo "$workflow_json" | jq '[.nodes[] | select(.type == "n8n-nodes-base.wait" and .parameters.resume == "webhook")] | length')
    
    if [ "$has_wait" -gt 0 ]; then
        if [ "$has_webhook_resume" -gt 0 ]; then
            echo -e "  ├─ Wait Node (Human-in-Loop): ${GREEN}✅ (webhook resume)${NC}"
        else
            echo -e "  ├─ Wait Node (Human-in-Loop): ${YELLOW}⚠️  (not webhook resume)${NC}"
        fi
    else
        echo -e "  ├─ Wait Node (Human-in-Loop): ${RED}❌ (not found)${NC}"
    fi
}

# Function to check frontend integration compatibility
check_frontend_compatibility() {
    local workflow_json=$1
    
    # Check for webhook trigger
    has_webhook_trigger=$(echo "$workflow_json" | jq '[.nodes[] | select(.type == "n8n-nodes-base.webhook")] | length')
    
    # Check for proper webhook path
    has_proper_path=$(echo "$workflow_json" | jq '[.nodes[] | select(.type == "n8n-nodes-base.webhook") | .parameters.path // "" | test("^[a-z0-9-]+$")] | any')
    
    if [ "$has_webhook_trigger" -gt 0 ]; then
        if [ "$has_proper_path" = "true" ]; then
            echo -e "  ├─ Frontend Compatibility: ${GREEN}✅ (proper webhook path)${NC}"
        else
            echo -e "  ├─ Frontend Compatibility: ${YELLOW}⚠️  (check webhook path)${NC}"
        fi
    else
        echo -e "  └─ Frontend Compatibility: ${RED}❌ (no webhook trigger)${NC}"
    fi
}

# Function to add webhook response node
add_webhook_response_node() {
    local workflow_json=$1
    local workflow_id=$2
    
    # Create webhook response node
    local response_node='{
        "parameters": {
            "respondWith": "json",
            "responseBody": "={{ JSON.stringify({\"success\": true, \"executionId\": $executionId, \"workflowId\": \"'$workflow_id'\", \"timestamp\": new Date().toISOString(), \"status\": \"processing\"}) }}",
            "responseHeaders": {
                "entries": [
                    {
                        "name": "Content-Type",
                        "value": "application/json"
                    }
                ]
            }
        },
        "id": "webhook-response-'$(date +%s)'",
        "name": "Return Execution ID",
        "type": "n8n-nodes-base.respondToWebhook",
        "typeVersion": 1.1,
        "position": [1200, 300]
    }'
    
    # Add node to workflow
    echo "$workflow_json" | jq ".nodes += [$response_node]"
}

# Function to add wait node for human-in-the-loop
add_wait_node() {
    local workflow_json=$1
    
    # Create wait node with webhook resume
    local wait_node='{
        "parameters": {
            "resume": "webhook",
            "options": {
                "webhookSuffix": "approval",
                "webhookMethod": "POST",
                "responseData": "passThrough",
                "responsePropertyName": "approvalData"
            }
        },
        "id": "wait-approval-'$(date +%s)'",
        "name": "Wait for Human Approval",
        "type": "n8n-nodes-base.wait",
        "typeVersion": 1.1,
        "position": [1400, 400],
        "webhookId": "approval-'$(uuidgen | tr '[:upper:]' '[:lower:]')'"
    }'
    
    # Add node to workflow
    echo "$workflow_json" | jq ".nodes += [$wait_node]"
}

# Main validation and update function
validate_and_update_workflows() {
    print_section "Fetching All Workflows"
    
    # Get all workflows
    workflows=$(docker exec n8n n8n list:workflow 2>/dev/null | grep -v "^Permissions" | grep -v "^There is a deprecation" | grep -v "^$")
    
    # Create backup directory
    mkdir -p "$WORKFLOW_BACKUP_DIR"
    
    print_section "Validating Agent Workflows"
    
    local non_compliant=()
    local compliant=()
    local updated=()
    
    while IFS='|' read -r id name; do
        # Skip empty lines and headers
        if [[ -z "$id" || "$id" == *"Permissions"* ]]; then
            continue
        fi
        
        # Clean up the values
        id=$(echo "$id" | xargs)
        name=$(echo "$name" | xargs)
        
        # Only process agent workflows
        if [[ ! "$name" == *"Agent"* && ! "$name" == *"Director"* ]]; then
            continue
        fi
        
        echo ""
        echo "Checking: $name ($id)"
        
        # Export workflow
        workflow_json=$(docker exec n8n n8n export:workflow --id="$id" --all 2>/dev/null | jq '.[0]')
        
        # Backup original
        echo "$workflow_json" > "$WORKFLOW_BACKUP_DIR/${id}_backup.json"
        
        # Run compliance checks
        check_webhook_response "$workflow_json" "$name"
        response_status=$?
        
        check_wait_node "$workflow_json"
        wait_status=$?
        
        check_frontend_compatibility "$workflow_json"
        frontend_status=$?
        
        # Determine if updates needed
        needs_update=false
        
        # Check if webhook response node is missing
        if ! echo "$workflow_json" | jq -e '.nodes[] | select(.type == "n8n-nodes-base.respondToWebhook")' > /dev/null 2>&1; then
            echo -e "  ${YELLOW}→ Adding webhook response node...${NC}"
            workflow_json=$(add_webhook_response_node "$workflow_json" "$id")
            needs_update=true
        fi
        
        # Check if wait node is missing
        if ! echo "$workflow_json" | jq -e '.nodes[] | select(.type == "n8n-nodes-base.wait" and .parameters.resume == "webhook")' > /dev/null 2>&1; then
            echo -e "  ${YELLOW}→ Adding human-in-the-loop wait node...${NC}"
            workflow_json=$(add_wait_node "$workflow_json")
            needs_update=true
        fi
        
        # Update workflow if needed
        if [ "$needs_update" = true ]; then
            echo -e "  ${YELLOW}→ Updating workflow...${NC}"
            
            # Save updated workflow
            echo "$workflow_json" > "/tmp/${id}_updated.json"
            
            # Import updated workflow
            docker exec n8n n8n import:workflow --input="/tmp/${id}_updated.json" 2>/dev/null
            
            updated+=("$name")
            echo -e "  ${GREEN}✅ Workflow updated successfully${NC}"
        else
            compliant+=("$name")
            echo -e "  ${GREEN}✅ Workflow is compliant${NC}"
        fi
        
    done <<< "$workflows"
    
    print_section "Compliance Summary"
    
    echo -e "${GREEN}Compliant Workflows: ${#compliant[@]}${NC}"
    for workflow in "${compliant[@]}"; do
        echo "  ✅ $workflow"
    done
    
    echo ""
    echo -e "${YELLOW}Updated Workflows: ${#updated[@]}${NC}"
    for workflow in "${updated[@]}"; do
        echo "  🔄 $workflow"
    done
    
    echo ""
    echo -e "${BLUE}Backup Location: $WORKFLOW_BACKUP_DIR${NC}"
}

# Function to test webhook integration
test_webhook_integration() {
    print_section "Testing Webhook Integration"
    
    # Test a sample workflow
    test_workflow_id="at1EQMQgpxKNNXBD" # Marketing Director
    
    echo "Testing Marketing Director webhook..."
    response=$(curl -s -X POST \
        "${N8N_URL}/webhook-test/${test_workflow_id}" \
        -H "Content-Type: application/json" \
        -d '{
            "test": true,
            "message": "Webhook compliance test",
            "timestamp": "'$(date -Iseconds)'"
        }')
    
    if echo "$response" | jq -e '.executionId' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Webhook returns execution ID${NC}"
        execution_id=$(echo "$response" | jq -r '.executionId')
        echo "Execution ID: $execution_id"
    else
        echo -e "${RED}❌ Webhook does not return execution ID${NC}"
        echo "Response: $response"
    fi
}

# Function to generate webhook URLs documentation
generate_webhook_urls() {
    print_section "Generating Webhook URLs Documentation"
    
    cat > /root/vivid_mas/AGENT_WEBHOOK_URLS.md << 'EOF'
# Agent Webhook URLs

## Production Base URL
`https://n8n.vividwalls.blog`

## Director Agent Webhooks

| Agent | Webhook Path | Full URL | Approval Webhook |
|-------|-------------|----------|------------------|
| Business Manager | `/webhook/business-manager` | `https://n8n.vividwalls.blog/webhook/business-manager` | `/webhook/business-manager/approval` |
| Marketing Director | `/webhook/marketing-director` | `https://n8n.vividwalls.blog/webhook/marketing-director` | `/webhook/marketing-director/approval` |
| Sales Director | `/webhook/sales-director` | `https://n8n.vividwalls.blog/webhook/sales-director` | `/webhook/sales-director/approval` |
| Operations Director | `/webhook/operations-director` | `https://n8n.vividwalls.blog/webhook/operations-director` | `/webhook/operations-director/approval` |
| Technology Director | `/webhook/technology-director` | `https://n8n.vividwalls.blog/webhook/technology-director` | `/webhook/technology-director/approval` |
| Finance Director | `/webhook/finance-director` | `https://n8n.vividwalls.blog/webhook/finance-director` | `/webhook/finance-director/approval` |
| Analytics Director | `/webhook/analytics-director` | `https://n8n.vividwalls.blog/webhook/analytics-director` | `/webhook/analytics-director/approval` |
| Customer Experience Director | `/webhook/customer-experience-director` | `https://n8n.vividwalls.blog/webhook/customer-experience-director` | `/webhook/customer-experience-director/approval` |
| Creative Director | `/webhook/creative-director` | `https://n8n.vividwalls.blog/webhook/creative-director` | `/webhook/creative-director/approval` |
| Product Director | `/webhook/product-director` | `https://n8n.vividwalls.blog/webhook/product-director` | `/webhook/product-director/approval` |

## Webhook Response Format

### Immediate Response (Execution ID)
```json
{
  "success": true,
  "executionId": "123456",
  "workflowId": "workflow-id",
  "timestamp": "2025-01-15T12:00:00.000Z",
  "status": "processing"
}
```

### Human Approval Request
```json
{
  "approvalRequired": true,
  "approvalWebhook": "https://n8n.vividwalls.blog/webhook/[agent]/approval",
  "context": {
    "priority": "high|medium|low",
    "deadline": "2025-01-15T14:00:00.000Z",
    "requestor": "agent-name",
    "description": "Approval request details"
  }
}
```

### Approval Response
```json
{
  "approved": true,
  "approver": "user-id",
  "comments": "Optional approval comments",
  "timestamp": "2025-01-15T12:30:00.000Z"
}
```
EOF
    
    echo -e "${GREEN}✅ Generated AGENT_WEBHOOK_URLS.md${NC}"
}

# Main execution
main() {
    echo ""
    echo "Select operation:"
    echo "1) Validate all workflows"
    echo "2) Update non-compliant workflows"
    echo "3) Test webhook integration"
    echo "4) Generate webhook URLs documentation"
    echo "5) Full compliance check and update"
    echo ""
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            validate_and_update_workflows
            ;;
        2)
            validate_and_update_workflows
            ;;
        3)
            test_webhook_integration
            ;;
        4)
            generate_webhook_urls
            ;;
        5)
            validate_and_update_workflows
            test_webhook_integration
            generate_webhook_urls
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
}

# Run if not sourced
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi