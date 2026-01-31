#!/usr/bin/env python3
"""Compare Business Manager workflow versions to identify the best one to keep."""

import json
from pathlib import Path

def analyze_workflow(file_path):
    """Analyze a workflow file and extract key metrics."""
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
        
        # Handle both full workflows and truncated ones
        nodes = data.get('nodes', [])
        if isinstance(nodes, str):
            # Truncated
            node_count = "Unknown (truncated)"
        else:
            node_count = len(nodes)
        
        connections = data.get('connections', {})
        
        # Check for MCP tools
        mcp_tools = []
        if isinstance(nodes, list):
            for node in nodes:
                if node.get('type') == 'n8n-nodes-mcp.mcpClientTool':
                    mcp_tools.append(node.get('parameters', {}).get('serverName', 'unknown'))
        
        return {
            'name': data.get('name', 'Unknown'),
            'id': data.get('id', 'no_id'),
            'active': data.get('active', False),
            'node_count': node_count,
            'connection_count': len(connections),
            'has_mcp': len(mcp_tools) > 0,
            'mcp_tools': mcp_tools,
            'created': data.get('createdAt', 'Unknown'),
            'updated': data.get('updatedAt', 'Unknown'),
            'file_size': file_path.stat().st_size
        }
    except Exception as e:
        return {'error': str(e)}

def main():
    base_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents")
    
    files = [
        "Business Manager Agent.json",
        "business_manager_workflow.json", 
        "business_manager_updated_complete.json"
    ]
    
    print("Business Manager Workflow Version Comparison")
    print("=" * 60)
    
    analyses = {}
    for filename in files:
        file_path = base_dir / filename
        if file_path.exists():
            analyses[filename] = analyze_workflow(file_path)
    
    # Display comparison
    for filename, analysis in analyses.items():
        print(f"\n{filename}:")
        print(f"  Name: {analysis.get('name', 'Unknown')}")
        print(f"  Nodes: {analysis.get('node_count', 'Unknown')}")
        print(f"  Connections: {analysis.get('connection_count', 0)}")
        print(f"  Has MCP: {analysis.get('has_mcp', False)}")
        print(f"  File Size: {analysis.get('file_size', 0):,} bytes")
        print(f"  Active: {analysis.get('active', False)}")
        print(f"  Updated: {analysis.get('updated', 'Unknown')}")
        
        if analysis.get('mcp_tools'):
            print(f"  MCP Tools: {', '.join(analysis['mcp_tools'])}")
    
    # Recommendation
    print("\n" + "=" * 60)
    print("RECOMMENDATION:")
    
    # Find the best version based on criteria
    best = None
    best_score = 0
    
    for filename, analysis in analyses.items():
        if 'error' in analysis:
            continue
            
        score = 0
        # Scoring criteria
        if isinstance(analysis.get('node_count'), int):
            score += analysis['node_count']  # More nodes = more complete
        if analysis.get('has_mcp'):
            score += 50  # MCP integration is important
        if 'updated_complete' in filename:
            score += 20  # Filename indicates completeness
        if analysis.get('file_size', 0) > 60000:
            score += 10  # Larger files likely more complete
        
        if score > best_score:
            best_score = score
            best = filename
    
    if best:
        print(f"Keep: {best}")
        print(f"Reason: Highest completeness score ({best_score})")
        
        # List features to merge from others
        print("\nFeatures to merge from other versions:")
        for filename, analysis in analyses.items():
            if filename != best and 'error' not in analysis:
                print(f"\nFrom {filename}:")
                # Identify unique features
                if filename == "Business Manager Agent.json":
                    print("  - Original Telegram tool configuration")
                    print("  - Schedule trigger settings")
                elif filename == "business_manager_workflow.json":
                    print("  - Any unique workflow automation features")

if __name__ == "__main__":
    main()