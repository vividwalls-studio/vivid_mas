# VividWalls MAS Webhook Configuration Reference

## N8N API Configuration

### API Key (Updated)
```
N8N_API_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzU1MTA3MDQxfQ.slVRvod1jTp6u8r0ZW1TpTe1mEgCU76LhphSXDyf-8I
N8N_API_URL=https://n8n.vividwalls.blog/api/v1
```

### Locations Updated
- `/opt/mcp-servers/n8n-mcp-server/.env`
- `/root/vivid_mas/.env`

## Webhook Configurations

### Business Manager Agent
- **URL**: `https://n8n.vividwalls.blog/webhook/business-manager-webhook`
- **Username**: `webhook`
- **Password**: `BM_webhook_2025_secure`

### Director Agents

#### Marketing Director
- **URL**: `https://n8n.vividwalls.blog/webhook/marketing-director-webhook`
- **Username**: `webhook`
- **Password**: `MD_webhook_2025_secure`

#### Sales Director
- **URL**: `https://n8n.vividwalls.blog/webhook/sales-director-webhook`
- **Username**: `webhook`
- **Password**: `SD_webhook_2025_secure`

#### Operations Director
- **URL**: `https://n8n.vividwalls.blog/webhook/operations-director-webhook`
- **Username**: `webhook`
- **Password**: `OD_webhook_2025_secure`

#### Customer Experience Director
- **URL**: `https://n8n.vividwalls.blog/webhook/customer-experience-director-webhook`
- **Username**: `webhook`
- **Password**: `CED_webhook_2025_secure`

#### Product Director
- **URL**: `https://n8n.vividwalls.blog/webhook/product-director-webhook`
- **Username**: `webhook`
- **Password**: `PD_webhook_2025_secure`

#### Finance Director
- **URL**: `https://n8n.vividwalls.blog/webhook/finance-director-webhook`
- **Username**: `webhook`
- **Password**: `FD_webhook_2025_secure`

#### Analytics Director
- **URL**: `https://n8n.vividwalls.blog/webhook/analytics-director-webhook`
- **Username**: `webhook`
- **Password**: `AD_webhook_2025_secure`

#### Technology Director
- **URL**: `https://n8n.vividwalls.blog/webhook/technology-director-webhook`
- **Username**: `webhook`
- **Password**: `TD_webhook_2025_secure`

#### Social Media Director
- **URL**: `https://n8n.vividwalls.blog/webhook/social-media-director-webhook`
- **Username**: `webhook`
- **Password**: `SMD_webhook_2025_secure`

## How to Configure Webhooks in n8n

1. **Access n8n UI**: Go to https://n8n.vividwalls.blog

2. **For each webhook node in your workflows**:
   - Open the webhook node settings
   - Go to the "Authentication" tab
   - Select "Basic Auth" from the dropdown
   - Create new credentials with:
     - **Name**: `[Agent Name] Webhook Auth`
     - **Username**: `webhook`
     - **Password**: Use the appropriate password from the list above

3. **Environment Variables Available**:
   All webhook configurations are stored in `/root/vivid_mas/.env` and can be accessed as environment variables:
   - `BUSINESS_MANAGER_WEBHOOK_URL`
   - `BUSINESS_MANAGER_WEBHOOK_PASSWORD`
   - `[AGENT_NAME]_DIRECTOR_WEBHOOK_URL`
   - `[AGENT_NAME]_DIRECTOR_WEBHOOK_PASSWORD`
   - `N8N_WEBHOOK_AUTH_ENABLED=true`
   - `N8N_WEBHOOK_DEBUG=true`

## Testing Webhooks

To test a webhook with authentication:

```bash
curl -X POST https://n8n.vividwalls.blog/webhook/[webhook-path] \
  -u "webhook:[PASSWORD]" \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

Example for Business Manager:
```bash
curl -X POST https://n8n.vividwalls.blog/webhook/business-manager-webhook \
  -u "webhook:BM_webhook_2025_secure" \
  -H "Content-Type: application/json" \
  -d '{"action": "test", "message": "Testing webhook authentication"}'
```

## Security Notes

- All webhook passwords are unique per agent
- Basic authentication is enabled globally
- Debug mode is enabled for troubleshooting
- Passwords should be rotated periodically
- Store credentials securely in n8n's credential system

## Verification Commands

SSH into droplet and run:
```bash
# Check API key configuration
cat /opt/mcp-servers/n8n-mcp-server/.env

# Count webhook configurations
grep -c WEBHOOK /root/vivid_mas/.env

# List all director webhooks
grep DIRECTOR_WEBHOOK_URL /root/vivid_mas/.env | cut -d= -f1
```