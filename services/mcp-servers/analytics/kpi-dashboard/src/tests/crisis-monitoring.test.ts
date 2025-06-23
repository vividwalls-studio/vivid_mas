/**
 * Crisis Trigger Monitoring Tests
 */

import { describe, it, expect, beforeEach } from '@jest/globals';
import { BusinessManagerKPIs } from '../business-manager-kpis';
import { MockAnalyticsDatabase } from './mocks/mock-database';

describe('Crisis Trigger Monitoring', () => {
  let businessManagerKPIs: BusinessManagerKPIs;
  let mockDb: MockAnalyticsDatabase;

  beforeEach(() => {
    mockDb = new MockAnalyticsDatabase();
    businessManagerKPIs = new BusinessManagerKPIs(mockDb as any);
  });

  describe('Revenue Crisis Detection', () => {
    it('should trigger critical alert for severe revenue decline', async () => {
      mockDb.setMockData({
        revenueMetrics: { 
          growth_percentage: -25,  // 25% decline
          total: 75000,
          order_count: 250
        },
        customerMetrics: { satisfaction_score: 4.2, cac: 45 }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.monitoring_status).toBe('attention_required');
      const revenueAlert = result.active_alerts.find(a => a.type === 'revenue_decline');
      expect(revenueAlert).toBeDefined();
      expect(revenueAlert?.severity).toBe('critical');
      expect(revenueAlert?.value).toBe(-25);
      
      const revenueAction = result.immediate_actions.find(a => a.trigger_type === 'revenue_decline');
      expect(revenueAction?.priority).toBe('critical');
    });

    it('should not trigger for positive revenue growth', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: 15 },
        customerMetrics: { satisfaction_score: 4.5, cac: 40 }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.monitoring_status).toBe('healthy');
      expect(result.active_alerts).toHaveLength(0);
    });

    it('should trigger at exactly -10% threshold', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -10 }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const revenueAlert = result.active_alerts.find(a => a.type === 'revenue_decline');
      expect(revenueAlert).toBeDefined();
    });
  });

  describe('Customer Satisfaction Crisis Detection', () => {
    it('should trigger high severity alert for low satisfaction', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: 5 },
        customerMetrics: { 
          satisfaction_score: 3.2,  // Well below 4.0 threshold
          cac: 45,
          retention_rate: 65
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const satisfactionAlert = result.active_alerts.find(a => a.type === 'low_satisfaction');
      expect(satisfactionAlert).toBeDefined();
      expect(satisfactionAlert?.severity).toBe('high');
      expect(satisfactionAlert?.threshold).toBe(4.0);
      expect(satisfactionAlert?.message).toContain('3.2/5.0');
    });

    it('should not trigger for satisfaction at or above threshold', async () => {
      mockDb.setMockData({
        customerMetrics: { satisfaction_score: 4.0, cac: 45 }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const satisfactionAlert = result.active_alerts.find(a => a.type === 'low_satisfaction');
      expect(satisfactionAlert).toBeUndefined();
    });
  });

  describe('Customer Acquisition Cost Crisis Detection', () => {
    it('should trigger medium severity alert for high CAC', async () => {
      mockDb.setMockData({
        customerMetrics: { 
          cac: 75,  // $75, well above $50 threshold
          clv: 850,
          satisfaction_score: 4.3
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      const cacAlert = result.active_alerts.find(a => a.type === 'high_cac');
      expect(cacAlert).toBeDefined();
      expect(cacAlert?.severity).toBe('medium');
      expect(cacAlert?.value).toBe(75);
      expect(cacAlert?.message).toContain('$75');
    });

    it('should calculate CAC to CLV ratio concerns', async () => {
      mockDb.setMockData({
        customerMetrics: { 
          cac: 65,
          clv: 200  // Poor CLV:CAC ratio
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.active_alerts.length).toBeGreaterThan(0);
      // Should trigger high CAC alert
      const cacAlert = result.active_alerts.find(a => a.type === 'high_cac');
      expect(cacAlert).toBeDefined();
    });
  });

  describe('Multiple Crisis Triggers', () => {
    it('should handle multiple simultaneous crisis triggers', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -15 },
        customerMetrics: { 
          satisfaction_score: 3.5,
          cac: 60,
          retention_rate: 55
        },
        operationalHealth: {
          system_uptime: 95,  // Below normal
          error_rate: 5
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.monitoring_status).toBe('attention_required');
      expect(result.active_alerts.length).toBeGreaterThanOrEqual(3);
      
      // Should have all three types of alerts
      const alertTypes = result.active_alerts.map(a => a.type);
      expect(alertTypes).toContain('revenue_decline');
      expect(alertTypes).toContain('low_satisfaction');
      expect(alertTypes).toContain('high_cac');
    });

    it('should prioritize critical alerts over others', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -20 },  // Critical
        customerMetrics: { 
          satisfaction_score: 3.8,  // High
          cac: 52  // Medium
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      // Critical alerts should appear first
      expect(result.active_alerts[0].severity).toBe('critical');
      
      // Actions should be prioritized by severity
      const criticalActions = result.immediate_actions.filter(a => a.priority === 'critical');
      expect(criticalActions.length).toBeGreaterThan(0);
    });
  });

  describe('Crisis Action Generation', () => {
    it('should generate specific actions for each crisis type', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -12 },
        customerMetrics: { satisfaction_score: 3.7, cac: 55 }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      // Check revenue decline action
      const revenueAction = result.immediate_actions.find(a => a.trigger_type === 'revenue_decline');
      expect(revenueAction?.action).toContain('analyze channel performance');
      expect(revenueAction?.action).toContain('pause underperforming');
      
      // Check satisfaction action
      const satisfactionAction = result.immediate_actions.find(a => a.trigger_type === 'low_satisfaction');
      expect(satisfactionAction?.action).toContain('customer feedback');
      expect(satisfactionAction?.action).toContain('service improvements');
      
      // Check CAC action
      const cacAction = result.immediate_actions.find(a => a.trigger_type === 'high_cac');
      expect(cacAction?.action).toContain('Optimize targeting');
      expect(cacAction?.action).toContain('segmentation');
    });

    it('should include context in crisis actions', async () => {
      mockDb.setMockData({
        revenueMetrics: { 
          growth_percentage: -18,
          total: 82000,
          order_count: 280
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.immediate_actions.length).toBeGreaterThan(0);
      result.immediate_actions.forEach(action => {
        expect(action.trigger_type).toBeDefined();
        expect(action.action).toBeDefined();
        expect(action.priority).toBeDefined();
      });
    });
  });

  describe('Real-time Monitoring', () => {
    it('should use recent time windows for real-time monitoring', async () => {
      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.timestamp).toBeDefined();
      const timestamp = new Date(result.timestamp);
      const now = new Date();
      const timeDiff = Math.abs(now.getTime() - timestamp.getTime());
      
      // Timestamp should be within 1 second of current time
      expect(timeDiff).toBeLessThan(1000);
    });

    it('should format monitoring status correctly', async () => {
      // Test healthy status
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: 10 },
        customerMetrics: { satisfaction_score: 4.5, cac: 40 }
      });
      
      let result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      expect(result.monitoring_status).toBe('healthy');
      
      // Test attention required status
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -15 }
      });
      
      result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      expect(result.monitoring_status).toBe('attention_required');
    });
  });

  describe('Edge Cases', () => {
    it('should handle missing metrics gracefully', async () => {
      mockDb.setMockData({
        revenueMetrics: null,
        customerMetrics: { satisfaction_score: 4.2 }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result).toBeDefined();
      expect(result.monitoring_status).toBeDefined();
    });

    it('should handle extreme values appropriately', async () => {
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -50 },  // Extreme decline
        customerMetrics: { 
          satisfaction_score: 1.0,  // Extremely low
          cac: 200  // Extremely high
        }
      });

      const result = await businessManagerKPIs.monitorCrisisTriggersRealtime();
      
      expect(result.monitoring_status).toBe('attention_required');
      expect(result.active_alerts.length).toBeGreaterThan(0);
      
      // All alerts should be critical or high severity
      result.active_alerts.forEach(alert => {
        expect(['critical', 'high']).toContain(alert.severity);
      });
    });
  });
});