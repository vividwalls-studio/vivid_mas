/**
 * Integration Tests for Business Manager MCP Server Tools
 */

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { FastMCP } from 'fastmcp';
import { registerBusinessManagerTools } from '../index-business-manager-extension';
import { MockAnalyticsDatabase } from './mocks/mock-database';

describe('Business Manager MCP Server Integration', () => {
  let server: FastMCP;
  let mockDb: MockAnalyticsDatabase;
  let mockBi: any;
  let mockCampaignAnalytics: any;
  let mockCustomerAnalytics: any;
  let mockAgentPerformance: any;

  beforeEach(() => {
    // Initialize server
    server = new FastMCP('Test Server', {
      version: '1.0.0',
      description: 'Test server for Business Manager tools'
    });

    // Initialize mocks
    mockDb = new MockAnalyticsDatabase();
    
    mockBi = {
      getBudgetStatus: jest.fn().mockResolvedValue(mockDb.getBudgetStatus()),
      getBusinessKPIs: jest.fn().mockResolvedValue({
        revenue: 100000,
        growth_rate: 15,
        conversion_rate: 3.2
      }),
      calculateForecastAccuracy: jest.fn().mockReturnValue(0.92),
      generateScenarioAnalysis: jest.fn().mockReturnValue([])
    };

    mockCampaignAnalytics = {
      analyzeCampaignPerformance: jest.fn().mockResolvedValue({
        overall_roas: 3.8,
        campaigns: []
      })
    };

    mockCustomerAnalytics = {
      analyzeCustomerSegments: jest.fn().mockResolvedValue([]),
      generateTargetingRecommendations: jest.fn().mockReturnValue([])
    };

    mockAgentPerformance = {
      getAgentPerformanceMetrics: jest.fn().mockResolvedValue({
        agents: [],
        overall_efficiency: 85
      })
    };

    // Register Business Manager tools
    registerBusinessManagerTools(
      server,
      mockDb,
      mockBi,
      mockCampaignAnalytics,
      mockCustomerAnalytics,
      mockAgentPerformance
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('get_business_manager_dashboard', () => {
    it('should successfully call dashboard tool', async () => {
      const result = await server.callTool('get_business_manager_dashboard', {
        timeframe: 'daily'
      });

      expect(result.success).toBe(true);
      expect(result.data).toBeDefined();
      expect(result.data.timeframe).toBe('daily');
      expect(result.data.executive_summary).toBeDefined();
      expect(result.message).toContain('successfully');
    });

    it('should handle different timeframes correctly', async () => {
      const timeframes = ['daily', 'weekly', 'monthly'];
      
      for (const timeframe of timeframes) {
        const result = await server.callTool('get_business_manager_dashboard', {
          timeframe
        });
        
        expect(result.success).toBe(true);
        expect(result.data.timeframe).toBe(timeframe);
      }
    });
  });

  describe('track_agent_task', () => {
    it('should track agent task completion', async () => {
      const taskData = {
        task_type: 'campaign_optimization',
        completion_time_ms: 3600000,
        success: true,
        quality_score: 0.95,
        impact_metrics: {
          roas_improvement: 0.15
        }
      };

      const result = await server.callTool('track_agent_task', {
        agent_id: 'marketing_director',
        task_data: taskData
      });

      expect(result.success).toBe(true);
      expect(result.message).toContain('Task tracked for agent marketing_director');
      expect(mockDb.trackedActivities.length).toBe(1);
    });

    it('should handle task tracking without optional fields', async () => {
      const taskData = {
        task_type: 'report_generation',
        completion_time_ms: 1800000,
        success: true
      };

      const result = await server.callTool('track_agent_task', {
        agent_id: 'analytics_director',
        task_data: taskData
      });

      expect(result.success).toBe(true);
      expect(mockDb.trackedActivities[0].metrics.quality_score).toBeNull();
    });
  });

  describe('track_agent_communication', () => {
    it('should track agent communication patterns', async () => {
      const result = await server.callTool('track_agent_communication', {
        from_agent: 'business_manager',
        to_agent: 'marketing_director',
        communication_type: 'task_delegation',
        response_time_ms: 1500,
        success: true
      });

      expect(result.success).toBe(true);
      expect(result.message).toContain('communication tracked successfully');
      expect(mockDb.trackedCommunications.length).toBe(1);
    });

    it('should work without optional response_time_ms', async () => {
      const result = await server.callTool('track_agent_communication', {
        from_agent: 'marketing_director',
        to_agent: 'social_media_director',
        communication_type: 'collaboration',
        success: true
      });

      expect(result.success).toBe(true);
      expect(mockDb.trackedCommunications[0].response_time_ms).toBeUndefined();
    });
  });

  describe('track_budget_allocation', () => {
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

      const result = await server.callTool('track_budget_allocation', allocation);

      expect(result.success).toBe(true);
      expect(result.message).toContain('Budget allocation tracked: facebook_ads');
      expect(mockDb.trackedBudgetDecisions.length).toBe(1);
      expect(mockDb.trackedBudgetDecisions[0].new_budget).toBe(12500);
    });
  });

  describe('get_agent_scorecard', () => {
    it('should generate agent scorecard for specific agent', async () => {
      const result = await server.callTool('get_agent_scorecard', {
        agent_id: 'marketing_director',
        days: 7
      });

      expect(result.success).toBe(true);
      expect(result.data).toBeDefined();
      expect(result.data.period).toBeDefined();
      expect(result.data.overall_efficiency).toBeGreaterThanOrEqual(0);
    });

    it('should generate scorecard for all agents when agent_id is omitted', async () => {
      const result = await server.callTool('get_agent_scorecard', {
        days: 30
      });

      expect(result.success).toBe(true);
      expect(result.data).toBeDefined();
    });
  });

  describe('monitor_crisis_triggers', () => {
    it('should detect crisis triggers when metrics breach thresholds', async () => {
      // Set mock data that triggers alerts
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -15 },
        customerMetrics: { satisfaction_score: 3.5, cac: 55 }
      });

      const result = await server.callTool('monitor_crisis_triggers', {});

      expect(result.success).toBe(true);
      expect(result.data.monitoring_status).toBe('attention_required');
      expect(result.data.active_alerts.length).toBeGreaterThan(0);
      expect(result.message).toContain('Crisis triggers detected');
    });

    it('should report healthy status when no triggers active', async () => {
      // Set healthy mock data
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: 10 },
        customerMetrics: { satisfaction_score: 4.5, cac: 40 }
      });

      const result = await server.callTool('monitor_crisis_triggers', {});

      expect(result.success).toBe(true);
      expect(result.data.monitoring_status).toBe('healthy');
      expect(result.data.active_alerts.length).toBe(0);
      expect(result.message).toContain('normal parameters');
    });
  });

  describe('generate_stakeholder_report', () => {
    it('should generate stakeholder report with HTML artifact', async () => {
      const result = await server.callTool('generate_stakeholder_report', {
        report_type: 'daily'
      });

      expect(result.success).toBe(true);
      expect(result.data.report_type).toBe('daily');
      expect(result.data.generated_at).toBeDefined();
      expect(result.html_artifact).toBeDefined();
      expect(result.message).toContain('daily stakeholder report generated');
    });

    it('should support different report types', async () => {
      const reportTypes = ['daily', 'weekly', 'monthly'];
      
      for (const reportType of reportTypes) {
        const result = await server.callTool('generate_stakeholder_report', {
          report_type: reportType
        });
        
        expect(result.success).toBe(true);
        expect(result.data.report_type).toBe(reportType);
      }
    });
  });

  describe('Strategic Decision Support Tools', () => {
    it('should analyze strategic alignment', async () => {
      const result = await server.callTool('analyze_strategic_alignment', {
        objectives: ['revenue_growth', 'customer_satisfaction'],
        period_days: 30
      });

      expect(result.success).toBe(true);
      expect(result.data.alignment_score).toBeDefined();
      expect(result.data.objectives_analysis).toBeDefined();
      expect(result.data.recommendations).toBeInstanceOf(Array);
      expect(mockAgentPerformance.getAgentPerformanceMetrics).toHaveBeenCalled();
      expect(mockBi.getBusinessKPIs).toHaveBeenCalled();
    });

    it('should coordinate multi-agent campaigns', async () => {
      const result = await server.callTool('coordinate_multi_agent_campaign', {
        campaign_type: 'product_launch',
        agents_involved: ['marketing_director', 'social_media_director'],
        budget: 25000,
        duration_days: 30
      });

      expect(result.success).toBe(true);
      expect(result.data.campaign_id).toBeDefined();
      expect(result.data.budget_allocation).toBeDefined();
      expect(result.data.timeline).toBeDefined();
      expect(result.data.communication_protocol).toBeDefined();
      expect(mockDb.trackedCommunications.length).toBe(1);
    });

    it('should evaluate resource allocation efficiency', async () => {
      const result = await server.callTool('evaluate_resource_allocation_efficiency', {
        include_recommendations: true
      });

      expect(result.success).toBe(true);
      expect(result.data.efficiency_score).toBeDefined();
      expect(result.data.budget_utilization).toBeDefined();
      expect(result.data.recommendations).toBeDefined();
      expect(mockBi.getBudgetStatus).toHaveBeenCalled();
      expect(mockCampaignAnalytics.analyzeCampaignPerformance).toHaveBeenCalled();
    });
  });

  describe('Resource Providers', () => {
    it('should provide business-manager-dashboard resource', async () => {
      const resources = server.getResources();
      const dashboardResource = resources.find(r => r.uri === 'business-manager-dashboard');
      
      expect(dashboardResource).toBeDefined();
      expect(dashboardResource?.mimeType).toBe('application/json');
      
      if (dashboardResource?.handler) {
        const content = await dashboardResource.handler();
        const data = JSON.parse(content);
        expect(data.timeframe).toBe('daily');
        expect(data.executive_summary).toBeDefined();
      }
    });

    it('should provide agent-coordination-status resource', async () => {
      const resources = server.getResources();
      const coordinationResource = resources.find(r => r.uri === 'agent-coordination-status');
      
      expect(coordinationResource).toBeDefined();
      expect(coordinationResource?.mimeType).toBe('application/json');
    });

    it('should provide crisis-monitoring-status resource', async () => {
      const resources = server.getResources();
      const crisisResource = resources.find(r => r.uri === 'crisis-monitoring-status');
      
      expect(crisisResource).toBeDefined();
      expect(crisisResource?.mimeType).toBe('application/json');
    });
  });

  describe('Error Handling', () => {
    it('should handle database errors gracefully', async () => {
      // Mock database error
      mockDb.trackAgentActivity = jest.fn().mockRejectedValue(new Error('Database connection failed'));

      try {
        await server.callTool('track_agent_task', {
          agent_id: 'test_agent',
          task_data: {
            task_type: 'test',
            completion_time_ms: 1000,
            success: true
          }
        });
      } catch (error) {
        expect(error).toBeDefined();
        expect(error.message).toContain('Database connection failed');
      }
    });

    it('should validate required parameters', async () => {
      try {
        // Missing required agent_id
        await server.callTool('track_agent_task', {
          task_data: {
            task_type: 'test',
            completion_time_ms: 1000,
            success: true
          }
        });
      } catch (error) {
        expect(error).toBeDefined();
      }
    });
  });
});