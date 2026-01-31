#!/bin/bash

# VividWalls MAS Redundancy Cleanup Script
# "Choice is an illusion created between those with power and those without" - Morpheus Validator
# Systematically removes all redundant and duplicate workflow files

set -e

# Configuration
WORKFLOW_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows"
CLEANUP_LOG="${WORKFLOW_DIR}/redundancy_cleanup.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$CLEANUP_LOG"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$CLEANUP_LOG"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$CLEANUP_LOG"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$CLEANUP_LOG"
}

# Change to workflow directory
cd "$WORKFLOW_DIR"

# Phase 1: Archive Legacy Director Agents (already have optimized versions in core/)
log "Phase 1: Archiving legacy director agents..."

# These have optimized versions in core/ directory
legacy_directors=(
    "finance_director_agent.json"
    "customer_experience_director_agent.json" 
    "product_director_agent.json"
    "technology_director_agent.json"
    "creative_director_agent.json"
    "social_media_director_agent.json"
)

for file in "${legacy_directors[@]}"; do
    if [[ -f "$file" ]]; then
        new_name=$(echo "$file" | sed 's/_agent\.json/_spec_v1_leg.json/' | tr '[:lower:]' '[:upper:]')
        mv "$file" "archived/legacy/$new_name"
        success "Archived: $file -> archived/legacy/$new_name"
    fi
done

# Phase 2: Archive Sales Segment Agents (consolidated into Sales Director)
log "Phase 2: Archiving sales segment agents..."

sales_segments=(
    "healthcare_sales_agent.json"
    "hospitality_sales_agent.json"
    "retail_sales_agent.json"
    "sales_agent.json"
    "sales_agent_knowledge_enhanced_example.json"
)

for file in "${sales_segments[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="SALES_$(echo "$file" | sed 's/_sales_agent\.json//' | sed 's/_agent\.json//' | sed 's/sales_//')_spec_v1_leg.json"
        mv "$file" "archived/legacy/$new_name"
        success "Archived: $file -> archived/legacy/$new_name"
    fi
done

# Phase 3: Archive Marketing Duplicates
log "Phase 3: Archiving marketing duplicates..."

marketing_duplicates=(
    "campaign_agent.json"
    "marketing_campaign_agent_(1).json"
    "marketing_campaign_workflow.json"
    "campaign_coordination.json"
    "marketing_knowledge_gatherer_agent.json"
    "marketing_research_agent.json"
    "email_marketing_agent.json"
)

for file in "${marketing_duplicates[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="MARKETING_$(echo "$file" | sed 's/marketing_//' | sed 's/_agent\.json/_spec_v1_leg.json/' | sed 's/\.json/_leg.json/')"
        mv "$file" "archived/duplicates/$new_name"
        success "Archived: $file -> archived/duplicates/$new_name"
    fi
done

# Phase 4: Archive Content Duplicates (consolidated into Content Operations Agent)
log "Phase 4: Archiving content duplicates..."

content_duplicates=(
    "content_strategy_agent.json"
    "content_strategy_agent_strategic.json"
    "copy_writer_agent.json"
    "copy_editor_agent.json"
    "keyword_agent.json"
    "copywriting_knowledge_gatherer_agent.json"
)

for file in "${content_duplicates[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="CONTENT_$(echo "$file" | sed 's/content_//' | sed 's/copy//' | sed 's/_agent\.json/_spec_v1_leg.json/' | sed 's/\.json/_leg.json/')"
        mv "$file" "archived/consolidated/$new_name"
        success "Archived: $file -> archived/consolidated/$new_name"
    fi
done

# Phase 5: Archive Knowledge Gatherer Duplicates (consolidated into Universal Knowledge Gatherer)
log "Phase 5: Archiving knowledge gatherer duplicates..."

knowledge_duplicates=(
    "customer_experience_knowledge_gatherer_agent.json"
    "finance_analytics_knowledge_gatherer_agent.json"
    "operations_knowledge_gatherer_agent.json"
    "technology_automation_knowledge_gatherer_agent.json"
)

for file in "${knowledge_duplicates[@]}"; do
    if [[ -f "$file" ]]; then
        domain=$(echo "$file" | sed 's/_knowledge_gatherer_agent\.json//' | sed 's/_analytics//' | sed 's/_automation//')
        new_name="KNOWLEDGE_${domain}_spec_v1_leg.json"
        mv "$file" "archived/consolidated/$new_name"
        success "Archived: $file -> archived/consolidated/$new_name"
    fi
done

# Phase 6: Archive Analytics Duplicates (consolidated into Analytics Director)
log "Phase 6: Archiving analytics duplicates..."

analytics_duplicates=(
    "data_analytics_agent.json"
    "data_insights_agent.json"
    "performance_analytics.json"
    "roi_analysis_agent.json"
)

