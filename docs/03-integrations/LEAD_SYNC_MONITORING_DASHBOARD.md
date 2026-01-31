# Lead Sync Monitoring Dashboard

## Overview

The Lead Sync Monitoring Dashboard provides real-time visibility into the bi-directional synchronization between Twenty CRM and Supabase. This dashboard helps monitor sync health, identify issues, and track lead flow metrics.

## Dashboard Components

### 1. Sync Status Overview

```sql
-- Real-time sync status summary
SELECT 
    sync_status,
    COUNT(*) as lead_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage,
    MAX(last_synced_at) as last_sync_time,
    AVG(sync_error_count) as avg_errors
FROM leads
GROUP BY sync_status
ORDER BY lead_count DESC;
```

### 2. Sync Performance Metrics

```sql
-- Hourly sync performance
SELECT 
    DATE_TRUNC('hour', synced_at) as sync_hour,
    COUNT(*) as syncs_completed,
    COUNT(CASE WHEN sync_status = 'error' THEN 1 END) as sync_errors,
    ROUND(AVG(EXTRACT(EPOCH FROM (synced_at - created_at))), 2) as avg_sync_time_seconds
FROM lead_sync_history
WHERE synced_at > NOW() - INTERVAL '24 hours'
GROUP BY sync_hour
ORDER BY sync_hour DESC;
```

### 3. Lead Flow Analytics

```sql
-- Daily lead flow by source and direction
SELECT 
    DATE_TRUNC('day', created_at) as date,
    lead_source,
    sync_direction,
    COUNT(*) as lead_count,
    AVG(lead_score) as avg_score
FROM leads
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY date, lead_source, sync_direction
ORDER BY date DESC, lead_count DESC;
```

### 4. Error Tracking

```sql
-- Recent sync errors with details
SELECT 
    l.id,
    l.first_name || ' ' || l.last_name as lead_name,
    l.email,
    l.sync_error_message,
    l.sync_error_count,
    l.last_synced_at,
    lsh.error_message as last_error_detail
FROM leads l
LEFT JOIN LATERAL (
    SELECT error_message 
    FROM lead_sync_history 
    WHERE lead_id = l.id 
    AND sync_status = 'error'
    ORDER BY synced_at DESC 
    LIMIT 1
) lsh ON true
WHERE l.sync_status = 'error'
ORDER BY l.sync_error_count DESC, l.last_synced_at DESC
LIMIT 20;
```

### 5. Segment Distribution

```sql
-- Lead distribution by segment and sync status
SELECT 
    cs.segment_name,
    COUNT(l.id) as total_leads,
    COUNT(CASE WHEN l.sync_status = 'synced' THEN 1 END) as synced_leads,
    COUNT(CASE WHEN l.twenty_id IS NOT NULL THEN 1 END) as in_twenty,
    AVG(l.lead_score) as avg_lead_score,
    AVG(l.segment_confidence) as avg_confidence
FROM leads l
LEFT JOIN customer_segments cs ON l.segment_id = cs.id
GROUP BY cs.segment_name
ORDER BY total_leads DESC;
```

## Monitoring Views

### Lead Sync Health Dashboard

