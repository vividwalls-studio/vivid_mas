#!/usr/bin/env python3
"""Organize remaining domain workflows into proper structure."""

import shutil
from pathlib import Path

def organize_domain_workflows():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    # Define workflow categorizations
    workflow_mappings = {
        # Sales domain workflows
        "sales": [
            "b2b_sales_agent.json",
            "corporate_sales_agent.json",
            "healthcare_sales_agent.json",
            "hospitality_sales_agent.json",
            "retail_sales_agent.json",
            "sales_agent_knowledge_enhanced_example.json",
            "sales_agent.json",
            "task_agent_4_sales_consolidation.json",
            "residential_sales_agent.json"
        ],
        # Marketing domain workflows
        "marketing": [
            "business_marketing_directives.json",
            "campaign_agent.json",
            "content_strategy_agent.json",
            "Content Strategy Agent Strategic.json",
            "copy_editor_agent.json",
            "copy_writer_agent.json",
            "keyword_agent.json",
            "marketing_campaign_agent.json",
            "Marketing Campaign Agent (1).json",
            "marketing_knowledge_gatherer_agent.json",
            "marketing_research_agent.json",
            "Email_Marketing_Agent.json",
            "email_marketing_agent.json",
            "newsletter_agent.json"
        ],
        # Social media domain workflows
        "social_media": [
            "facebook_agent.json",
            "instagram_agent.json",
            "pinterest_agent.json"
        ],
        # Analytics domain workflows
        "analytics": [
            "data_insights_agent.json",
            "data_extraction_agent.json"
        ],
        # Product domain workflows
        "product": [
            "color_analysis_agent.json",
            "pictorem_agent.json",
            "product_agent.json"
        ],
        # Customer experience domain workflows
        "customer_experience": [
            "customer_service_agent.json",
            "customer_relationship_agent.json",
            "customer_agent.json"
        ],
        # Operations domain workflows
        "operations": [
            "lead-generation-workflow.json",
            "appointment_setter_agent.json"
        ]
    }
    
    # Integration workflows
    integration_mappings = {
        "external/shopify": [
            "shopify_agent.json",
            "shopify_variant_products_automation.json"
        ],
        "internal/database": [
            "extract_supabase_research_reports_node.json",
            "extract_search_results_vectors.json"
        ],
        "internal/mcp": [
            "example-mcp-tools-workflow.json"
        ]
    }
    
    # Utility workflows
    utility_mappings = {
        "data-processing/knowledge-extraction": [
            "customer_experience_knowledge_gatherer_agent.json",
            "finance_analytics_knowledge_gatherer_agent.json",
            "operations_knowledge_gatherer_agent.json",
            "product_marketing_knowledge_gatherer_agent.json"
        ],
        "data-processing/research": [
            # Will move research-related workflows here
        ],
        "automation": [
            "task_agent_1.json",
            "task_agent_2.json",
            "task_agent_3.json"
        ]
    }
    
    moved_count = 0
    
    print("Organizing Domain Workflows")
    print("=" * 60)
    
    # Process domain workflows
    for domain, workflows in workflow_mappings.items():
        target_dir = base_dir / "workflows" / "domains" / domain
        target_dir.mkdir(parents=True, exist_ok=True)
        
        print(f"\n{domain.upper()} domain:")
        for workflow in workflows:
            source = base_dir / workflow
            if source.exists():
                dest = target_dir / workflow.replace(" ", "_").lower()
                shutil.move(str(source), str(dest))
                print(f"  ✓ {workflow} → {dest.name}")
                moved_count += 1
            else:
                # Try without spaces
                source_alt = base_dir / workflow.replace(" ", "_")
                if source_alt.exists():
                    dest = target_dir / workflow.replace(" ", "_").lower()
                    shutil.move(str(source_alt), str(dest))
                    print(f"  ✓ {workflow} → {dest.name}")
                    moved_count += 1
    
    # Process integration workflows
    print("\n\nINTEGRATION workflows:")
    for path, workflows in integration_mappings.items():
        target_dir = base_dir / "workflows" / "integrations" / path
        target_dir.mkdir(parents=True, exist_ok=True)
        
        for workflow in workflows:
            source = base_dir / workflow
            if source.exists():
                dest = target_dir / workflow
                shutil.move(str(source), str(dest))
                print(f"  ✓ {workflow} → integrations/{path}/{workflow}")
                moved_count += 1
    
    # Process utility workflows
    print("\n\nUTILITY workflows:")
    for path, workflows in utility_mappings.items():
        target_dir = base_dir / "workflows" / "utilities" / path
        target_dir.mkdir(parents=True, exist_ok=True)
        
        for workflow in workflows:
            source = base_dir / workflow
            if source.exists():
                dest = target_dir / workflow
                shutil.move(str(source), str(dest))
                print(f"  ✓ {workflow} → utilities/{path}/{workflow}")
                moved_count += 1
    
    print(f"\n✓ Organized {moved_count} workflows")
    
    # Check remaining files
    remaining = list(base_dir.glob("*.json"))
    if remaining:
        print(f"\n⚠️ {len(remaining)} files still unorganized:")
        for file in remaining[:10]:
            print(f"  - {file.name}")
        if len(remaining) > 10:
            print(f"  ... and {len(remaining) - 10} more")

if __name__ == "__main__":
    organize_domain_workflows()