for file in "${analytics_duplicates[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="ANALYTICS_$(echo "$file" | sed 's/data_//' | sed 's/_agent\.json/_spec_v1_leg.json/' | sed 's/\.json/_leg.json/')"
        mv "$file" "archived/consolidated/$new_name"
        success "Archived: $file -> archived/consolidated/$new_name"
    fi
done

# Phase 7: Archive Task Agents (implementation complete)
log "Phase 7: Archiving task agents..."

task_agents=(
    "task_agent_2_workflow_implementation.json"
    "task_agent_3_vector_store_integration.json"
    "task_agent_4_sales_consolidation.json"
    "task_agent_5_error_handling.json"
)

for file in "${task_agents[@]}"; do
    if [[ -f "$file" ]]; then
        task_num=$(echo "$file" | sed 's/task_agent_//' | sed 's/_.*/.json/')
        new_name="UTILITIES_task${task_num}_util_v1_dep.json"
        mv "$file" "archived/deprecated/$new_name"
        success "Archived: $file -> archived/deprecated/$new_name"
    fi
done

# Phase 8: Archive Customer Experience Duplicates
log "Phase 8: Archiving customer experience duplicates..."

cx_duplicates=(
    "customer_relationship_agent.json"
    "customer_service_agent.json"
    "customer_experience_workflow.json"
)

for file in "${cx_duplicates[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="CUSTOMER_EXPERIENCE_$(echo "$file" | sed 's/customer_//' | sed 's/_agent\.json/_spec_v1_leg.json/' | sed 's/\.json/_leg.json/')"
        mv "$file" "archived/legacy/$new_name"
        success "Archived: $file -> archived/legacy/$new_name"
    fi
done

# Phase 9: Archive Finance Duplicates
log "Phase 9: Archiving finance duplicates..."

finance_duplicates=(
    "budget_management_agent.json"
    "budget_optimization.json"
)

for file in "${finance_duplicates[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="FINANCE_$(echo "$file" | sed 's/budget_//' | sed 's/_agent\.json/_spec_v1_leg.json/' | sed 's/\.json/_leg.json/')"
        mv "$file" "archived/consolidated/$new_name"
        success "Archived: $file -> archived/consolidated/$new_name"
    fi
done

# Phase 10: Archive Utility and System Files
log "Phase 10: Archiving utility and system files..."

utility_files=(
    "strategic_orchestrator.json"
    "workflow_automation.json"
    "workflow_registry.json"
    "integration_management_agent.json"
    "color_analysis_agent.json"
    "system_monitoring_agent.json"
    "research_report_output_parser.json"
    "n8n_documentation.json"
)

for file in "${utility_files[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="UTILITIES_$(echo "$file" | sed 's/_agent\.json/_util_v1_leg.json/' | sed 's/\.json/_leg.json/')"
        mv "$file" "archived/legacy/$new_name"
        success "Archived: $file -> archived/legacy/$new_name"
    fi
done

# Phase 11: Move Platform Integration Files
log "Phase 11: Moving platform integration files..."

integration_files=(
    "facebook_agent.json"
    "instagram_agent.json"
    "pinterest_agent.json"
    "pictorem_agent.json"
)

for file in "${integration_files[@]}"; do
    if [[ -f "$file" ]]; then
        platform=$(echo "$file" | sed 's/_agent\.json//')
        new_name="INTEGRATIONS_${platform}_intg_v1.json"
        mv "$file" "integrations/$new_name"
        success "Moved: $file -> integrations/$new_name"
    fi
done

# Phase 12: Move Process Files
log "Phase 12: Moving process files..."

process_files=(
    "stakeholder_communications.json"
    "stakeholder_business_marketing_directives.json"
    "business_marketing_directives.json"
    "knowledge_graph_expansion_workflow.json"
)

for file in "${process_files[@]}"; do
    if [[ -f "$file" ]]; then
        process_name=$(echo "$file" | sed 's/stakeholder_//' | sed 's/_workflow\.json//' | sed 's/\.json//')
        new_name="PROCESSES_${process_name}_proc_v1.json"
        mv "$file" "processes/$new_name"
        success "Moved: $file -> processes/$new_name"
    fi
done

# Phase 13: Move Remaining Specialized Agents
log "Phase 13: Moving remaining specialized agents..."

specialized_files=(
    "lead-generation-workflow.json"
    "orders_fulfillment_agent.json"
    "ecommerce-order-fulfillment-workflow.json"
)

for file in "${specialized_files[@]}"; do
    if [[ -f "$file" ]]; then
        if [[ "$file" == *"lead"* ]]; then
            new_name="SALES_coordinator_spec_v1_opt.json"
        elif [[ "$file" == *"order"* ]]; then
            new_name="OPERATIONS_processor_spec_v1_opt.json"
        fi
        mv "$file" "specialized/$new_name"
        success "Moved: $file -> specialized/$new_name"
    fi
