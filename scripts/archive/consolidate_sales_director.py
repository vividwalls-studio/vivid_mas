#!/usr/bin/env python3
"""Consolidate Sales Director workflow versions."""

import json
from pathlib import Path
import shutil
from datetime import datetime

def analyze_sales_workflow(file_path):
    """Analyze Sales Director workflow."""
    with open(file_path, 'r') as f:
        data = json.load(f)
    
    nodes = data.get('nodes', [])
    
    # Look for specific features
    has_personas = False
    has_mongodb = False
    has_vector_store = False
    specialist_count = 0
    
    for node in nodes:
        node_type = node.get('type', '')
        node_name = node.get('name', '').lower()
        
        if 'persona' in node_name:
            has_personas = True
        if 'mongodb' in node_type.lower() or 'mongo' in node_name:
            has_mongodb = True
        if 'vector' in node_type.lower() or 'vector' in node_name:
            has_vector_store = True
        if any(spec in node_name for spec in ['hospitality', 'corporate', 'healthcare', 'retail', 'residential']):
            specialist_count += 1
    
    return {
        'name': data.get('name'),
        'nodes': len(nodes),
        'has_personas': has_personas,
        'has_mongodb': has_mongodb,
        'has_vector_store': has_vector_store,
        'specialist_agents': specialist_count,
        'active': data.get('active', False),
        'file_size': file_path.stat().st_size
    }

def main():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    original = base_dir / "sales_director_agent.json"
    enhanced = base_dir / "sales_director_agent_enhanced.json"
    
    print("Sales Director Version Comparison")
    print("=" * 60)
    
    # Analyze both versions
    if original.exists():
        orig_analysis = analyze_sales_workflow(original)
        print(f"\n{original.name}:")
        print(f"  Nodes: {orig_analysis['nodes']}")
        print(f"  Has Personas: {orig_analysis['has_personas']}")
        print(f"  Has MongoDB: {orig_analysis['has_mongodb']}")
        print(f"  Has Vector Store: {orig_analysis['has_vector_store']}")
        print(f"  Specialist Agents: {orig_analysis['specialist_agents']}")
        print(f"  File Size: {orig_analysis['file_size']:,} bytes")
    
    if enhanced.exists():
        enh_analysis = analyze_sales_workflow(enhanced)
        print(f"\n{enhanced.name}:")
        print(f"  Nodes: {enh_analysis['nodes']}")
        print(f"  Has Personas: {enh_analysis['has_personas']}")
        print(f"  Has MongoDB: {enh_analysis['has_mongodb']}")
        print(f"  Has Vector Store: {enh_analysis['has_vector_store']}")
        print(f"  Specialist Agents: {enh_analysis['specialist_agents']}")
        print(f"  File Size: {enh_analysis['file_size']:,} bytes")
    
    print("\n" + "=" * 60)
    print("RECOMMENDATION: Keep sales_director_agent_enhanced.json")
    print("(Enhanced version has specialist personas and MongoDB integration)")
    
    # Load both versions
    with open(original, 'r') as f:
        original_data = json.load(f)
    
    with open(enhanced, 'r') as f:
        enhanced_data = json.load(f)
    
    # Backup enhanced version
    backup_path = str(enhanced) + f'.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}'
    shutil.copy2(enhanced, backup_path)
    
    # Extract vector store config from original if needed
    vector_nodes = []
    for node in original_data.get('nodes', []):
        if 'vector' in node.get('type', '').lower() or 'vector' in node.get('name', '').lower():
            # Check if enhanced version already has this
            has_similar = any(
                'vector' in n.get('name', '').lower() 
                for n in enhanced_data.get('nodes', [])
            )
            if not has_similar:
                vector_nodes.append(node)
    
    features_merged = []
    if vector_nodes:
        print(f"\nMerging {len(vector_nodes)} vector store configurations from original")
        # Add vector nodes to enhanced version
        for node in vector_nodes:
            node['id'] = node.get('id', '') + '_merged'
            enhanced_data['nodes'].append(node)
            features_merged.append(f"Vector config: {node.get('name')}")
    
    # Extract any documentation/notes from original
    if 'description' in original_data and 'description' not in enhanced_data:
        enhanced_data['description'] = original_data['description']
        features_merged.append("Original description/documentation")
    
    # Update metadata
    enhanced_data['updatedAt'] = datetime.now().isoformat()
    enhanced_data['name'] = "Sales Director Agent"  # Standardize name
    
    # Save consolidated version
    with open(enhanced, 'w') as f:
        json.dump(enhanced_data, f, indent=2)
    
    if features_merged:
        print("\nFeatures merged from original:")
        for feature in features_merged:
            print(f"  - {feature}")
    
    # Archive original version
    archive_dir = base_dir / "workflows" / "archive" / "sales_director_versions"
    archive_dir.mkdir(parents=True, exist_ok=True)
    
    dest = archive_dir / original.name
    shutil.move(str(original), str(dest))
    print(f"\nArchived: {original.name}")
    
    # Move enhanced to final location
    final_location = base_dir / "workflows" / "domains" / "sales" / "sales_director_agent.json"
    final_location.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(enhanced), str(final_location))
    print(f"Moved to: {final_location.relative_to(base_dir)}")
    
    print("\n✓ Sales Director consolidation complete!")

if __name__ == "__main__":
    main()