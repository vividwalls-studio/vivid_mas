#!/usr/bin/env python3
"""
N8N Workflow Inventory and Analysis Script
Analyzes all n8n workflow JSON files in the services/agents directory
"""

import json
import os
import hashlib
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional
from collections import defaultdict

class WorkflowAnalyzer:
    def __init__(self, base_path: str):
        self.base_path = Path(base_path)
        self.workflows = []
        self.errors = []
        self.duplicates = defaultdict(list)
        
    def analyze_workflows(self, json_files: List[str]) -> Dict[str, Any]:
        """Analyze all workflow files and generate inventory"""
        scan_date = datetime.now().isoformat()
        total_files = len(json_files)
        valid_workflows = 0
        invalid_files = 0
        
        # Process files in batches
        batch_size = 10
        for i in range(0, len(json_files), batch_size):
            batch = json_files[i:i + batch_size]
            for file_path in batch:
                workflow_data = self._analyze_single_workflow(file_path)
                if workflow_data:
                    if workflow_data['validation_status'] == 'valid':
                        valid_workflows += 1
                    else:
                        invalid_files += 1
                    self.workflows.append(workflow_data)
                else:
                    invalid_files += 1
                    
        # Detect duplicates
        self._detect_duplicates()
        
        # Create inventory
        inventory = {
            'workflow_inventory': {
                'metadata': {
                    'scan_date': scan_date,
                    'total_files': total_files,
                    'valid_workflows': valid_workflows,
                    'invalid_files': invalid_files
                },
                'workflows': self.workflows,
                'validation_summary': self._get_validation_summary(),
                'duplicate_analysis': self._get_duplicate_summary()
            }
        }
        
        return inventory
    
    def _analyze_single_workflow(self, file_path: str) -> Optional[Dict[str, Any]]:
        """Analyze a single workflow file"""
        try:
            path = Path(file_path)
            file_stats = path.stat()
            
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Parse JSON
            try:
                workflow = json.loads(content)
                validation_status = 'valid'
                errors = []
            except json.JSONDecodeError as e:
                validation_status = 'invalid'
                errors = [f"JSON parse error: {str(e)}"]
                workflow = {}
                
            # Extract metadata
            workflow_data = {
                'file_path': str(path),
                'file_name': path.name,
                'file_size': file_stats.st_size,
                'last_modified': datetime.fromtimestamp(file_stats.st_mtime).isoformat(),
                'validation_status': validation_status,
                'errors': errors
            }
            
            # If valid JSON, extract n8n specific data
            if validation_status == 'valid':
                workflow_data.update(self._extract_n8n_metadata(workflow, content))
                
            return workflow_data
            
        except Exception as e:
            self.errors.append({
                'file': file_path,
                'error': str(e)
            })
            return None
            
    def _extract_n8n_metadata(self, workflow: Dict, content: str) -> Dict[str, Any]:
        """Extract n8n specific metadata from workflow"""
        metadata = {
            'id': workflow.get('id', 'no_id'),
            'name': workflow.get('name', 'unnamed'),
            'description': self._extract_description(workflow),
            'node_count': len(workflow.get('nodes', [])),
            'node_types': self._extract_node_types(workflow),
            'has_trigger': self._has_trigger_node(workflow),
            'has_error_handling': self._has_error_handling(workflow),
            'uses_credentials': self._uses_credentials(workflow),
            'connections_count': self._count_connections(workflow),
            'fingerprint': self._generate_fingerprint(workflow),
            'workflow_type': self._determine_workflow_type(workflow)
        }
        
        # Validate n8n schema
        schema_errors = self._validate_n8n_schema(workflow)
        if schema_errors:
            metadata['schema_violations'] = schema_errors
            
        return metadata
        
    def _extract_description(self, workflow: Dict) -> str:
        """Extract description from workflow or nodes"""
        # Check main workflow description
        if 'description' in workflow:
            return workflow['description']
            
        # Check for description in meta
        if 'meta' in workflow and 'description' in workflow['meta']:
            return workflow['meta']['description']
            
        # Check first node description
        nodes = workflow.get('nodes', [])
        if nodes and 'notes' in nodes[0]:
            return nodes[0]['notes'][:200] + '...' if len(nodes[0]['notes']) > 200 else nodes[0]['notes']
            
        return 'No description found'
        
    def _extract_node_types(self, workflow: Dict) -> List[str]:
        """Extract unique node types from workflow"""
        node_types = set()
        for node in workflow.get('nodes', []):
            node_type = node.get('type', 'unknown')
            node_types.add(node_type)
        return sorted(list(node_types))
        
    def _has_trigger_node(self, workflow: Dict) -> bool:
        """Check if workflow has a trigger node"""
        for node in workflow.get('nodes', []):
            if 'trigger' in node.get('type', '').lower():
                return True
        return False
        
    def _has_error_handling(self, workflow: Dict) -> bool:
        """Check if workflow has error handling"""
        for node in workflow.get('nodes', []):
            # Check for error trigger
            if node.get('type') == 'n8n-nodes-base.errorTrigger':
                return True
            # Check for continue on fail
            if node.get('continueOnFail', False):
                return True
            # Check parameters
            params = node.get('parameters', {})
            if params.get('continueOnFail', False):
                return True
        return False
        
    def _uses_credentials(self, workflow: Dict) -> List[str]:
        """List credentials used in workflow"""
        credentials = set()
        for node in workflow.get('nodes', []):
            if 'credentials' in node:
                for cred_type, cred_data in node['credentials'].items():
                    credentials.add(cred_type)
        return sorted(list(credentials))
        
    def _count_connections(self, workflow: Dict) -> int:
        """Count total connections in workflow"""
        connections = workflow.get('connections', {})
        count = 0
        for node_connections in connections.values():
            for output_type in node_connections.values():
                if isinstance(output_type, list):
                    count += len(output_type)
        return count
        
    def _generate_fingerprint(self, workflow: Dict) -> str:
        """Generate a fingerprint for duplicate detection"""
        # Create a normalized structure for comparison
        normalized = {
            'nodes': sorted([{
                'type': node.get('type'),
                'position': node.get('position', [0, 0])
            } for node in workflow.get('nodes', [])], key=lambda x: x['type']),
            'connections': workflow.get('connections', {})
        }
        
        # Generate hash
        json_str = json.dumps(normalized, sort_keys=True)
        return hashlib.md5(json_str.encode()).hexdigest()
        
    def _determine_workflow_type(self, workflow: Dict) -> str:
        """Determine the type of workflow"""
        nodes = workflow.get('nodes', [])
        node_types = [node.get('type', '') for node in nodes]
        
        # Check for AI agent nodes
        ai_nodes = ['@n8n/n8n-nodes-langchain.agent', 'n8n-nodes-base.openAi', 
                    '@n8n/n8n-nodes-langchain.openAi', 'n8n-nodes-base.googleAi']
        has_ai = any(node_type in ai_nodes for node_type in node_types)
        
        # Check for workflow tools
        has_workflow_tool = any('workflowtool' in node_type.lower() for node_type in node_types)
        
        # Count AI nodes
        ai_count = sum(1 for node_type in node_types if any(ai in node_type for ai in ai_nodes))
        
        if ai_count > 1:
            return 'Multi-Agent Workflow'
        elif has_ai and has_workflow_tool:
            return 'Workflow Tool'
        elif has_ai:
            return 'Agent Workflow'
        else:
            return 'Regular Workflow'
            
    def _validate_n8n_schema(self, workflow: Dict) -> List[str]:
        """Validate workflow against n8n schema requirements"""
        errors = []
        
        # Required fields
        required_fields = ['nodes', 'connections']
        for field in required_fields:
            if field not in workflow:
                errors.append(f"Missing required field: {field}")
                
        # Validate nodes
        if 'nodes' in workflow:
            if not isinstance(workflow['nodes'], list):
                errors.append("'nodes' must be an array")
            else:
                for i, node in enumerate(workflow['nodes']):
                    node_errors = self._validate_node(node, i)
                    errors.extend(node_errors)
                    
        # Validate connections
        if 'connections' in workflow:
            if not isinstance(workflow['connections'], dict):
                errors.append("'connections' must be an object")
                
        return errors
        
    def _validate_node(self, node: Dict, index: int) -> List[str]:
        """Validate individual node"""
        errors = []
        required_node_fields = ['id', 'name', 'type', 'position']
        
        for field in required_node_fields:
            if field not in node:
                errors.append(f"Node {index}: Missing required field '{field}'")
                
        # Validate position
        if 'position' in node:
            if not isinstance(node['position'], list) or len(node['position']) != 2:
                errors.append(f"Node {index}: 'position' must be [x, y] array")
                
        return errors
        
    def _detect_duplicates(self):
        """Detect duplicate workflows based on fingerprints"""
        fingerprint_map = defaultdict(list)
        
        for workflow in self.workflows:
            if 'fingerprint' in workflow:
                fingerprint_map[workflow['fingerprint']].append(workflow['file_path'])
                
        # Find duplicates
        for fingerprint, files in fingerprint_map.items():
            if len(files) > 1:
                self.duplicates[fingerprint] = files
                
    def _get_validation_summary(self) -> Dict[str, int]:
        """Get summary of validation issues"""
        summary = {
            'syntax_errors': 0,
            'schema_violations': 0,
            'missing_required_fields': 0,
            'total_errors': 0
        }
        
        for workflow in self.workflows:
            if workflow['validation_status'] == 'invalid':
                summary['syntax_errors'] += 1
            if 'schema_violations' in workflow:
                summary['schema_violations'] += len(workflow['schema_violations'])
            summary['total_errors'] += len(workflow.get('errors', []))
            
        return summary
        
    def _get_duplicate_summary(self) -> Dict[str, Any]:
        """Get summary of duplicate workflows"""
        return {
            'total_duplicate_groups': len(self.duplicates),
            'total_duplicate_files': sum(len(files) - 1 for files in self.duplicates.values()),
            'duplicate_groups': [
                {
                    'fingerprint': fp,
                    'files': files,
                    'count': len(files)
                }
                for fp, files in self.duplicates.items()
            ]
        }
        
    def save_inventory(self, inventory: Dict[str, Any], output_file: str):
        """Save inventory to JSON file"""
        with open(output_file, 'w') as f:
            json.dump(inventory, f, indent=2)
            
    def get_sample_workflows(self, count: int = 3) -> List[Dict[str, Any]]:
        """Get sample workflows with full details"""
        samples = []
        valid_workflows = [w for w in self.workflows if w['validation_status'] == 'valid']
        
        for workflow in valid_workflows[:count]:
            try:
                with open(workflow['file_path'], 'r') as f:
                    full_workflow = json.load(f)
                    samples.append({
                        'metadata': workflow,
                        'full_workflow': full_workflow
                    })
            except:
                pass
                
        return samples


