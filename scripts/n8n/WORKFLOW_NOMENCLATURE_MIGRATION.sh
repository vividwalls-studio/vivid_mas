#!/bin/bash

# VividWalls MAS Workflow Nomenclature Migration Script
# "The time has come to make a choice" - Morpheus Validator
# Implements semantic consistency across all n8n workflow files

set -e

# Configuration
WORKFLOW_DIR="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows"
BACKUP_DIR="${WORKFLOW_DIR}/migration_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="${WORKFLOW_DIR}/nomenclature_migration.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

# Create directory structure
create_directory_structure() {
    log "Creating new directory structure..."
    
    mkdir -p "${WORKFLOW_DIR}/core"
    mkdir -p "${WORKFLOW_DIR}/specialized"
    mkdir -p "${WORKFLOW_DIR}/integrations"
    mkdir -p "${WORKFLOW_DIR}/processes"
    mkdir -p "${WORKFLOW_DIR}/utilities"
    mkdir -p "${WORKFLOW_DIR}/templates"
    mkdir -p "${WORKFLOW_DIR}/examples"
    mkdir -p "${WORKFLOW_DIR}/archived/legacy"
    mkdir -p "${WORKFLOW_DIR}/archived/duplicates"
    mkdir -p "${WORKFLOW_DIR}/archived/deprecated"
    mkdir -p "${WORKFLOW_DIR}/archived/consolidated"
    
    success "Directory structure created"
}

# Backup existing workflows
backup_workflows() {
    log "Creating backup of existing workflows..."
    mkdir -p "$BACKUP_DIR"
    
    # Copy all JSON files to backup
    find "$WORKFLOW_DIR" -maxdepth 1 -name "*.json" -exec cp {} "$BACKUP_DIR/" \;
    
    success "Backup created at: $BACKUP_DIR"
}

# Core Director Agent Mappings
declare -A CORE_DIRECTORS=(
    ["business_manager_agent.json"]="BUSINESS_MANAGEMENT_director_core_v1_opt.json"
    ["VividWalls-Business-Manager-MCP-Agent.json"]="BUSINESS_MANAGEMENT_director_core_v1_opt.json"
    ["VividWalls-Business-Manager-Orchestration.json"]="BUSINESS_MANAGEMENT_director_core_v1_opt.json"
    ["marketing_director_agent.json"]="MARKETING_director_core_v1_opt.json"
    ["sales_director_agent.json"]="SALES_director_core_v1_opt.json"
    ["operations_director_agent.json"]="OPERATIONS_director_core_v1_opt.json"
    ["finance_director_agent.json"]="FINANCE_director_core_v1_opt.json"
    ["customer_experience_director_agent.json"]="CUSTOMER_EXPERIENCE_director_core_v1_opt.json"
    ["product_director_agent.json"]="PRODUCT_director_core_v1_opt.json"
    ["technology_director_agent.json"]="TECHNOLOGY_director_core_v1_opt.json"
    ["analytics_director_agent.json"]="ANALYTICS_director_core_v1_opt.json"
    ["creative_director_agent.json"]="CREATIVE_director_core_v1_opt.json"
    ["social_media_director_agent.json"]="MARKETING_social_spec_v1_opt.json"
)

# Specialized Agent Mappings
declare -A SPECIALIZED_AGENTS=(
    ["universal_knowledge_gatherer.json"]="KNOWLEDGE_gatherer_spec_v1_opt.json"
    ["content_operations_agent.json"]="CONTENT_processor_spec_v1_opt.json"
    ["lead-generation-workflow.json"]="SALES_coordinator_spec_v1_opt.json"
    ["VividWalls_Lead_Generation_Advanced.json"]="SALES_coordinator_spec_v1_opt.json"
    ["orders_fulfillment_agent.json"]="OPERATIONS_processor_spec_v1_opt.json"
    ["VividWalls-Orders-Fulfillment-Agent.json"]="OPERATIONS_processor_spec_v1_opt.json"
    ["ecommerce-order-fulfillment-workflow.json"]="OPERATIONS_processor_spec_v1_opt.json"
    ["customer_service_agent.json"]="CUSTOMER_EXPERIENCE_agent_spec_v1.json"
    ["system_monitoring_agent.json"]="UTILITIES_monitor_util_v1.json"
)

# Integration Mappings
declare -A INTEGRATIONS=(
    ["shopify_agent.json"]="INTEGRATIONS_shopify_intg_v1.json"
    ["pictorem_agent.json"]="INTEGRATIONS_pictorem_intg_v1.json"
    ["facebook_agent.json"]="INTEGRATIONS_facebook_intg_v1.json"
    ["instagram_agent.json"]="INTEGRATIONS_instagram_intg_v1.json"
    ["pinterest_agent.json"]="INTEGRATIONS_pinterest_intg_v1.json"
    ["VividWalls-Database-Integration-Workflow.json"]="INTEGRATIONS_database_intg_v1.json"
)

