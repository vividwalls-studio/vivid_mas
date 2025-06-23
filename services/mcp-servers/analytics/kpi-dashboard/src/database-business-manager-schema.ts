/**
 * Database Schema Extensions for Business Manager Agent
 * 
 * Defines the data structures and tables needed to track Business Manager
 * activities, agent coordination, and strategic oversight metrics.
 */

export const businessManagerSchemas = {
  // Agent task tracking table
  agent_tasks: `
    CREATE TABLE IF NOT EXISTS agent_tasks (
      id SERIAL PRIMARY KEY,
      agent_id VARCHAR(100) NOT NULL,
      task_id VARCHAR(100) UNIQUE NOT NULL,
      task_type VARCHAR(100) NOT NULL,
      status VARCHAR(50) NOT NULL,
      priority VARCHAR(20),
      assigned_at TIMESTAMP NOT NULL,
      started_at TIMESTAMP,
      completed_at TIMESTAMP,
      completion_time_ms INTEGER,
      quality_score DECIMAL(3,2),
      success BOOLEAN,
      error_message TEXT,
      impact_metrics JSONB,
      created_by VARCHAR(100) DEFAULT 'business_manager',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_agent_tasks_agent (agent_id),
      INDEX idx_agent_tasks_status (status),
      INDEX idx_agent_tasks_created (created_at)
    );
  `,

  // Agent communication tracking
  agent_communications: `
    CREATE TABLE IF NOT EXISTS agent_communications (
      id SERIAL PRIMARY KEY,
      communication_id VARCHAR(100) UNIQUE NOT NULL,
      from_agent VARCHAR(100) NOT NULL,
      to_agent VARCHAR(100) NOT NULL,
      communication_type VARCHAR(50) NOT NULL,
      message_content TEXT,
      priority VARCHAR(20),
      request_timestamp TIMESTAMP NOT NULL,
      response_timestamp TIMESTAMP,
      response_time_ms INTEGER,
      success BOOLEAN NOT NULL,
      error_details TEXT,
      related_task_id VARCHAR(100),
      metadata JSONB,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_agent_comm_from (from_agent),
      INDEX idx_agent_comm_to (to_agent),
      INDEX idx_agent_comm_type (communication_type),
      INDEX idx_agent_comm_created (created_at)
    );
  `,

  // Budget allocation decisions
  budget_allocations: `
    CREATE TABLE IF NOT EXISTS budget_allocations (
      id SERIAL PRIMARY KEY,
      allocation_id VARCHAR(100) UNIQUE NOT NULL,
      channel VARCHAR(100) NOT NULL,
      previous_budget DECIMAL(10,2) NOT NULL,
      new_budget DECIMAL(10,2) NOT NULL,
      change_percentage DECIMAL(5,2),
      reason TEXT NOT NULL,
      expected_roi DECIMAL(5,2),
      actual_roi DECIMAL(5,2),
      decision_metrics JSONB NOT NULL,
      approved_by VARCHAR(100) DEFAULT 'business_manager',
      effective_date DATE NOT NULL,
      expiry_date DATE,
      status VARCHAR(50) DEFAULT 'active',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_budget_channel (channel),
      INDEX idx_budget_status (status),
      INDEX idx_budget_effective (effective_date)
    );
  `,

  // Agent performance metrics
  agent_performance_metrics: `
    CREATE TABLE IF NOT EXISTS agent_performance_metrics (
      id SERIAL PRIMARY KEY,
      agent_id VARCHAR(100) NOT NULL,
      metric_date DATE NOT NULL,
      tasks_completed INTEGER DEFAULT 0,
      tasks_failed INTEGER DEFAULT 0,
      average_completion_time_ms INTEGER,
      average_quality_score DECIMAL(3,2),
      response_time_ms_p50 INTEGER,
      response_time_ms_p95 INTEGER,
      response_time_ms_p99 INTEGER,
      efficiency_score DECIMAL(3,2),
      coordination_score DECIMAL(3,2),
      reliability_score DECIMAL(3,2),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      UNIQUE KEY unique_agent_date (agent_id, metric_date),
      INDEX idx_perf_agent (agent_id),
      INDEX idx_perf_date (metric_date)
    );
  `,

  // Crisis triggers and alerts
  crisis_triggers: `
    CREATE TABLE IF NOT EXISTS crisis_triggers (
      id SERIAL PRIMARY KEY,
      trigger_id VARCHAR(100) UNIQUE NOT NULL,
      trigger_type VARCHAR(100) NOT NULL,
      severity VARCHAR(20) NOT NULL,
      detected_value DECIMAL(10,2),
      threshold_value DECIMAL(10,2),
      metric_name VARCHAR(100),
      description TEXT,
      detected_at TIMESTAMP NOT NULL,
      acknowledged_at TIMESTAMP,
      resolved_at TIMESTAMP,
      resolution_action TEXT,
      resolution_result TEXT,
      status VARCHAR(50) DEFAULT 'active',
      metadata JSONB,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_crisis_type (trigger_type),
      INDEX idx_crisis_severity (severity),
      INDEX idx_crisis_status (status),
      INDEX idx_crisis_detected (detected_at)
    );
  `,

  // Strategic decisions log
  strategic_decisions: `
    CREATE TABLE IF NOT EXISTS strategic_decisions (
      id SERIAL PRIMARY KEY,
      decision_id VARCHAR(100) UNIQUE NOT NULL,
      decision_type VARCHAR(100) NOT NULL,
      decision_category VARCHAR(100),
      description TEXT NOT NULL,
      rationale TEXT,
      expected_impact TEXT,
      actual_impact TEXT,
      decision_data JSONB,
      approved_by VARCHAR(100) DEFAULT 'business_manager',
      stakeholder_notified BOOLEAN DEFAULT FALSE,
      notification_sent_at TIMESTAMP,
      decision_date TIMESTAMP NOT NULL,
      review_date TIMESTAMP,
      status VARCHAR(50) DEFAULT 'pending',
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_decision_type (decision_type),
      INDEX idx_decision_status (status),
      INDEX idx_decision_date (decision_date)
    );
  `,

  // Multi-agent coordination tracking
  coordination_sessions: `
    CREATE TABLE IF NOT EXISTS coordination_sessions (
      id SERIAL PRIMARY KEY,
      session_id VARCHAR(100) UNIQUE NOT NULL,
      campaign_id VARCHAR(100),
      session_type VARCHAR(100) NOT NULL,
      participating_agents JSONB NOT NULL,
      objectives JSONB,
      budget_allocated DECIMAL(10,2),
      start_time TIMESTAMP NOT NULL,
      end_time TIMESTAMP,
      status VARCHAR(50) DEFAULT 'active',
      outcome TEXT,
      performance_metrics JSONB,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_coord_campaign (campaign_id),
      INDEX idx_coord_type (session_type),
      INDEX idx_coord_status (status)
    );
  `,

  // Stakeholder reports metadata
  stakeholder_reports: `
    CREATE TABLE IF NOT EXISTS stakeholder_reports (
      id SERIAL PRIMARY KEY,
      report_id VARCHAR(100) UNIQUE NOT NULL,
      report_type VARCHAR(50) NOT NULL,
      report_period_start DATE NOT NULL,
      report_period_end DATE NOT NULL,
      generated_at TIMESTAMP NOT NULL,
      sent_to_stakeholder BOOLEAN DEFAULT FALSE,
      stakeholder_email VARCHAR(255),
      delivery_method VARCHAR(50),
      delivery_status VARCHAR(50),
      report_data JSONB NOT NULL,
      key_metrics JSONB,
      recommendations JSONB,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_report_type (report_type),
      INDEX idx_report_period (report_period_start, report_period_end),
      INDEX idx_report_generated (generated_at)
    );
  `,

  // Business KPI snapshots for historical tracking
  business_kpi_snapshots: `
    CREATE TABLE IF NOT EXISTS business_kpi_snapshots (
      id SERIAL PRIMARY KEY,
      snapshot_date DATE NOT NULL,
      snapshot_hour INTEGER NOT NULL,
      revenue DECIMAL(10,2),
      orders INTEGER,
      conversion_rate DECIMAL(5,2),
      average_order_value DECIMAL(10,2),
      customer_acquisition_cost DECIMAL(10,2),
      customer_lifetime_value DECIMAL(10,2),
      overall_roas DECIMAL(5,2),
      active_customers INTEGER,
      new_customers INTEGER,
      returning_customers INTEGER,
      channel_metrics JSONB,
      agent_metrics JSONB,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      UNIQUE KEY unique_snapshot (snapshot_date, snapshot_hour),
      INDEX idx_snapshot_date (snapshot_date)
    );
  `
};

