export interface ResourceDefinition {
  uri: string;
  name: string;
  description: string;
  mimeType: string;
  fetchData: () => Promise<any>;
}

// Mock data generator for demo purposes - replace with actual data sources
const generateMockMetrics = () => ({
  timestamp: new Date().toISOString(),
  revenue: {
    daily: Math.floor(Math.random() * 10000) + 5000,
    weekly: Math.floor(Math.random() * 70000) + 35000,
    monthly: Math.floor(Math.random() * 300000) + 150000,
    growth: {
      daily: (Math.random() * 20 - 10).toFixed(2) + '%',
      weekly: (Math.random() * 15 - 5).toFixed(2) + '%',
      monthly: (Math.random() * 10).toFixed(2) + '%'
    }
  },
  traffic: {
    visitors: Math.floor(Math.random() * 5000) + 2000,
    pageViews: Math.floor(Math.random() * 15000) + 8000,
    avgSessionDuration: Math.floor(Math.random() * 300) + 120,
    bounceRate: (Math.random() * 30 + 20).toFixed(2) + '%'
  },
  conversion: {
    rate: (Math.random() * 5 + 1).toFixed(2) + '%',
    averageOrderValue: Math.floor(Math.random() * 200) + 100,
    cartAbandonmentRate: (Math.random() * 40 + 30).toFixed(2) + '%'
  }
});