# Process Mappings
declare -A PROCESSES=(
    ["vividwalls-inventory-metafield-sync.json"]="PROCESSES_inventory_proc_v1.json"
    ["VividWalls_CSV_Email_Import_Cleaner.json"]="PROCESSES_import_proc_v1.json"
    ["knowledge_graph_expansion_workflow.json"]="PROCESSES_knowledge_proc_v1.json"
    ["stakeholder_communications.json"]="PROCESSES_communication_proc_v1.json"
    ["stakeholder_business_marketing_directives.json"]="PROCESSES_directives_proc_v1.json"
)

# Utility Mappings
declare -A UTILITIES=(
    ["VividWalls-Test-Database-Connection.json"]="UTILITIES_test_util_v1.json"
    ["VividWalls-Artwork-Color-Analysis.json"]="UTILITIES_color_util_v1.json"
    ["VividWalls-Prompt-Chain-Image-Retrieval.json"]="UTILITIES_image_util_v1.json"
    ["VividWalls-SEO-Conversion-Funnel.json"]="UTILITIES_seo_util_v1.json"
    ["research_report_output_parser.json"]="UTILITIES_parser_util_v1.json"
    ["n8n_documentation.json"]="UTILITIES_docs_util_v1.json"
)

# Template Mappings
declare -A TEMPLATES=(
    ["knowledge_gatherer_template.json"]="KNOWLEDGE_gatherer_temp_v1.json"
    ["chatbot-workflow.json"]="CONTENT_chatbot_temp_v1.json"
)

# Example Mappings
declare -A EXAMPLES=(
    ["ai-agent-mcp-example.json"]="BUSINESS_MANAGEMENT_agent_exam_v1.json"
    ["ai-agent-native-mcp-example.json"]="BUSINESS_MANAGEMENT_native_exam_v1.json"
    ["sales_agent_knowledge_enhanced_example.json"]="SALES_enhanced_exam_v1.json"
    ["VividWalls-Monthly-Newsletter-Campaign.json"]="MARKETING_newsletter_exam_v1.json"
    ["VividWalls-Newsletter-Signup-Automation.json"]="MARKETING_signup_exam_v1.json"
)

