#!/usr/bin/env python3
"""Clean up empty directories in the workflows structure."""

import os
from pathlib import Path

def remove_empty_dirs(root_path):
    """Remove empty directories recursively."""
    removed_dirs = []
    
    # Walk bottom-up to handle nested empty directories
    for dirpath, dirnames, filenames in os.walk(root_path, topdown=False):
        # Skip if it's the root path itself
        if dirpath == str(root_path):
            continue
            
        # Check if directory is empty (no files and no remaining subdirs)
        if not filenames and not os.listdir(dirpath):
            try:
                os.rmdir(dirpath)
                removed_dirs.append(dirpath)
                print(f"  ✅ Removed empty directory: {Path(dirpath).relative_to(root_path)}")
            except OSError as e:
                print(f"  ⚠️  Could not remove {dirpath}: {e}")
    
    return removed_dirs

def main():
    """Main function to clean up empty directories."""
    workflows_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows")
    
    print("Cleaning up empty directories in workflows structure")
    print("=" * 80)
    
    # Remove empty directories
    removed = remove_empty_dirs(workflows_dir)
    
    if removed:
        print(f"\nTotal empty directories removed: {len(removed)}")
    else:
        print("\nNo empty directories found.")
    
    # Also check and clean the services/workflows directory if it exists
    services_workflows = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/workflows")
    if services_workflows.exists() and not any(services_workflows.iterdir()):
        try:
            services_workflows.rmdir()
            print(f"\n✅ Removed empty services/workflows directory")
        except OSError as e:
            print(f"\n⚠️  Could not remove services/workflows: {e}")

if __name__ == "__main__":
    main()