#!/bin/bash

# Git Workflow Helper for VividWalls MAS Restoration
# Provides common git operations for the restoration project

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to show usage
show_usage() {
    cat << EOF
Git Workflow Helper for VividWalls MAS Restoration

Usage: $0 <command> [options]

Commands:
    start <phase> <task>     Start working on a specific task
    commit <message>         Commit with conventional format
    finish                   Finish current task and create PR
    status                   Show current branch and changes
    switch <branch>          Switch to a different task branch
    merge-phase <phase>      Merge all completed tasks in a phase
    validate                 Run validation checks before merge

Examples:
    $0 start phase0 credential-consolidation
    $0 commit "create master.env with all credentials"
    $0 finish
    $0 merge-phase phase1

EOF
}

# Get current branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Start working on a task
start_task() {
    local phase=$1
    local task=$2
    local branch="restoration/${phase}-${task}"
    
    echo -e "${BLUE}Starting work on ${phase} - ${task}...${NC}"
    
    # Stash any uncommitted changes
    if [[ -n $(git status -s) ]]; then
        echo -e "${YELLOW}Stashing uncommitted changes...${NC}"
        git stash push -m "WIP: $(get_current_branch)"
    fi
    
    # Switch to branch
    git checkout $branch
    echo -e "${GREEN}✓ Switched to branch: $branch${NC}"
    
    # Show task info
    case $branch in
        *credential-consolidation*)
            echo -e "${YELLOW}Task: Create master.env file${NC}"
            echo "Files to work on:"
            echo "  - master.env"
            echo "  - VIVIDWALLS_CREDENTIAL_AUDIT_REPORT.md"
            ;;
        *directory-structure*)
            echo -e "${YELLOW}Task: Create future-state directory structure${NC}"
            echo "Key directories to create:"
            echo "  - services/{supabase,n8n,caddy,...}"
            echo "  - caddy/sites-enabled"
            echo "  - scripts, data, shared"
            ;;
        *docker-compose*)
            echo -e "${YELLOW}Task: Create main docker-compose.yml${NC}"
            echo "Requirements:"
            echo "  - All services on vivid_mas network"
            echo "  - n8n with /opt/mcp-servers volume"
            echo "  - Environment variable references"
            ;;
        *caddy-config*)
            echo -e "${YELLOW}Task: Create Caddy configuration${NC}"
            echo "Files to create:"
            echo "  - Caddyfile"
            echo "  - caddy/sites-enabled/*.caddy"
            ;;
    esac
}

# Commit with conventional format
commit_changes() {
    local message=$1
    local current_branch=$(get_current_branch)
    
    # Extract phase from branch name
    local phase=$(echo $current_branch | grep -oP 'phase\d+' || echo "restoration")
    
    # Determine commit type based on branch
    local type="feat"
    if [[ $current_branch == *"fix"* ]]; then
        type="fix"
    elif [[ $current_branch == *"docs"* ]]; then
        type="docs"
    fi
    
    # Create commit
    git add -A
    git commit -m "${type}(${phase}): ${message}"
    echo -e "${GREEN}✓ Committed: ${type}(${phase}): ${message}${NC}"
}

# Finish current task
finish_task() {
    local current_branch=$(get_current_branch)
    
    if [[ $current_branch == "main" ]] || [[ $current_branch == "restoration/base" ]]; then
        echo -e "${RED}Error: Cannot finish task on $current_branch${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Finishing task on branch: $current_branch${NC}"
    
    # Ensure all changes are committed
    if [[ -n $(git status -s) ]]; then
        echo -e "${YELLOW}Uncommitted changes detected. Please commit first.${NC}"
        exit 1
    fi
    
    # Push branch
    git push -u origin $current_branch
    
    # Determine parent branch
    local parent_branch="restoration/base"
    if [[ $current_branch == *"phase1-"* ]] && [[ $current_branch != "restoration/phase1-architecture" ]]; then
        parent_branch="restoration/phase1-architecture"
    elif [[ $current_branch == *"phase2-"* ]] && [[ $current_branch != "restoration/phase2-data-migration" ]]; then
        parent_branch="restoration/phase2-data-migration"
    elif [[ $current_branch == *"phase3-"* ]] && [[ $current_branch != "restoration/phase3-validation" ]]; then
        parent_branch="restoration/phase3-validation"
    elif [[ $current_branch == *"phase4-"* ]] && [[ $current_branch != "restoration/phase4-cutover" ]]; then
        parent_branch="restoration/phase4-cutover"
    fi
    
    echo -e "${GREEN}✓ Task complete!${NC}"
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Create a pull request from $current_branch to $parent_branch"
    echo "2. After review, merge the PR"
    echo "3. Delete the feature branch"
    
    # Generate PR template
    generate_pr_template $current_branch $parent_branch
}

# Generate PR template
generate_pr_template() {
    local source=$1
    local target=$2
    local pr_file=".github/pull_request_template.md"
    
    mkdir -p .github
    cat > $pr_file << EOF
## PR Type
- [x] Sub-task completion
- [ ] Phase completion
- [ ] Hotfix

## Phase/Task
Branch: $source → $target

## Changes Made
<!-- List specific changes -->
- 

## Testing Performed
- [ ] Local testing completed
- [ ] No secrets exposed
- [ ] Documentation updated

## Validation Checklist
- [ ] All tests pass
- [ ] No merge conflicts
- [ ] Follows naming conventions

## Notes
<!-- Any additional context -->

EOF
    echo -e "${GREEN}✓ PR template created at $pr_file${NC}"
}

# Show status
show_status() {
    local current_branch=$(get_current_branch)
    echo -e "${BLUE}Current branch: ${current_branch}${NC}"
    echo -e "${YELLOW}Git status:${NC}"
    git status -s
    
    if [[ -n $(git stash list) ]]; then
        echo -e "${YELLOW}Stashed changes:${NC}"
        git stash list
    fi
}

# Validate before merge
validate_branch() {
    echo -e "${BLUE}Running validation checks...${NC}"
    
    # Check for secrets
    echo -n "Checking for exposed secrets... "
    if grep -r "password\|secret\|key" --include="*.yml" --include="*.yaml" --include="*.env" . | grep -v ".env.example" | grep -v "master.env" > /dev/null; then
        echo -e "${RED}✗ Found potential secrets${NC}"
        echo "Please review these files:"
        grep -r "password\|secret\|key" --include="*.yml" --include="*.yaml" --include="*.env" . | grep -v ".env.example"
        exit 1
    else
        echo -e "${GREEN}✓${NC}"
    fi
    
    # Check for TODO items
    echo -n "Checking for incomplete TODOs... "
    if grep -r "TODO\|FIXME\|XXX" --include="*.sh" --include="*.yml" --include="*.md" . > /dev/null; then
        echo -e "${YELLOW}⚠ Found TODO items${NC}"
        grep -r "TODO\|FIXME\|XXX" --include="*.sh" --include="*.yml" --include="*.md" . | head -5
    else
        echo -e "${GREEN}✓${NC}"
    fi
    
    echo -e "${GREEN}✓ Validation complete${NC}"
}

# Main script logic
case $1 in
    start)
        start_task $2 $3
        ;;
    commit)
        commit_changes "$2"
        ;;
    finish)
        finish_task
        ;;
    status)
        show_status
        ;;
    switch)
        git checkout $2
        ;;
    validate)
        validate_branch
        ;;
    *)
        show_usage
        ;;
esac