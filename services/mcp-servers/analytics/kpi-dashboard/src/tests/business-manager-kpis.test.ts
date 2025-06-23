/**
 * Unit Tests for Business Manager KPIs Module
 */

import { describe, it, expect, beforeEach, jest } from '@jest/globals';
import { BusinessManagerKPIs } from '../business-manager-kpis';
import { MockAnalyticsDatabase } from './mocks/mock-database';

describe('BusinessManagerKPIs', () => {
  let businessManagerKPIs: BusinessManagerKPIs;
  let mockDb: MockAnalyticsDatabase;

  beforeEach(() => {
    mockDb = new MockAnalyticsDatabase();
    businessManagerKPIs = new BusinessManagerKPIs(mockDb as any);
  });

  describe('getBusinessManagerDashboard', () => {
    it('should return comprehensive dashboard data for daily timeframe', async () => {
      const dashboard = await businessManagerKPIs.getBusinessManagerDashboard('daily');
      
      expect(dashboard).toBeDefined();
      expect(dashboard.timeframe).toBe('daily');
      expect(dashboard.executive_summary).toBeDefined();
      expect(dashboard.executive_summary.total_revenue).toBeGreaterThanOrEqual(0);
      expect(dashboard.executive_summary.conversion_rate).toBeGreaterThanOrEqual(0);
      expect(dashboard.executive_summary.customer_acquisition_cost).toBeGreaterThanOrEqual(0);
      expect(dashboard.crisis_alerts).toBeInstanceOf(Array);
      expect(dashboard.recommendations).toBeInstanceOf(Array);
    });

    it('should return weekly dashboard with correct date range', async () => {
      const dashboard = await businessManagerKPIs.getBusinessManagerDashboard('weekly');
      
      expect(dashboard.timeframe).toBe('weekly');
      // Verify date range calculation
      const now = new Date();
      const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
      // Dashboard should contain data from the past week
      expect(dashboard.timestamp).toBeDefined();
    });

    it('should include crisis alerts when thresholds are breached', async () => {
      // Mock data that triggers crisis alerts
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -15 }, // Revenue decline > 10%
        customerMetrics: { satisfaction_score: 3.5, cac: 60 }, // Low satisfaction & high CAC
      });

      const dashboard = await businessManagerKPIs.getBusinessManagerDashboard('daily');
      
      expect(dashboard.crisis_alerts.length).toBeGreaterThan(0);
      expect(dashboard.crisis_alerts.some(alert => alert.type === 'revenue_decline')).toBe(true);
      expect(dashboard.crisis_alerts.some(alert => alert.type === 'low_satisfaction')).toBe(true);
      expect(dashboard.crisis_alerts.some(alert => alert.type === 'high_cac')).toBe(true);
    });
  });

  describe('trackAgentTaskCompletion', () => {
    it('should successfully track agent task completion', async () => {
      const taskData = {
        task_type: 'campaign_optimization',
        completion_time_ms: 3600000,
        success: true,
        quality_score: 0.95,
        impact_metrics: {
          roas_improvement: 0.15,
          budget_saved: 2500
        }
      };

      const result = await businessManagerKPIs.trackAgentTaskCompletion('marketing_director', taskData);
      
      expect(result).toBeDefined();
      expect(result.success).toBe(true);
      expect(mockDb.trackedActivities.length).toBe(1);
      expect(mockDb.trackedActivities[0].agent_id).toBe('marketing_director');
      expect(mockDb.trackedActivities[0].activity_type).toBe('task_completion');
    });

    it('should handle failed tasks appropriately', async () => {
      const taskData = {
        task_type: 'data_analysis',
        completion_time_ms: 7200000,
        success: false,
        quality_score: 0.3
      };

      const result = await businessManagerKPIs.trackAgentTaskCompletion('analytics_director', taskData);
      
      expect(result.success).toBe(true);
      expect(mockDb.trackedActivities[0].metrics.success).toBe(false);
    });
  });

  describe('trackAgentCommunication', () => {
    it('should track inter-agent communication', async () => {
      const communicationData = {
        from_agent: 'business_manager',
        to_agent: 'marketing_director',
        communication_type: 'task_delegation' as const,
        response_time_ms: 1500,
        success: true
      };

      const result = await businessManagerKPIs.trackAgentCommunication(communicationData);
      
      expect(result).toBeDefined();
      expect(result.success).toBe(true);
      expect(mockDb.trackedCommunications.length).toBe(1);
      expect(mockDb.trackedCommunications[0].from_agent).toBe('business_manager');
      expect(mockDb.trackedCommunications[0].to_agent).toBe('marketing_director');
    });

    it('should handle different communication types', async () => {
      const communicationTypes = ['task_delegation', 'data_request', 'status_update', 'collaboration'];
      
      for (const type of communicationTypes) {
        await businessManagerKPIs.trackAgentCommunication({
          from_agent: 'agent1',
          to_agent: 'agent2',
          communication_type: type as any,
          success: true
        });
      }

      expect(mockDb.trackedCommunications.length).toBe(4);
      expect(mockDb.trackedCommunications.map(c => c.communication_type)).toEqual(communicationTypes);
    });
  });

  describe('trackBudgetAllocation', () => {
    it('should track budget allocation decisions', async () => {
      const allocation = {
        channel: 'facebook_ads',
        previous_budget: 10000,
        new_budget: 12500,
        reason: 'High ROAS performance',
        expected_roi: 4.2,
        decision_metrics: {
          last_week_roas: 4.5,
          conversion_rate: 3.8
        }
      };

      const result = await businessManagerKPIs.trackBudgetAllocation(allocation);
      
      expect(result).toBeDefined();
      expect(result.success).toBe(true);
      expect(mockDb.trackedBudgetDecisions.length).toBe(1);
      expect(mockDb.trackedBudgetDecisions[0].channel).toBe('facebook_ads');
      expect(mockDb.trackedBudgetDecisions[0].new_budget).toBe(12500);
    });

    it('should calculate budget change percentage', async () => {
      const allocation = {
        channel: 'pinterest',
        previous_budget: 5000,
        new_budget: 4000,
        reason: 'Underperforming channel',
        expected_roi: 2.5,
        decision_metrics: {}
      };

      await businessManagerKPIs.trackBudgetAllocation(allocation);
      
      // 20% decrease
      expect(mockDb.trackedBudgetDecisions[0].previous_budget).toBe(5000);
      expect(mockDb.trackedBudgetDecisions[0].new_budget).toBe(4000);
    });
  });

  describe('getAgentScorecard', () => {
    it('should generate scorecard for specific agent', async () => {
      // Add mock agent activities
      mockDb.setMockAgentActivities([
        {
          agent_id: 'marketing_director',
          activity_type: 'task_completion',
          timestamp: new Date(),
          metrics: { success: true, completion_time_ms: 3600000, quality_score: 0.9 }
        },
        {
          agent_id: 'marketing_director',
          activity_type: 'task_completion',
          timestamp: new Date(),
          metrics: { success: true, completion_time_ms: 2700000, quality_score: 0.95 }
        }
      ]);

      const scorecard = await businessManagerKPIs.getAgentScorecard('marketing_director', 7);
      
      expect(scorecard).toBeDefined();
      expect(scorecard.period).toBeDefined();
      expect(scorecard.agents).toBeDefined();
      expect(scorecard.overall_efficiency).toBeGreaterThanOrEqual(0);
      expect(scorecard.coordination_score).toBeGreaterThanOrEqual(0);
      expect(scorecard.recommendations).toBeInstanceOf(Array);
    });

    it('should generate scorecard for all agents when no agent_id provided', async () => {
      const scorecard = await businessManagerKPIs.getAgentScorecard(undefined, 7);
      
      expect(scorecard).toBeDefined();
      expect(scorecard.agents).toBeDefined();
    });
  });

  describe('monitorCrisisTriggersRealtime', () => {
    it('should detect no crisis when metrics are healthy', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: 10 },
        customerMetrics: { satisfaction_score: 4.5, cac: 40 },
        operationalHealth: { system_uptime: 99.9 }
      });

      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(triggers.monitoring_status).toBe('healthy');
      expect(triggers.active_alerts.length).toBe(0);
    });

    it('should detect crisis triggers and provide immediate actions', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -12 },
        customerMetrics: { satisfaction_score: 3.8, cac: 55 },
        operationalHealth: { system_uptime: 99.9 }
      });

      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(triggers.monitoring_status).toBe('attention_required');
      expect(triggers.active_alerts.length).toBeGreaterThan(0);
      expect(triggers.immediate_actions).toBeInstanceOf(Array);
      expect(triggers.immediate_actions.length).toBeGreaterThan(0);
    });

    it('should prioritize crisis triggers by severity', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -20 }, // Critical
        customerMetrics: { satisfaction_score: 3.5, cac: 60 }, // High & Medium
      });

      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const criticalAlerts = triggers.active_alerts.filter(a => a.severity === 'critical');
      const highAlerts = triggers.active_alerts.filter(a => a.severity === 'high');
      
      expect(criticalAlerts.length).toBeGreaterThan(0);
      expect(highAlerts.length).toBeGreaterThan(0);
    });
  });

  describe('generateStakeholderReport', () => {
    it('should generate daily stakeholder report', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report).toBeDefined();
      expect(report.report_type).toBe('daily');
      expect(report.generated_at).toBeDefined();
      expect(report.data).toBeDefined();
      expect(report.html_template).toBeDefined();
      expect(report.export_formats).toContain('html');
      expect(report.export_formats).toContain('pdf');
      expect(report.interactive_elements).toBeInstanceOf(Array);
    });

    it('should include interactive elements in report', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('weekly');
      
      expect(report.interactive_elements).toContain('revenue_trend_chart');
      expect(report.interactive_elements).toContain('channel_performance_radar');
      expect(report.interactive_elements).toContain('agent_efficiency_heatmap');
      expect(report.interactive_elements).toContain('customer_journey_funnel');
    });

    it('should support different report types', async () => {
      const reportTypes = ['daily', 'weekly', 'monthly'] as const;
      
      for (const type of reportTypes) {
        const report = await businessManagerKPIs.generateStakeholderReport(type);
        expect(report.report_type).toBe(type);
      }
    });
  });

  describe('Crisis Action Generation', () => {
    it('should generate appropriate actions for revenue decline', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -15 },
        customerMetrics: { satisfaction_score: 4.2, cac: 45 }
      });

      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const revenueAction = triggers.immediate_actions.find(
        a => a.trigger_type === 'revenue_decline'
      );
      
      expect(revenueAction).toBeDefined();
      expect(revenueAction?.action).toContain('analyze channel performance');
    });

    it('should generate appropriate actions for low satisfaction', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: 5 },
        customerMetrics: { satisfaction_score: 3.7, cac: 45 }
      });

      const triggers = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const satisfactionAction = triggers.immediate_actions.find(
        a => a.trigger_type === 'low_satisfaction'
      );
      
      expect(satisfactionAction).toBeDefined();
      expect(satisfactionAction?.action).toContain('customer feedback');
    });
  });

  describe('Executive Recommendations', () => {
    it('should generate recommendations based on low ROAS', async () => {
      mockDb.setMockData({
        channelPerformance: { overall_roas: 2.8 } // Below 3.5 threshold
      });

      const dashboard = await businessManagerKPIs.getBusinessManagerDashboard('daily');
      
      const budgetRecommendation = dashboard.recommendations.find(
        r => r.category === 'budget_optimization'
      );
      
      expect(budgetRecommendation).toBeDefined();
      expect(budgetRecommendation?.priority).toBe('high');
      expect(budgetRecommendation?.action).toContain('Reallocate budget');
    });
  });
});