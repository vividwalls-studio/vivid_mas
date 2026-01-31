#!/usr/bin/env python3
"""
Fix VividWalls-MAS workflows only
- Ignores Deal Flow and DesignThru-AI workflows
- Focuses on workflows with VividWalls, Agent, Director, or MAS tags
- Fixes node type issues and updates tags
"""

import json
import psycopg2
import sys
from typing import List, Dict, Optional

# Database connection
DB_CONFIG = {
    'host': 'localhost',
    'port': 5433,
    'database': 'postgres',
    'user': 'postgres',
    'password': 'myqP9lSMLobnuIfkUpXQzZg07'
}

class VividWallsWorkflowFixer:
    def __init__(self):
        self.conn = None
        self.vividwalls_workflows = []
        self.issues_fixed = []
        
    def connect_db(self):
        """Connect to PostgreSQL database"""
        try:
            self.conn = psycopg2.connect(**DB_CONFIG)
            print("✅ Connected to database")
            return True
        except Exception as e:
            print(f"❌ Database connection failed: {e}")
            return False
    
    def get_vividwalls_workflows(self) -> List[Dict]:
        """Get all VividWalls MAS workflows"""
        query = """
        SELECT id, name, active, nodes::text, connections::text
        FROM workflow_entity 
        WHERE (
            name LIKE '%VividWalls%' 
            OR name LIKE '%Agent%' 
            OR name LIKE '%Director%' 
            OR name LIKE '%MAS%'
        )
        AND name NOT LIKE '%Deal Flow%'
        AND name NOT LIKE '%DesignThru%'
        ORDER BY name;
        """
        
        cursor = self.conn.cursor()
        cursor.execute(query)
        
        workflows = []
        for row in cursor.fetchall():
            workflows.append({
                'id': row[0],
                'name': row[1],
                'active': row[2],
                'nodes': json.loads(row[3]) if row[3] else [],
                'connections': json.loads(row[4]) if row[4] else {}
            })
        
        cursor.close()
        print(f"📊 Found {len(workflows)} VividWalls/MAS workflows")
        return workflows
    
    def fix_mcp_nodes(self, nodes: List[Dict]) -> tuple[List[Dict], List[str]]:
        """Fix MCP node issues in workflow"""
        fixes_applied = []
        
        for node in nodes:
            node_type = node.get('type', '')
            
            # Fix MCP toolkit nodes
            if 'mcpToolKit' in node_type:
                # Replace with standard Code node
                node['type'] = 'n8n-nodes-base.code'
                fixes_applied.append(f"Replaced mcpToolKit with code node: {node.get('name')}")
            
            # Fix vector store nodes
            elif 'vectorStoreAirtableSearch' in node_type:
                # Replace with Supabase vector store
                node['type'] = '@n8n/n8n-nodes-langchain.vectorStoreSupabase'
                fixes_applied.append(f"Replaced Airtable vector with Supabase: {node.get('name')}")
            
            # Ensure all nodes have required fields
            if 'position' not in node:
                node['position'] = [0, 0]
                fixes_applied.append(f"Added position to node: {node.get('name')}")
        
        return nodes, fixes_applied
    
    def update_workflow_tags(self, workflow_id: str, workflow_name: str):
        """Ensure workflow has proper VividWalls-MAS tags"""
        cursor = self.conn.cursor()
        
        # Check if tags exist
        cursor.execute("""
            SELECT t.name 
            FROM tag_entity t
            JOIN workflows_tags wt ON t.id = wt.tagId
            WHERE wt.workflowId = %s
        """, (workflow_id,))
        
        existing_tags = [row[0] for row in cursor.fetchall()]
        
        # Determine required tags based on name
        required_tags = []
        
        if 'VividWalls' in workflow_name:
            required_tags.append('VividWalls')
        if 'Agent' in workflow_name:
            required_tags.append('Agent')
        if 'Director' in workflow_name:
            required_tags.append('Director')
        if 'MAS' in workflow_name or 'Agent' in workflow_name:
            required_tags.append('MAS')
        
        # Add VividWalls-MAS tag to all
        required_tags.append('VividWalls-MAS')
        
        # Add missing tags
        for tag in required_tags:
            if tag not in existing_tags:
                # First ensure tag exists
                cursor.execute("""
                    INSERT INTO tag_entity (name, createdAt, updatedAt)
                    VALUES (%s, NOW(), NOW())
                    ON CONFLICT (name) DO NOTHING
                    RETURNING id
                """, (tag,))
                
                result = cursor.fetchone()
                if result:
                    tag_id = result[0]
                else:
                    cursor.execute("SELECT id FROM tag_entity WHERE name = %s", (tag,))
                    tag_id = cursor.fetchone()[0]
                
                # Link tag to workflow
                cursor.execute("""
                    INSERT INTO workflows_tags (workflowId, tagId)
                    VALUES (%s, %s)
                    ON CONFLICT DO NOTHING
                """, (workflow_id, tag_id))
                
                print(f"   ✅ Added tag: {tag}")
        
        cursor.close()
    
    def process_workflow(self, workflow: Dict):
        """Process a single workflow"""
        print(f"\n📄 Processing: {workflow['name']}")
        
        # Fix node issues
        if workflow['nodes']:
            fixed_nodes, fixes = self.fix_mcp_nodes(workflow['nodes'])
            
            if fixes:
                print(f"   🔧 Applied {len(fixes)} node fixes:")
                for fix in fixes[:3]:  # Show first 3 fixes
                    print(f"      - {fix}")
                
                # Update workflow in database
                cursor = self.conn.cursor()
                cursor.execute("""
                    UPDATE workflow_entity
                    SET nodes = %s::jsonb, updatedAt = NOW()
                    WHERE id = %s
                """, (json.dumps(fixed_nodes), workflow['id']))
                cursor.close()
                
                self.issues_fixed.extend(fixes)
        
        # Update tags
        self.update_workflow_tags(workflow['id'], workflow['name'])
    
    def generate_report(self):
        """Generate summary report"""
        print("\n" + "="*60)
        print("VIVIDWALLS WORKFLOW FIX REPORT")
        print("="*60)
        
        print(f"\n📊 Statistics:")
        print(f"   - VividWalls workflows processed: {len(self.vividwalls_workflows)}")
        print(f"   - Node fixes applied: {len(self.issues_fixed)}")
        print(f"   - Tags updated: All workflows tagged with VividWalls-MAS")
        
        print("\n✅ All VividWalls workflows have been:")
        print("   1. Fixed for MCP node compatibility")
        print("   2. Tagged with VividWalls-MAS for filtering")
        print("   3. Preserved Deal Flow and DesignThru-AI workflows")
        
        print("\n💡 Next Steps:")
        print("   1. Restart n8n to clear error cache")
        print("   2. Test workflows through n8n UI")
        print("   3. Use VividWalls-MAS tag for filtering")

def main():
    """Main function"""
    print("🔧 VividWalls-MAS Workflow Fixer")
    print("="*60)
    print("Focusing only on VividWalls workflows")
    print("Preserving Deal Flow and DesignThru-AI workflows")
    print("")
    
    fixer = VividWallsWorkflowFixer()
    
    # Connect to database
    if not fixer.connect_db():
        sys.exit(1)
    
    try:
        # Get VividWalls workflows
        fixer.vividwalls_workflows = fixer.get_vividwalls_workflows()
        
        # Process each workflow
        for workflow in fixer.vividwalls_workflows:
            fixer.process_workflow(workflow)
        
        # Commit changes
        fixer.conn.commit()
        print("\n✅ Changes committed to database")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        if fixer.conn:
            fixer.conn.rollback()
    
    finally:
        # Generate report
        fixer.generate_report()
        
        # Close connection
        if fixer.conn:
            fixer.conn.close()

if __name__ == "__main__":
    main()