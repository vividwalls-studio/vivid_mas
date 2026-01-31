#!/usr/bin/env python3
"""Migrate core workflows to organized structure."""

import shutil
from pathlib import Path

def migrate_core_workflows():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    # Define core workflow mappings
    workflow_mappings = {
        # Orchestration workflows
        "orchestration": [
            "strategic_orchestrator.json",
            "stakeholder_communications.json",
            "stakeholder_business_marketing_directives.json"
        ],
        # Delegation workflows
        "delegation": [
            "campaign_coordination.json",
            "workflow_automation.json"
        ],
        # Monitoring workflows
        "monitoring": [
            "performance_analytics.json",
            "budget_optimization.json"
        ]
    }
    
    moved_count = 0
    
    print("Migrating Core Workflows")
    print("=" * 60)
    
    for category, workflows in workflow_mappings.items():
        target_dir = base_dir / "workflows" / "core" / category
        target_dir.mkdir(parents=True, exist_ok=True)
        
        print(f"\n{category.upper()} workflows:")
        
        for workflow in workflows:
            source = base_dir / workflow
            if source.exists():
                dest = target_dir / workflow
                shutil.move(str(source), str(dest))
                print(f"  ✓ Moved: {workflow}")
                moved_count += 1
            else:
                print(f"  ✗ Not found: {workflow}")
    
    # Also check for any other core-related workflows
    print("\nChecking for additional core workflows...")
    
    # Patterns that indicate core workflows
    core_patterns = [
        "automation", "integration", "system", "monitor", 
        "orchestrat", "coordinat", "manag"
    ]
    
    remaining_files = list(base_dir.glob("*.json"))
    additional_core = []
    
    for file in remaining_files:
        filename_lower = file.name.lower()
        if any(pattern in filename_lower for pattern in core_patterns):
            # Exclude agent files (those will go to domains)
            if "agent" not in filename_lower:
                additional_core.append(file.name)
    
    if additional_core:
        print(f"\nFound {len(additional_core)} additional core workflow candidates:")
        for workflow in additional_core[:10]:  # Show first 10
            print(f"  - {workflow}")
        if len(additional_core) > 10:
            print(f"  ... and {len(additional_core) - 10} more")
    
    print(f"\n✓ Migrated {moved_count} core workflows")
    return moved_count

if __name__ == "__main__":
    migrate_core_workflows()