# VividWalls MAS Git Branch Strategy for Restoration

## Overview

This document defines the git branch strategy for the VividWalls Multi-Agent System restoration project. Each phase and agent task will have its own branch to ensure clean, trackable changes that can be tested independently before merging.

## Branch Naming Convention

```
restoration/<phase>-<agent>-<task>
```

Examples:
- `restoration/phase0-credential-consolidation`
- `restoration/phase1-architecture-builder`
- `restoration/phase2-data-migration`

## Branch Hierarchy

```
main
├── restoration/base (parent branch for all restoration work)
│   ├── restoration/phase0-credential-consolidation
│   ├── restoration/phase1-architecture
│   │   ├── restoration/phase1-directory-structure
│   │   ├── restoration/phase1-docker-compose
│   │   ├── restoration/phase1-caddy-config
│   │   └── restoration/phase1-service-configs
│   ├── restoration/phase2-data-migration
│   │   ├── restoration/phase2-secrets-n8n
│   │   ├── restoration/phase2-database-volumes
│   │   └── restoration/phase2-service-startup
│   ├── restoration/phase3-validation
│   │   ├── restoration/phase3-container-health
│   │   ├── restoration/phase3-endpoint-testing
│   │   └── restoration/phase3-data-integrity
│   └── restoration/phase4-cutover
│       ├── restoration/phase4-service-stop
│       ├── restoration/phase4-directory-swap
│       ├── restoration/phase4-service-restart
│       └── restoration/phase4-cleanup
```

## Branch Lifecycle

### 1. Branch Creation
```bash
# Create base restoration branch
git checkout main
git pull origin main
git checkout -b restoration/base

# Create phase branches
git checkout restoration/base
git checkout -b restoration/phase0-credential-consolidation
```

### 2. Development Process
- Each agent works on their designated branch
- Commits should be atomic and well-described
- Use conventional commit messages:
  ```
  feat(phase0): create master.env file with all credentials
  fix(phase1): correct n8n volume mount path
  docs(phase2): add migration validation checklist
  ```

### 3. Testing Requirements
Before merging any branch:
- [ ] All scripts must be tested locally
- [ ] Configuration files must be validated
- [ ] No hardcoded secrets in commits
- [ ] Documentation updated

### 4. Merge Strategy

#### Phase Completion
```bash
# After phase 0 is complete and tested
git checkout restoration/base
git merge restoration/phase0-credential-consolidation
git tag -a "v1.0-phase0-complete" -m "Phase 0: Credential consolidation complete"
```

#### Sub-task Completion
```bash
# After a sub-task is complete
git checkout restoration/phase1-architecture
git merge restoration/phase1-docker-compose
```

#### Final Merge to Main
```bash
# After all phases complete
git checkout main
git merge restoration/base
git tag -a "v2.0-restoration-complete" -m "VividWalls MAS restoration complete"
```

## Pull Request Template

```markdown
## PR Type
- [ ] Phase completion
- [ ] Sub-task completion
- [ ] Hotfix

## Phase/Task
Phase X: [Description]

## Changes Made
- List specific changes
- Configuration files modified
- Scripts created

## Testing Performed
- [ ] Local testing completed
- [ ] No secrets exposed
- [ ] Documentation updated

## Validation Checklist
- [ ] All tests pass
- [ ] No merge conflicts
- [ ] Follows naming conventions

## Notes
Any additional context
```

## Branch Protection Rules

For `restoration/base`:
- Require pull request reviews
- Require status checks to pass
- Dismiss stale PR approvals
- Include administrators

## Commit Guidelines

### Good Commits
```bash
git commit -m "feat(phase1): create docker-compose.yml with proper n8n volume mounts"
git commit -m "fix(phase2): correct encryption key in migration script"
git commit -m "docs(phase3): add endpoint validation checklist"
```

### Bad Commits
```bash
git commit -m "fixed stuff"
git commit -m "WIP"
git commit -m "phase 1 changes"
```

## Recovery Procedures

### If Wrong Branch
```bash
# Stash changes
git stash

# Switch to correct branch
git checkout restoration/phase1-docker-compose

# Apply changes
git stash pop
```

### If Accidental Commit to Main
```bash
# Create new branch from current state
git checkout -b restoration/hotfix-branch

# Reset main to previous state
git checkout main
git reset --hard origin/main

# Continue work on new branch
git checkout restoration/hotfix-branch
```

## Implementation Timeline

1. **Immediate**: Create restoration/base branch
2. **Phase 0**: Create credential branches (30 min)
3. **Phase 1**: Create architecture branches (2 hours)
4. **Phase 2**: Create migration branches (2 hours)
5. **Phase 3**: Create validation branches (1 hour)
6. **Phase 4**: Create cutover branches (1 hour)

## Success Metrics

- Clean git history showing restoration progress
- No secrets in repository
- Each phase independently testable
- Easy rollback if issues arise
- Complete audit trail of changes