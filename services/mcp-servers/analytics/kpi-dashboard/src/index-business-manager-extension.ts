/**
 * Business Manager Agent Extension for KPI Dashboard MCP Server
 * 
 * This module extends the existing KPI dashboard with Business Manager-specific tools
 * for comprehensive oversight and coordination capabilities.
 */

import { FastMCP } from 'fastmcp';
import { BusinessManagerKPIs, businessManagerToolSchemas } from './business-manager-kpis.js';

export function registerBusinessManagerTools(
  server: FastMCP,
  db: any,
  bi: any,
  campaignAnalytics: any,
  customerAnalytics: any,
  agentPerformance: any
) {
  // Initialize Business Manager KPIs module
  const businessManagerKPIs = new BusinessManagerKPIs(db);

  // ==============================================
  // BUSINESS MANAGER OVERSIGHT TOOLS
  // ==============================================

  server.tool(
    'get_business_manager_dashboard',
    businessManagerToolSchemas.get_business_manager_dashboard.description,
    businessManagerToolSchemas.get_business_manager_dashboard.parameters,
    async ({ timeframe }) => {
      const dashboard = await businessManagerKPIs.getBusinessManagerDashboard(timeframe);
      return {
        success: true,
        data: dashboard,
        message: 'Business Manager dashboard generated successfully'
      };
    }
  );

  server.tool(
    'track_agent_task',
    businessManagerToolSchemas.track_agent_task.description,
    businessManagerToolSchemas.track_agent_task.parameters,
    async ({ agent_id, task_data }) => {
      const result = await businessManagerKPIs.trackAgentTaskCompletion(agent_id, task_data);
      return {
        success: true,
        data: result,
        message: `Task tracked for agent ${agent_id}`
      };
    }
  );

  server.tool(
    'track_agent_communication',
    businessManagerToolSchemas.track_agent_communication.description,
    businessManagerToolSchemas.track_agent_communication.parameters,
    async (params) => {
      const result = await businessManagerKPIs.trackAgentCommunication(params);
      return {
        success: true,
        data: result,
        message: 'Agent communication tracked successfully'
      };
    }
  );

  server.tool(
    'track_budget_allocation',
    businessManagerToolSchemas.track_budget_allocation.description,
    businessManagerToolSchemas.track_budget_allocation.parameters,
    async (allocation) => {
      const result = await businessManagerKPIs.trackBudgetAllocation(allocation);
      return {
        success: true,
        data: result,
        message: `Budget allocation tracked: ${allocation.channel}`
      };
    }
  );

  server.tool(
    'get_agent_scorecard',
    businessManagerToolSchemas.get_agent_scorecard.description,
    businessManagerToolSchemas.get_agent_scorecard.parameters,
    async ({ agent_id, days }) => {
      const scorecard = await businessManagerKPIs.getAgentScorecard(agent_id, days);
      return {
        success: true,
        data: scorecard,
        message: 'Agent scorecard generated successfully'
      };
    }
  );

  server.tool(
    'monitor_crisis_triggers',
    businessManagerToolSchemas.monitor_crisis_triggers.description,
    businessManagerToolSchemas.monitor_crisis_triggers.parameters,
    async () => {
      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      return {
        success: true,
        data: triggers,
        message: triggers.active_alerts.length > 0 
          ? 'Crisis triggers detected - immediate action required' 
          : 'All systems operating within normal parameters'
      };
    }
  );

  server.tool(
    'generate_stakeholder_report',
    businessManagerToolSchemas.generate_stakeholder_report.description,
    businessManagerToolSchemas.generate_stakeholder_report.parameters,
    async ({ report_type }) => {
      const report = await businessManagerKPIs.generateStakeholderReport(report_type);
      return {
        success: true,
        data: report,
        message: `${report_type} stakeholder report generated`,
        html_artifact: report.html_template
      };
    }
  );

  // ==============================================
  // STRATEGIC DECISION SUPPORT TOOLS
  // ==============================================

  server.tool(
    'analyze_strategic_alignment',
    'Analyze alignment between agent activities and business objectives',
    {
      objectives: ['revenue_growth', 'customer_satisfaction', 'operational_efficiency'],
      period_days: 30
    },
    async ({ objectives, period_days }) => {
      // Analyze how well current activities align with strategic objectives
      const [agentActivities, businessMetrics, campaignPerformance] = await Promise.all([
        agentPerformance.getAgentPerformanceMetrics(undefined, period_days),
        bi.getBusinessKPIs(objectives, { days: period_days }),
        campaignAnalytics.analyzeCampaignPerformance('all', period_days)
      ]);

      const alignmentScore = calculateStrategicAlignment(
        agentActivities,
        businessMetrics,
        campaignPerformance,
        objectives
      );

      return {
        success: true,
        data: {
          alignment_score: alignmentScore,
          objectives_analysis: analyzeObjectiveProgress(businessMetrics, objectives),
          recommendations: generateAlignmentRecommendations(alignmentScore)
        },
        message: `Strategic alignment score: ${alignmentScore.overall}%`
      };
    }
  );

  server.tool(
    'coordinate_multi_agent_campaign',
    'Coordinate complex campaigns across multiple agents and channels',
    {
      campaign_type: 'product_launch',
      agents_involved: ['marketing_director', 'social_media_director', 'email_marketing'],
      budget: 10000,
      duration_days: 30
    },
    async ({ campaign_type, agents_involved, budget, duration_days }) => {
      // Create coordination plan for multi-agent campaign
      const coordinationPlan = {
        campaign_id: `campaign_${Date.now()}`,
        type: campaign_type,
        agents: agents_involved,
        budget_allocation: allocateBudgetByAgent(budget, agents_involved),
        timeline: generateCampaignTimeline(duration_days, agents_involved),
        communication_protocol: defineAgentCommunicationProtocol(agents_involved),
        success_metrics: defineCampaignSuccessMetrics(campaign_type)
      };

      // Track the coordination setup
      await businessManagerKPIs.trackAgentCommunication({
        from_agent: 'business_manager',
        to_agent: 'all_campaign_agents',
        communication_type: 'task_delegation',
        success: true
      });

      return {
        success: true,
        data: coordinationPlan,
        message: 'Multi-agent campaign coordination plan created'
      };
    }
  );

  server.tool(
    'evaluate_resource_allocation_efficiency',
    'Evaluate current resource allocation across all channels and agents',
    {
      include_recommendations: true
    },
    async ({ include_recommendations }) => {
      // Get current budget status and performance metrics
      const [budgetStatus, channelPerformance, agentUtilization] = await Promise.all([
        bi.getBudgetStatus(),
        campaignAnalytics.analyzeCampaignPerformance('all', 30),
        agentPerformance.getAgentPerformanceMetrics(undefined, 30)
      ]);

      const efficiency = calculateResourceEfficiency(
        budgetStatus,
        channelPerformance,
        agentUtilization
      );

      const result = {
        success: true,
        data: {
          efficiency_score: efficiency,
          budget_utilization: budgetStatus.utilization_rate,
          roi_by_channel: budgetStatus.roi_by_channel,
          agent_productivity: calculateAgentProductivity(agentUtilization)
        },
        message: `Resource allocation efficiency: ${efficiency.overall}%`
      };

      if (include_recommendations) {
        result.data.recommendations = generateResourceOptimizationPlan(efficiency);
      }

      return result;
    }
  );

  // ==============================================
  // RESOURCE PROVIDERS FOR BUSINESS MANAGER
  // ==============================================

  server.resource(
    'business-manager-dashboard',
    'Real-time Business Manager oversight dashboard',
    'application/json',
    async () => {
      const dashboard = await businessManagerKPIs.getBusinessManagerDashboard('daily');
      return JSON.stringify(dashboard, null, 2);
    }
  );

  server.resource(
    'agent-coordination-status',
    'Current status of all agent coordination activities',
    'application/json',
    async () => {
      const scorecard = await businessManagerKPIs.getAgentScorecard(undefined, 1);
      return JSON.stringify(scorecard, null, 2);
    }
  );

  server.resource(
    'crisis-monitoring-status',
    'Real-time crisis trigger monitoring data',
    'application/json',
    async () => {
      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      return JSON.stringify(triggers, null, 2);
    }
  );

  console.log('✅ Business Manager tools registered successfully');
}

