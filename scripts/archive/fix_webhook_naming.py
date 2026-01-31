#!/usr/bin/env python3
"""
Fix webhook naming inconsistencies in n8n agent workflows.
Standardizes all webhook paths to use semantic role-based naming with -agent suffix.
"""

import json
import os
import re
from pathlib import Path
from typing import Dict, List, Tuple

# Base directory for workflows
WORKFLOW_DIR = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows")

# Mapping of current webhook paths to corrected ones
WEBHOOK_FIXES = {
    # Director Level
    "/webhook/analyticsdirector-approval": "/webhook/analytics-director-agent",
    "/webhook/salesdirector-approval": "/webhook/sales-director-agent",
    
    # Finance Department
    "/webhook/accounting-approval": "/webhook/accounting-agent",
    "/webhook/budgeting-approval": "/webhook/budgeting-agent",
    "/webhook/financialplanning-approval": "/webhook/financial-planning-agent",
    
    # Sales Department
    "/webhook/accountmanagement-approval": "/webhook/account-management-agent",
    "/webhook/corporatesales-approval": "/webhook/corporate-sales-agent",
    "/webhook/educationalsales-approval": "/webhook/educational-sales-agent",
    "/webhook/governmentsales-approval": "/webhook/government-sales-agent",
    "/webhook/healthcaresales-approval": "/webhook/healthcare-sales-agent",
    "/webhook/hospitalitysales-approval": "/webhook/hospitality-sales-agent",
    "/webhook/leadgeneration-approval": "/webhook/lead-generation-agent",
    "/webhook/partnershipdevelopment-approval": "/webhook/partnership-development-agent",
    "/webhook/realestatesales-approval": "/webhook/real-estate-sales-agent",
    "/webhook/residentialsales-approval": "/webhook/residential-sales-agent",
    "/webhook/retailsales-approval": "/webhook/retail-sales-agent",
    "/webhook/salesanalytics-approval": "/webhook/sales-analytics-agent",
    
    # Customer Experience
    "/webhook/customerfeedback-approval": "/webhook/customer-feedback-agent",
    "/webhook/customerservice-approval": "/webhook/customer-service-agent",
    "/webhook/customersuccess-approval": "/webhook/customer-success-agent",
    "/webhook/livechat-approval": "/webhook/live-chat-agent",
    "/webhook/supportticket-approval": "/webhook/support-ticket-agent",
    
    # Operations
    "/webhook/inventorymanagement-approval": "/webhook/inventory-management-agent",
    "/webhook/logistics-approval": "/webhook/logistics-agent",
    "/webhook/qualitycontrol-approval": "/webhook/quality-control-agent",
    "/webhook/supplychain-approval": "/webhook/supply-chain-agent",
    "/webhook/vendormanagement-approval": "/webhook/vendor-management-agent",
    
    # Product
    "/webhook/catalogmanagement-approval": "/webhook/catalog-management-agent",
    "/webhook/productanalytics-approval": "/webhook/product-analytics-agent",
    "/webhook/productdevelopment-approval": "/webhook/product-development-agent",
    "/webhook/productresearch-approval": "/webhook/product-research-agent",
    
    # Marketing
    "/webhook/copywriter-approval": "/webhook/copywriter-agent",
    "/webhook/emailmarketing-approval": "/webhook/email-marketing-agent",
    "/webhook/keyword-approval": "/webhook/keyword-agent",
    "/webhook/newsletter-approval": "/webhook/newsletter-agent",
    
    # Social Media
    "/webhook/linkedin-approval": "/webhook/linkedin-agent",
    "/webhook/pinterest-approval": "/webhook/pinterest-agent",
    "/webhook/tiktok-approval": "/webhook/tiktok-agent",
    "/webhook/twitter-approval": "/webhook/twitter-agent",
    "/webhook/youtube-approval": "/webhook/youtube-agent",
    
    # Special Cases
    "/webhook/campaign-manager-agent---strategic-webhook": "/webhook/campaign-manager-agent",
    "campaign-finance-webhook": "/webhook/campaign-finance-agent",
    "/webhook/keyword-webhook": "/webhook/keyword-agent",
    "/webhook/product-director-webhook": "/webhook/product-director-agent",
    "/webhook/facebook-marketing-knowledge-gatherer-agent-webhook": "/webhook/facebook-marketing-agent",
    
    # Missing webhook prefix
    "/marketing-director-agent": "/webhook/marketing-director-agent",
    "/campaign-agent": "/webhook/campaign-agent",
    "/content-strategy-agent": "/webhook/content-strategy-agent",
    "/copy-editor-agent": "/webhook/copy-editor-agent",
    "/creative-director-agent": "/webhook/creative-director-agent",
    "/customer-experience-director-agent": "/webhook/customer-experience-director-agent",
    "/data-analytics-agent": "/webhook/data-analytics-agent",
    "/marketing-research-agent": "/webhook/marketing-research-agent",
    "/product-director-agent": "/webhook/product-director-agent",
    "/instagram-subagent": "/webhook/instagram-agent",
}

