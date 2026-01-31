#!/usr/bin/env python3
"""Fix common issues in n8n workflows."""

import json
import uuid
from pathlib import Path
import re

def fix_workflow_id(data):
    """Fix missing or invalid workflow IDs."""
    if not data.get('id') or data.get('id') == 'no_id':
        # Generate a proper ID based on workflow name
        name = data.get('name', 'unnamed')
        base_id = re.sub(r'[^\w-]', '-', name.lower()).strip('-')
        data['id'] = f"{base_id}-{str(uuid.uuid4())[:8]}"
    return data

def fix_node_names(data):
    """Fix missing node names."""
    if 'nodes' in data and isinstance(data['nodes'], list):
        for node in data['nodes']:
            if not node.get('name'):
                # Generate name based on type and ID
                node_type = node.get('type', 'unknown').split('.')[-1]
                node_id = node.get('id', str(uuid.uuid4())[:8])
                node['name'] = f"{node_type}_{node_id}"
    return data

def fix_workflow_name(data):
    """Fix missing workflow names."""
    if not data.get('name'):
        # Try to infer from filename or use generic name
        data['name'] = 'Unnamed Workflow'
    return data

def fix_node_references(data):
    """Fix connection references to non-existent nodes."""
    if 'nodes' not in data or 'connections' not in data:
        return data
    
    # Build a map of node names
    node_names = {node.get('name') for node in data['nodes'] if node.get('name')}
    
    # Check and fix connections
    fixed_connections = {}
    for source_name, targets in data.get('connections', {}).items():
        if source_name in node_names:
            fixed_connections[source_name] = targets
            # Note: We could also check target references but that's more complex
    
    data['connections'] = fixed_connections
    return data

def add_missing_credentials(data):
    """Add placeholder for missing credentials."""
    if 'nodes' in data and isinstance(data['nodes'], list):
        needs_creds = False
        for node in data['nodes']:
            node_type = node.get('type', '')
            # Common nodes that need credentials
            if any(cred_type in node_type for cred_type in ['supabase', 'telegram', 'httpRequest', 'mcp']):
                if 'credentials' not in node:
                    needs_creds = True
                    # Add placeholder
                    if 'supabase' in node_type:
                        node['credentials'] = {"supabaseApi": {"id": "supabase-creds", "name": "Supabase"}}
                    elif 'telegram' in node_type:
                        node['credentials'] = {"telegramApi": {"id": "telegram-creds", "name": "Telegram"}}
    
    return data

def fix_sticky_nodes(data):
    """Fix sticky note nodes that are missing names."""
    if 'nodes' in data and isinstance(data['nodes'], list):
        for node in data['nodes']:
            if node.get('id', '').startswith('sticky-') and not node.get('name'):
                # Extract meaningful name from ID
                name_part = node['id'].replace('sticky-', '').replace('-', ' ').title()
                node['name'] = f"Note: {name_part}"
            
            # Ensure sticky notes have proper type
            if node.get('id', '').startswith('sticky-') and not node.get('type'):
                node['type'] = 'n8n-nodes-base.stickyNote'
    
    return data

def fix_workflow_file(file_path, backup=True):
    """Fix issues in a workflow file."""
    print(f"Processing: {file_path.name}")
    
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
        
        # Create backup
        if backup:
            backup_path = file_path.with_suffix('.json.backup')
            with open(backup_path, 'w') as f:
                json.dump(data, f, indent=2)
        
        # Apply fixes
        original_issues = validate_basic_issues(data)
        
        data = fix_workflow_id(data)
        data = fix_workflow_name(data)
        data = fix_node_names(data)
        data = fix_sticky_nodes(data)
        data = fix_node_references(data)
        data = add_missing_credentials(data)
        
        # Add version if missing
        if 'versionId' not in data:
            data['versionId'] = f"v1-{str(uuid.uuid4())[:8]}"
        
        # Add settings if missing
        if 'settings' not in data:
            data['settings'] = {"executionOrder": "v1"}
        
        # Check if fixes helped
        new_issues = validate_basic_issues(data)
        
        if len(new_issues) < len(original_issues):
            # Save fixed version
            with open(file_path, 'w') as f:
                json.dump(data, f, indent=2)
            
            print(f"  ✅ Fixed {len(original_issues) - len(new_issues)} issues")
            if new_issues:
                print(f"  ⚠️  {len(new_issues)} issues remain")
        else:
            print(f"  ℹ️  No automatic fixes applied")
        
        return True
        
    except json.JSONDecodeError as e:
        print(f"  ❌ Invalid JSON: {e}")
        return False
    except Exception as e:
        print(f"  ❌ Error: {e}")
        return False

def validate_basic_issues(data):
    """Quick validation to count issues."""
    issues = []
    
    if not data.get('id') or data.get('id') == 'no_id':
        issues.append("Missing ID")
    
    if not data.get('name'):
        issues.append("Missing name")
    
    if 'nodes' in data:
        for node in data['nodes']:
            if not node.get('name'):
                issues.append(f"Node missing name: {node.get('id')}")
            if not node.get('type'):
                issues.append(f"Node missing type: {node.get('id')}")
    
    return issues

def main():
    """Fix issues in all workflows."""
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows")
    
    print("Fixing Workflow Issues")
    print("=" * 80)
    
    # Find all JSON files (excluding archive and configs)
    workflow_files = []
    for json_file in base_dir.rglob("*.json"):
        if "archive" not in str(json_file) and json_file.name != "knowledge_gatherer_configs.json":
            workflow_files.append(json_file)
    
    fixed_count = 0
    error_count = 0
    
    for workflow_file in sorted(workflow_files):
        if fix_workflow_file(workflow_file):
            fixed_count += 1
        else:
            error_count += 1
    
    print("\n" + "=" * 80)
    print(f"Processed {len(workflow_files)} workflows")
    print(f"Successfully processed: {fixed_count}")
    print(f"Errors: {error_count}")
    
    # Special handling for problem files
    print("\nSpecial Cases:")
    
    # Fix stakeholder_business_marketing_directives.json
    problem_file = base_dir / "core/orchestration/stakeholder_business_marketing_directives.json"
    if problem_file.exists():
        print(f"\nFixing {problem_file.name} (list instead of dict issue)")
        try:
            with open(problem_file, 'r') as f:
                content = f.read()
            
            # If it's a list, wrap it in a workflow structure
            data = json.loads(content)
            if isinstance(data, list):
                workflow = {
                    "name": "Stakeholder Business Marketing Directives",
                    "nodes": data if all(isinstance(item, dict) for item in data) else [],
                    "connections": {},
                    "id": "stakeholder-directives-" + str(uuid.uuid4())[:8],
                    "versionId": "v1",
                    "settings": {"executionOrder": "v1"}
                }
                
                with open(problem_file, 'w') as f:
                    json.dump(workflow, f, indent=2)
                
                print("  ✅ Fixed list/dict structure issue")
        except Exception as e:
            print(f"  ❌ Could not fix: {e}")

if __name__ == "__main__":
    main()