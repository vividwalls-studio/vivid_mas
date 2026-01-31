#!/usr/bin/env python3
"""
Fix n8n workflow update issues
- Handles 400 Bad Request errors (invalid workflow format)
- Handles 404 Not Found errors (workflow IDs don't exist)
- Properly formats workflows for n8n API updates
"""

import json
import requests
import sys
import os
from pathlib import Path
from typing import Dict, List, Optional, Any

# Configuration from environment
N8N_API_URL = os.getenv('N8N_API_URL', 'https://n8n.vividwalls.blog/api/v1')
N8N_API_KEY = os.getenv('N8N_API_KEY', '')

class WorkflowUpdateFixer:
    def __init__(self):
        if not N8N_API_KEY:
            print("❌ N8N_API_KEY environment variable not set!")
            print("   Please run: source .env")
            sys.exit(1)
            
        self.headers = {
            'X-N8N-API-KEY': N8N_API_KEY,
            'Content-Type': 'application/json'
        }
        self.existing_workflows = {}
        self.issues_found = []
        self.fixes_applied = []
        
    def get_all_workflows(self) -> List[Dict]:
        """Get all workflows from n8n"""
        try:
            response = requests.get(
                f"{N8N_API_URL}/workflows?limit=250",
                headers=self.headers
            )
            response.raise_for_status()
            workflows = response.json()['data']
            print(f"✅ Found {len(workflows)} workflows in n8n")
            
            # Create lookup by ID and name
            for wf in workflows:
                self.existing_workflows[wf['id']] = wf
                self.existing_workflows[wf['name']] = wf
                
            return workflows
        except Exception as e:
            print(f"❌ Error fetching workflows: {e}")
            return []
    
    def validate_workflow_format(self, workflow: Dict) -> List[str]:
        """Validate workflow format and return issues"""
        issues = []
        
        # Check required fields for update
        required_for_update = ['name', 'nodes', 'connections']
        for field in required_for_update:
            if field not in workflow:
                issues.append(f"Missing required field: {field}")
        
        # Check node format
        if 'nodes' in workflow:
            for node in workflow['nodes']:
                if 'type' not in node:
                    issues.append(f"Node missing type: {node.get('name', 'Unknown')}")
                if 'position' not in node:
                    issues.append(f"Node missing position: {node.get('name', 'Unknown')}")
                    
                # Check for unrecognized node types
                node_type = node.get('type', '')
                if 'mcpToolKit' in node_type:
                    issues.append(f"Unrecognized node type: {node_type} - MCP nodes may not be installed")
                if 'vectorStore' in node_type and 'Airtable' in node_type:
                    issues.append(f"Unrecognized node type: {node_type} - Vector store nodes may not be installed")
        
        # Check connections format
        if 'connections' in workflow and not isinstance(workflow['connections'], dict):
            issues.append("Connections must be a dictionary")
            
        return issues
    
    def fix_workflow_for_update(self, workflow: Dict) -> Dict:
        """Fix workflow format for n8n API update"""
        fixed = {}
        
        # Only include fields that can be updated
        updatable_fields = ['name', 'nodes', 'connections', 'settings', 'staticData', 'active', 'tags']
        
        for field in updatable_fields:
            if field in workflow:
                fixed[field] = workflow[field]
        
        # Remove read-only fields
        readonly_fields = ['id', 'createdAt', 'updatedAt', 'versionId', 'meta', 'pinData']
        for field in readonly_fields:
            if field in fixed:
                del fixed[field]
        
        # Fix node issues
        if 'nodes' in fixed:
            for node in fixed['nodes']:
                # Add default position if missing
                if 'position' not in node:
                    node['position'] = [0, 0]
                
                # Fix unrecognized node types
                if 'mcpToolKit' in node.get('type', ''):
                    print(f"⚠️  Warning: MCP node type '{node['type']}' may not be available")
                    # Could map to alternative node type here if needed
                    
        # Ensure connections is a dict
        if 'connections' in fixed and not isinstance(fixed['connections'], dict):
            fixed['connections'] = {}
            
        return fixed
    
    def update_workflow(self, workflow_id: str, workflow_data: Dict) -> bool:
        """Update a workflow via API"""
        try:
            # Prepare update data
            update_data = self.fix_workflow_for_update(workflow_data)
            
            response = requests.put(
                f"{N8N_API_URL}/workflows/{workflow_id}",
                headers=self.headers,
                json=update_data
            )
            
            if response.status_code == 200:
                print(f"✅ Successfully updated workflow: {workflow_id}")
                return True
            elif response.status_code == 400:
                print(f"❌ 400 Bad Request for workflow {workflow_id}")
                print(f"   Response: {response.text}")
                self.issues_found.append(f"400 error for {workflow_id}: {response.text}")
                return False
            elif response.status_code == 404:
                print(f"❌ 404 Not Found for workflow {workflow_id}")
                self.issues_found.append(f"404 error - workflow {workflow_id} doesn't exist")
                return False
            else:
                print(f"❌ Error {response.status_code} for workflow {workflow_id}")
                print(f"   Response: {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ Exception updating workflow {workflow_id}: {e}")
            return False
    
    def create_workflow(self, workflow_data: Dict) -> Optional[str]:
        """Create a new workflow"""
        try:
            create_data = self.fix_workflow_for_update(workflow_data)
            
            response = requests.post(
                f"{N8N_API_URL}/workflows",
                headers=self.headers,
                json=create_data
            )
            
            if response.status_code in [200, 201]:
                new_id = response.json()['data']['id']
                print(f"✅ Created new workflow: {new_id}")
                return new_id
            else:
                print(f"❌ Error creating workflow: {response.status_code}")
                print(f"   Response: {response.text}")
                return None
                
        except Exception as e:
            print(f"❌ Exception creating workflow: {e}")
            return None
    
    def process_workflow_file(self, file_path: Path) -> bool:
        """Process a single workflow file"""
        print(f"\n📄 Processing: {file_path.name}")
        
        try:
            with open(file_path, 'r') as f:
                workflow = json.load(f)
        except Exception as e:
            print(f"   ❌ Error reading file: {e}")
            return False
        
        # Validate format
        issues = self.validate_workflow_format(workflow)
        if issues:
            print(f"   ⚠️  Format issues found:")
            for issue in issues:
                print(f"      - {issue}")
        
        # Check if workflow exists
        workflow_id = workflow.get('id')
        workflow_name = workflow.get('name')
        
        existing = None
        if workflow_id and workflow_id in self.existing_workflows:
            existing = self.existing_workflows[workflow_id]
            print(f"   ✅ Found by ID: {workflow_id}")
        elif workflow_name and workflow_name in self.existing_workflows:
            existing = self.existing_workflows[workflow_name]
            print(f"   ✅ Found by name: {workflow_name}")
            workflow_id = existing['id']
        
        if existing:
            # Update existing workflow
            success = self.update_workflow(workflow_id, workflow)
            if success:
                self.fixes_applied.append(f"Updated: {workflow_name}")
            return success
        else:
            # Create new workflow
            print(f"   ⚠️  Workflow not found, creating new...")
            new_id = self.create_workflow(workflow)
            if new_id:
                self.fixes_applied.append(f"Created: {workflow_name} (ID: {new_id})")
                return True
            return False
    
    def generate_report(self):
        """Generate final report"""
        print("\n" + "="*60)
        print("WORKFLOW UPDATE REPORT")
        print("="*60)
        
        print(f"\n📊 Statistics:")
        print(f"   - Existing workflows in n8n: {len([w for w in self.existing_workflows.values() if 'id' in w])}")
        print(f"   - Fixes applied: {len(self.fixes_applied)}")
        print(f"   - Issues found: {len(self.issues_found)}")
        
        if self.fixes_applied:
            print(f"\n✅ Successful Updates/Creates:")
            for fix in self.fixes_applied:
                print(f"   - {fix}")
        
        if self.issues_found:
            print(f"\n❌ Issues Found:")
            for issue in self.issues_found[:10]:  # Show first 10 issues
                print(f"   - {issue}")
        
        print("\n💡 Common Issues and Solutions:")
        print("   1. Unrecognized node types (mcpToolKit, vectorStore):")
        print("      → Install missing n8n nodes or update to compatible versions")
        print("   2. 404 Not Found errors:")
        print("      → Workflow IDs don't match - script creates new workflows instead")
        print("   3. 400 Bad Request errors:")
        print("      → Format issues - script attempts to fix automatically")

def main():
    """Main function"""
    print("🔧 N8N Workflow Update Issue Fixer")
    print("="*60)
    
    fixer = WorkflowUpdateFixer()
    
    # Get all existing workflows
    fixer.get_all_workflows()
    
    # Process workflow files
    workflow_dir = Path('/root/vivid_mas/services/n8n/backup/workflows')
    if workflow_dir.exists():
        workflow_files = list(workflow_dir.glob('*.json'))
        print(f"\n📁 Found {len(workflow_files)} workflow files to process")
        
        for file_path in workflow_files:
            fixer.process_workflow_file(file_path)
    else:
        print(f"❌ Workflow directory not found: {workflow_dir}")
    
    # Generate report
    fixer.generate_report()

if __name__ == "__main__":
    main()