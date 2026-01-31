#!/usr/bin/env python3
"""
Create a clean workflow update with only the essential fields
"""

import json

def clean_node(node):
    """Remove fields that might cause validation errors"""
    # Essential fields for update
    essential_fields = ['id', 'name', 'type', 'typeVersion', 'position', 'parameters']
    
    # Additional fields that might be allowed
    optional_fields = ['credentials', 'description']
    
    # Fields to definitely exclude
    exclude_fields = ['webhookId', '__rl', 'cachedResultName', 'matchingColumns', 'schema', 
                     'attemptToConvertTypes', 'convertFieldsToString']
    
    cleaned = {}
    for key, value in node.items():
        if key in essential_fields or key in optional_fields:
            if key == 'parameters' and isinstance(value, dict):
                # Clean parameters recursively
                cleaned_params = {}
                for pk, pv in value.items():
                    if pk not in exclude_fields:
                        if isinstance(pv, dict) and '__rl' in pv:
                            # Clean __rl objects
                            cleaned_params[pk] = {
                                'value': pv.get('value'),
                                'mode': pv.get('mode', 'list')
                            }
                        else:
                            cleaned_params[pk] = pv
                cleaned[key] = cleaned_params
            else:
                cleaned[key] = value
    
    return cleaned

def main():
    # Read normalized data
    with open('normalized_update_data.json', 'r') as f:
        data = json.load(f)
    
    # Clean nodes
    cleaned_nodes = []
    for node in data['nodes']:
        cleaned_nodes.append(clean_node(node))
    
    # Create minimal update payload
    update_data = {
        'workflowId': data['workflowId'],
        'name': data['name'],
        'nodes': cleaned_nodes,
        'connections': data['connections'],
        'active': data['active'],
        'tags': data['tags']
    }
    
    # Write cleaned data
    with open('clean_update_data.json', 'w') as f:
        json.dump(update_data, f, indent=2)
    
    print("✅ Created clean update data")
    print(f"📁 Output: clean_update_data.json")
    print(f"📊 Nodes: {len(cleaned_nodes)}")

if __name__ == "__main__":
    main()