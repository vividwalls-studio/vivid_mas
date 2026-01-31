#!/usr/bin/env python3
"""Direct removal of known duplicate files."""

import os
import shutil
from pathlib import Path
from datetime import datetime

# Base directory
BASE_DIR = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")

# List of files that are safe to remove (from the duplicate analysis)
FILES_TO_REMOVE = [
    "normalized_update_data.json",
    "final_research_reports_supabase_node.json", 
    "director_id_mappings.json",
    "business_manager_current.json",
    "streamlined_supabase_research_reports_node.json",
    "updated_research_reports_supabase_node.json",
    "corrected_research_reports_supabase_node.json",
    "business_manager_new_nodes.json",
    "marketing_director_mcp_integration_example.json",
    "facebook_marketing_knowledge_gatherer_agent.json",
    "pinterest_marketing_knowledge_gatherer_agent.json",
    "instagram_marketing_knowledge_gatherer_agent.json",
    "optimized_supabase_research_reports_node.json",
    "research_reports_supabase_node.json",
    "vector_population_supabase_node.json"
]

def main():
    # Create archive directory
    archive_dir = BASE_DIR / "workflows" / "archive" / "duplicates"
    archive_dir.mkdir(parents=True, exist_ok=True)
    
    removed = 0
    not_found = 0
    
    print("Removing duplicate workflow files...")
    
    for filename in FILES_TO_REMOVE:
        file_path = BASE_DIR / filename
        
        if file_path.exists():
            # Archive the file
            archive_path = archive_dir / filename
            shutil.move(str(file_path), str(archive_path))
            print(f"✓ Archived: {filename}")
            removed += 1
        else:
            print(f"✗ Not found: {filename}")
            not_found += 1
    
    print(f"\nSummary:")
    print(f"- Files archived: {removed}")
    print(f"- Files not found: {not_found}")
    print(f"- Archive location: {archive_dir}")

if __name__ == "__main__":
    main()