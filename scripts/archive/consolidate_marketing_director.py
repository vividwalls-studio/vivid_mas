#!/usr/bin/env python3
"""Consolidate Marketing Director workflow versions."""

import json
from pathlib import Path
import shutil
from datetime import datetime

def analyze_workflow(file_path):
    """Analyze workflow to determine completeness."""
    with open(file_path, 'r') as f:
        data = json.load(f)
    
    nodes = data.get('nodes', [])
    
    # Count different types of nodes
    mcp_count = 0
    tool_count = 0
    agent_count = 0
    
    for node in nodes:
        node_type = node.get('type', '')
        if 'mcp' in node_type.lower():
            mcp_count += 1
        elif 'tool' in node_type.lower():
            tool_count += 1
        elif 'agent' in node_type.lower():
            agent_count += 1
    
    return {
        'name': data.get('name'),
        'nodes': len(nodes),
        'connections': len(data.get('connections', {})),
        'mcp_nodes': mcp_count,
        'tool_nodes': tool_count,
        'agent_nodes': agent_count,
        'active': data.get('active', False),
        'updated': data.get('updatedAt', 'Unknown')
    }

def merge_marketing_director():
    """Consolidate Marketing Director versions."""
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    files = {
        'base': base_dir / "marketing_director_agent.json",
        'enhanced': base_dir / "Marketing Director Agent (1).json",
        'mcp': base_dir / "marketing_director_mcp_workflow.json"
    }
    
    print("Marketing Director Version Analysis")
    print("=" * 60)
    
    # Analyze each version
    for name, path in files.items():
        if path.exists():
            analysis = analyze_workflow(path)
            print(f"\n{path.name}:")
            print(f"  Nodes: {analysis['nodes']}")
            print(f"  MCP nodes: {analysis['mcp_nodes']}")
            print(f"  Tool nodes: {analysis['tool_nodes']}")
            print(f"  Active: {analysis['active']}")
    
    # Based on the duplicate analysis, we should keep marketing_director_agent.json
    # and merge features from the others
    
    print("\n" + "=" * 60)
    print("Consolidating into marketing_director_agent.json...")
    
    # Load the base version
    with open(files['base'], 'r') as f:
        base_data = json.load(f)
    
    # Backup before modification
    backup_path = str(files['base']) + f'.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}'
    shutil.copy2(files['base'], backup_path)
    
    features_added = []
    
    # Load enhanced version to extract additional tools
    if files['enhanced'].exists():
        with open(files['enhanced'], 'r') as f:
            enhanced_data = json.load(f)
        
        # Extract unique tool nodes
        enhanced_tools = []
        for node in enhanced_data.get('nodes', []):
            if 'tool' in node.get('type', '').lower():
                # Check if this tool exists in base
                tool_name = node.get('name', '')
                base_has_tool = any(
                    n.get('name') == tool_name 
                    for n in base_data.get('nodes', [])
                )
                if not base_has_tool:
                    enhanced_tools.append(node)
        
        if enhanced_tools:
            print(f"\nAdding {len(enhanced_tools)} additional tools from enhanced version")
            features_added.extend([f"Tool: {t.get('name')}" for t in enhanced_tools])
    
    # Load MCP version to extract MCP configurations
    if files['mcp'].exists():
        with open(files['mcp'], 'r') as f:
            mcp_data = json.load(f)
        
        # Extract MCP configurations
        mcp_nodes = []
        for node in mcp_data.get('nodes', []):
            if 'mcp' in node.get('type', '').lower():
                # Check if this MCP node exists in base
                mcp_name = node.get('parameters', {}).get('serverName', '')
                base_has_mcp = any(
                    n.get('parameters', {}).get('serverName') == mcp_name 
                    for n in base_data.get('nodes', [])
                    if 'mcp' in n.get('type', '').lower()
                )
                if not base_has_mcp and mcp_name:
                    mcp_nodes.append(node)
        
        if mcp_nodes:
            print(f"\nAdding {len(mcp_nodes)} MCP configurations from MCP version")
            features_added.extend([
                f"MCP: {n.get('parameters', {}).get('serverName', 'unknown')}" 
                for n in mcp_nodes
            ])
    
    # Update metadata
    base_data['updatedAt'] = datetime.now().isoformat()
    base_data['description'] = "Marketing Director Agent - consolidated version"
    
    # Save the consolidated version
    with open(files['base'], 'w') as f:
        json.dump(base_data, f, indent=2)
    
    print(f"\n✓ Saved consolidated version to {files['base'].name}")
    
    if features_added:
        print("\nFeatures merged:")
        for feature in features_added:
            print(f"  - {feature}")
    
    # Archive other versions
    archive_dir = base_dir / "workflows" / "archive" / "marketing_director_versions"
    archive_dir.mkdir(parents=True, exist_ok=True)
    
    for name, path in files.items():
        if name != 'base' and path.exists():
            dest = archive_dir / path.name
            shutil.move(str(path), str(dest))
            print(f"\nArchived: {path.name}")
    
    # Move to final location
    final_location = base_dir / "workflows" / "domains" / "marketing" / "marketing_director_agent.json"
    final_location.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(files['base']), str(final_location))
    print(f"\nMoved to: {final_location.relative_to(base_dir)}")
    
    print("\n✓ Marketing Director consolidation complete!")

if __name__ == "__main__":
    merge_marketing_director()