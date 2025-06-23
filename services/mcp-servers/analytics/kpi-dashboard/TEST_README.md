# Business Manager KPI Dashboard Testing Guide

## Overview

This document describes the comprehensive test suite for the Business Manager KPI Dashboard MCP Server. The tests ensure all functionality works correctly, from basic KPI tracking to crisis monitoring and stakeholder report generation.

## Test Structure

```
src/tests/
├── business-manager-kpis.test.ts    # Unit tests for core KPI functionality
├── mcp-server-integration.test.ts   # Integration tests for MCP tools
├── crisis-monitoring.test.ts        # Crisis trigger detection tests
├── stakeholder-report.test.ts       # Report generation tests
├── run-all-tests.ts                 # Test runner script
└── mocks/
    └── mock-database.ts             # Mock database for testing
```

## Running Tests

### Prerequisites

```bash
# Install dependencies
npm install

# Build the project (if needed)
npm run build
```

### Run All Tests

```bash
# Run complete test suite
npm test

# Run tests in watch mode (for development)
npm run test:watch

# Run tests with coverage report
npm run test:coverage
```

### Run Specific Test Suites

```bash
# Unit tests only
npm run test:unit

# Integration tests only
npm run test:integration

# Crisis monitoring tests only
npm run test:crisis

# Stakeholder report tests only
npm run test:report
```

### Run Test Runner Script

```bash
# Make the script executable (first time only)
chmod +x src/tests/run-all-tests.ts

# Run all tests with summary
npx tsx src/tests/run-all-tests.ts
```

## Test Coverage

The test suite covers:

### 1. **Business Manager KPIs Module** (Unit Tests)
- ✅ Executive dashboard generation (daily/weekly/monthly)
- ✅ Agent task tracking
- ✅ Inter-agent communication tracking
- ✅ Budget allocation tracking
- ✅ Agent scorecard generation
- ✅ Crisis trigger monitoring
- ✅ Stakeholder report generation
- ✅ Executive recommendations
- ✅ Crisis action generation

### 2. **MCP Server Integration** (Integration Tests)
- ✅ All Business Manager tools registration
- ✅ Tool parameter validation
- ✅ Response format verification
- ✅ Resource providers
- ✅ Error handling
- ✅ Strategic decision support tools

### 3. **Crisis Monitoring** (Specialized Tests)
- ✅ Revenue decline detection (>10%)
- ✅ Customer satisfaction alerts (<4.0)
- ✅ High CAC detection (>$50)
- ✅ Multiple simultaneous triggers
- ✅ Severity prioritization
- ✅ Action generation for each crisis type
- ✅ Real-time monitoring accuracy
- ✅ Edge cases and extreme values

### 4. **Stakeholder Reports** (Report Tests)
- ✅ Daily, weekly, monthly report types
- ✅ Executive summary accuracy
- ✅ HTML template generation
- ✅ Export format support (HTML, PDF, CSV)
- ✅ Interactive elements
- ✅ Crisis alert inclusion
- ✅ Recommendation generation
- ✅ Data formatting and accuracy

## Test Data

Tests use mock data to simulate various scenarios:

### Healthy Metrics (Default)
```javascript
{
  revenueMetrics: { growth_percentage: 5, total: 100000 },
  customerMetrics: { satisfaction_score: 4.3, cac: 42.50 },
  channelPerformance: { overall_roas: 3.8 }
}
```

### Crisis Scenarios
```javascript
// Revenue crisis
{ revenueMetrics: { growth_percentage: -15 } }

// Customer satisfaction crisis
{ customerMetrics: { satisfaction_score: 3.5 } }

// High CAC crisis
{ customerMetrics: { cac: 60 } }
```

## Coverage Requirements

The project maintains high test coverage standards:
- **Branches**: 80%
- **Functions**: 80%
- **Lines**: 80%
- **Statements**: 80%

## Debugging Tests

### Enable Verbose Output
```bash
# Run with detailed logging
npm test -- --verbose

# Run specific test file with debugging
npm test -- src/tests/crisis-monitoring.test.ts --verbose
```

### Debug in VS Code
1. Add breakpoints in test files
2. Use "Debug: Jest Tests" configuration
3. Or run: `npm test -- --inspect-brk`

## Common Issues

### 1. Module Resolution Errors
```bash
# If you see "Cannot find module" errors
npm run build
```

### 2. Type Errors
```bash
# Check TypeScript compilation
npm run typecheck
```

### 3. Test Timeouts
Tests have a 10-second timeout. If tests are timing out:
- Check async operations
- Verify mock implementations
- Increase timeout in jest.config.js if needed

## Adding New Tests

When adding new Business Manager features:

1. **Add unit tests** in `business-manager-kpis.test.ts`
2. **Add integration tests** in `mcp-server-integration.test.ts`
3. **Update mock database** if new data structures are needed
4. **Run full test suite** to ensure no regressions

Example test structure:
```typescript
describe('New Feature', () => {
  it('should perform expected behavior', async () => {
    // Arrange
    const mockData = { /* test data */ };
    mockDb.setMockData(mockData);
    
    // Act
    const result = await businessManagerKPIs.newFeature();
    
    // Assert
    expect(result).toBeDefined();
    expect(result.property).toBe(expectedValue);
  });
});
```

## CI/CD Integration

For continuous integration:

```yaml
# Example GitHub Actions workflow
test:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-node@v3
      with:
        node-version: '18'
    - run: npm ci
    - run: npm run build
    - run: npm test
    - run: npm run test:coverage
```

## Performance Testing

While not included in the main test suite, consider performance testing for:
- Dashboard generation time (<100ms)
- Crisis trigger detection (<50ms)
- Report generation (<500ms)
- Concurrent tool calls

## Security Testing

Ensure tests cover:
- Input validation
- SQL injection prevention (if using raw queries)
- Authorization checks
- Data sanitization

## Maintenance

- Review and update tests when Business Manager requirements change
- Keep mock data realistic and aligned with production scenarios
- Update coverage thresholds as code quality improves
- Document any test-specific environment requirements