def find_workflow_files() -> List[Path]:
    """Find all JSON workflow files, excluding archives."""
    workflow_files = []
    for root, dirs, files in os.walk(WORKFLOW_DIR):
        # Skip archive directories
        if 'archive' in root:
            continue
        for file in files:
            if file.endswith('.json'):
                workflow_files.append(Path(root) / file)
    return workflow_files

def fix_webhook_in_workflow(workflow_path: Path) -> Tuple[bool, str, str]:
    """
    Fix webhook path in a workflow file.
    Returns: (was_modified, old_path, new_path)
    """
    try:
        with open(workflow_path, 'r') as f:
            content = f.read()
            data = json.loads(content)
        
        modified = False
        old_path = ""
        new_path = ""
        
        # Search for webhook nodes
        if 'nodes' in data:
            for node in data['nodes']:
                # Check for webhook trigger nodes
                if node.get('type') == 'n8n-nodes-base.webhook':
                    params = node.get('parameters', {})
                    current_path = params.get('path', '')
                    
                    # Check if this path needs fixing
                    if current_path in WEBHOOK_FIXES:
                        old_path = current_path
                        new_path = WEBHOOK_FIXES[current_path]
                        params['path'] = new_path
                        modified = True
                        print(f"  Fixing: {old_path} → {new_path}")
                    
                    # Also check for paths missing /webhook prefix
                    elif current_path and not current_path.startswith('/webhook/') and not current_path.startswith('webhook/'):
                        # Check if it's an agent path that should have /webhook prefix
                        if '-agent' in current_path or 'subagent' in current_path:
                            old_path = current_path
                            new_path = f"/webhook{current_path}" if current_path.startswith('/') else f"/webhook/{current_path}"
                            # Apply additional fixes if needed
                            if new_path in WEBHOOK_FIXES:
                                new_path = WEBHOOK_FIXES[new_path]
                            params['path'] = new_path
                            modified = True
                            print(f"  Fixing: {old_path} → {new_path}")
        
        if modified:
            # Write back the fixed workflow
            with open(workflow_path, 'w') as f:
                json.dump(data, f, indent=2)
            return True, old_path, new_path
        
        return False, "", ""
        
    except json.JSONDecodeError as e:
        print(f"  ⚠️  Error parsing JSON in {workflow_path}: {e}")
        return False, "", ""
    except Exception as e:
        print(f"  ⚠️  Error processing {workflow_path}: {e}")
        return False, "", ""

