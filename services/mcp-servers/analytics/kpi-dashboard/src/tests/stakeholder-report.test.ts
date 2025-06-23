/**
 * Stakeholder Report Generation Tests
 */

import { describe, it, expect, beforeEach } from '@jest/globals';
import { BusinessManagerKPIs } from '../business-manager-kpis';
import { MockAnalyticsDatabase } from './mocks/mock-database';

describe('Stakeholder Report Generation', () => {
  let businessManagerKPIs: BusinessManagerKPIs;
  let mockDb: MockAnalyticsDatabase;

  beforeEach(() => {
    mockDb = new MockAnalyticsDatabase();
    businessManagerKPIs = new BusinessManagerKPIs(mockDb as any);
  });

  describe('Report Types', () => {
    it('should generate daily stakeholder report', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report).toBeDefined();
      expect(report.report_type).toBe('daily');
      expect(report.generated_at).toBeDefined();
      expect(report.data).toBeDefined();
      expect(report.data.timeframe).toBe('daily');
    });

    it('should generate weekly stakeholder report', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('weekly');
      
      expect(report.report_type).toBe('weekly');
      expect(report.data.timeframe).toBe('weekly');
      
      // Weekly report should have different data range
      expect(report.data).toBeDefined();
      expect(report.data.executive_summary).toBeDefined();
    });

    it('should generate monthly stakeholder report', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('monthly');
      
      expect(report.report_type).toBe('monthly');
      expect(report.data.timeframe).toBe('monthly');
      
      // Monthly report should include comprehensive metrics
      expect(report.data.executive_summary).toBeDefined();
      expect(report.data.channel_performance).toBeDefined();
      expect(report.data.agent_coordination).toBeDefined();
    });
  });

  describe('Report Content', () => {
    it('should include all required sections in report data', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      // Check executive summary
      expect(report.data.executive_summary).toMatchObject({
        total_revenue: expect.any(Number),
        revenue_growth: expect.any(Number),
        total_orders: expect.any(Number),
        conversion_rate: expect.any(Number),
        average_order_value: expect.any(Number),
        customer_acquisition_cost: expect.any(Number),
        customer_lifetime_value: expect.any(Number),
        overall_roas: expect.any(Number)
      });
      
      // Check other sections
      expect(report.data.channel_performance).toBeDefined();
      expect(report.data.agent_coordination).toBeDefined();
      expect(report.data.operational_health).toBeDefined();
      expect(report.data.customer_metrics).toBeDefined();
      expect(report.data.budget_status).toBeDefined();
      expect(report.data.crisis_alerts).toBeInstanceOf(Array);
      expect(report.data.recommendations).toBeInstanceOf(Array);
    });

    it('should include timestamp in correct format', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      const generatedAt = new Date(report.generated_at);
      expect(generatedAt).toBeInstanceOf(Date);
      expect(generatedAt.toISOString()).toBe(report.generated_at);
      
      // Should be recent (within last minute)
      const now = new Date();
      const timeDiff = Math.abs(now.getTime() - generatedAt.getTime());
      expect(timeDiff).toBeLessThan(60000); // 1 minute
    });
  });

  describe('HTML Template Generation', () => {
    it('should generate HTML template with required features', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report.html_template).toBeDefined();
      expect(report.html_template.template).toBe('modern_dashboard');
      expect(report.html_template.includes_charts).toBe(true);
      expect(report.html_template.responsive).toBe(true);
      expect(report.html_template.dark_mode_support).toBe(true);
    });

    it('should include export formats', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('weekly');
      
      expect(report.export_formats).toBeInstanceOf(Array);
      expect(report.export_formats).toContain('html');
      expect(report.export_formats).toContain('pdf');
      expect(report.export_formats).toContain('csv');
    });

    it('should include interactive elements', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('monthly');
      
      expect(report.interactive_elements).toBeInstanceOf(Array);
      expect(report.interactive_elements).toContain('revenue_trend_chart');
      expect(report.interactive_elements).toContain('channel_performance_radar');
      expect(report.interactive_elements).toContain('agent_efficiency_heatmap');
      expect(report.interactive_elements).toContain('customer_journey_funnel');
    });
  });

  describe('Report Data Accuracy', () => {
    it('should reflect current metrics in report', async () => {
      // Set specific mock data
      mockDb.setMockData({
        revenueMetrics: {
          total: 150000,
          growth_percentage: 20,
          order_count: 500,
          conversion_rate: 4.5,
          aov: 300
        },
        customerMetrics: {
          cac: 35,
          clv: 1000,
          satisfaction_score: 4.6
        }
      });

      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report.data.executive_summary.total_revenue).toBe(150000);
      expect(report.data.executive_summary.revenue_growth).toBe(20);
      expect(report.data.executive_summary.total_orders).toBe(500);
      expect(report.data.executive_summary.conversion_rate).toBe(4.5);
      expect(report.data.executive_summary.customer_acquisition_cost).toBe(35);
      expect(report.data.executive_summary.customer_lifetime_value).toBe(1000);
    });

    it('should include crisis alerts in report when active', async () => {
      // Set data that triggers crisis alerts
      mockDb.setMockData({
        revenueMetrics: { growth_percentage: -15 },
        customerMetrics: { satisfaction_score: 3.5, cac: 60 }
      });

      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report.data.crisis_alerts.length).toBeGreaterThan(0);
      expect(report.data.crisis_alerts.some(alert => alert.type === 'revenue_decline')).toBe(true);
      expect(report.data.crisis_alerts.some(alert => alert.type === 'low_satisfaction')).toBe(true);
    });

    it('should include recommendations based on performance', async () => {
      // Set data that triggers recommendations
      mockDb.setMockData({
        channelPerformance: { overall_roas: 2.8 } // Below 3.5 threshold
      });

      const report = await businessManagerKPIs.generateStakeholderReport('weekly');
      
      expect(report.data.recommendations.length).toBeGreaterThan(0);
      const budgetRecommendation = report.data.recommendations.find(
        r => r.category === 'budget_optimization'
      );
      expect(budgetRecommendation).toBeDefined();
      expect(budgetRecommendation?.priority).toBe('high');
    });
  });

  describe('Report Formatting', () => {
    it('should format numbers appropriately', async () => {
      mockDb.setMockData({
        revenueMetrics: {
          total: 123456.78,
          aov: 299.99
        },
        customerMetrics: {
          cac: 42.5555,
          clv: 850.1234
        }
      });

      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      // Numbers should be properly formatted in the report
      expect(report.data.executive_summary.total_revenue).toBe(123456.78);
      expect(report.data.executive_summary.average_order_value).toBe(299.99);
    });

    it('should handle missing data gracefully', async () => {
      // Set partial mock data
      mockDb.setMockData({
        revenueMetrics: null,
        customerMetrics: { satisfaction_score: 4.2 }
      });

      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report).toBeDefined();
      expect(report.data).toBeDefined();
      // Should have default values or zeros for missing data
      expect(report.data.executive_summary.total_revenue).toBe(0);
    });
  });

  describe('Report Metadata', () => {
    it('should include proper metadata for each report type', async () => {
      const reportTypes = ['daily', 'weekly', 'monthly'] as const;
      
      for (const type of reportTypes) {
        const report = await businessManagerKPIs.generateStakeholderReport(type);
        
        expect(report.report_type).toBe(type);
        expect(report.generated_at).toBeDefined();
        expect(report.data.timestamp).toBeDefined();
        expect(report.data.timeframe).toBe(type);
      }
    });

    it('should generate unique report data for each call', async () => {
      const report1 = await businessManagerKPIs.generateStakeholderReport('daily');
      
      // Wait a bit to ensure different timestamp
      await new Promise(resolve => setTimeout(resolve, 10));
      
      const report2 = await businessManagerKPIs.generateStakeholderReport('daily');
      
      expect(report1.generated_at).not.toBe(report2.generated_at);
      expect(report1.data.timestamp).not.toBe(report2.data.timestamp);
    });
  });

  describe('Stakeholder Communication Features', () => {
    it('should support stakeholder notification preferences', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('daily');
      
      // Report should be ready for different delivery methods
      expect(report.export_formats).toContain('html');
      expect(report.html_template).toBeDefined();
      
      // Should support the requirements from Business Manager prompt
      expect(report.html_template.responsive).toBe(true);
      expect(report.html_template.dark_mode_support).toBe(true);
    });

    it('should include actionable insights for stakeholders', async () => {
      const report = await businessManagerKPIs.generateStakeholderReport('weekly');
      
      // Should have recommendations
      expect(report.data.recommendations).toBeInstanceOf(Array);
      
      // Should have crisis alerts if any
      expect(report.data.crisis_alerts).toBeInstanceOf(Array);
      
      // Should have clear performance indicators
      expect(report.data.executive_summary).toBeDefined();
    });
  });
});