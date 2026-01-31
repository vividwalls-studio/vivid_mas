#!/usr/bin/env python3
"""Merge features from different Business Manager workflow versions."""

import json
from pathlib import Path
import shutil
from datetime import datetime

def extract_telegram_config(workflow_data):
    """Extract Telegram tool configuration from workflow."""
    telegram_nodes = []
    
    nodes = workflow_data.get('nodes', [])
    if isinstance(nodes, list):
        for node in nodes:
            # Look for Telegram-related nodes
            if 'telegram' in node.get('type', '').lower() or \
               'telegram' in node.get('name', '').lower():
                telegram_nodes.append(node)
    
    return telegram_nodes

def extract_schedule_triggers(workflow_data):
    """Extract schedule trigger configurations."""
    schedule_nodes = []
    
    nodes = workflow_data.get('nodes', [])
    if isinstance(nodes, list):
        for node in nodes:
            # Look for schedule/cron trigger nodes
            if node.get('type') == 'n8n-nodes-base.scheduleTrigger' or \
               node.get('type') == 'n8n-nodes-base.cronTrigger':
                schedule_nodes.append(node)
    
    return schedule_nodes

def merge_features(target_file, source_files):
    """Merge features from source files into target file."""
    # Load target workflow
    with open(target_file, 'r') as f:
        target_data = json.load(f)
    
    # Backup target before modification
    backup_path = str(target_file) + f'.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}'
    shutil.copy2(target_file, backup_path)
    print(f"Created backup: {backup_path}")
    
    features_merged = []
    
    # Extract features from each source
    for source_file in source_files:
        if not source_file.exists():
            continue
            
        with open(source_file, 'r') as f:
            source_data = json.load(f)
        
        # Extract Telegram config from Business Manager Agent.json
        if source_file.name == "Business Manager Agent.json":
            telegram_nodes = extract_telegram_config(source_data)
            if telegram_nodes:
                print(f"Found {len(telegram_nodes)} Telegram nodes in {source_file.name}")
                
                # Check if target already has Telegram nodes
                existing_telegram = extract_telegram_config(target_data)
                if not existing_telegram:
                    # Add Telegram nodes to target
                    if isinstance(target_data.get('nodes'), list):
                        for node in telegram_nodes:
                            # Give unique IDs to avoid conflicts
                            node['id'] = node.get('id', '') + '_merged'
                            target_data['nodes'].append(node)
                            features_merged.append(f"Telegram node: {node.get('name')}")
            
            # Extract schedule triggers
            schedule_nodes = extract_schedule_triggers(source_data)
            if schedule_nodes:
                print(f"Found {len(schedule_nodes)} schedule triggers in {source_file.name}")
                
                existing_schedules = extract_schedule_triggers(target_data)
                if not existing_schedules:
                    if isinstance(target_data.get('nodes'), list):
                        for node in schedule_nodes:
                            node['id'] = node.get('id', '') + '_merged'
                            target_data['nodes'].append(node)
                            features_merged.append(f"Schedule trigger: {node.get('name')}")
    
    # Update metadata
    target_data['updatedAt'] = datetime.now().isoformat()
    if 'description' in target_data:
        target_data['description'] += "\n\nMerged features from other versions."
    else:
        target_data['description'] = "Business Manager Agent - consolidated version with merged features."
    
    # Save merged version
    with open(target_file, 'w') as f:
        json.dump(target_data, f, indent=2)
    
    return features_merged

def main():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    # Target file (the one we're keeping)
    target = base_dir / "business_manager_updated_complete.json"
    
    # Source files to merge features from
    sources = [
        base_dir / "Business Manager Agent.json",
        base_dir / "business_manager_workflow.json"
    ]
    
    print("Merging Business Manager workflow features...")
    print(f"Target: {target.name}")
    print(f"Sources: {[s.name for s in sources if s.exists()]}")
    print()
    
    # Perform merge
    merged_features = merge_features(target, sources)
    
    if merged_features:
        print("\nMerged features:")
        for feature in merged_features:
            print(f"  - {feature}")
    else:
        print("\nNo new features to merge (target already has all features)")
    
    # Archive source files
    archive_dir = base_dir / "workflows" / "archive" / "business_manager_versions"
    archive_dir.mkdir(parents=True, exist_ok=True)
    
    for source in sources:
        if source.exists():
            dest = archive_dir / source.name
            shutil.move(str(source), str(dest))
            print(f"\nArchived: {source.name} → {dest.relative_to(base_dir)}")
    
    # Move target to proper location
    final_location = base_dir / "workflows" / "core" / "orchestration" / "business_manager_agent.json"
    final_location.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(str(target), str(final_location))
    print(f"\nCopied to final location: {final_location.relative_to(base_dir)}")
    
    # Remove original after successful copy
    target.unlink()
    print(f"Removed original: {target.name}")
    
    print("\n✓ Business Manager consolidation complete!")

if __name__ == "__main__":
    main()