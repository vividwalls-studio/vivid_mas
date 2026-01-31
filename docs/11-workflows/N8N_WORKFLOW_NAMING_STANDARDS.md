# N8N Workflow Naming Standards & Nomenclature

## Overview

A standardized naming convention ensures workflows are:
- **Searchable**: Easy to find using partial names
- **Sortable**: Logical ordering in lists
- **Identifiable**: Clear purpose at a glance
- **Scalable**: Works for hundreds of workflows
- **Consistent**: Follows predictable patterns

## Naming Format

### Standard Structure

```
[PREFIX]-[CATEGORY]-[FUNCTION]-[SPECIFIC]-[VERSION]
```

### Components Breakdown

1. **PREFIX** (Required): Client/Project identifier
   - `VW` = VividWalls
   - `DT` = DesignThru AI
   - `DEMO` = Course/Demo
   - `TPL` = Template
   - `TEST` = Test workflows

2. **CATEGORY** (Required): Department/Area
   - `BM` = Business Manager
   - `MKT` = Marketing
   - `SLS` = Sales
   - `OPS` = Operations
   - `CX` = Customer Experience
   - `PRD` = Product
   - `FIN` = Finance
   - `ANL` = Analytics
   - `TECH` = Technology
   - `SOC` = Social Media
   - `INT` = Integration
   - `DATA` = Data Processing
   - `AUTO` = Automation
   - `UTIL` = Utility

3. **FUNCTION** (Required): Primary action/purpose
   - `DIR` = Director Agent
   - `ORCH` = Orchestrator
   - `SYNC` = Synchronization
   - `PROC` = Processing
   - `NOTIF` = Notification
   - `REPORT` = Reporting
   - `IMPORT` = Data Import
   - `EXPORT` = Data Export
   - `WEBHOOK` = Webhook Handler
   - `SCHED` = Scheduled Task
   - `API` = API Integration
   - `AGENT` = Agent Workflow

4. **SPECIFIC** (Optional): Specific details
   - Platform names: `Shopify`, `Stripe`, `SendGrid`
   - Agent names: `Campaign`, `Research`, `Content`
   - Process names: `Orders`, `Inventory`, `Customers`

5. **VERSION** (Optional): Version indicator
   - `v1`, `v2`, `v3` = Version numbers
   - `dev` = Development version
   - `prod` = Production version
   - `beta` = Beta testing
   - `archive` = Archived version

## Naming Examples

### VividWalls MAS Workflows

#### Director Agents
- `VW-BM-DIR-Orchestrator` (Business Manager Director Orchestrator)
- `VW-MKT-DIR-Main` (Marketing Director Main)
- `VW-SLS-DIR-Main` (Sales Director Main)
- `VW-OPS-DIR-Main` (Operations Director Main)
- `VW-CX-DIR-Main` (Customer Experience Director)
- `VW-PRD-DIR-Main` (Product Director)
- `VW-FIN-DIR-Main` (Finance Director)
- `VW-ANL-DIR-Main` (Analytics Director)
- `VW-TECH-DIR-Main` (Technology Director)
- `VW-SOC-DIR-Main` (Social Media Director)

#### Marketing Agents
- `VW-MKT-AGENT-Campaign` (Marketing Campaign Agent)
- `VW-MKT-AGENT-Research` (Marketing Research Agent)
- `VW-MKT-AGENT-Content` (Content Marketing Agent)
- `VW-MKT-AGENT-Email` (Email Marketing Agent)
- `VW-MKT-AGENT-Strategy` (Content Strategy Agent)

#### Sales Agents
- `VW-SLS-AGENT-Hospitality` (Hospitality Sales Agent)
- `VW-SLS-AGENT-Corporate` (Corporate Sales Agent)
- `VW-SLS-AGENT-Healthcare` (Healthcare Sales Agent)
- `VW-SLS-AGENT-Residential` (Residential Sales Agent)

#### Integration Workflows
- `VW-INT-API-Shopify-Sync` (Shopify Integration)
- `VW-INT-API-Stripe-Payment` (Stripe Payment Processing)
- `VW-INT-API-SendGrid-Email` (SendGrid Email Service)
- `VW-INT-API-Supabase-Data` (Supabase Data Sync)
- `VW-INT-API-Neo4j-Graph` (Neo4j Graph Operations)

#### Data Processing
- `VW-DATA-PROC-Orders` (Order Processing)
- `VW-DATA-PROC-Inventory` (Inventory Processing)
- `VW-DATA-SYNC-Products` (Product Synchronization)
- `VW-DATA-IMPORT-Customers` (Customer Import)
- `VW-DATA-EXPORT-Reports` (Report Export)

#### Scheduled Tasks
- `VW-AUTO-SCHED-DailyReports` (Daily Reports)
- `VW-AUTO-SCHED-WeeklyAnalytics` (Weekly Analytics)
- `VW-AUTO-SCHED-InventoryCheck` (Inventory Check)

#### Webhook Handlers
- `VW-INT-WEBHOOK-OrderCreated` (Order Created Webhook)
- `VW-INT-WEBHOOK-CustomerSignup` (Customer Signup)
- `VW-INT-WEBHOOK-PaymentComplete` (Payment Complete)

