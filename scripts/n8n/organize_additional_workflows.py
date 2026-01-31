#!/usr/bin/env python3
"""Organize the additional 27 workflows found in services/workflows directory."""

import json
import shutil
from pathlib import Path

# Source and destination directories
source_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/workflows")
agents_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows")

# Workflow categorization based on names
workflow_mapping = {
    # Core Business Manager workflows
    "VividWalls-Business-Manager-MCP-Agent.json": "core/directors/",
    "VividWalls-Business-Manager-Orchestration.json": "core/orchestration/",
    
    # Marketing workflows
    "VividWalls-Content-Marketing-Human-Approval-Agent.json": "domains/marketing/",
    "VividWalls-Content-Marketing-MCP-Agent.json": "domains/marketing/",
    "VividWalls-Marketing-Campaign-Human-Approval-Agent.json": "domains/marketing/",
    "VividWalls-Marketing-Research-Agent.json": "domains/marketing/",
    "VividWalls-Monthly-Newsletter-Campaign.json": "domains/marketing/",
    "VividWalls-Newsletter-Signup-Automation.json": "domains/marketing/",
    "VividWalls-SEO-Conversion-Funnel.json": "domains/marketing/",
    "VividWalls_Lead_Generation_Advanced.json": "domains/marketing/",
    
    # Sales workflows
    "VividWalls-Sales-Agent-WordPress-Enhanced.json": "domains/sales/",
    "VividWalls-Sales-Agent.json": "domains/sales/",
    
    # Customer Experience workflows
    "VividWalls-Customer-Relationship-Human-Approval-Agent.json": "domains/customer-experience/",
    "VividWalls-Customer-Relationship-MCP-Agent.json": "domains/customer-experience/",
    
    # Operations workflows
    "VividWalls-Orders-Fulfillment-Agent.json": "domains/operations/",
    "ecommerce-order-fulfillment-workflow.json": "domains/operations/",
    
    # Product/Creative workflows
    "VividWalls-Artwork-Color-Analysis.json": "domains/creative/",
    "VividWalls-Prompt-Chain-Image-Retrieval.json": "domains/creative/",
    
    # Integration workflows
    "VividWalls-Database-Integration-Workflow.json": "integrations/database/",
    "VividWalls-Test-Database-Connection.json": "integrations/database/",
    "vividwalls-inventory-metafield-sync.json": "integrations/ecommerce/",
    
    # Utility workflows
    "VividWalls_CSV_Email_Import_Cleaner.json": "utilities/data-processing/",
    "knowledge_graph_expansion_workflow.json": "utilities/data-processing/knowledge-extraction/",
    
    # AI/Chat workflows
    "VividWalls Knowledge Base AI Agent.json": "integrations/ai/",
    "chatbot-workflow.json": "integrations/ai/",
    "ai-agent-mcp-example.json": "integrations/ai/",
    "ai-agent-native-mcp-example.json": "integrations/ai/",
    
    # System/Overview workflows
    "VividWalls Multi-Agent System Workflow Overview.json": "core/system/",
    "n8n_documentation.json": "utilities/documentation/"
}

def organize_workflows():
    """Organize workflows into proper structure."""
    print("Organizing Additional Workflows")
    print("=" * 80)
    
    # Create archive for workflows
    archive_dir = agents_dir / "archive" / "migrated_from_services_workflows"
    archive_dir.mkdir(parents=True, exist_ok=True)
    
    moved_count = 0
    archived_count = 0
    
    # Process each workflow
    for workflow_file in source_dir.glob("*.json"):
        if workflow_file.name in workflow_mapping:
            # Move to designated location
            dest_subdir = workflow_mapping[workflow_file.name]
            dest_path = agents_dir / dest_subdir / workflow_file.name
            
            # Create destination directory if needed
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Check if file already exists
            if dest_path.exists():
                # Archive the new one as duplicate
                archive_path = archive_dir / f"duplicate_{workflow_file.name}"
                shutil.copy2(workflow_file, archive_path)
                print(f"  📦 Archived duplicate: {workflow_file.name}")
                archived_count += 1
            else:
                # Move to proper location
                shutil.move(str(workflow_file), str(dest_path))
                print(f"  ✅ Moved to {dest_subdir}: {workflow_file.name}")
                moved_count += 1
        else:
            # Unknown workflow - archive it
            archive_path = archive_dir / workflow_file.name
            shutil.move(str(workflow_file), str(archive_path))
            print(f"  📦 Archived unknown: {workflow_file.name}")
            archived_count += 1
    
    # Move documentation files
    doc_count = 0
    for doc_file in source_dir.glob("*.md"):
        doc_dest = agents_dir / "archive" / "documentation_from_services" / doc_file.name
        doc_dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(doc_file), str(doc_dest))
        print(f"  📄 Moved documentation: {doc_file.name}")
        doc_count += 1
    
    # Handle archived workflows subdirectory
    archived_dir = source_dir / "archived_workflows"
    if archived_dir.exists():
        archive_dest = agents_dir / "archive" / "imported_archive"
        shutil.move(str(archived_dir), str(archive_dest))
        print(f"  📦 Moved archived_workflows directory")
    
    print("\n" + "=" * 80)
    print(f"Summary:")
    print(f"  Moved to structure: {moved_count}")
    print(f"  Archived: {archived_count}")
    print(f"  Documentation: {doc_count}")
    
    return moved_count, archived_count, doc_count

def validate_additions():
    """Validate the newly added workflows."""
    print("\nValidating Newly Added Workflows")
    print("=" * 80)
    
    issues = []
    
    for dest_subdir in set(workflow_mapping.values()):
        dir_path = agents_dir / dest_subdir
        if dir_path.exists():
            for json_file in dir_path.glob("VividWalls*.json"):
                try:
                    with open(json_file, 'r') as f:
                        data = json.load(f)
                    
                    # Basic validation
                    if not data.get('name'):
                        issues.append(f"{json_file.name}: Missing name")
                    if not data.get('nodes'):
                        issues.append(f"{json_file.name}: No nodes")
                    
                except json.JSONDecodeError:
                    issues.append(f"{json_file.name}: Invalid JSON")
    
    if issues:
        print("Issues found:")
        for issue in issues:
            print(f"  ⚠️  {issue}")
    else:
        print("  ✅ All newly added workflows are valid JSON")
    
    return len(issues)

if __name__ == "__main__":
    # Check if source directory exists
    if not source_dir.exists():
        print(f"Source directory not found: {source_dir}")
        exit(1)
    
    # Organize workflows
    moved, archived, docs = organize_workflows()
    
    # Validate additions
    issues = validate_additions()
    
    print(f"\nWorkflow organization complete!")
    print(f"Total files processed: {moved + archived + docs}")