def generate_webhook_documentation(fixes: Dict[str, List[Tuple[str, str, str]]]) -> str:
    """Generate documentation of all webhook endpoints."""
    doc = ["# Agent Webhook Endpoints\n"]
    doc.append("## Standardized Webhook URLs for VividWalls MAS Agents\n")
    doc.append("All webhooks follow the pattern: `/webhook/{department}-{role}-agent`\n\n")
    
    # Organize by department
    departments = {
        'Directors': [],
        'Analytics': [],
        'Marketing': [],
        'Sales': [],
        'Customer Experience': [],
        'Finance': [],
        'Operations': [],
        'Product': [],
        'Social Media': [],
        'Integrations': []
    }
    
    for filepath, changes in fixes.items():
        filename = os.path.basename(filepath)
        for _, _, new_path in changes:
            if new_path and new_path != "":
                # Categorize by department
                if 'director' in new_path.lower():
                    departments['Directors'].append((filename, new_path))
                elif 'analytics' in new_path.lower() or 'data' in new_path.lower():
                    departments['Analytics'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['marketing', 'campaign', 'content', 'copy', 'keyword', 'newsletter', 'email-marketing']):
                    departments['Marketing'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['sales', 'lead-generation', 'partnership']):
                    departments['Sales'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['customer', 'support', 'chat']):
                    departments['Customer Experience'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['finance', 'accounting', 'budgeting']):
                    departments['Finance'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['inventory', 'logistics', 'quality', 'supply', 'vendor']):
                    departments['Operations'].append((filename, new_path))
                elif 'product' in new_path.lower() or 'catalog' in new_path.lower():
                    departments['Product'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['facebook', 'instagram', 'linkedin', 'pinterest', 'tiktok', 'twitter', 'youtube']):
                    departments['Social Media'].append((filename, new_path))
                elif any(x in new_path.lower() for x in ['supabase', 'twenty', 'sync']):
                    departments['Integrations'].append((filename, new_path))
    
    # Write documentation by department
    for dept, items in departments.items():
        if items:
            doc.append(f"### {dept}\n")
            for filename, webhook_path in sorted(set(items), key=lambda x: x[1]):
                agent_name = filename.replace('_workflow.json', '').replace('.json', '').replace('_', ' ').title()
                doc.append(f"- **{agent_name}**: `{webhook_path}`\n")
            doc.append("\n")
    
    return ''.join(doc)

def main():
    """Main execution function."""
    print("🔧 Fixing Webhook Naming Inconsistencies")
    print("=" * 50)
    
    # Find all workflow files
    workflow_files = find_workflow_files()
    print(f"Found {len(workflow_files)} workflow files to check\n")
    
    # Track changes
    total_fixed = 0
    fixes = {}
    
    # Process each workflow
    for workflow_path in workflow_files:
        relative_path = workflow_path.relative_to(WORKFLOW_DIR)
        print(f"Checking: {relative_path}")
        
        was_modified, old_path, new_path = fix_webhook_in_workflow(workflow_path)
        
        if was_modified:
            total_fixed += 1
            if str(workflow_path) not in fixes:
                fixes[str(workflow_path)] = []
            fixes[str(workflow_path)].append((was_modified, old_path, new_path))
    
    print("\n" + "=" * 50)
    print(f"✅ Fixed {total_fixed} workflow files")
    
    # Generate documentation
    if fixes:
        doc_content = generate_webhook_documentation(fixes)
        doc_path = WORKFLOW_DIR.parent / "AGENT_WEBHOOK_ENDPOINTS.md"
        with open(doc_path, 'w') as f:
            f.write(doc_content)
        print(f"📝 Generated webhook documentation: {doc_path}")
    
    # Create summary report
    summary = [
        "# Webhook Naming Fix Summary\n",
        f"## Total workflows processed: {len(workflow_files)}\n",
        f"## Total workflows fixed: {total_fixed}\n\n",
        "## Changes Made:\n"
    ]
    
    for filepath, changes in fixes.items():
        summary.append(f"### {Path(filepath).name}\n")
        for _, old, new in changes:
            summary.append(f"- `{old}` → `{new}`\n")
        summary.append("\n")
    
    summary_path = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/WEBHOOK_FIX_SUMMARY.md")
    with open(summary_path, 'w') as f:
        f.write(''.join(summary))
    
    print(f"📋 Summary report saved to: {summary_path}")
    print("\n✨ Webhook naming standardization complete!")

if __name__ == "__main__":
    main()