// Helper functions for database operations
export const businessManagerQueries = {
  // Insert agent task
  insertAgentTask: `
    INSERT INTO agent_tasks (
      agent_id, task_id, task_type, status, priority, 
      assigned_at, impact_metrics
    ) VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING *;
  `,

  // Update task completion
  updateTaskCompletion: `
    UPDATE agent_tasks 
    SET 
      status = $2,
      completed_at = $3,
      completion_time_ms = $4,
      quality_score = $5,
      success = $6,
      error_message = $7,
      updated_at = CURRENT_TIMESTAMP
    WHERE task_id = $1
    RETURNING *;
  `,

  // Insert agent communication
  insertAgentCommunication: `
    INSERT INTO agent_communications (
      communication_id, from_agent, to_agent, communication_type,
      request_timestamp, response_timestamp, response_time_ms, 
      success, related_task_id, metadata
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    RETURNING *;
  `,

  // Insert budget allocation
  insertBudgetAllocation: `
    INSERT INTO budget_allocations (
      allocation_id, channel, previous_budget, new_budget,
      change_percentage, reason, expected_roi, decision_metrics,
      effective_date
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    RETURNING *;
  `,

  // Get agent performance summary
  getAgentPerformanceSummary: `
    SELECT 
      agent_id,
      COUNT(*) as total_tasks,
      SUM(CASE WHEN success = true THEN 1 ELSE 0 END) as successful_tasks,
      AVG(completion_time_ms) as avg_completion_time,
      AVG(quality_score) as avg_quality_score
    FROM agent_tasks
    WHERE created_at >= $1 AND created_at <= $2
    GROUP BY agent_id;
  `,

  // Get active crisis triggers
  getActiveCrisisTriggers: `
    SELECT * FROM crisis_triggers
    WHERE status = 'active'
    ORDER BY severity DESC, detected_at DESC;
  `,

  // Get recent strategic decisions
  getRecentStrategicDecisions: `
    SELECT * FROM strategic_decisions
    WHERE decision_date >= $1
    ORDER BY decision_date DESC
    LIMIT $2;
  `,

  // Insert KPI snapshot
  insertKPISnapshot: `
    INSERT INTO business_kpi_snapshots (
      snapshot_date, snapshot_hour, revenue, orders, conversion_rate,
      average_order_value, customer_acquisition_cost, customer_lifetime_value,
      overall_roas, active_customers, new_customers, returning_customers,
      channel_metrics, agent_metrics
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
    ON CONFLICT (snapshot_date, snapshot_hour) 
    DO UPDATE SET
      revenue = EXCLUDED.revenue,
      orders = EXCLUDED.orders,
      conversion_rate = EXCLUDED.conversion_rate,
      average_order_value = EXCLUDED.average_order_value,
      customer_acquisition_cost = EXCLUDED.customer_acquisition_cost,
      customer_lifetime_value = EXCLUDED.customer_lifetime_value,
      overall_roas = EXCLUDED.overall_roas,
      active_customers = EXCLUDED.active_customers,
      new_customers = EXCLUDED.new_customers,
      returning_customers = EXCLUDED.returning_customers,
      channel_metrics = EXCLUDED.channel_metrics,
      agent_metrics = EXCLUDED.agent_metrics,
      created_at = CURRENT_TIMESTAMP
    RETURNING *;
  `
};