```sql
CREATE OR REPLACE VIEW lead_sync_health_dashboard AS
WITH sync_stats AS (
    SELECT 
        COUNT(*) as total_leads,
        COUNT(CASE WHEN sync_status = 'synced' THEN 1 END) as synced_leads,
        COUNT(CASE WHEN sync_status = 'pending' THEN 1 END) as pending_leads,
        COUNT(CASE WHEN sync_status = 'error' THEN 1 END) as error_leads,
        COUNT(CASE WHEN last_synced_at > NOW() - INTERVAL '1 hour' THEN 1 END) as recently_synced
    FROM leads
),
sync_performance AS (
    SELECT 
        AVG(CASE WHEN sync_status = 'synced' THEN 1 ELSE 0 END) * 100 as sync_success_rate,
        PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY EXTRACT(EPOCH FROM (last_synced_at - updated_at))
        ) as median_sync_time_seconds
    FROM leads
    WHERE last_synced_at IS NOT NULL
),
error_summary AS (
    SELECT 
        COUNT(DISTINCT lead_id) as leads_with_errors,
        COUNT(*) as total_errors,
        MAX(synced_at) as last_error_time
    FROM lead_sync_history
    WHERE sync_status = 'error'
    AND synced_at > NOW() - INTERVAL '24 hours'
)
SELECT 
    s.*,
    sp.sync_success_rate,
    sp.median_sync_time_seconds,
    es.leads_with_errors,
    es.total_errors,
    es.last_error_time,
    CASE 
        WHEN s.error_leads > 10 OR sp.sync_success_rate < 90 THEN 'critical'
        WHEN s.error_leads > 5 OR sp.sync_success_rate < 95 THEN 'warning'
        ELSE 'healthy'
    END as overall_health
FROM sync_stats s, sync_performance sp, error_summary es;
```

### Real-time Sync Activity

```sql
CREATE OR REPLACE VIEW real_time_sync_activity AS
SELECT 
    lsh.id,
    lsh.synced_at,
    lsh.sync_type,
    lsh.sync_direction,
    lsh.sync_status,
    lsh.fields_changed,
    l.first_name || ' ' || l.last_name as lead_name,
    l.email,
    l.company_name,
    cs.segment_name
FROM lead_sync_history lsh
JOIN leads l ON lsh.lead_id = l.id
LEFT JOIN customer_segments cs ON l.segment_id = cs.id
WHERE lsh.synced_at > NOW() - INTERVAL '1 hour'
ORDER BY lsh.synced_at DESC
LIMIT 100;
```

## Alert Conditions

### Critical Alerts

1. **Sync Failure Rate > 10%**
```sql
SELECT 
    CASE 
        WHEN (COUNT(CASE WHEN sync_status = 'error' THEN 1 END) * 100.0 / COUNT(*)) > 10 
        THEN true 
        ELSE false 
    END as alert_critical_failure_rate
FROM lead_sync_history
WHERE synced_at > NOW() - INTERVAL '1 hour';
```

2. **No Syncs in 30 Minutes**
```sql
SELECT 
    CASE 
        WHEN MAX(synced_at) < NOW() - INTERVAL '30 minutes' 
        THEN true 
        ELSE false 
    END as alert_sync_stalled
FROM lead_sync_history;
```

3. **High Error Count Lead**
```sql
SELECT 
    id, 
    first_name || ' ' || last_name as lead_name,
    sync_error_count
FROM leads
WHERE sync_error_count > 5
ORDER BY sync_error_count DESC;
```

## Implementation in n8n

### Monitoring Workflow

```json
{
  "name": "Lead Sync Monitor",
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [
            {
              "field": "minutes",
              "minutesInterval": 5
            }
          ]
        }
      },
      "name": "Check Every 5 Minutes",
      "type": "n8n-nodes-base.scheduleTrigger"
    },
    {
      "parameters": {
        "mcpTool": {
          "server": "supabase",
          "tool": "get-sync-metrics",
          "arguments": {}
        }
      },
      "name": "Get Sync Metrics",
      "type": "@modelcontextprotocol/n8n-nodes-mcp"
    },
    {
      "parameters": {
        "conditions": {
          "number": [
            {
              "value1": "={{$json.metrics[2].count}}",
              "operation": "larger",
              "value2": 10
            }
          ]
        }
      },
      "name": "Check Error Threshold",
      "type": "n8n-nodes-base.if"
    }
  ]
}
```

## Grafana Dashboard Configuration

### Panel 1: Sync Status Pie Chart
- Query: `sync_monitoring` view
- Visualization: Pie chart
- Group by: `sync_status`
- Metric: `count`