done

# Phase 14: Move Template Files
log "Phase 14: Moving template files..."

template_files=(
    "chatbot-workflow.json"
)

for file in "${template_files[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="CONTENT_chatbot_temp_v1.json"
        mv "$file" "templates/$new_name"
        success "Moved: $file -> templates/$new_name"
    fi
done

# Phase 15: Move Example Files
log "Phase 15: Moving example files..."

example_files=(
    "ai-agent-native-mcp-example.json"
)

for file in "${example_files[@]}"; do
    if [[ -f "$file" ]]; then
        new_name="BUSINESS_MANAGEMENT_native_exam_v1.json"
        mv "$file" "examples/$new_name"
        success "Moved: $file -> examples/$new_name"
    fi
done

# Phase 16: Archive VividWalls Prefixed Files
log "Phase 16: Archiving VividWalls prefixed files..."

vividwalls_files=(
    "VividWalls Knowledge Base AI Agent.json"
    "VividWalls Multi-Agent System Workflow Overview.json"
    "VividWalls-Artwork-Color-Analysis.json"
    "VividWalls-Business-Manager-MCP-Agent.json"
    "VividWalls-Business-Manager-Orchestration.json"
    "VividWalls-Content-Marketing-Human-Approval-Agent.json"
    "VividWalls-Content-Marketing-MCP-Agent.json"
    "VividWalls-Customer-Relationship-Human-Approval-Agent.json"
    "VividWalls-Customer-Relationship-MCP-Agent.json"
    "VividWalls-Database-Integration-Workflow.json"
    "VividWalls-Marketing-Campaign-Human-Approval-Agent.json"
    "VividWalls-Marketing-Research-Agent.json"
    "VividWalls-Monthly-Newsletter-Campaign.json"
    "VividWalls-Newsletter-Signup-Automation.json"
    "VividWalls-Orders-Fulfillment-Agent.json"
    "VividWalls-Prompt-Chain-Image-Retrieval.json"
    "VividWalls-SEO-Conversion-Funnel.json"
    "VividWalls-Sales-Agent-WordPress-Enhanced.json"
    "VividWalls-Sales-Agent.json"
    "VividWalls_CSV_Email_Import_Cleaner.json"
    "VividWalls_Lead_Generation_Advanced.json"
)

for file in "${vividwalls_files[@]}"; do
    if [[ -f "$file" ]]; then
        # Determine appropriate category and archive location
        if [[ "$file" == *"Business-Manager"* ]]; then
            new_name="BUSINESS_MANAGEMENT_manager_spec_v1_leg.json"
            mv "$file" "archived/duplicates/$new_name"
        elif [[ "$file" == *"Marketing"* ]]; then
            new_name="MARKETING_$(echo "$file" | sed 's/VividWalls-//' | sed 's/-/_/g' | sed 's/\.json/_leg.json/')"
            mv "$file" "archived/duplicates/$new_name"
        elif [[ "$file" == *"Sales"* ]]; then
            new_name="SALES_$(echo "$file" | sed 's/VividWalls-//' | sed 's/-/_/g' | sed 's/\.json/_leg.json/')"
            mv "$file" "archived/duplicates/$new_name"
        elif [[ "$file" == *"Customer"* ]]; then
            new_name="CUSTOMER_EXPERIENCE_$(echo "$file" | sed 's/VividWalls-//' | sed 's/-/_/g' | sed 's/\.json/_leg.json/')"
            mv "$file" "archived/duplicates/$new_name"
        elif [[ "$file" == *"Orders"* ]]; then
            new_name="OPERATIONS_$(echo "$file" | sed 's/VividWalls-//' | sed 's/-/_/g' | sed 's/\.json/_leg.json/')"
            mv "$file" "archived/duplicates/$new_name"
        elif [[ "$file" == *"Database"* ]]; then
            new_name="INTEGRATIONS_database_intg_v1_leg.json"
            mv "$file" "archived/duplicates/$new_name"
        else
            # Generic utilities
            new_name="UTILITIES_$(echo "$file" | sed 's/VividWalls[-_]//' | sed 's/[-\s]/_/g' | sed 's/\.json/_leg.json/')"
            mv "$file" "archived/duplicates/$new_name"
        fi
        success "Archived: $file -> $new_name"
    fi
done

# Phase 17: Clean up configuration files
log "Phase 17: Moving configuration files..."

config_files=(
    "knowledge_gatherer_configs.json"
)

for file in "${config_files[@]}"; do
    if [[ -f "$file" ]]; then
        mv "$file" "templates/"
        success "Moved: $file -> templates/"
    fi
done

log "=== Redundancy Cleanup Complete ==="
success "All redundant and duplicate files have been systematically organized"
success "Backup preserved at: migration_backup_20250719_170823/"
success "Cleanup log: $CLEANUP_LOG"