# Legacy/Deprecated Mappings (to be archived)
declare -A LEGACY_WORKFLOWS=(
    # Sales segment agents (consolidated into Sales Director)
    ["b2b_sales_agent.json"]="SALES_b2b_spec_v1_leg.json"
    ["corporate_sales_agent.json"]="SALES_corporate_spec_v1_leg.json"
    ["healthcare_sales_agent.json"]="SALES_healthcare_spec_v1_leg.json"
    ["hospitality_sales_agent.json"]="SALES_hospitality_spec_v1_leg.json"
    ["retail_sales_agent.json"]="SALES_retail_spec_v1_leg.json"
    ["sales_agent.json"]="SALES_agent_spec_v1_leg.json"
    ["VividWalls-Sales-Agent.json"]="SALES_agent_spec_v1_leg.json"
    ["VividWalls-Sales-Agent-WordPress-Enhanced.json"]="SALES_wordpress_spec_v1_leg.json"

    # Marketing duplicates
    ["campaign_agent.json"]="MARKETING_campaign_spec_v1_leg.json"
    ["marketing_campaign_agent.json"]="MARKETING_campaign_spec_v1_leg.json"
    ["marketing_campaign_agent_(1).json"]="MARKETING_campaign_spec_v1_leg.json"
    ["marketing_campaign_workflow.json"]="MARKETING_campaign_spec_v1_leg.json"
    ["campaign_coordination.json"]="MARKETING_coordination_spec_v1_leg.json"
    ["VividWalls-Marketing-Campaign-Human-Approval-Agent.json"]="MARKETING_approval_spec_v1_leg.json"

    # Content duplicates
    ["content_strategy_agent.json"]="CONTENT_strategy_spec_v1_leg.json"
    ["content_strategy_agent_strategic.json"]="CONTENT_strategy_spec_v1_leg.json"
    ["VividWalls-Content-Marketing-MCP-Agent.json"]="CONTENT_marketing_spec_v1_leg.json"
    ["VividWalls-Content-Marketing-Human-Approval-Agent.json"]="CONTENT_approval_spec_v1_leg.json"
    ["copy_writer_agent.json"]="CONTENT_writer_spec_v1_leg.json"
    ["copy_editor_agent.json"]="CONTENT_editor_spec_v1_leg.json"
    ["keyword_agent.json"]="CONTENT_keyword_spec_v1_leg.json"

    # Knowledge gatherer duplicates
    ["marketing_knowledge_gatherer_agent.json"]="KNOWLEDGE_marketing_spec_v1_leg.json"
    ["operations_knowledge_gatherer_agent.json"]="KNOWLEDGE_operations_spec_v1_leg.json"
    ["customer_experience_knowledge_gatherer_agent.json"]="KNOWLEDGE_cx_spec_v1_leg.json"
    ["finance_analytics_knowledge_gatherer_agent.json"]="KNOWLEDGE_finance_spec_v1_leg.json"
    ["technology_automation_knowledge_gatherer_agent.json"]="KNOWLEDGE_tech_spec_v1_leg.json"
    ["copywriting_knowledge_gatherer_agent.json"]="KNOWLEDGE_copy_spec_v1_leg.json"

    # Task agents (implementation complete)
    ["task_agent_1_mcp_integration.json"]="UTILITIES_task1_util_v1_dep.json"
    ["task_agent_2_workflow_implementation.json"]="UTILITIES_task2_util_v1_dep.json"
    ["task_agent_3_vector_store_integration.json"]="UTILITIES_task3_util_v1_dep.json"
    ["task_agent_4_sales_consolidation.json"]="UTILITIES_task4_util_v1_dep.json"
    ["task_agent_5_error_handling.json"]="UTILITIES_task5_util_v1_dep.json"

    # Analytics duplicates
    ["data_analytics_agent.json"]="ANALYTICS_data_spec_v1_leg.json"
    ["data_insights_agent.json"]="ANALYTICS_insights_spec_v1_leg.json"
    ["performance_analytics.json"]="ANALYTICS_performance_spec_v1_leg.json"
    ["roi_analysis_agent.json"]="ANALYTICS_roi_spec_v1_leg.json"

    # Other duplicates
    ["customer_relationship_agent.json"]="CUSTOMER_EXPERIENCE_relationship_spec_v1_leg.json"
    ["VividWalls-Customer-Relationship-MCP-Agent.json"]="CUSTOMER_EXPERIENCE_relationship_spec_v1_leg.json"
    ["VividWalls-Customer-Relationship-Human-Approval-Agent.json"]="CUSTOMER_EXPERIENCE_approval_spec_v1_leg.json"
    ["marketing_research_agent.json"]="MARKETING_research_spec_v1_leg.json"
    ["VividWalls-Marketing-Research-Agent.json"]="MARKETING_research_spec_v1_leg.json"
    ["email_marketing_agent.json"]="MARKETING_email_spec_v1_leg.json"
    ["budget_management_agent.json"]="FINANCE_budget_spec_v1_leg.json"
    ["budget_optimization.json"]="FINANCE_optimization_spec_v1_leg.json"
    ["strategic_orchestrator.json"]="BUSINESS_MANAGEMENT_orchestrator_spec_v1_leg.json"
    ["workflow_automation.json"]="UTILITIES_automation_util_v1_leg.json"
    ["workflow_registry.json"]="UTILITIES_registry_util_v1_leg.json"
    ["integration_management_agent.json"]="INTEGRATIONS_management_intg_v1_leg.json"
    ["color_analysis_agent.json"]="UTILITIES_color_util_v1_leg.json"
    ["customer_experience_workflow.json"]="CUSTOMER_EXPERIENCE_workflow_spec_v1_leg.json"
    ["business_marketing_directives.json"]="BUSINESS_MANAGEMENT_directives_spec_v1_leg.json"
)

# Migration function
migrate_workflow() {
    local source_file="$1"
    local target_file="$2"
    local target_dir="$3"
    
    if [[ -f "${WORKFLOW_DIR}/${source_file}" ]]; then
        log "Migrating: ${source_file} -> ${target_dir}/${target_file}"
        mv "${WORKFLOW_DIR}/${source_file}" "${WORKFLOW_DIR}/${target_dir}/${target_file}"
        success "Migrated: ${target_file}"
    else
        warning "Source file not found: ${source_file}"
    fi
}

