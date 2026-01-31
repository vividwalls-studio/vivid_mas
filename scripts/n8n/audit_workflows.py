#!/usr/bin/env python3
"""
Audit VividWalls MAS Workflows
Identifies redundant, incorrect, and missing workflows
"""

import json
import os
from pathlib import Path
from datetime import datetime
import re

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
N8N_WORKFLOWS_PATH = BASE_PATH / "services/n8n"
AGENTS_DATA_PATH = BASE_PATH / "services/agents"
WORKFLOW_INDEX_PATH = BASE_PATH / "workflows"

class WorkflowAuditor:
    def __init__(self):
        self.existing_workflows = {}
        self.data_flow_agents = []
        self.redundant_workflows = []
        self.missing_workflows = []
        self.incorrect_workflows = []
        self.workflow_mapping = {}
        
    def scan_existing_workflows(self):
        """Scan all existing n8n workflows"""
        print("🔍 Scanning existing workflows...")
        
        # Define directories to scan
        workflow_dirs = [
            N8N_WORKFLOWS_PATH / "agents/workflows",
            N8N_WORKFLOWS_PATH / "workflows",
            BASE_PATH / "services/agents/workflows"
        ]
        
        for workflow_dir in workflow_dirs:
            if workflow_dir.exists():
                # Recursively find all JSON files
                for workflow_file in workflow_dir.rglob("*.json"):
                    if workflow_file.is_file() and not workflow_file.name.startswith('.'):
                        relative_path = workflow_file.relative_to(BASE_PATH)
                        workflow_name = workflow_file.stem
                        
                        # Try to load and extract workflow info
                        try:
                            with open(workflow_file) as f:
                                data = json.load(f)
                                if isinstance(data, dict):
                                    workflow_info = {
                                        "path": str(relative_path),
                                        "name": data.get("name", workflow_name),
                                        "nodes": len(data.get("nodes", [])),
                                        "active": data.get("active", False),
                                        "tags": data.get("tags", [])
                                    }
                                else:
                                    workflow_info = {
                                        "path": str(relative_path),
                                        "name": workflow_name,
                                        "nodes": 0,
                                        "active": False,
                                        "tags": []
                                    }
                        except:
                            workflow_info = {
                                "path": str(relative_path),
                                "name": workflow_name,
                                "error": "Failed to parse JSON"
                            }
                        
                        # Categorize workflow
                        if workflow_name not in self.existing_workflows:
                            self.existing_workflows[workflow_name] = []
                        self.existing_workflows[workflow_name].append(workflow_info)
        
        print(f"  Found {len(self.existing_workflows)} unique workflow names")
        
    def scan_data_flow_definitions(self):
        """Scan data flow markdown files for required agents"""
        print("\n📋 Scanning data flow definitions...")
        
        data_flow_files = list(AGENTS_DATA_PATH.glob("*_DATA_FLOW.md"))
        
        for df_file in data_flow_files:
            # Extract agent name from filename
            agent_name = df_file.stem.replace("_DATA_FLOW", "").replace("_", " ").title()
            agent_key = df_file.stem.replace("_DATA_FLOW", "").lower()
            
            self.data_flow_agents.append({
                "name": agent_name,
                "key": agent_key,
                "file": df_file.name
            })
        
        print(f"  Found {len(self.data_flow_agents)} agent data flow definitions")
    
    def identify_redundancies(self):
        """Identify redundant workflows"""
        print("\n🔄 Identifying redundant workflows...")
        
        # Look for duplicate workflows (same name in multiple locations)
        for workflow_name, instances in self.existing_workflows.items():
            if len(instances) > 1:
                self.redundant_workflows.append({
                    "workflow": workflow_name,
                    "instances": instances,
                    "recommendation": "Keep most recent or most complete version"
                })
        
        # Look for similar workflow names that might be duplicates
        workflow_names = list(self.existing_workflows.keys())
        for i, name1 in enumerate(workflow_names):
            for name2 in workflow_names[i+1:]:
                # Check for similar names
                if self._are_similar(name1, name2):
                    self.redundant_workflows.append({
                        "workflow": f"{name1} vs {name2}",
                        "instances": [
                            self.existing_workflows[name1][0],
                            self.existing_workflows[name2][0]
                        ],
                        "recommendation": "Review for consolidation"
                    })
        
        print(f"  Found {len(self.redundant_workflows)} potential redundancies")
    
    def identify_missing_workflows(self):
        """Identify missing workflows based on data flow definitions"""
        print("\n❌ Identifying missing workflows...")
        
        # Map expected workflow names from data flow agents
        expected_workflows = {
            "campaign_agent": ["campaign-agent", "campaign_agent"],
            "campaign_manager_agent": ["campaign-manager", "campaign_manager", "Campaign Manager Agent Strategic"],
            "content_strategy_agent": ["content-strategy", "content_strategy"],
            "copy_writer_agent": ["copywriter", "copy-writer", "copywriter_workflow"],
            "creative_director_agent": ["creative-director", "creative_director"],
            "customer_experience_director_agent": ["customer-experience-director", "customer_experience_director"],
            "data_analytics_agent": ["data-analytics", "analytics", "data_analytics"],
            "email_marketing_agent": ["email-marketing", "emailmarketing", "emailmarketing_workflow"],
            "facebook_subagent": ["facebook", "facebook-agent"],
            "hospitality_sales_agent": ["hospitality-sales", "hospitalitysales"],
            "instagram_subagent": ["instagram", "instagram-agent"],
            "marketing_director_agent": ["marketing-director", "marketing_director"],
            "marketing_research_agent": ["marketing-research", "marketing_research"],
            "pinterest_subagent": ["pinterest", "pinterest-agent"],
            "product_director_agent": ["product-director", "product_director"],
            "sales_director_agent": ["sales-director", "salesdirector", "salesdirector_workflow"],
            "social_media_agent": ["social-media", "social_media_director"]
        }
        
        # Check which expected workflows are missing
        existing_names_lower = [name.lower() for name in self.existing_workflows.keys()]
        
        for agent in self.data_flow_agents:
            agent_key = agent["key"]
            found = False
            
            if agent_key in expected_workflows:
                # Check if any variant exists
                for variant in expected_workflows[agent_key]:
                    if any(variant in name for name in existing_names_lower):
                        found = True
                        break
            
            if not found:
                self.missing_workflows.append({
                    "agent": agent["name"],
                    "key": agent_key,
                    "expected_workflow": f"{agent_key.replace('_', '-')}-workflow",
                    "data_flow_file": agent["file"]
                })
        
        print(f"  Found {len(self.missing_workflows)} missing workflows")
    
    def identify_incorrect_workflows(self):
        """Identify potentially incorrect or obsolete workflows"""
        print("\n⚠️ Identifying incorrect/obsolete workflows...")
        
        # Patterns that indicate test, example, or obsolete workflows
        obsolete_patterns = [
            "test", "example", "demo", "backup", "old", "temp", 
            "geographic-income", "medusa-integration", "medusa-inventory"
        ]
        
        for workflow_name, instances in self.existing_workflows.items():
            workflow_lower = workflow_name.lower()
            
            # Check for obsolete patterns
            for pattern in obsolete_patterns:
                if pattern in workflow_lower:
                    self.incorrect_workflows.append({
                        "workflow": workflow_name,
                        "path": instances[0]["path"],
                        "reason": f"Contains pattern '{pattern}' - likely test/example",
                        "recommendation": "Delete or move to examples folder"
                    })
                    break
            
            # Check for workflows without corresponding data flow
            if not any(agent["key"] in workflow_lower for agent in self.data_flow_agents):
                # Skip if already marked as incorrect
                if not any(w["workflow"] == workflow_name for w in self.incorrect_workflows):
                    # Check if it's a utility workflow
                    utility_patterns = ["sync", "webhook", "handler", "reasoning", "integration"]
                    if not any(p in workflow_lower for p in utility_patterns):
                        self.incorrect_workflows.append({
                            "workflow": workflow_name,
                            "path": instances[0]["path"],
                            "reason": "No corresponding data flow definition",
                            "recommendation": "Review for validity"
                        })
        
        print(f"  Found {len(self.incorrect_workflows)} potentially incorrect workflows")
    
    def _are_similar(self, name1, name2):
        """Check if two workflow names are similar"""
        # Normalize names
        norm1 = re.sub(r'[^a-z0-9]', '', name1.lower())
        norm2 = re.sub(r'[^a-z0-9]', '', name2.lower())
        
        # Check if one contains the other
        if norm1 in norm2 or norm2 in norm1:
            return True
        
        # Check Levenshtein distance (simple implementation)
        if abs(len(norm1) - len(norm2)) <= 3:
            matches = sum(1 for a, b in zip(norm1, norm2) if a == b)
            if matches / max(len(norm1), len(norm2)) > 0.8:
                return True
        
        return False
    
    def generate_report(self):
        """Generate comprehensive audit report"""
        print("\n" + "=" * 60)
        print("📊 WORKFLOW AUDIT REPORT")
        print("=" * 60)
        
        report = {
            "timestamp": datetime.now().isoformat(),
            "summary": {
                "total_workflows": sum(len(instances) for instances in self.existing_workflows.values()),
                "unique_workflows": len(self.existing_workflows),
                "redundant": len(self.redundant_workflows),
                "missing": len(self.missing_workflows),
                "incorrect": len(self.incorrect_workflows)
            },
            "redundant_workflows": self.redundant_workflows,
            "missing_workflows": self.missing_workflows,
            "incorrect_workflows": self.incorrect_workflows,
            "recommendations": []
        }
        
        # Generate recommendations
        if self.redundant_workflows:
            report["recommendations"].append({
                "priority": "high",
                "action": "Remove duplicate workflows",
                "details": f"Found {len(self.redundant_workflows)} redundant workflows that should be consolidated"
            })
        
        if self.missing_workflows:
            report["recommendations"].append({
                "priority": "high",
                "action": "Create missing workflows",
                "details": f"Need to create {len(self.missing_workflows)} workflows based on data flow definitions"
            })
        
        if self.incorrect_workflows:
            report["recommendations"].append({
                "priority": "medium",
                "action": "Clean up incorrect/obsolete workflows",
                "details": f"Found {len(self.incorrect_workflows)} workflows that appear to be test/example or obsolete"
            })
        
        # Save report
        report_path = BASE_PATH / "workflow_audit_report.json"
        with open(report_path, 'w') as f:
            json.dump(report, f, indent=2)
        
        # Print summary
        print(f"\n📈 Summary:")
        print(f"  • Total workflow files: {report['summary']['total_workflows']}")
        print(f"  • Unique workflows: {report['summary']['unique_workflows']}")
        print(f"  • Redundant workflows: {report['summary']['redundant']}")
        print(f"  • Missing workflows: {report['summary']['missing']}")
        print(f"  • Incorrect/obsolete: {report['summary']['incorrect']}")
        
        if self.redundant_workflows:
            print(f"\n🔄 Redundant Workflows to Remove:")
            for item in self.redundant_workflows[:5]:  # Show first 5
                print(f"  • {item['workflow']}")
                for instance in item['instances']:
                    print(f"    - {instance['path']}")
        
        if self.missing_workflows:
            print(f"\n❌ Missing Workflows to Create:")
            for item in self.missing_workflows[:10]:  # Show first 10
                print(f"  • {item['agent']} → {item['expected_workflow']}")
        
        if self.incorrect_workflows:
            print(f"\n⚠️ Incorrect/Obsolete Workflows to Delete:")
            for item in self.incorrect_workflows[:10]:  # Show first 10
                print(f"  • {item['workflow']}: {item['reason']}")
        
        print(f"\n💾 Detailed report saved to: {report_path}")
        
        return report

def main():
    """Run workflow audit"""
    print("🚀 VividWalls MAS Workflow Audit")
    print("=" * 60)
    
    auditor = WorkflowAuditor()
    
    # Run audit steps
    auditor.scan_existing_workflows()
    auditor.scan_data_flow_definitions()
    auditor.identify_redundancies()
    auditor.identify_missing_workflows()
    auditor.identify_incorrect_workflows()
    
    # Generate report
    report = auditor.generate_report()
    
    print("\n✅ Audit complete!")
    
    return 0

if __name__ == "__main__":
    exit(main())