// Helper functions for strategic analysis
function calculateStrategicAlignment(agentActivities: any, businessMetrics: any, campaignPerformance: any, objectives: string[]) {
  // Mock implementation - would calculate actual alignment scores
  return {
    overall: 85,
    by_objective: objectives.map(obj => ({ objective: obj, score: 80 + Math.random() * 20 }))
  };
}

function analyzeObjectiveProgress(businessMetrics: any, objectives: string[]) {
  return objectives.map(obj => ({
    objective: obj,
    current_progress: Math.random() * 100,
    target_progress: 100,
    on_track: Math.random() > 0.3
  }));
}

function generateAlignmentRecommendations(alignmentScore: any) {
  const recommendations = [];
  if (alignmentScore.overall < 90) {
    recommendations.push({
      priority: 'high',
      action: 'Realign agent priorities with underperforming objectives',
      expected_impact: 'Improve alignment by 10-15%'
    });
  }
  return recommendations;
}

function allocateBudgetByAgent(totalBudget: number, agents: string[]) {
  const allocation: Record<string, number> = {};
  const equalShare = totalBudget / agents.length;
  agents.forEach(agent => {
    allocation[agent] = equalShare;
  });
  return allocation;
}

function generateCampaignTimeline(durationDays: number, agents: string[]) {
  return {
    start_date: new Date().toISOString(),
    end_date: new Date(Date.now() + durationDays * 24 * 60 * 60 * 1000).toISOString(),
    milestones: [
      { day: 1, description: 'Campaign launch', responsible_agents: agents },
      { day: 7, description: 'First performance review', responsible_agents: ['business_manager'] },
      { day: 14, description: 'Mid-campaign optimization', responsible_agents: agents },
      { day: durationDays, description: 'Campaign completion', responsible_agents: agents }
    ]
  };
}

