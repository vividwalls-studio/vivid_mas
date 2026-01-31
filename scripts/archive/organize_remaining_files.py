#!/usr/bin/env python3
"""Organize remaining configuration and utility files."""

import shutil
from pathlib import Path

def organize_remaining():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    # Create archive for config/test files
    config_archive = base_dir / "workflows" / "archive" / "config_and_test"
    config_archive.mkdir(parents=True, exist_ok=True)
    
    # Files to archive (config/test/partial files)
    archive_files = [
        "clean_update_data.json",
        "connections_only.json",
        "customer_segments_config.json",
        "minimal_update.json",
        "nodes_only.json",
        "precise_update_data.json",
        "workflow_update_payload.json"
    ]
    
    # Workflows to organize
    workflow_mappings = {
        "operations": ["orders_fulfillment_agent.json"],
        "utilities/data-processing/research": ["research_report_output_parser.json"],
        "utilities/automation": [
            "task_agent_1_mcp_integration.json",
            "task_agent_2_workflow_implementation.json",
            "task_agent_3_vector_store_integration.json",
            "task_agent_5_error_handling.json"
        ]
    }
    
    print("Organizing Remaining Files")
    print("=" * 60)
    
    # Archive config/test files
    print("\nArchiving configuration/test files:")
    archived = 0
    for filename in archive_files:
        source = base_dir / filename
        if source.exists():
            dest = config_archive / filename
            shutil.move(str(source), str(dest))
            print(f"  ✓ Archived: {filename}")
            archived += 1
    
    # Organize remaining workflows
    print("\nOrganizing remaining workflows:")
    moved = 0
    for path, workflows in workflow_mappings.items():
        if "/" in path:
            domain, subpath = path.split("/", 1)
            target_dir = base_dir / "workflows" / domain / subpath
        else:
            target_dir = base_dir / "workflows" / "domains" / path
            
        target_dir.mkdir(parents=True, exist_ok=True)
        
        for workflow in workflows:
            source = base_dir / workflow
            if source.exists():
                dest = target_dir / workflow
                shutil.move(str(source), str(dest))
                print(f"  ✓ {workflow} → {path}/{workflow}")
                moved += 1
    
    print(f"\n✓ Archived {archived} config/test files")
    print(f"✓ Organized {moved} workflows")
    
    # Final check
    remaining = list(base_dir.glob("*.json"))
    if remaining:
        print(f"\n⚠️ Still have {len(remaining)} unorganized files:")
        for f in remaining:
            print(f"  - {f.name}")
    else:
        print("\n✅ All files organized!")

if __name__ == "__main__":
    organize_remaining()