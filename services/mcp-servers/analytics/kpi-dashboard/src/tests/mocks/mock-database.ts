/**
 * Mock Analytics Database for Testing
 */

export class MockAnalyticsDatabase {
  public trackedActivities: any[] = [];
  public trackedCommunications: any[] = [];
  public trackedBudgetDecisions: any[] = [];
  private mockData: any = {};
  private mockAgentActivities: any[] = [];

  constructor() {
    this.resetMockData();
  }

  // Reset mock data to defaults
  resetMockData() {
    this.mockData = {
      revenueMetrics: {
        total: 100000,
        growth_percentage: 5,
        order_count: 350,
        conversion_rate: 3.2,
        aov: 285.71
      },
      channelPerformance: {
        overall_roas: 3.8,
        channels: [
          { name: 'facebook', roas: 4.2, spend: 5000, revenue: 21000 },
          { name: 'pinterest', roas: 3.5, spend: 3000, revenue: 10500 },
          { name: 'email', roas: 5.2, spend: 1000, revenue: 5200 }
        ]
      },
      agentPerformance: {
        task_completion_rate: 95,
        average_response_time: 2500,
        coordination_efficiency: 88
      },
      operationalHealth: {
        system_uptime: 99.9,
        error_rate: 0.1,
        api_performance: 98
      },
      customerMetrics: {
        cac: 42.50,
        clv: 850.00,
        satisfaction_score: 4.3,
        retention_rate: 78
      },
      budgetStatus: {
        total_allocated: 50000,
        total_spent: 45000,
        utilization_rate: 90,
        roi_by_channel: [
          { channel: 'facebook', roi: 320 },
          { channel: 'pinterest', roi: 250 },
          { channel: 'email', roi: 420 }
        ]
      }
    };

    this.trackedActivities = [];
    this.trackedCommunications = [];
    this.trackedBudgetDecisions = [];
    this.mockAgentActivities = [];
  }

  // Set specific mock data for testing
  setMockData(data: any) {
    this.mockData = { ...this.mockData, ...data };
  }

  // Set mock agent activities
  setMockAgentActivities(activities: any[]) {
    this.mockAgentActivities = activities;
  }

  // Mock method implementations
  async trackAgentActivity(data: any) {
    this.trackedActivities.push(data);
    return { success: true, id: Date.now() };
  }

  async trackAgentCommunication(data: any) {
    this.trackedCommunications.push({ ...data, timestamp: new Date() });
    return { success: true, id: Date.now() };
  }

  async trackBudgetDecision(data: any) {
    this.trackedBudgetDecisions.push(data);
    return { success: true, id: Date.now() };
  }

  async getAgentActivities(query: any) {
    if (this.mockAgentActivities.length > 0) {
      return this.mockAgentActivities;
    }
    
    // Generate mock activities based on query
    const activities = [];
    const agents = ['marketing_director', 'sales_agent', 'analytics_director'];
    
    for (const agent of agents) {
      if (!query.agent_id || query.agent_id === agent) {
        activities.push({
          agent_id: agent,
          activity_type: 'task_completion',
          timestamp: new Date(),
          metrics: {
            success: true,
            completion_time_ms: 3000000,
            quality_score: 0.85 + Math.random() * 0.15
          }
        });
      }
    }
    
    return activities;
  }

  // Mock metric retrieval methods
  async getRevenueMetrics(startDate: Date, endDate: Date) {
    return this.mockData.revenueMetrics;
  }

  async getChannelPerformance(startDate: Date, endDate: Date) {
    return this.mockData.channelPerformance;
  }

  async getAgentPerformanceMetrics(startDate: Date, endDate: Date) {
    return this.mockData.agentPerformance;
  }

  async getOperationalHealth() {
    return this.mockData.operationalHealth;
  }

  async getCustomerMetrics(startDate: Date, endDate: Date) {
    return this.mockData.customerMetrics;
  }

  async getBudgetStatus() {
    return this.mockData.budgetStatus;
  }

  // Mock crisis trigger checking
  async checkCrisisTriggers(metrics: any) {
    const triggers = [];
    
    // Revenue decline > 10%
    if (metrics.revenueMetrics?.growth_percentage < -10) {
      triggers.push({
        type: 'revenue_decline',
        severity: 'critical',
        value: metrics.revenueMetrics.growth_percentage,
        threshold: -10,
        message: `Revenue declined by ${Math.abs(metrics.revenueMetrics.growth_percentage)}%`
      });
    }

    // Customer satisfaction < 4.0
    if (metrics.customerMetrics?.satisfaction_score < 4.0) {
      triggers.push({
        type: 'low_satisfaction',
        severity: 'high',
        value: metrics.customerMetrics.satisfaction_score,
        threshold: 4.0,
        message: `Customer satisfaction at ${metrics.customerMetrics.satisfaction_score}/5.0`
      });
    }

    // CAC > $50
    if (metrics.customerMetrics?.cac > 50) {
      triggers.push({
        type: 'high_cac',
        severity: 'medium',
        value: metrics.customerMetrics.cac,
        threshold: 50,
        message: `Customer acquisition cost at $${metrics.customerMetrics.cac}`
      });
    }

    return triggers;
  }

  // Mock database initialization
  async initialize() {
    return Promise.resolve();
  }

  // Mock query execution
  async query(sql: string, params: any[]) {
    // Return mock data based on query pattern
    if (sql.includes('agent_tasks')) {
      return { rows: this.trackedActivities };
    }
    if (sql.includes('agent_communications')) {
      return { rows: this.trackedCommunications };
    }
    if (sql.includes('budget_allocations')) {
      return { rows: this.trackedBudgetDecisions };
    }
    return { rows: [] };
  }
}