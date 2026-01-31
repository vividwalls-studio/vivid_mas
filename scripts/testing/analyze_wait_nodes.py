#!/usr/bin/env python3
"""
Analyze n8n workflows for wait nodes and user interaction requirements.
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Tuple

# Base directory for workflows
WORKFLOW_DIR = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows")

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

def analyze_workflow_for_wait_nodes(workflow_path: Path) -> Dict:
    """
    Analyze a workflow for wait nodes and user interaction requirements.
    """
    try:
        with open(workflow_path, 'r') as f:
            data = json.load(f)
        
        workflow_name = data.get('name', workflow_path.stem)
        wait_nodes = []
        webhook_nodes = []
        manual_trigger_nodes = []
        form_nodes = []
        
        # Search for different types of user interaction nodes
        for node in data.get('nodes', []):
            node_type = node.get('type', '')
            node_name = node.get('name', 'Unnamed')
            node_id = node.get('id', '')
            
            # Wait nodes
            if 'wait' in node_type.lower():
                wait_info = {
                    'name': node_name,
                    'type': node_type,
                    'id': node_id,
                    'parameters': node.get('parameters', {})
                }
                
                # Check for wait conditions
                if 'resumeOnWebhook' in str(node.get('parameters', {})):
                    wait_info['wait_type'] = 'webhook'
                elif 'timeUnit' in node.get('parameters', {}):
                    wait_info['wait_type'] = 'timer'
                else:
                    wait_info['wait_type'] = 'unknown'
                
                # Check for approval patterns
                notes = node.get('notes', '')
                if 'approval' in notes.lower() or 'approval' in node_name.lower():
                    wait_info['requires_approval'] = True
                    wait_info['approval_notes'] = notes
                else:
                    wait_info['requires_approval'] = False
                
                wait_nodes.append(wait_info)
            
            # Webhook nodes (potential user interaction points)
            elif 'webhook' in node_type.lower():
                webhook_info = {
                    'name': node_name,
                    'type': node_type,
                    'path': node.get('parameters', {}).get('path', ''),
                    'method': node.get('parameters', {}).get('httpMethod', 'GET')
                }
                webhook_nodes.append(webhook_info)
            
            # Manual trigger nodes
            elif 'manualTrigger' in node_type or 'manual' in node_type.lower():
                manual_trigger_nodes.append({
                    'name': node_name,
                    'type': node_type
                })
            
            # Form nodes
            elif 'form' in node_type.lower():
                form_nodes.append({
                    'name': node_name,
                    'type': node_type,
                    'fields': node.get('parameters', {}).get('formFields', {})
                })
        
        return {
            'workflow_name': workflow_name,
            'workflow_path': str(workflow_path),
            'wait_nodes': wait_nodes,
            'webhook_nodes': webhook_nodes,
            'manual_trigger_nodes': manual_trigger_nodes,
            'form_nodes': form_nodes,
            'has_user_interaction': bool(wait_nodes or manual_trigger_nodes or form_nodes),
            'requires_approval': any(node.get('requires_approval', False) for node in wait_nodes)
        }
        
    except json.JSONDecodeError as e:
        return {
            'workflow_name': workflow_path.stem,
            'workflow_path': str(workflow_path),
            'error': f"JSON decode error: {e}"
        }
    except Exception as e:
        return {
            'workflow_name': workflow_path.stem,
            'workflow_path': str(workflow_path),
            'error': f"Error: {e}"
        }

def main():
    """Main analysis function."""
    print("🔍 Analyzing Wait Nodes and User Interactions in n8n Workflows")
    print("=" * 70)
    
    # Find all workflow files
    workflow_files = find_workflow_files()
    print(f"Found {len(workflow_files)} workflow files to analyze\n")
    
    # Analyze each workflow
    workflows_with_wait = []
    workflows_with_approval = []
    all_wait_nodes = []
    
    for workflow_path in workflow_files:
        analysis = analyze_workflow_for_wait_nodes(workflow_path)
        
        if 'error' not in analysis:
            if analysis['wait_nodes']:
                workflows_with_wait.append(analysis)
                all_wait_nodes.extend(analysis['wait_nodes'])
            
            if analysis['requires_approval']:
                workflows_with_approval.append(analysis)
    
    # Generate report
    print(f"📊 Analysis Summary:")
    print(f"  Total workflows: {len(workflow_files)}")
    print(f"  Workflows with wait nodes: {len(workflows_with_wait)}")
    print(f"  Workflows requiring approval: {len(workflows_with_approval)}")
    print(f"  Total wait nodes found: {len(all_wait_nodes)}")
    
    # Categorize wait nodes
    webhook_waits = [n for n in all_wait_nodes if n.get('wait_type') == 'webhook']
    timer_waits = [n for n in all_wait_nodes if n.get('wait_type') == 'timer']
    approval_waits = [n for n in all_wait_nodes if n.get('requires_approval')]
    
    print(f"\n📌 Wait Node Types:")
    print(f"  Webhook-based waits: {len(webhook_waits)}")
    print(f"  Timer-based waits: {len(timer_waits)}")
    print(f"  Approval required: {len(approval_waits)}")
    
    # List workflows with approval requirements
    if workflows_with_approval:
        print(f"\n⚠️  Workflows Requiring User Approval ({len(workflows_with_approval)}):")
        for workflow in workflows_with_approval:
            print(f"\n  📁 {workflow['workflow_name']}")
            for node in workflow['wait_nodes']:
                if node.get('requires_approval'):
                    print(f"     - Wait Node: {node['name']}")
                    if 'approval_notes' in node:
                        print(f"       Notes: {node['approval_notes']}")
    
    # List all workflows with wait nodes for detailed review
    if workflows_with_wait:
        print(f"\n📝 All Workflows with Wait Nodes ({len(workflows_with_wait)}):")
        for workflow in sorted(workflows_with_wait, key=lambda x: x['workflow_name']):
            print(f"\n  {workflow['workflow_name']}")
            print(f"    Path: {Path(workflow['workflow_path']).relative_to(WORKFLOW_DIR)}")
            print(f"    Wait nodes: {len(workflow['wait_nodes'])}")
            for node in workflow['wait_nodes']:
                print(f"      - {node['name']} ({node['wait_type']})")
    
    # Generate detailed JSON report
    report = {
        'summary': {
            'total_workflows': len(workflow_files),
            'workflows_with_wait': len(workflows_with_wait),
            'workflows_with_approval': len(workflows_with_approval),
            'total_wait_nodes': len(all_wait_nodes),
            'webhook_waits': len(webhook_waits),
            'timer_waits': len(timer_waits),
            'approval_waits': len(approval_waits)
        },
        'workflows_requiring_approval': [
            {
                'name': w['workflow_name'],
                'path': str(Path(w['workflow_path']).relative_to(WORKFLOW_DIR)),
                'wait_nodes': [n for n in w['wait_nodes'] if n.get('requires_approval')]
            }
            for w in workflows_with_approval
        ],
        'all_workflows_with_wait': [
            {
                'name': w['workflow_name'],
                'path': str(Path(w['workflow_path']).relative_to(WORKFLOW_DIR)),
                'wait_count': len(w['wait_nodes']),
                'wait_types': list(set(n.get('wait_type', 'unknown') for n in w['wait_nodes']))
            }
            for w in workflows_with_wait
        ]
    }
    
    # Save report
    report_path = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/WAIT_NODES_ANALYSIS.json")
    with open(report_path, 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"\n💾 Detailed report saved to: {report_path}")
    
    return len(workflows_with_approval)

if __name__ == "__main__":
    exit(0 if main() == 0 else 1)