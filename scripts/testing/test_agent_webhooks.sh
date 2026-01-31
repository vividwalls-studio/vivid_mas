#!/bin/bash

# VividWalls Agent Webhook Testing Script
# This script tests agent webhooks via n8n and retrieves responses

echo "========================================="
echo "VividWalls Agent Webhook Testing"
echo "========================================="

# Base URL for n8n webhooks
N8N_BASE_URL="https://n8n.vividwalls.blog/webhook"

# Test webhook endpoint (you'll need to update with actual webhook paths)
test_webhook() {
    local agent_name=$1
    local webhook_path=$2
    local payload=$3
    
    echo ""
    echo "Testing $agent_name webhook..."
    echo "URL: $N8N_BASE_URL/$webhook_path"
    echo "Payload: $payload"
    
    response=$(curl -s -X POST \
        "$N8N_BASE_URL/$webhook_path" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    echo "Response: $response"
    echo "----------------------------------------"
    
    return 0
}

# Example test payloads for different agents
echo ""
echo "Testing Agent Webhooks..."

# Business Manager Agent
test_webhook "Business Manager" "business-manager" '{
    "action": "analyze",
    "department": "marketing",
    "request": "Generate weekly performance report"
}'

# Marketing Director Agent  
test_webhook "Marketing Director" "marketing-director" '{
    "action": "campaign_analysis",
    "campaign_id": "test_001",
    "metrics": ["engagement", "reach", "conversions"]
}'

# Social Media Director
test_webhook "Social Media Director" "social-media" '{
    "action": "schedule_post",
    "platform": "instagram",
    "content": "Test post content",
    "schedule_time": "2025-08-13T10:00:00Z"
}'

# Data Analytics Agent
test_webhook "Data Analytics" "data-analytics" '{
    "action": "generate_report",
    "report_type": "sales_analysis",
    "date_range": {
        "start": "2025-08-01",
        "end": "2025-08-12"
    }
}'

echo ""
echo "Testing complete!"