### Panel 2: Sync Performance Time Series
- Query: `lead_analytics` view  
- Visualization: Time series graph
- X-axis: `date`
- Y-axis: `total_leads`, `synced_to_twenty`

### Panel 3: Error Rate Gauge
- Query: Calculate error percentage from `sync_monitoring`
- Visualization: Gauge
- Thresholds: 
  - Green: 0-5%
  - Yellow: 5-10%
  - Red: >10%

### Panel 4: Recent Errors Table
- Query: Recent errors with lead details
- Visualization: Table
- Columns: Lead Name, Error Message, Error Count, Last Sync

## Usage Guide

### 1. Setup Database Views
```bash
# Run the migration to create monitoring views
psql $SUPABASE_DB_URL -f services/supabase/migrations/203_lead_sync_monitoring.sql
```

### 2. Configure n8n Monitoring
- Import the monitoring workflow JSON
- Set up alert notifications (Telegram, Email, Slack)
- Configure thresholds based on your requirements

### 3. Access Metrics via MCP
```javascript
// Get current sync metrics
{
  server: 'supabase',
  tool: 'get-sync-metrics',
  arguments: {}
}
```

### 4. Create Custom Alerts
```sql
-- Example: Alert for stale leads
CREATE OR REPLACE FUNCTION check_stale_leads()
RETURNS TABLE(stale_count INTEGER, oldest_pending TIMESTAMP)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as stale_count,
        MIN(created_at) as oldest_pending
    FROM leads
    WHERE sync_status = 'pending'
    AND created_at < NOW() - INTERVAL '1 hour';
END;
$$ LANGUAGE plpgsql;
```

## Troubleshooting Guide

### Common Issues

1. **High Error Rate**
   - Check Twenty CRM API availability
   - Verify API rate limits
   - Review error messages in `lead_sync_history`

2. **Sync Delays**
   - Check n8n workflow execution logs
   - Verify schedule triggers are active
   - Monitor database connection pool

3. **Duplicate Leads**
   - Review conflict resolution settings
   - Check `twenty_id` uniqueness
   - Verify upsert logic in workflows

### Debug Queries

```sql
-- Find stuck leads
SELECT * FROM leads 
WHERE sync_status = 'syncing' 
AND updated_at < NOW() - INTERVAL '10 minutes';

-- Check webhook processing
SELECT 
    DATE_TRUNC('minute', synced_at) as minute,
    COUNT(*) as webhook_count
FROM lead_sync_history
WHERE sync_type = 'webhook_update'
AND synced_at > NOW() - INTERVAL '1 hour'
GROUP BY minute
ORDER BY minute DESC;
```

## Performance Optimization

### Indexes for Monitoring
```sql
-- Already included in migration
CREATE INDEX idx_sync_history_monitoring 
ON lead_sync_history(synced_at DESC, sync_status);

CREATE INDEX idx_leads_sync_monitoring 
ON leads(sync_status, last_synced_at);
```

### Materialized Views (Optional)
```sql
-- For high-traffic dashboards
CREATE MATERIALIZED VIEW lead_sync_daily_summary AS
SELECT 
    DATE_TRUNC('day', synced_at) as sync_date,
    sync_direction,
    sync_status,
    COUNT(*) as sync_count,
    COUNT(DISTINCT lead_id) as unique_leads
FROM lead_sync_history
GROUP BY sync_date, sync_direction, sync_status;

-- Refresh daily
CREATE OR REPLACE FUNCTION refresh_daily_summary()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY lead_sync_daily_summary;
END;
$$ LANGUAGE plpgsql;
```

## Maintenance

### Weekly Tasks
1. Review error patterns
2. Clean up old sync history (>30 days)
3. Analyze sync performance trends
4. Update alert thresholds if needed

### Monthly Tasks
1. Audit lead data quality
2. Review segment classifications
3. Optimize slow queries
4. Archive completed sync logs

This monitoring dashboard ensures reliable lead synchronization between Twenty CRM and Supabase, providing the visibility needed to maintain data integrity and sync performance.