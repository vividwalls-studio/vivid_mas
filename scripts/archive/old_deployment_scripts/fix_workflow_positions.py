#!/usr/bin/env python3
"""
Fix extreme node positions in Business Manager Agent workflow
and ensure proper zoom level when opening
"""

import json
import sys

def normalize_positions(nodes):
    """Normalize node positions to reasonable values centered around origin"""
    
    # Find extreme positions
    min_x = float('inf')
    max_x = float('-inf')
    min_y = float('inf')
    max_y = float('-inf')
    
    for node in nodes:
        if 'position' in node and len(node['position']) == 2:
            x, y = node['position']
            min_x = min(min_x, x)
            max_x = max(max_x, x)
            min_y = min(min_y, y)
            max_y = max(max_y, y)
    
    print(f"Original position range: X({min_x} to {max_x}), Y({min_y} to {max_y})")
    
    # Calculate center and normalize
    center_x = (min_x + max_x) / 2
    center_y = (min_y + max_y) / 2
    
    # Target center position (reasonable canvas area)
    target_center_x = 1000
    target_center_y = 500
    
    # Calculate offset
    offset_x = target_center_x - center_x
    offset_y = target_center_y - center_y
    
    # Apply normalization
    normalized_nodes = []
    for node in nodes:
        node_copy = node.copy()
        if 'position' in node_copy and len(node_copy['position']) == 2:
            old_x, old_y = node_copy['position']
            # Normalize extreme positions
            if abs(old_x) > 10000:
                # Bring extreme positions to a reasonable range
                new_x = target_center_x + (old_x / abs(old_x)) * 2000  # Max 2000 units from center
            else:
                new_x = old_x + offset_x
            
            if abs(old_y) > 10000:
                new_y = target_center_y + (old_y / abs(old_y)) * 1000  # Max 1000 units from center
            else:
                new_y = old_y + offset_y
                
            node_copy['position'] = [int(new_x), int(new_y)]
            
            if abs(old_x) > 10000 or abs(old_y) > 10000:
                print(f"Fixed {node['name']}: [{old_x}, {old_y}] -> [{int(new_x)}, {int(new_y)}]")
        
        normalized_nodes.append(node_copy)
    
    return normalized_nodes

def main():
    # Read the current workflow data
    with open('precise_update_data.json', 'r') as f:
        data = json.load(f)
    
    # Normalize positions
    data['nodes'] = normalize_positions(data['nodes'])
    
    # Ensure workflow settings for proper zoom
    # (n8n doesn't expose zoom settings via API, but proper positioning helps)
    
    # Write normalized data
    with open('normalized_update_data.json', 'w') as f:
        json.dump(data, f, indent=2)
    
    print("\n✅ Created normalized update data with fixed positions")
    print("📁 Output: normalized_update_data.json")

if __name__ == "__main__":
    main()