#!/usr/bin/env python3
"""
Test Agent System
Comprehensive testing suite for the VividWalls Multi-Agent System
"""

import json
import requests
import time
from pathlib import Path
from datetime import datetime
import uuid

# Configuration
N8N_BASE_URL = "https://n8n.vividwalls.blog"
SUPABASE_URL = "https://supabase.vividwalls.blog"
TEST_TIMEOUT = 30  # seconds

class AgentSystemTester:
    def __init__(self):
        self.test_results = []
        self.agents_tested = 0
        self.tests_passed = 0
        self.tests_failed = 0
        
    def log_result(self, test_name, status, details=""):
        """Log test result"""
        result = {
            "timestamp": datetime.now().isoformat(),
            "test": test_name,
            "status": status,
            "details": details
        }
        self.test_results.append(result)
        
        if status == "PASS":
            self.tests_passed += 1
            print(f"  ✅ {test_name}: PASSED")
        else:
            self.tests_failed += 1
            print(f"  ❌ {test_name}: FAILED - {details}")
    
    def test_agent_configuration(self):
        """Test agent configuration files"""
        print("\n🔍 Testing Agent Configuration...")
        
        # Check agents.json
        agents_file = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/mcp_data/agents.json")
        if agents_file.exists():
            with open(agents_file) as f:
                agents = json.load(f)
                self.log_result("Agent configuration file", "PASS", f"{len(agents)} agents found")
                
                # Validate agent structure
                required_fields = ["id", "name", "role", "backstory", "short_term_memory", "long_term_memory", "episodic_memory"]
                for agent in agents[:5]:  # Test first 5 agents
                    missing_fields = [field for field in required_fields if field not in agent]
                    if missing_fields:
                        self.log_result(f"Agent structure - {agent['name']}", "FAIL", f"Missing fields: {missing_fields}")
                    else:
                        self.log_result(f"Agent structure - {agent['name']}", "PASS")
        else:
            self.log_result("Agent configuration file", "FAIL", "File not found")
    
    def test_communication_matrix(self):
        """Test agent communication matrix"""
        print("\n🔗 Testing Communication Matrix...")
        
        matrix_file = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/mcp_data/agent_communication_matrix.json")
        if matrix_file.exists():
            with open(matrix_file) as f:
                matrix = json.load(f)
                self.log_result("Communication matrix file", "PASS")
                
                # Test communication patterns
                if "communication_patterns" in matrix:
                    patterns = matrix["communication_patterns"]
                    self.log_result("Hierarchical communications", "PASS" if "hierarchical" in patterns else "FAIL")
                    self.log_result("Departmental communications", "PASS" if "departmental" in patterns else "FAIL")
                    self.log_result("Cross-functional communications", "PASS" if "cross_functional" in patterns else "FAIL")
                else:
                    self.log_result("Communication patterns", "FAIL", "Missing patterns section")
        else:
            self.log_result("Communication matrix file", "FAIL", "File not found")
    
    def test_mcp_servers(self):
        """Test MCP server configurations"""
        print("\n🔧 Testing MCP Servers...")
        
        mcp_path = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents")
        
        test_servers = [
            "sale-sdir-ecto-r-prompts",
            "marketing-director-prompts",
            "analytics-director-prompts",
            "finance-director-prompts"
        ]
        
        for server in test_servers:
            server_path = mcp_path / server
            if server_path.exists():
                # Check for required files
                package_json = server_path / "package.json"
                tsconfig = server_path / "tsconfig.json"
                
                if package_json.exists() and tsconfig.exists():
                    self.log_result(f"MCP Server - {server}", "PASS")
                else:
                    missing = []
                    if not package_json.exists():
                        missing.append("package.json")
                    if not tsconfig.exists():
                        missing.append("tsconfig.json")
                    self.log_result(f"MCP Server - {server}", "FAIL", f"Missing: {', '.join(missing)}")
            else:
                self.log_result(f"MCP Server - {server}", "FAIL", "Directory not found")
    
    def test_n8n_workflows(self):
        """Test n8n workflow files"""
        print("\n📋 Testing n8n Workflows...")
        
        workflow_path = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows")
        
        departments = ["core", "sales", "marketing", "finance", "operations", "product", "customer_experience", "social_media"]
        
        for dept in departments:
            dept_path = workflow_path / dept
            if dept_path.exists():
                workflows = list(dept_path.glob("*.json"))
                if workflows:
                    self.log_result(f"Workflows - {dept}", "PASS", f"{len(workflows)} workflows")
                    
                    # Validate first workflow structure
                    with open(workflows[0]) as f:
                        workflow = json.load(f)
                        required = ["name", "nodes", "connections"]
                        missing = [field for field in required if field not in workflow]
                        if missing:
                            self.log_result(f"Workflow structure - {dept}", "FAIL", f"Missing: {missing}")
                        else:
                            self.log_result(f"Workflow structure - {dept}", "PASS")
                else:
                    self.log_result(f"Workflows - {dept}", "FAIL", "No workflows found")
            else:
                self.log_result(f"Workflows - {dept}", "WARN", "Department not found")
    
    def test_agent_hierarchy(self):
        """Test agent hierarchy and reporting structure"""
        print("\n👥 Testing Agent Hierarchy...")
        
        # Load agents and matrix
        agents_file = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/mcp_data/agents.json")
        matrix_file = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/mcp_data/agent_communication_matrix.json")
        
        if agents_file.exists() and matrix_file.exists():
            with open(agents_file) as f:
                agents = json.load(f)
            with open(matrix_file) as f:
                matrix = json.load(f)
            
            # Check director agents exist
            directors = [
                "SalesDirectorAgent",
                "MarketingDirectorAgent", 
                "FinanceDirectorAgent",
                "OperationsDirectorAgent",
                "ProductDirectorAgent",
                "CustomerExperienceDirectorAgent",
                "TechnologyDirectorAgent",
                "AnalyticsDirectorAgent"
            ]
            
            agent_names = [agent['name'] for agent in agents]
            
            for director in directors:
                if director in agent_names:
                    self.log_result(f"Director exists - {director}", "PASS")
                else:
                    self.log_result(f"Director exists - {director}", "FAIL", "Not found in agents")
            
            # Check departmental structure
            if "communication_patterns" in matrix and "departmental" in matrix["communication_patterns"]:
                departments = matrix["communication_patterns"]["departmental"]["flows"]
                for dept in departments:
                    leader = dept.get("leader")
                    members = dept.get("members", [])
                    
                    if leader in agent_names:
                        # Check if at least some members exist
                        existing_members = [m for m in members if m in agent_names]
                        if existing_members:
                            self.log_result(f"Department - {dept['department']}", "PASS", 
                                          f"Leader + {len(existing_members)} members")
                        else:
                            self.log_result(f"Department - {dept['department']}", "WARN", 
                                          "Leader exists but no members found")
                    else:
                        self.log_result(f"Department - {dept['department']}", "FAIL", 
                                      f"Leader {leader} not found")
    
    def generate_report(self):
        """Generate comprehensive test report"""
        print("\n" + "=" * 60)
        print("📊 TEST REPORT")
        print("=" * 60)
        
        total_tests = self.tests_passed + self.tests_failed
        success_rate = (self.tests_passed / total_tests * 100) if total_tests > 0 else 0
        
        print(f"\n📈 Summary:")
        print(f"  • Total tests: {total_tests}")
        print(f"  • Passed: {self.tests_passed}")
        print(f"  • Failed: {self.tests_failed}")
        print(f"  • Success rate: {success_rate:.1f}%")
        
        if self.tests_failed > 0:
            print(f"\n❌ Failed Tests:")
            for result in self.test_results:
                if result["status"] == "FAIL":
                    print(f"  • {result['test']}: {result['details']}")
        
        # Save detailed report
        report = {
            "timestamp": datetime.now().isoformat(),
            "summary": {
                "total_tests": total_tests,
                "passed": self.tests_passed,
                "failed": self.tests_failed,
                "success_rate": success_rate
            },
            "details": self.test_results
        }
        
        report_path = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/test_report.json")
        with open(report_path, 'w') as f:
            json.dump(report, f, indent=2)
        
        print(f"\n💾 Detailed report saved to: {report_path}")
        
        return success_rate >= 80  # Return True if 80% or more tests pass

def main():
    """Run all tests"""
    print("🚀 VividWalls Multi-Agent System Test Suite")
    print("=" * 60)
    
    tester = AgentSystemTester()
    
    # Run test suites
    tester.test_agent_configuration()
    tester.test_communication_matrix()
    tester.test_mcp_servers()
    tester.test_n8n_workflows()
    tester.test_agent_hierarchy()
    
    # Generate report
    success = tester.generate_report()
    
    if success:
        print("\n✅ SYSTEM TEST PASSED - Ready for deployment!")
    else:
        print("\n⚠️ SYSTEM TEST FAILED - Review failed tests before deployment")
    
    return 0 if success else 1

if __name__ == "__main__":
    exit(main())