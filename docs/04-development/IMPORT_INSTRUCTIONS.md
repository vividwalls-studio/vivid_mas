
# N8N Workflow Import Instructions

## Files Created: 13
Location: /Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_workflows_to_import

## Import Methods:

### Method 1: Via n8n UI
1. Access n8n at https://n8n.vividwalls.blog
2. Go to Workflows > Import
3. Upload each JSON file

### Method 2: Via n8n CLI (on droplet)
```bash
cd /root/vivid_mas
for file in n8n_workflows_to_import/*.json; do
  docker exec n8n n8n import:workflow --input="$file"
done
```

### Method 3: Via n8n API
```bash
for file in n8n_workflows_to_import/*.json; do
  curl -X POST https://n8n.vividwalls.blog/api/v1/workflows \
    -H "X-N8N-API-KEY: YOUR_API_KEY" \
    -H "Content-Type: application/json" \
    -d @"$file"
done
```

## Workflows Created:
- Campaign Manager Agent (campaign-manager)
- Copy Writer Agent (copy-writer)
- Copy Editor Agent (copy-editor)
- Email Marketing Agent (email-marketing)
- Product Director Agent (product-director)
- Hospitality Sales Agent (hospitality-sales)
- Corporate Sales Agent (corporate-sales)
- Healthcare Sales Agent (healthcare-sales)
- Pinterest Agent (pinterest)
- Twitter Agent (twitter)
- LinkedIn Agent (linkedin)
- TikTok Agent (tiktok)
- YouTube Agent (youtube)
