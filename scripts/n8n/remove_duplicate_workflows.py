#!/usr/bin/env python3
"""
Script to safely remove duplicate n8n workflows
Archives duplicates before removal for safety
"""

import json
import os
import shutil
from datetime import datetime
from pathlib import Path

def load_duplicate_analysis(analysis_file):
    """Load the duplicate analysis results"""
    with open(analysis_file, 'r') as f:
        return json.load(f)

def create_archive_directory():
    """Create archive directory for removed duplicates"""
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    archive_dir = Path(f'/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/archive/duplicates_{timestamp}')
    archive_dir.mkdir(parents=True, exist_ok=True)
    return archive_dir

def archive_and_remove(file_path, archive_dir):
    """Archive a file before removing it"""
    source = Path(file_path)
    if not source.exists():
        print(f"Warning: File not found: {file_path}")
        return False
    
    # Create relative path in archive
    relative_path = source.name
    dest = archive_dir / relative_path
    
    # Copy to archive
    shutil.copy2(source, dest)
    print(f"Archived: {source.name} → archive/duplicates_{archive_dir.name.split('_', 1)[1]}/")
    
    # Remove original
    source.unlink()
    print(f"Removed: {file_path}")
    
    return True

def main():
    # Load duplicate analysis
    analysis_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_duplicate_analysis.json'
    analysis = load_duplicate_analysis(analysis_file)
    
    # Get safe to remove files
    safe_to_remove = analysis['duplicate_analysis']['removal_impact']['safe_to_remove']
    
    print(f"Found {len(safe_to_remove)} files safe to remove")
    print("\nFiles to be removed:")
    for file in safe_to_remove:
        print(f"  - {Path(file).name}")
    
    # Confirm with user
    response = input("\nProceed with archiving and removal? (y/n): ")
    if response.lower() != 'y':
        print("Operation cancelled")
        return
    
    # Create archive directory
    archive_dir = create_archive_directory()
    print(f"\nArchiving to: {archive_dir}")
    
    # Process removals
    success_count = 0
    for file_path in safe_to_remove:
        if archive_and_remove(file_path, archive_dir):
            success_count += 1
    
    print(f"\nCompleted: {success_count}/{len(safe_to_remove)} files archived and removed")
    
    # Create removal log
    log_file = archive_dir / 'removal_log.json'
    with open(log_file, 'w') as f:
        json.dump({
            'timestamp': datetime.now().isoformat(),
            'files_removed': safe_to_remove,
            'success_count': success_count,
            'archive_location': str(archive_dir)
        }, f, indent=2)
    
    print(f"Removal log saved to: {log_file}")

if __name__ == "__main__":
    main()