export const resources: ResourceDefinition[] = [
  {
    uri: 'analytics://vividwalls/executive-dashboard',
    name: 'Executive Dashboard',
    description: 'Real-time executive dashboard with key business metrics',
    mimeType: 'application/json',
    fetchData: async () => ({
      businessHealth: {
        score: Math.floor(Math.random() * 30) + 70,
        trend: 'improving',
        alerts: [
          'Cart abandonment rate above threshold',
          'Pinterest campaign underperforming'
        ]
      },
      keyMetrics: generateMockMetrics(),
      topProducts: [
        { name: 'Abstract Canvas Collection', revenue: 15234, units: 89 },
        { name: 'Nature Photography Prints', revenue: 12456, units: 124 },
        { name: 'Modern Minimalist Series', revenue: 9876, units: 67 }
      ],
      channelPerformance: {
        facebook: { revenue: 25000, roi: 3.2 },
        instagram: { revenue: 18000, roi: 2.8 },
        pinterest: { revenue: 12000, roi: 2.1 },
        organic: { revenue: 35000, roi: null }
      }
    })
  },
  {
    uri: 'analytics://vividwalls/real-time-metrics',
    name: 'Real-Time Metrics Stream',
    description: 'Live stream of business metrics updated every minute',
    mimeType: 'application/json',
    fetchData: async () => ({
      timestamp: new Date().toISOString(),
      activeUsers: Math.floor(Math.random() * 200) + 50,
      currentOrders: Math.floor(Math.random() * 20) + 5,
      revenueToday: Math.floor(Math.random() * 10000) + 5000,
      conversionRate: (Math.random() * 5 + 1).toFixed(2) + '%',
      serverLoad: (Math.random() * 60 + 20).toFixed(1) + '%',
      apiResponseTime: Math.floor(Math.random() * 200) + 100 + 'ms'
    })
  },
  {
    uri: 'analytics://vividwalls/customer-insights',
    name: 'Customer Analytics & Insights',
    description: 'Comprehensive customer behavior and segmentation data',
    mimeType: 'application/json',
    fetchData: async () => ({
      segments: [
        {
          name: 'High-Value Customers',
          size: 1234,
          avgOrderValue: 450,
          lifetimeValue: 2800,
          churnRisk: 'low'
        },
        {
          name: 'Frequent Buyers',
          size: 3456,
          avgOrderValue: 180,
          lifetimeValue: 1200,
          churnRisk: 'medium'
        },
        {
          name: 'New Customers',
          size: 5678,
          avgOrderValue: 120,
          lifetimeValue: 120,
          churnRisk: 'high'
        }
      ],
      behaviorPatterns: {
        preferredCategories: ['Abstract Art', 'Nature Photography', 'Modern Prints'],
        peakShoppingHours: ['10-12 AM', '7-9 PM'],
        deviceBreakdown: { mobile: '65%', desktop: '30%', tablet: '5%' }
      },
      retention: {
        month1: '85%',
        month3: '65%',
        month6: '45%',
        month12: '35%'
      }
    })
  },
  {
    uri: 'analytics://vividwalls/marketing-attribution',
    name: 'Marketing Attribution Analysis',
    description: 'Multi-touch attribution data across all marketing channels',
    mimeType: 'application/json',
    fetchData: async () => ({
      attributionModels: {
        firstTouch: {
          facebook: '35%',
          instagram: '25%',
          pinterest: '20%',
          organic: '15%',
          email: '5%'
        },
        lastTouch: {
          organic: '40%',
          email: '25%',
          facebook: '20%',
          instagram: '10%',
          pinterest: '5%'
        },
        linear: {
          facebook: '28%',
          organic: '27%',
          instagram: '18%',
          email: '15%',
          pinterest: '12%'
        }
      },
      channelInteractions: {
        averageTouchpoints: 3.2,
        conversionPaths: [
          'Facebook → Email → Organic',
          'Instagram → Pinterest → Organic',
          'Organic → Email → Organic'
        ]
      }
    })
  },
  {
    uri: 'analytics://vividwalls/predictive-insights',
    name: 'Predictive Analytics & Forecasts',
    description: 'AI-powered predictions and business forecasts',
    mimeType: 'application/json',
    fetchData: async () => ({
      revenueForecasts: {
        nextWeek: { estimate: 75000, confidence: '85%', range: [70000, 80000] },
        nextMonth: { estimate: 320000, confidence: '75%', range: [300000, 340000] },
        nextQuarter: { estimate: 980000, confidence: '65%', range: [900000, 1060000] }
      },
      demandPredictions: {
        trendingCategories: ['Minimalist Art', 'Botanical Prints'],
        seasonalPeaks: ['Black Friday', 'Spring Refresh', 'Holiday Season'],
        inventoryAlerts: [
          { product: 'Abstract Canvas #42', predictedStockout: '5 days' },
          { product: 'Nature Print #18', predictedStockout: '12 days' }
        ]
      },
      customerChurn: {
        atRiskCustomers: 234,
        predictedChurnRate: '12%',
        recommendedActions: [
          'Send personalized discount to high-risk segment',
          'Launch re-engagement email campaign',
          'Offer loyalty program enrollment'
        ]
      }
    })
  },
  {
    uri: 'analytics://vividwalls/competitive-analysis',
    name: 'Competitive Intelligence Report',
    description: 'Market positioning and competitive landscape analysis',
    mimeType: 'application/json',
    fetchData: async () => ({
      marketPosition: {
        marketShare: '12%',
        ranking: 4,
        growthRate: '+18% YoY',
        competitiveThreat: 'medium'
      },
      competitors: [
        {
          name: 'ArtWall Pro',
          marketShare: '25%',
          pricing: 'Premium',
          strengths: ['Brand recognition', 'Wide selection'],
          weaknesses: ['High prices', 'Slow shipping']
        },
        {
          name: 'Canvas Direct',
          marketShare: '20%',
          pricing: 'Budget',
          strengths: ['Low prices', 'Fast shipping'],
          weaknesses: ['Quality concerns', 'Limited selection']
        }
      ],
      opportunities: [
        'Expand into custom framing services',
        'Launch artist collaboration program',
        'Enter European market'
      ]
    })
  },
  {
    uri: 'analytics://vividwalls/data-quality-scorecard',
    name: 'Data Quality & Integrity Scorecard',
    description: 'Assessment of data quality across all systems',
    mimeType: 'application/json',
    fetchData: async () => ({
      overallScore: 92,
      dimensions: {
        completeness: { score: 95, issues: ['Missing email for 5% of customers'] },
        accuracy: { score: 93, issues: ['Product categorization needs review'] },
        consistency: { score: 90, issues: ['Date format mismatch between systems'] },
        timeliness: { score: 91, issues: ['Inventory updates lag by 30 minutes'] }
      },
      systemHealth: {
        shopify: { status: 'healthy', lastSync: '2 minutes ago' },
        supabase: { status: 'healthy', lastSync: 'real-time' },
        facebook: { status: 'healthy', lastSync: '15 minutes ago' },
        pinterest: { status: 'warning', lastSync: '2 hours ago' }
      },
      recommendations: [
        'Implement automated email validation',
        'Standardize date formats across systems',
        'Increase Pinterest API sync frequency'
      ]
    })
  },
  {
    uri: 'analytics://vividwalls/anomaly-alerts',
    name: 'Anomaly Detection & Alerts',
    description: 'Real-time anomaly detection across business metrics',
    mimeType: 'application/json',
    fetchData: async () => ({
      activeAlerts: [
        {
          metric: 'Conversion Rate',
          severity: 'warning',
          description: 'Conversion rate dropped 25% in last hour',
          timestamp: new Date(Date.now() - 1800000).toISOString(),
          suggestedAction: 'Check website performance and payment gateway'
        },
        {
          metric: 'Pinterest Spend',
          severity: 'info',
          description: 'Campaign spend 15% above daily target',
          timestamp: new Date(Date.now() - 3600000).toISOString(),
          suggestedAction: 'Review campaign performance and adjust budget'
        }
      ],
      recentAnomalies: {
        last24Hours: 3,
        last7Days: 12,
        falsePositiveRate: '8%'
      },
      thresholds: {
        revenue: { type: 'percentage', value: 20, window: '1 hour' },
        traffic: { type: 'stddev', value: 2, window: '30 minutes' },
        conversion: { type: 'absolute', value: 1, window: '1 hour' }
      }
    })
  },
  {
    uri: 'analytics://vividwalls/analytics-catalog',
    name: 'Analytics Resources Catalog',
    description: 'Directory of all available analytics resources and capabilities',
    mimeType: 'application/json',
    fetchData: async () => ({
      availableReports: [
        { name: 'Daily Business Review', frequency: 'daily', lastRun: 'Today 6:00 AM' },
        { name: 'Weekly Performance Summary', frequency: 'weekly', lastRun: 'Monday' },
        { name: 'Monthly Executive Report', frequency: 'monthly', lastRun: 'Nov 1' }
      ],
      dashboards: [
        { name: 'Executive Dashboard', url: '/dashboards/executive', users: 5 },
        { name: 'Marketing Performance', url: '/dashboards/marketing', users: 12 },
        { name: 'Operations Monitor', url: '/dashboards/operations', users: 8 }
      ],
      dataRefreshSchedule: {
        realTime: ['Orders', 'Traffic', 'Inventory'],
        every5Minutes: ['Social Media Metrics', 'Ad Performance'],
        every15Minutes: ['Customer Segments', 'Attribution'],
        hourly: ['Predictive Models', 'Competitive Analysis']
      },
      apiEndpoints: [
        { endpoint: '/api/metrics', description: 'Real-time metrics' },
        { endpoint: '/api/reports', description: 'Generate custom reports' },
        { endpoint: '/api/forecasts', description: 'Predictive analytics' }
      ]
    })
  }
];