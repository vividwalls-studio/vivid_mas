#!/usr/bin/env python3
"""Validate all n8n workflows for JSON validity and completeness."""

import json
from pathlib import Path
from collections import defaultdict
import uuid

def validate_workflow(file_path):
    """Validate a single workflow file."""
    issues = []
    
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
        
        # Basic structure checks
        if not data.get('name'):
            issues.append("Missing workflow name")
        
        if not data.get('nodes'):
            issues.append("No nodes defined")
        elif not isinstance(data['nodes'], list):
            issues.append("Nodes must be a list")
        else:
            # Node validation
            node_ids = set()
            for i, node in enumerate(data['nodes']):
                if not node.get('id'):
                    issues.append(f"Node {i} missing ID")
                else:
                    if node['id'] in node_ids:
                        issues.append(f"Duplicate node ID: {node['id']}")
                    node_ids.add(node['id'])
                
                if not node.get('type'):
                    issues.append(f"Node {node.get('id', i)} missing type")
                
                if not node.get('name'):
                    issues.append(f"Node {node.get('id', i)} missing name")
        
        # Connection validation
        if 'connections' in data and data['nodes']:
            connections = data.get('connections', {})
            
            # Check if all connection nodes exist
            for source_node, targets in connections.items():
                if not any(n.get('name') == source_node for n in data['nodes']):
                    issues.append(f"Connection source '{source_node}' not found in nodes")
                
                if isinstance(targets, dict):
                    for output_type, target_list in targets.items():
                        if isinstance(target_list, list):
                            for targets_array in target_list:
                                if isinstance(targets_array, list):
                                    for target in targets_array:
                                        if isinstance(target, dict) and 'node' in target:
                                            if not any(n.get('name') == target['node'] for n in data['nodes']):
                                                issues.append(f"Connection target '{target['node']}' not found")
        
        # Workflow metadata
        if not data.get('id') or data.get('id') == 'no_id':
            issues.append("Missing or invalid workflow ID")
        
        # Check for credentials
        has_credentials = False
        for node in data.get('nodes', []):
            if 'credentials' in node:
                has_credentials = True
                break
        
        if not has_credentials and len(data.get('nodes', [])) > 2:
            issues.append("No credentials configured (might need configuration)")
        
        return {
            'valid': len(issues) == 0,
            'issues': issues,
            'node_count': len(data.get('nodes', [])),
            'has_connections': bool(data.get('connections')),
            'workflow_id': data.get('id'),
            'active': data.get('active', False)
        }
        
    except json.JSONDecodeError as e:
        return {
            'valid': False,
            'issues': [f"Invalid JSON: {str(e)}"],
            'node_count': 0,
            'has_connections': False,
            'workflow_id': None,
            'active': False
        }
    except Exception as e:
        return {
            'valid': False,
            'issues': [f"Error reading file: {str(e)}"],
            'node_count': 0,
            'has_connections': False,
            'workflow_id': None,
            'active': False
        }

def validate_all_workflows():
    """Validate all workflows in the organized structure."""
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows")
    
    results = defaultdict(list)
    summary = {
        'total': 0,
        'valid': 0,
        'invalid': 0,
        'warnings': 0,
        'active': 0
    }
    
    print("Validating All Workflows")
    print("=" * 80)
    
    # Find all JSON files (excluding archive)
    workflow_files = []
    for json_file in base_dir.rglob("*.json"):
        if "archive" not in str(json_file):
            workflow_files.append(json_file)
    
    # Validate each workflow
    for workflow_file in sorted(workflow_files):
        relative_path = workflow_file.relative_to(base_dir)
        category = str(relative_path.parent)
        
        validation = validate_workflow(workflow_file)
        
        results[category].append({
            'file': workflow_file.name,
            'validation': validation
        })
        
        summary['total'] += 1
        if validation['valid']:
            summary['valid'] += 1
        else:
            summary['invalid'] += 1
        
        if validation['issues'] and validation['valid']:
            summary['warnings'] += 1
        
        if validation['active']:
            summary['active'] += 1
    
    # Display results by category
    for category, workflows in sorted(results.items()):
        print(f"\n{category.upper()}")
        print("-" * len(category))
        
        for workflow in workflows:
            status = "✅" if workflow['validation']['valid'] else "❌"
            active = "🟢" if workflow['validation']['active'] else "⚪"
            nodes = workflow['validation']['node_count']
            
            print(f"{status} {active} {workflow['file']} ({nodes} nodes)")
            
            if workflow['validation']['issues']:
                for issue in workflow['validation']['issues']:
                    print(f"     ⚠️  {issue}")
    
    # Summary
    print("\n" + "=" * 80)
    print("VALIDATION SUMMARY")
    print(f"Total workflows: {summary['total']}")
    print(f"Valid: {summary['valid']} ({summary['valid']/summary['total']*100:.1f}%)")
    print(f"Invalid: {summary['invalid']}")
    print(f"Warnings: {summary['warnings']}")
    print(f"Active: {summary['active']}")
    
    # Generate fix recommendations
    if summary['invalid'] > 0:
        print("\nRECOMMENDED FIXES:")
        print("1. Check invalid JSON files for syntax errors")
        print("2. Ensure all workflows have unique IDs")
        print("3. Verify node connections reference existing nodes")
        print("4. Add missing workflow names and descriptions")
    
    return summary

def generate_workflow_registry():
    """Generate a registry of all workflows with their locations."""
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows")
    
    registry = {
        'workflows': {},
        'categories': defaultdict(list)
    }
    
    for json_file in base_dir.rglob("*.json"):
        if "archive" not in str(json_file):
            try:
                with open(json_file, 'r') as f:
                    data = json.load(f)
                
                workflow_id = data.get('id', str(uuid.uuid4()))
                relative_path = json_file.relative_to(base_dir)
                category = str(relative_path.parent)
                
                registry['workflows'][workflow_id] = {
                    'name': data.get('name', 'Unknown'),
                    'path': str(relative_path),
                    'category': category,
                    'active': data.get('active', False),
                    'node_count': len(data.get('nodes', []))
                }
                
                registry['categories'][category].append(workflow_id)
                
            except:
                pass
    
    # Save registry
    registry_file = base_dir / "workflow_registry.json"
    with open(registry_file, 'w') as f:
        json.dump(registry, f, indent=2)
    
    print(f"\nWorkflow registry saved to: {registry_file}")

if __name__ == "__main__":
    summary = validate_all_workflows()
    generate_workflow_registry()