### Demo/Template Workflows
- `DEMO-INT-API-Basic` (Basic API Demo)
- `DEMO-DATA-PROC-CSV` (CSV Processing Demo)
- `DEMO-AUTO-WEBHOOK-Simple` (Simple Webhook Demo)
- `TPL-INT-API-REST` (REST API Template)
- `TPL-DATA-SYNC-Generic` (Generic Sync Template)
- `TPL-AUTO-NOTIF-Email` (Email Notification Template)

### Test Workflows
- `TEST-INT-API-Shopify-dev` (Shopify API Test)
- `TEST-DATA-PROC-Performance` (Performance Test)
- `TEST-AUTO-WEBHOOK-Debug` (Webhook Debug Test)

## Search Patterns

The nomenclature enables powerful search patterns:

### By Client
- `VW-*` = All VividWalls workflows
- `DT-*` = All DesignThru workflows
- `DEMO-*` = All demo workflows

### By Department
- `*-MKT-*` = All marketing workflows
- `*-SLS-*` = All sales workflows
- `*-FIN-*` = All finance workflows

### By Function
- `*-DIR-*` = All director agents
- `*-AGENT-*` = All agent workflows
- `*-API-*` = All API integrations
- `*-WEBHOOK-*` = All webhook handlers
- `*-SCHED-*` = All scheduled tasks

### By Platform
- `*-Shopify*` = All Shopify-related
- `*-Stripe*` = All Stripe-related
- `*-SendGrid*` = All SendGrid-related

### By Version
- `*-v2` = All version 2 workflows
- `*-dev` = All development workflows
- `*-prod` = All production workflows

## Migration Mapping

Current names to new nomenclature:

| Current Name | New Name |
|-------------|----------|
| Business Manager | VW-BM-DIR-Orchestrator |
| Marketing Director Agent | VW-MKT-DIR-Main |
| Sales Director Agent | VW-SLS-DIR-Main |
| VividWalls Marketing Campaign Agent | VW-MKT-AGENT-Campaign |
| VividWalls Customer Relationship Agent | VW-CX-AGENT-Relationship |
| VividWalls Shopify | VW-INT-API-Shopify-Sync |
| Order Fulfillment Workflow | VW-OPS-PROC-OrderFulfillment |
| Data Analytics Agent | VW-ANL-AGENT-DataAnalysis |
| Facebook Agent | VW-SOC-AGENT-Facebook |
| Instagram Agent | VW-SOC-AGENT-Instagram |
| Content Strategy Agent | VW-MKT-AGENT-Strategy |
| Creative Director Agent | VW-MKT-DIR-Creative |
| Shopify Agent | VW-INT-AGENT-Shopify |
| My workflow | TEST-UTIL-Unnamed-001 |
| WordPress Chatbot with OpenAI | DEMO-INT-API-WordPress-Chat |

## Benefits of This Nomenclature

### 1. Improved Searchability
- Find all workflows for a client instantly
- Filter by department or function
- Locate specific integrations quickly

### 2. Better Organization
- Workflows sort logically in lists
- Related workflows appear together
- Clear hierarchy visible

### 3. Instant Recognition
- Purpose clear from name alone
- No need to open workflow to understand it
- Status (dev/prod) immediately visible

### 4. Scalability
- Works for 10 or 1000 workflows
- Easy to add new categories
- Consistent across teams

### 5. Team Collaboration
- Everyone uses same naming
- Reduces confusion
- Easier handoffs

## Implementation Rules

1. **No Spaces**: Use hyphens to separate components
2. **Use UPPERCASE** for prefixes and categories
3. **Use PascalCase** for specific names
4. **Keep It Short**: Maximum 50 characters
5. **Be Specific**: Avoid generic terms
6. **Version Control**: Always indicate dev/prod status
7. **No Special Characters**: Only letters, numbers, hyphens
8. **Consistent Abbreviations**: Use standard abbreviations

## Enforcement

### Automated Checks
- Script validates naming on save
- Suggestions provided for non-compliant names
- Reports generated for naming violations

### Manual Review
- Weekly audit of new workflows
- Rename non-compliant workflows
- Update documentation as needed

## Quick Reference Card

```
PREFIX-CATEGORY-FUNCTION-[Specific]-[Version]

PREFIX:     VW | DT | DEMO | TPL | TEST
CATEGORY:   BM | MKT | SLS | OPS | CX | PRD | FIN | ANL | TECH | SOC | INT | DATA | AUTO | UTIL
FUNCTION:   DIR | ORCH | SYNC | PROC | NOTIF | REPORT | IMPORT | EXPORT | WEBHOOK | SCHED | API | AGENT
Specific:   PascalCase description
Version:    v1 | v2 | dev | prod | beta | archive
```

## Examples by Use Case

### "I need to find all production marketing workflows"
Search: `VW-MKT-*-prod`

### "Show me all webhook handlers"
Search: `*-WEBHOOK-*`

### "Find all Shopify integrations"
Search: `*-Shopify*`

### "List all director agents"
Search: `*-DIR-*`

### "Show development workflows"
Search: `*-dev`

This nomenclature system provides a robust, scalable foundation for workflow management that will grow with your needs.