function defineAgentCommunicationProtocol(agents: string[]) {
  return {
    reporting_frequency: 'daily',
    communication_channels: ['mcp_direct', 'workflow_events'],
    escalation_path: ['specialist_agent', 'director_agent', 'business_manager']
  };
}

function defineCampaignSuccessMetrics(campaignType: string) {
  const baseMetrics = ['roi', 'conversion_rate', 'customer_acquisition'];
  const typeSpecificMetrics: Record<string, string[]> = {
    product_launch: ['product_awareness', 'initial_sales_velocity'],
    seasonal: ['inventory_turnover', 'repeat_purchase_rate'],
    retention: ['customer_lifetime_value', 'churn_reduction']
  };
  return [...baseMetrics, ...(typeSpecificMetrics[campaignType] || [])];
}

function calculateResourceEfficiency(budgetStatus: any, channelPerformance: any, agentUtilization: any) {
  return {
    overall: 82,
    budget_efficiency: 85,
    channel_efficiency: 78,
    agent_efficiency: 83
  };
}

function calculateAgentProductivity(agentUtilization: any) {
  return {
    average_task_completion_time: '2.5 hours',
    tasks_per_agent_per_day: 12,
    quality_score: 92
  };
}

function generateResourceOptimizationPlan(efficiency: any) {
  return [
    {
      area: 'budget_reallocation',
      action: 'Shift 15% budget from low-ROI channels to top performers',
      expected_improvement: '12% ROI increase'
    },
    {
      area: 'agent_workload',
      action: 'Redistribute tasks based on agent efficiency scores',
      expected_improvement: '20% faster task completion'
    }
  ];
}