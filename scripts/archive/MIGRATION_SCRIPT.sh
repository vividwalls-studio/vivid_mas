#!/bin/bash

# VividWalls MAS Workflow Optimization Migration Script
# This script safely archives redundant workflows after optimization

# Set paths
WORKFLOW_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows"
ARCHIVE_DIR="$WORKFLOW_DIR/archived/$(date +%Y%m%d_%H%M%S)"
OPTIMIZED_DIR="$WORKFLOW_DIR/optimized"

# Create archive directory
echo "Creating archive directory: $ARCHIVE_DIR"
mkdir -p "$ARCHIVE_DIR"

# Function to safely move workflow
move_workflow() {
    local workflow=$1
    local category=$2
    
    if [ -f "$WORKFLOW_DIR/$workflow" ]; then
        mkdir -p "$ARCHIVE_DIR/$category"
        echo "Archiving: $workflow -> $category/"
        mv "$WORKFLOW_DIR/$workflow" "$ARCHIVE_DIR/$category/"
    else
        echo "Skipping (not found): $workflow"
    fi
}

# Phase 1: Archive Sales Segment Agents
echo -e "\n=== Phase 1: Archiving Sales Segment Agents ==="
move_workflow "b2b_sales_agent.json" "sales_segments"
move_workflow "corporate_sales_agent.json" "sales_segments"
move_workflow "healthcare_sales_agent.json" "sales_segments"
move_workflow "hospitality_sales_agent.json" "sales_segments"
move_workflow "retail_sales_agent.json" "sales_segments"
move_workflow "sales_agent.json" "sales_segments"
move_workflow "VividWalls-Sales-Agent.json" "sales_segments"
move_workflow "VividWalls-Sales-Agent-WordPress-Enhanced.json" "sales_segments"

# Phase 2: Archive Task Agents
echo -e "\n=== Phase 2: Archiving Task Agents ==="
for i in {1..5}; do
    move_workflow "task_agent_${i}_*.json" "task_agents"
done

# Phase 3: Archive Knowledge Gatherers
echo -e "\n=== Phase 3: Archiving Knowledge Gatherer Agents ==="
move_workflow "marketing_knowledge_gatherer_agent.json" "knowledge_gatherers"
move_workflow "operations_knowledge_gatherer_agent.json" "knowledge_gatherers"
move_workflow "customer_experience_knowledge_gatherer_agent.json" "knowledge_gatherers"
move_workflow "finance_analytics_knowledge_gatherer_agent.json" "knowledge_gatherers"
move_workflow "technology_automation_knowledge_gatherer_agent.json" "knowledge_gatherers"
move_workflow "copywriting_knowledge_gatherer_agent.json" "knowledge_gatherers"

# Phase 4: Archive Analytics Redundancies
echo -e "\n=== Phase 4: Archiving Redundant Analytics Agents ==="
move_workflow "data_analytics_agent.json" "analytics"
move_workflow "data_insights_agent.json" "analytics"
move_workflow "performance_analytics.json" "analytics"
move_workflow "roi_analysis_agent.json" "analytics"

# Phase 5: Copy Optimized Workflows to Main Directory
echo -e "\n=== Phase 5: Installing Optimized Workflows ==="
if [ -d "$OPTIMIZED_DIR" ]; then
    echo "Copying optimized workflows..."
    cp "$OPTIMIZED_DIR/business_manager_orchestrator.json" "$WORKFLOW_DIR/"
    cp "$OPTIMIZED_DIR/sales_director_enhanced.json" "$WORKFLOW_DIR/"
    cp "$OPTIMIZED_DIR/marketing_director_pattern_aware.json" "$WORKFLOW_DIR/"
    echo "Optimized workflows installed."
fi

# Create migration report
REPORT_FILE="$ARCHIVE_DIR/migration_report.txt"
echo -e "\n=== Creating Migration Report ==="
cat > "$REPORT_FILE" << EOF
VividWalls MAS Workflow Optimization Migration Report
Generated: $(date)

Archive Location: $ARCHIVE_DIR

Workflows Archived:
$(find "$ARCHIVE_DIR" -name "*.json" | wc -l) total workflows

By Category:
- Sales Segments: $(find "$ARCHIVE_DIR/sales_segments" -name "*.json" 2>/dev/null | wc -l)
- Task Agents: $(find "$ARCHIVE_DIR/task_agents" -name "*.json" 2>/dev/null | wc -l)
- Knowledge Gatherers: $(find "$ARCHIVE_DIR/knowledge_gatherers" -name "*.json" 2>/dev/null | wc -l)
- Analytics: $(find "$ARCHIVE_DIR/analytics" -name "*.json" 2>/dev/null | wc -l)

New Optimized Workflows:
- business_manager_orchestrator.json (Pattern-aware orchestration)
- sales_director_enhanced.json (Dynamic persona loading)
- marketing_director_pattern_aware.json (Pattern execution)

Next Steps:
1. Update n8n workflow references
2. Test enhanced director workflows
3. Update documentation
4. Monitor performance improvements
EOF

echo "Migration report saved to: $REPORT_FILE"

# Show summary
echo -e "\n=== Migration Summary ==="
echo "Workflows archived: $(find "$ARCHIVE_DIR" -name "*.json" | wc -l)"
echo "Archive location: $ARCHIVE_DIR"
echo "Optimized workflows installed: 3"

echo -e "\n=== IMPORTANT: Next Steps ==="
echo "1. Test the new enhanced workflows in n8n"
echo "2. Update any workflow IDs in Business Manager"
echo "3. Verify all functionality is preserved"
echo "4. Only delete archives after successful testing"

echo -e "\nMigration complete!"