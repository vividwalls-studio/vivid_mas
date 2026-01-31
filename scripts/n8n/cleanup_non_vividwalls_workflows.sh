#!/bin/bash

# Cleanup non-VividWalls workflows from n8n
# This removes Deal Flow, DesignThru-AI, test workflows, and workflows with problematic nodes

echo "==================================="
echo "Non-VividWalls Workflow Cleanup"
echo "==================================="
echo ""

# Workflows to remove (patterns)
NON_VIVIDWALLS_PATTERNS=(
    "Deal Flow"
    "DesignThru"
    "Pitch Book"
    "Equity Deal"
    "PR_Deal"
    "Test Workflow"
    "Debug Test"
    "workflow to delete"
    "My workflow"
    "PE Deal"
)

# Function to check if workflow should be removed
should_remove_workflow() {
    local name="$1"
    for pattern in "${NON_VIVIDWALLS_PATTERNS[@]}"; do
        if [[ "$name" == *"$pattern"* ]]; then
            return 0  # Should remove
        fi
    done
    return 1  # Should keep
}

# Access n8n directly via docker
echo "Accessing n8n workflows via UI credentials..."
echo ""

# Get list of workflows through n8n CLI
docker exec n8n n8n list:workflow 2>/dev/null | while IFS='│' read -r id name active; do
    # Skip header rows
    if [[ "$id" == *"ID"* ]] || [[ "$id" == *"─"* ]]; then
        continue
    fi
    
    # Clean up the fields
    id=$(echo "$id" | xargs)
    name=$(echo "$name" | xargs)
    active=$(echo "$active" | xargs)
    
    if [ ! -z "$id" ] && [ ! -z "$name" ]; then
        if should_remove_workflow "$name"; then
            echo "❌ REMOVE: $name (ID: $id)"
            # Uncomment to actually delete:
            # docker exec n8n n8n delete:workflow --id="$id" 2>/dev/null && echo "   ✅ Deleted"
        else
            # Check if it's a VividWalls workflow
            if [[ "$name" == *"VividWalls"* ]] || [[ "$name" == *"Director"* ]] || [[ "$name" == *"Agent"* ]]; then
                echo "✅ KEEP: $name"
            fi
        fi
    fi
done

echo ""
echo "==================================="
echo "Workflow Cleanup Summary"
echo "==================================="
echo ""
echo "To actually delete the workflows, uncomment the delete command in the script."
echo ""
echo "Problematic node types to watch for:"
echo "- @n8n/n8n-nodes-langchain.vectorStoreAirtableSearch"
echo "- Any Airtable-specific nodes"
echo "- Non-standard vector store implementations"
echo ""
echo "These nodes cause webhook errors and should be replaced with:"
echo "- Supabase vector store"
echo "- Qdrant vector store"
echo "- Standard n8n nodes"