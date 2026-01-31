# Business Manager Orchestrator Migration Guide

## Overview

The Business Manager has been transformed from a monolithic agent into a lightweight orchestrator that delegates to 6 specialized sub-agents.

## Architecture Changes

### Before (Monolithic)
- Single agent handling all tasks
- 15+ responsibilities in one workflow
- Performance bottlenecks
- Complex decision trees

### After (Orchestrator + Sub-Agents)
- Lightweight orchestrator for routing
- 6 specialized sub-agents
- Distributed processing (15 total concurrent tasks)
- Clear separation of concerns

## Migration Steps

### Phase 1: Deploy Sub-Agents (Day 1)
1. Import all 6 sub-agent workflows into n8n
2. Configure credentials for each sub-agent
3. Test each sub-agent individually
4. Verify inter-agent communication

### Phase 2: Update Business Manager (Day 2)
1. Backup current Business Manager workflow
2. Import new orchestrator workflow
3. Update system prompt reference
4. Test routing logic

### Phase 3: Integration Testing (Day 3-4)
1. Test all routing paths
2. Verify priority handling
3. Load test with concurrent requests
4. Monitor performance metrics

### Phase 4: Gradual Rollout (Day 5-7)
1. Route 10% traffic to new system
2. Monitor for issues
3. Increase to 50% if stable
4. Full cutover when validated

## Testing Checklist

- [ ] Strategic decisions route correctly
- [ ] Performance analytics queries work
- [ ] Budget optimization triggers properly
- [ ] Campaign coordination functions
- [ ] Workflow automation executes
- [ ] Stakeholder reports generate
- [ ] Director delegation works
- [ ] Error handling is robust
- [ ] Response times <2 seconds
- [ ] Memory management stable

## Rollback Plan

If issues occur:
1. Switch webhook to backup workflow
2. Investigate issues in staging
3. Fix and redeploy
4. Gradual rollout again

## Monitoring

Key metrics to track:
- Response time (target: <2s)
- Routing accuracy (target: >95%)
- Task completion rate (target: >95%)
- Error rate (target: <2%)
- Sub-agent utilization

## Support

For issues or questions:
- Check sub-agent logs
- Review orchestrator routing
- Verify credential configuration
- Test individual components

---
Migration Date: {datetime.now().isoformat()}
