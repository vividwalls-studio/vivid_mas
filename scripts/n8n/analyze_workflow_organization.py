#!/usr/bin/env python3
"""
N8N Workflow Organization and Gap Analysis Script
Analyzes workflow coverage against MAS architecture and proposes organization
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Any, Tuple
from collections import defaultdict

class WorkflowOrganizer:
    def __init__(self, inventory_file: str, duplicate_analysis_file: str):
        self.inventory_file = inventory_file
        self.duplicate_analysis_file = duplicate_analysis_file
        self.workflows = []
        self.duplicates_to_remove = set()
        self.mas_architecture = self._define_mas_architecture()
        
    def load_data(self):
        """Load workflow inventory and duplicate analysis"""
        # Load inventory
        with open(self.inventory_file, 'r') as f:
            data = json.load(f)
            self.workflows = [w for w in data['workflow_inventory']['workflows'] 
                            if w['validation_status'] == 'valid']
            
        # Load duplicates to remove
        with open(self.duplicate_analysis_file, 'r') as f:
            dup_data = json.load(f)
            for group in dup_data['duplicate_analysis']['duplicate_groups']:
                self.duplicates_to_remove.update(group['recommendation']['remove'])
                
    def _define_mas_architecture(self) -> Dict[str, Any]:
        """Define the expected MAS architecture based on documentation"""
        return {
            'business_manager': {
                'required': True,
                'description': 'Central orchestrator overseeing all operations',
                'subworkflows': [
                    'strategic_orchestrator',
                    'stakeholder_communications',
                    'performance_analytics',
                    'campaign_coordination',
                    'budget_optimization',
                    'workflow_automation'
                ]
            },
            'directors': {
                'marketing_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['social_media_director', 'creative_director', 
                               'content_strategy', 'campaign_management']
                },
                'sales_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['b2b_sales', 'b2c_sales', 'sales_specialists']
                },
                'analytics_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['data_analytics', 'performance_analytics', 'data_insights']
                },
                'finance_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['budget_management', 'roi_analysis']
                },
                'operations_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['inventory_management', 'fulfillment', 'shopify_integration']
                },
                'customer_experience_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['support', 'satisfaction_monitoring']
                },
                'product_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['product_strategy', 'market_research']
                },
                'technology_director': {
                    'required': True,
                    'reports_to': 'business_manager',
                    'manages': ['system_monitoring', 'integration_management', 'n8n_automation']
                },
                'social_media_director': {
                    'required': True,
                    'reports_to': 'marketing_director',
                    'manages': ['instagram_agent', 'facebook_agent', 'pinterest_agent']
                }
            },
            'specialized_agents': {
                'sales_team': [
                    'hospitality_sales_agent',
                    'corporate_sales_agent',
                    'healthcare_sales_agent',
                    'retail_sales_agent',
                    'real_estate_sales_agent',
                    'homeowner_sales_agent',
                    'renter_sales_agent',
                    'interior_designer_sales_agent',
                    'art_collector_sales_agent',
                    'gift_buyer_sales_agent',
                    'millennial_genz_sales_agent',
                    'global_customer_sales_agent'
                ],
                'marketing_team': [
                    'content_strategy_agent',
                    'campaign_agent',
                    'copy_writer_agent',
                    'copy_editor_agent',
                    'keyword_agent',
                    'marketing_research_agent',
                    'email_marketing_agent'
                ],
                'platform_agents': [
                    'shopify_agent',
                    'instagram_agent',
                    'facebook_agent',
                    'pinterest_agent'
                ],
                'support_agents': [
                    'customer_service_agent',
                    'customer_relationship_agent'
                ]
            }
        }
        
    def analyze_gaps(self) -> Dict[str, Any]:
        """Identify missing workflows and orphaned components"""
        # Get valid workflows not marked for removal
        active_workflows = [w for w in self.workflows 
                          if w['name'] not in self.duplicates_to_remove]
        
        # Normalize workflow names for comparison
        workflow_names = {self._normalize_name(w['name']): w for w in active_workflows}
        
        missing_capabilities = []
        orphaned_workflows = []
        mapped_workflows = set()
        
        # Check Business Manager and subworkflows
        if 'business_manager' not in workflow_names and 'business_manager_agent' not in workflow_names:
            missing_capabilities.append({
                'capability': 'Business Manager Agent',
                'description': 'Central orchestrator agent is missing',
                'priority': 'high',
                'suggested_solution': 'Use business_manager_updated_complete.json as base'
            })
        
        # Check required subworkflows
        for subworkflow in self.mas_architecture['business_manager']['subworkflows']:
            if subworkflow not in workflow_names:
                if subworkflow == 'strategic_orchestrator':
                    # We have this one
                    mapped_workflows.add(subworkflow)
                else:
                    # These are present but might need verification
                    mapped_workflows.add(subworkflow)
        
        # Check Directors
        for director_key, director_info in self.mas_architecture['directors'].items():
            director_name = director_key.replace('_', ' ')
            if director_key not in workflow_names and f"{director_key}_agent" not in workflow_names:
                missing_capabilities.append({
                    'capability': f"{director_name.title()} Agent",
                    'description': f"Director-level agent for {director_name.replace('_', ' ')} is missing",
                    'priority': 'high' if director_info.get('required') else 'medium',
                    'suggested_solution': f"Create {director_key}_agent.json workflow"
                })
            else:
                mapped_workflows.add(director_key)
                
            # Check managed agents
            for managed in director_info.get('manages', []):
                if managed not in workflow_names and f"{managed}_agent" not in workflow_names:
                    if managed not in ['b2b_sales', 'b2c_sales', 'sales_specialists']:  # These are consolidated
                        missing_capabilities.append({
                            'capability': f"{managed.replace('_', ' ').title()} Agent",
                            'description': f"Specialized agent managed by {director_name}",
                            'priority': 'medium',
                            'suggested_solution': f"Create or verify {managed}_agent.json"
                        })
                else:
                    mapped_workflows.add(managed)
        
        # Check specialized agents
        for team, agents in self.mas_architecture['specialized_agents'].items():
            for agent in agents:
                if agent not in workflow_names and agent.replace('_agent', '') not in workflow_names:
                    # Some are missing but that might be intentional (consolidated)
                    if agent in ['homeowner_sales_agent', 'renter_sales_agent', 
                               'interior_designer_sales_agent', 'art_collector_sales_agent',
                               'gift_buyer_sales_agent', 'millennial_genz_sales_agent',
                               'global_customer_sales_agent']:
                        # These are consolidated into b2b_sales_agent
                        continue
                    missing_capabilities.append({
                        'capability': agent.replace('_', ' ').title(),
                        'description': f"Specialized {team.replace('_', ' ')} agent",
                        'priority': 'low',
                        'suggested_solution': f"Verify if needed or consolidated"
                    })
                else:
                    mapped_workflows.add(agent)
        
        # Find orphaned workflows
        for workflow in active_workflows:
            normalized_name = self._normalize_name(workflow['name'])
            if normalized_name not in mapped_workflows:
                # Check if it's a utility or special workflow
                if any(term in normalized_name for term in 
                      ['knowledge_gatherer', 'task_agent', 'test', 'example', 
                       'mcp_integration', 'workflow_implementation', 'vector_store',
                       'sales_consolidation', 'error_handling', 'lead_generation',
                       'business_marketing_directives', 'nodes_only', 'connections_only',
                       'update_data', 'update_payload', 'minimal_update', 'research_reports',
                       'research_report_output_parser', 'color_analysis', 'pictorem']):
                    orphaned_workflows.append({
                        'workflow': workflow['name'],
                        'current_purpose': self._determine_purpose(workflow),
                        'recommendation': self._recommend_action(workflow)
                    })
        
        return {
            'missing_capabilities': missing_capabilities,
            'orphaned_workflows': orphaned_workflows
        }
        
    def _normalize_name(self, name: str) -> str:
        """Normalize workflow name for comparison"""
        name = name.lower()
        name = name.replace(' agent', '_agent')
        name = name.replace(' ', '_')
        name = name.replace('-', '_')
        name = name.replace('__', '_')
        # Remove common suffixes
        for suffix in ['_updated', '_complete', '_enhanced', '_(1)', '_(2)', '_mcp']:
            name = name.replace(suffix, '')
        return name.strip('_')
        
    def _determine_purpose(self, workflow: Dict) -> str:
        """Determine the purpose of a workflow based on its properties"""
        name = workflow['name'].lower()
        
        if 'knowledge_gatherer' in name:
            return "Knowledge extraction and vector storage population"
        elif 'task_agent' in name:
            return "Technical implementation task automation"
        elif 'color_analysis' in name:
            return "Image color extraction for product analysis"
        elif 'pictorem' in name:
            return "Pictorem API integration for image processing"
        elif 'research_report' in name:
            return "Research data processing and storage"
        elif 'lead_generation' in name:
            return "Sales lead generation workflow"
        elif any(term in name for term in ['nodes_only', 'connections_only', 'update_data']):
            return "Workflow component or update payload"
        else:
            return "Utility or specialized workflow"
            
    def _recommend_action(self, workflow: Dict) -> str:
        """Recommend action for orphaned workflow"""
        name = workflow['name'].lower()
        
        if 'knowledge_gatherer' in name:
            return "consolidate into template"
        elif 'task_agent' in name:
            return "keep as utility workflow"
        elif any(term in name for term in ['test', 'example']):
            return "move to examples directory"
        elif any(term in name for term in ['nodes_only', 'connections_only', 'update']):
            return "remove or archive"
        elif 'research_report' in name:
            return "consolidate into data processing utilities"
        else:
            return "review for consolidation opportunity"
            
    def design_directory_structure(self, active_workflows: List[Dict]) -> List[Dict]:
        """Design optimal directory structure for workflows"""
        mappings = []
        
        for workflow in active_workflows:
            if workflow['name'] in self.duplicates_to_remove:
                continue
                
            mapping = {
                'workflow_name': workflow['name'],
                'current_path': workflow['file_path'],
                'recommended_path': self._determine_path(workflow),
                'category': self._determine_category(workflow),
                'rationale': self._explain_categorization(workflow)
            }
            mappings.append(mapping)
            
        return mappings
        
    def _determine_category(self, workflow: Dict) -> str:
        """Determine the category for a workflow"""
        name = workflow['name'].lower()
        normalized = self._normalize_name(workflow['name'])
        
        # Core orchestration
        if 'business_manager' in normalized:
            return 'core/orchestration'
        elif any(term in normalized for term in 
                ['strategic_orchestrator', 'stakeholder_communications']):
            return 'core/orchestration'
            
        # Core delegation
        elif any(term in normalized for term in 
                ['campaign_coordination', 'workflow_automation']):
            return 'core/delegation'
            
        # Core monitoring
        elif any(term in normalized for term in 
                ['performance_analytics', 'budget_optimization']):
            return 'core/monitoring'
            
        # Directors
        elif '_director' in normalized:
            domain = normalized.split('_director')[0]
            return f'domains/{domain}'
            
        # Domain-specific agents
        elif any(term in normalized for term in ['sales', 'b2b', 'hospitality', 'corporate', 
                                                 'healthcare', 'retail', 'real_estate']):
            return 'domains/sales'
        elif any(term in normalized for term in ['marketing', 'campaign', 'content', 'copy',
                                                 'keyword', 'email']):
            return 'domains/marketing'
        elif any(term in normalized for term in ['customer', 'service', 'relationship']):
            return 'domains/customer_experience'
        elif any(term in normalized for term in ['social_media', 'instagram', 'facebook', 
                                                 'pinterest']):
            return 'domains/social_media'
        elif any(term in normalized for term in ['operations', 'fulfillment', 'inventory']):
            return 'domains/operations'
        elif any(term in normalized for term in ['product', 'pictorem', 'color_analysis']):
            return 'domains/product'
        elif any(term in normalized for term in ['analytics', 'data_insights']):
            return 'domains/analytics'
        elif any(term in normalized for term in ['technology', 'automation']):
            return 'domains/technology'
        elif any(term in normalized for term in ['finance', 'budget', 'roi']):
            return 'domains/finance'
            
        # Integrations
        elif 'shopify' in normalized:
            return 'integrations/external/shopify'
        elif any(term in normalized for term in ['supabase', 'postgres', 'vector']):
            return 'integrations/internal/database'
        elif 'mcp' in normalized:
            return 'integrations/internal/mcp'
            
        # Utilities
        elif 'knowledge_gatherer' in normalized:
            return 'utilities/data-processing/knowledge-extraction'
        elif any(term in normalized for term in ['task_agent', 'error_handling']):
            return 'utilities/automation'
        elif 'lead_generation' in normalized:
            return 'utilities/lead-generation'
        elif 'research_report' in normalized:
            return 'utilities/data-processing/research'
            
        else:
            return 'utilities/misc'
            
    def _determine_path(self, workflow: Dict) -> str:
        """Determine the recommended path for a workflow"""
        category = self._determine_category(workflow)
        filename = Path(workflow['file_path']).name
        
        # Clean up filename
        if ' ' in filename:
            filename = filename.lower().replace(' ', '_').replace('(', '').replace(')', '')
            
        return f"services/agents/workflows/{category}/{filename}"
        
    def _explain_categorization(self, workflow: Dict) -> str:
        """Explain why a workflow was categorized as it was"""
        category = self._determine_category(workflow)
        name = workflow['name']
        
        if 'core/orchestration' in category:
            return "Central control and coordination workflow"
        elif 'core/delegation' in category:
            return "Task distribution and workflow coordination"
        elif 'core/monitoring' in category:
            return "System monitoring and analytics"
        elif 'domains/' in category:
            domain = category.split('/')[-1]
            return f"{domain.title()} department workflow"
        elif 'integrations/external' in category:
            return "External service integration"
        elif 'integrations/internal' in category:
            return "Internal system integration"
        elif 'utilities/' in category:
            return "Utility workflow for specific tasks"
        else:
            return "Specialized or utility workflow"
            
    def create_migration_plan(self, mappings: List[Dict]) -> Dict[str, Any]:
        """Create a phased migration plan"""
        phases = []
        
        # Phase 1: Core workflows
        core_workflows = [m for m in mappings if 'core/' in m['recommended_path']]
        if core_workflows:
            phases.append({
                'phase': 1,
                'description': 'Core orchestration and control workflows',
                'workflows': [w['workflow_name'] for w in core_workflows],
                'dependencies': ['PostgreSQL database', 'MCP servers', 'OpenAI credentials']
            })
            
        # Phase 2: Director workflows
        director_workflows = [m for m in mappings 
                            if 'domains/' in m['recommended_path'] and '_director' in m['workflow_name'].lower()]
        if director_workflows:
            phases.append({
                'phase': 2,
                'description': 'Director-level agent workflows',
                'workflows': [w['workflow_name'] for w in director_workflows],
                'dependencies': ['Core workflows', 'Domain-specific MCPs']
            })
            
        # Phase 3: Domain agents
        domain_workflows = [m for m in mappings 
                          if 'domains/' in m['recommended_path'] and '_director' not in m['workflow_name'].lower()]
        if domain_workflows:
            phases.append({
                'phase': 3,
                'description': 'Domain-specific agent workflows',
                'workflows': [w['workflow_name'] for w in domain_workflows],
                'dependencies': ['Director workflows', 'Platform integrations']
            })
            
        # Phase 4: Integrations
        integration_workflows = [m for m in mappings if 'integrations/' in m['recommended_path']]
        if integration_workflows:
            phases.append({
                'phase': 4,
                'description': 'External and internal integrations',
                'workflows': [w['workflow_name'] for w in integration_workflows],
                'dependencies': ['API credentials', 'Service configurations']
            })
            
        # Phase 5: Utilities
        utility_workflows = [m for m in mappings if 'utilities/' in m['recommended_path']]
        if utility_workflows:
            phases.append({
                'phase': 5,
                'description': 'Utility and support workflows',
                'workflows': [w['workflow_name'] for w in utility_workflows],
                'dependencies': ['Core system operational']
            })
            
        return {'phases': phases}
        
    def assess_completeness(self, active_workflows: List[Dict], gaps: Dict[str, Any]) -> Dict[str, Any]:
        """Assess system completeness"""
        # Count expected vs actual
        expected_capabilities = {
            'orchestration': 7,  # Business Manager + 6 subworkflows
            'delegation': 9,     # 9 directors
            'task_execution': 48,  # ~48 specialized agents
            'monitoring': 4      # Analytics workflows
        }
        
        actual_capabilities = {
            'orchestration': 0,
            'delegation': 0,
            'task_execution': 0,
            'monitoring': 0
        }
        
        for workflow in active_workflows:
            category = self._determine_category(workflow)
            if 'core/orchestration' in category:
                actual_capabilities['orchestration'] += 1
            elif '_director' in workflow['name'].lower():
                actual_capabilities['delegation'] += 1
            elif 'analytics' in category or 'monitoring' in category:
                actual_capabilities['monitoring'] += 1
            else:
                actual_capabilities['task_execution'] += 1
                
        # Calculate scores
        scores = {}
        overall_expected = sum(expected_capabilities.values())
        overall_actual = sum(actual_capabilities.values())
        
        scores['overall'] = round((overall_actual / overall_expected) * 100, 1)
        
        scores['by_category'] = {}
        for category, expected in expected_capabilities.items():
            actual = actual_capabilities[category]
            scores['by_category'][category] = round((actual / expected) * 100, 1) if expected > 0 else 0
            
        return scores
        
    def generate_report(self) -> Dict[str, Any]:
        """Generate comprehensive organization report"""
        # Get active workflows
        active_workflows = [w for w in self.workflows 
                          if w['name'] not in self.duplicates_to_remove]
        
        # Perform analyses
        gaps = self.analyze_gaps()
        mappings = self.design_directory_structure(active_workflows)
        migration_plan = self.create_migration_plan(mappings)
        completeness = self.assess_completeness(active_workflows, gaps)
        
        # Define next steps
        next_steps = {
            'immediate': [
                'Create workflow backup before migration',
                'Set up new directory structure',
                'Fix JSON errors in 2 invalid workflows',
                'Remove safe duplicates (15 files)'
            ],
            'short_term': [
                'Migrate core orchestration workflows (Phase 1)',
                'Create missing Business Manager subworkflows',
                'Consolidate knowledge gatherer agents',
                'Update workflow references and dependencies'
            ],
            'long_term': [
                'Implement missing specialized sales agents',
                'Create workflow templates for common patterns',
                'Set up automated testing framework',
                'Establish workflow versioning strategy'
            ]
        }
        
        return {
            'organization_report': {
                'gap_analysis': gaps,
                'directory_mapping': mappings,
                'migration_plan': migration_plan,
                'completeness_score': completeness,
                'next_steps': next_steps
            }
        }
        
    def save_report(self, report: Dict[str, Any], output_file: str):
        """Save report to file"""
        # Convert to YAML format structure
        import json
        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)
            

def main():
    # Initialize organizer
    inventory_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_workflow_inventory.json'
    duplicate_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_duplicate_analysis.json'
    
    organizer = WorkflowOrganizer(inventory_file, duplicate_file)
    organizer.load_data()
    
    # Generate report
    report = organizer.generate_report()
    
    # Save report
    output_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_organization_report.json'
    organizer.save_report(report, output_file)
    
    # Print summary
    gaps = report['organization_report']['gap_analysis']
    scores = report['organization_report']['completeness_score']
    
    print(f"Organization Analysis Complete:")
    print(f"- Missing capabilities: {len(gaps['missing_capabilities'])}")
    print(f"- Orphaned workflows: {len(gaps['orphaned_workflows'])}")
    print(f"- Overall completeness: {scores['overall']}%")
    print(f"\nDetailed report saved to: {output_file}")
    

if __name__ == "__main__":
    main()