def main():
    # Get list of JSON files
    base_path = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents"
    
    # Read file list from previous command
    json_files = []
    with open('/tmp/n8n_workflow_files.txt', 'w') as f:
        import subprocess
        result = subprocess.run(
            ['find', base_path, '-name', '*.json', '-type', 'f'],
            capture_output=True, text=True
        )
        for line in result.stdout.strip().split('\n'):
            if line and not any(x in line for x in ['archive', 'venv', 'test', 'coverage', 'import-templates', 'prompts']):
                json_files.append(line)
                f.write(line + '\n')
    
    # Analyze workflows
    analyzer = WorkflowAnalyzer(base_path)
    inventory = analyzer.analyze_workflows(json_files)
    
    # Save inventory
    output_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_workflow_inventory.json'
    analyzer.save_inventory(inventory, output_file)
    
    # Save sample workflows
    samples = analyzer.get_sample_workflows(3)
    with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_workflow_samples.json', 'w') as f:
        json.dump(samples, f, indent=2)
    
    print(f"Workflow inventory saved to: {output_file}")
    print(f"Found {inventory['workflow_inventory']['metadata']['total_files']} files")
    print(f"Valid workflows: {inventory['workflow_inventory']['metadata']['valid_workflows']}")
    print(f"Invalid files: {inventory['workflow_inventory']['metadata']['invalid_files']}")
    

if __name__ == "__main__":
    main()