// Indexes for optimized queries
export const businessManagerIndexes = [
  'CREATE INDEX idx_tasks_agent_date ON agent_tasks(agent_id, created_at DESC);',
  'CREATE INDEX idx_comm_agents ON agent_communications(from_agent, to_agent, created_at DESC);',
  'CREATE INDEX idx_budget_recent ON budget_allocations(effective_date DESC, channel);',
  'CREATE INDEX idx_crisis_active ON crisis_triggers(status, severity, detected_at DESC) WHERE status = \'active\';',
  'CREATE INDEX idx_decisions_recent ON strategic_decisions(decision_date DESC, status);',
  'CREATE INDEX idx_snapshots_recent ON business_kpi_snapshots(snapshot_date DESC, snapshot_hour DESC);'
];

// Views for common queries
export const businessManagerViews = {
  // Current agent efficiency view
  agent_efficiency_current: `
    CREATE OR REPLACE VIEW agent_efficiency_current AS
    SELECT 
      a.agent_id,
      COUNT(DISTINCT t.task_id) as tasks_today,
      AVG(t.completion_time_ms) as avg_completion_time,
      AVG(t.quality_score) as avg_quality_score,
      SUM(CASE WHEN t.success = true THEN 1 ELSE 0 END)::FLOAT / COUNT(*) as success_rate,
      MAX(t.completed_at) as last_task_completed
    FROM agent_tasks t
    WHERE t.created_at >= CURRENT_DATE
    GROUP BY a.agent_id;
  `,

  // Budget allocation effectiveness view
  budget_effectiveness: `
    CREATE OR REPLACE VIEW budget_effectiveness AS
    SELECT 
      channel,
      new_budget as current_budget,
      expected_roi,
      actual_roi,
      (actual_roi - expected_roi) as roi_variance,
      CASE 
        WHEN actual_roi >= expected_roi THEN 'meeting_expectations'
        ELSE 'below_expectations'
      END as performance_status
    FROM budget_allocations
    WHERE status = 'active'
    AND effective_date <= CURRENT_DATE
    AND (expiry_date IS NULL OR expiry_date > CURRENT_DATE);
  `,

  // Crisis trigger summary view  
  crisis_summary: `
    CREATE OR REPLACE VIEW crisis_summary AS
    SELECT 
      trigger_type,
      severity,
      COUNT(*) as trigger_count,
      MIN(detected_at) as first_detected,
      MAX(detected_at) as last_detected,
      AVG(EXTRACT(EPOCH FROM (COALESCE(resolved_at, CURRENT_TIMESTAMP) - detected_at))/3600) as avg_resolution_hours
    FROM crisis_triggers
    WHERE detected_at >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY trigger_type, severity;
  `
};