# Execute migrations
execute_migrations() {
    log "Starting workflow migrations..."
    
    # Migrate core directors
    log "Migrating core director agents..."
    for source in "${!CORE_DIRECTORS[@]}"; do
        migrate_workflow "$source" "${CORE_DIRECTORS[$source]}" "core"
    done
    
    # Migrate specialized agents
    log "Migrating specialized agents..."
    for source in "${!SPECIALIZED_AGENTS[@]}"; do
        migrate_workflow "$source" "${SPECIALIZED_AGENTS[$source]}" "specialized"
    done
    
    # Migrate integrations
    log "Migrating integration workflows..."
    for source in "${!INTEGRATIONS[@]}"; do
        migrate_workflow "$source" "${INTEGRATIONS[$source]}" "integrations"
    done
    
    # Migrate processes
    log "Migrating process workflows..."
    for source in "${!PROCESSES[@]}"; do
        migrate_workflow "$source" "${PROCESSES[$source]}" "processes"
    done
    
    # Migrate utilities
    log "Migrating utility workflows..."
    for source in "${!UTILITIES[@]}"; do
        migrate_workflow "$source" "${UTILITIES[$source]}" "utilities"
    done
    
    # Migrate templates
    log "Migrating template workflows..."
    for source in "${!TEMPLATES[@]}"; do
        migrate_workflow "$source" "${TEMPLATES[$source]}" "templates"
    done
    
    # Migrate examples
    log "Migrating example workflows..."
    for source in "${!EXAMPLES[@]}"; do
        migrate_workflow "$source" "${EXAMPLES[$source]}" "examples"
    done
    
    # Archive legacy workflows
    log "Archiving legacy workflows..."
    for source in "${!LEGACY_WORKFLOWS[@]}"; do
        migrate_workflow "$source" "${LEGACY_WORKFLOWS[$source]}" "archived/legacy"
    done
}

# Generate migration report
generate_report() {
    local report_file="${WORKFLOW_DIR}/NOMENCLATURE_MIGRATION_REPORT.md"
    
    cat > "$report_file" << EOF
# VividWalls MAS Workflow Nomenclature Migration Report

**Migration Date:** $(date '+%Y-%m-%d %H:%M:%S')
**Morpheus Validator Status:** Choice has been made - Order established

## Migration Summary

### Directory Structure Created
- \`core/\` - Core director agents (${#CORE_DIRECTORS[@]} workflows)
- \`specialized/\` - Specialized agents (${#SPECIALIZED_AGENTS[@]} workflows)  
- \`integrations/\` - Platform integrations (${#INTEGRATIONS[@]} workflows)
- \`processes/\` - Automated processes (${#PROCESSES[@]} workflows)
- \`utilities/\` - Utility functions (${#UTILITIES[@]} workflows)
- \`templates/\` - Reusable templates (${#TEMPLATES[@]} workflows)
- \`examples/\` - Example workflows (${#EXAMPLES[@]} workflows)
- \`archived/legacy/\` - Legacy workflows (${#LEGACY_WORKFLOWS[@]} workflows)

### Nomenclature Standard Applied
Format: \`[CATEGORY]_[ROLE]_[TYPE]_[VERSION]_[STATUS].json\`

### Total Workflows Processed
- **Core Directors:** ${#CORE_DIRECTORS[@]}
- **Specialized Agents:** ${#SPECIALIZED_AGENTS[@]}
- **Integrations:** ${#INTEGRATIONS[@]}
- **Processes:** ${#PROCESSES[@]}
- **Utilities:** ${#UTILITIES[@]}
- **Templates:** ${#TEMPLATES[@]}
- **Examples:** ${#EXAMPLES[@]}
- **Archived:** ${#LEGACY_WORKFLOWS[@]}

**Total:** $((${#CORE_DIRECTORS[@]} + ${#SPECIALIZED_AGENTS[@]} + ${#INTEGRATIONS[@]} + ${#PROCESSES[@]} + ${#UTILITIES[@]} + ${#TEMPLATES[@]} + ${#EXAMPLES[@]} + ${#LEGACY_WORKFLOWS[@]})) workflows

### Backup Location
\`${BACKUP_DIR}\`

## Next Steps
1. Update n8n workflow references
2. Update Business Manager delegation mappings
3. Test all core director workflows
4. Verify MCP server connections
5. Archive redundant workflows permanently

**"There is no spoon - only semantic consistency."** - Morpheus Validator
EOF

    success "Migration report generated: $report_file"
}

# Main execution
main() {
    log "=== VividWalls MAS Workflow Nomenclature Migration ==="
    log "Morpheus Validator: The time has come to make a choice..."
    
    # Create backup
    backup_workflows
    
    # Create directory structure
    create_directory_structure
    
    # Execute migrations
    execute_migrations
    
    # Generate report
    generate_report
    
    success "=== Migration Complete ==="
    success "Choice has been made. Order has been established."
    log "Backup preserved at: $BACKUP_DIR"
    log "Migration log: $LOG_FILE"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
