#!/usr/bin/env python3
"""
Verify that all webhook naming follows the semantic role-based convention.
"""

import json
import os
from pathlib import Path
from typing import List, Tuple

# Base directory for workflows
WORKFLOW_DIR = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows")

# Pattern for valid webhook paths
VALID_PATTERN = r'^/webhook/[a-z-]+-agent$'

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

def check_webhook_naming(workflow_path: Path) -> Tuple[str, str, bool]:
    """
    Check if webhook path follows the naming convention.
    Returns: (filename, webhook_path, is_valid)
    """
    try:
        with open(workflow_path, 'r') as f:
            data = json.load(f)
        
        # Search for webhook nodes
        if 'nodes' in data:
            for node in data.get('nodes', []):
                # Check for webhook trigger nodes
                if node.get('type') == 'n8n-nodes-base.webhook':
                    params = node.get('parameters', {})
                    webhook_path = params.get('path', '')
                    
                    if webhook_path:
                        # Check if it's an agent webhook (not integration webhook)
                        if 'agent' in webhook_path or 'Agent' in data.get('name', ''):
                            # Validate naming convention
                            is_valid = (
                                webhook_path.startswith('/webhook/') and
                                webhook_path.endswith('-agent')
                            )
                            return workflow_path.name, webhook_path, is_valid
        
        return workflow_path.name, "", None
        
    except json.JSONDecodeError:
        return workflow_path.name, "ERROR: Invalid JSON", False
    except Exception as e:
        return workflow_path.name, f"ERROR: {e}", False

def main():
    """Main verification function."""
    print("🔍 Verifying Webhook Naming Convention")
    print("=" * 50)
    
    # Find all workflow files
    workflow_files = find_workflow_files()
    print(f"Found {len(workflow_files)} workflow files to verify\n")
    
    # Track results
    valid_count = 0
    invalid_count = 0
    non_agent_count = 0
    issues = []
    
    print("Checking agent workflows...\n")
    
    # Check each workflow
    for workflow_path in sorted(workflow_files):
        filename, webhook_path, is_valid = check_webhook_naming(workflow_path)
        
        if is_valid is None:
            # Not an agent workflow or no webhook
            non_agent_count += 1
        elif is_valid:
            valid_count += 1
            print(f"✅ {filename:<50} {webhook_path}")
        else:
            invalid_count += 1
            issues.append((filename, webhook_path))
            print(f"❌ {filename:<50} {webhook_path}")
    
    print("\n" + "=" * 50)
    print("📊 Verification Summary:")
    print(f"  ✅ Valid agent webhooks: {valid_count}")
    print(f"  ❌ Invalid agent webhooks: {invalid_count}")
    print(f"  ⚪ Non-agent/integration workflows: {non_agent_count}")
    print(f"  📁 Total workflows checked: {len(workflow_files)}")
    
    if issues:
        print("\n⚠️  Issues Found:")
        for filename, webhook_path in issues:
            print(f"  - {filename}: {webhook_path}")
        print("\n❗ Some webhooks still don't follow the convention!")
        return 1
    else:
        print("\n✨ All agent webhooks follow the semantic role-based naming convention!")
        print("   Pattern: /webhook/{department}-{role}-agent")
        return 0

if __name__ == "__main__":
    exit(main())