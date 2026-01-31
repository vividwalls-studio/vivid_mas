# VividWalls MAS Frontend Implementation System Prompt

## Overview

This document serves as the definitive system prompt for implementing the VividWalls Multi-Agent System (MAS) frontend, incorporating the monitoring dashboard design, workflow integration patterns, and n8n connectivity architecture. It extends the frontend architecture document with specific implementation details for real-time monitoring, agent communication, and workflow management.

## Core Implementation Requirements

### 1. n8nui Pattern Integration

Based on the n8n workflow integration pattern, the frontend must implement:

```typescript
interface N8nUIConfig {
  endpoints: {
    startWorkflow: '/api/start-workflow/:webhookId';
    getExecution: '/api/execution/:xid';
    resumeWorkflow: '/api/resume-workflow/:xid';
  };
  polling: {
    interval: 1000; // 1 second for real-time feel
    maxAttempts: 300; // 5 minutes max wait
  };
  webhookConfig: {
    baseUrl: process.env.N8N_WEBHOOK_URL;
    waitNodeUrl: process.env.N8N_WAIT_NODE_RESUME_URL;
  };
}
```

### 2. Real-Time Monitoring Dashboard Implementation

#### Executive Dashboard Component

```typescript
interface ExecutiveDashboard {
  layout: '4x3-grid';
  refreshRate: 60000; // 1 minute
  widgets: {
    revenueTracker: {
      position: [0, 0];
      size: [2, 1];
      component: 'RevenueTrackerWidget';
      dataSource: 'prometheus';
      metrics: ['current_day_revenue', 'mtd_revenue', 'revenue_vs_target'];
    };
    orderVolume: {
      position: [2, 0];
      size: [1, 1];
      component: 'OrderVolumeWidget';
      dataSource: 'shopify-mcp';
    };
    agentPerformance: {
      position: [3, 0];
      size: [1, 1];
      component: 'AgentPerformanceGauge';
      dataSource: 'n8n-executions';
    };
    departmentHealth: {
      position: [0, 1];
      size: [4, 1];
      component: 'DepartmentScorecard';
      dataSource: 'analytics-aggregator';
    };
  };
}
```
### 3. Agent Communication Hub

#### Multi-Agent Chat Implementation

```typescript
// Agent Chat Manager
class AgentChatManager {
  private activeConversations: Map<string, ConversationThread>;
  private socket: Socket;
  private messageQueue: MessageQueue;

  constructor(config: AgentChatConfig) {
    this.socket = io(config.wsUrl, {
      reconnection: true,
      reconnectionAttempts: 10,
      reconnectionDelay: 5000
    });
    
    this.setupEventHandlers();
    this.initializeMessageQueue();
  }

  // Handle agent selection for communication
  async selectAgents(agentIds: string[]): Promise<void> {
    const agents = await this.fetchAgentProfiles(agentIds);
    agents.forEach(agent => {
      this.createConversationThread(agent);
    });
  }

  // Real-time message handling
  sendMessage(agentId: string, message: Message): void {
    this.socket.emit('agent:message', {
      agentId,
      message,
      timestamp: Date.now(),
      conversationId: this.activeConversations.get(agentId)?.id
    });
  }

  // Agent status monitoring
  subscribeToAgentStatus(agentId: string): void {
    this.socket.on(`agent:status:${agentId}`, (status: AgentStatus) => {
      this.updateAgentStatusIndicator(agentId, status);
    });
  }
}
### 4. Workflow Management Dashboard

#### Workflow Execution Monitor

```tsx
// React component for workflow monitoring
const WorkflowExecutionMonitor: React.FC = () => {
  const [executions, setExecutions] = useState<WorkflowExecution[]>([]);
  const [selectedExecution, setSelectedExecution] = useState<string | null>(null);

  // Poll for execution updates
  useEffect(() => {
    if (selectedExecution) {
      const interval = setInterval(async () => {
        const execution = await fetchExecutionDetails(selectedExecution);
        updateExecutionDisplay(execution);
        
        // Check if workflow is waiting for input
        if (execution.status === 'waiting') {
          showWaitNodeInterface(execution);
        }
      }, 1000);

      return () => clearInterval(interval);
    }
  }, [selectedExecution]);

  // Render execution timeline
  const renderExecutionTimeline = (execution: WorkflowExecution) => {
    return (
      <Timeline>
        {execution.nodes.map((node, index) => (
          <TimelineItem key={node.id}>
            <TimelineSeparator>
              <TimelineDot color={getNodeStatusColor(node.status)} />
              {index < execution.nodes.length - 1 && <TimelineConnector />}
            </TimelineSeparator>
            <TimelineContent>
              <Typography variant="h6">{node.name}</Typography>
              <Typography variant="body2">{node.executionTime}ms</Typography>
              {node.error && <Alert severity="error">{node.error}</Alert>}
            </TimelineContent>
          </TimelineItem>
        ))}
      </Timeline>
    );
  };
};
### 5. Department-Specific Dashboards

#### Marketing Dashboard Implementation

```tsx
const MarketingDashboard: React.FC = () => {
  const [metrics, setMetrics] = useState<MarketingMetrics>({
    campaignPerformance: [],
    contentAnalytics: {},
    customerAcquisition: {},
    budgetUtilization: {}
  });

  return (
    <DashboardLayout>
      <Grid container spacing={3}>
        {/* Campaign Performance */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardHeader title="Active Campaigns" />
            <CardContent>
              <CampaignPerformanceChart data={metrics.campaignPerformance} />
              <MetricsList>
                <MetricItem label="Total Campaigns" value={metrics.activeCampaigns} />
                <MetricItem label="Avg Engagement" value={`${metrics.avgEngagement}%`} />
                <MetricItem label="ROI" value={`${metrics.roi}x`} />
              </MetricsList>
            </CardContent>
          </Card>
        </Grid>

        {/* Multi-Channel Analytics */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardHeader title="Channel Performance" />
            <CardContent>
              <ChannelComparisonChart channels={[
                { name: 'Facebook', revenue: 12500, engagement: 4.2 },
                { name: 'Instagram', revenue: 8700, engagement: 6.8 },
                { name: 'Pinterest', revenue: 5300, engagement: 3.9 },
                { name: 'Email', revenue: 15200, engagement: 12.4 }
              ]} />
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </DashboardLayout>
  );
};
### 6. Real-Time Data Integration

#### WebSocket Event Handling

```typescript
// Centralized WebSocket event management
class RealtimeDataManager {
  private eventHandlers: Map<string, EventHandler[]> = new Map();
  private dataCache: DataCache;

  constructor(private socket: Socket) {
    this.setupGlobalHandlers();
    this.initializeDataCache();
  }

  // Subscribe to specific data streams
  subscribeToMetrics(metrics: string[], callback: MetricCallback): void {
    metrics.forEach(metric => {
      this.socket.emit('subscribe:metric', metric);
      this.on(`metric:${metric}`, callback);
    });
  }

  // Handle workflow events
  private setupWorkflowHandlers(): void {
    this.socket.on('workflow:status:update', (data: WorkflowStatusUpdate) => {
      this.dataCache.updateWorkflow(data.workflowId, data);
      this.emit('workflow:updated', data);
    });

    this.socket.on('workflow:error', (error: WorkflowError) => {
      this.handleWorkflowError(error);
      this.showNotification({
        severity: 'error',
        title: 'Workflow Error',
        message: error.message,
        actions: [{
          label: 'View Details',
          handler: () => this.navigateToWorkflow(error.workflowId)
        }]
      });
    });
  }

  // Agent communication events
  private setupAgentHandlers(): void {
    this.socket.on('agent:message', (message: AgentMessage) => {
      this.dataCache.addMessage(message);
      this.emit('agent:new:message', message);
    });

    this.socket.on('agent:typing', (data: AgentTypingIndicator) => {
      this.emit('agent:typing:indicator', data);
    });
  }
}
### 7. Alert Management System

```typescript
interface AlertConfiguration {
  levels: {
    critical: {
      notification: ['pagerduty', 'slack', 'email', 'sms'];
      escalation: 'immediate';
      color: '#F44336';
    };
    high: {
      notification: ['slack', 'email', 'dashboard'];
      escalation: '5_minutes';
      color: '#FF9800';
    };
    medium: {
      notification: ['slack', 'dashboard'];
      escalation: '15_minutes';
      color: '#FFC107';
    };
    low: {
      notification: ['dashboard'];
      escalation: 'weekly_summary';
      color: '#2196F3';
    };
  };
}

// Alert Component
const AlertCenter: React.FC = () => {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [filter, setFilter] = useState<AlertFilter>({ severity: 'all' });

  const handleAlert = (alert: Alert) => {
    // Determine notification channels based on severity
    const channels = getNotificationChannels(alert.severity);
    
    // Send notifications
    channels.forEach(channel => {
      notificationService.send(channel, {
        title: alert.title,
        message: alert.message,
        severity: alert.severity,
        timestamp: alert.timestamp,
        actions: alert.actions
      });
    });

    // Update UI
    setAlerts(prev => [alert, ...prev]);
    
    // Show toast notification
    showToast({
      severity: alert.severity,
      message: alert.title,
      action: {
        label: 'View',
        onClick: () => navigateToAlert(alert.id)
      }
    });
  };
};
### 8. Mobile-Responsive Implementation

```tsx
// Mobile Dashboard Component
const MobileDashboard: React.FC = () => {
  const [activeView, setActiveView] = useState<'overview' | 'details'>('overview');
  const { swipeable } = useSwipeable({
    onSwipedLeft: () => navigateNext(),
    onSwipedRight: () => navigatePrev()
  });

  return (
    <MobileLayout {...swipeable}>
      <AppBar position="sticky">
        <Toolbar>
          <Typography variant="h6">VividWalls MAS</Typography>
          <IconButton edge="end" onClick={toggleNotifications}>
            <Badge badgeContent={unreadCount} color="error">
              <NotificationsIcon />
            </Badge>
          </IconButton>
        </Toolbar>
      </AppBar>

      <SwipeableViews index={activeView} onChangeIndex={setActiveView}>
        {/* Overview Screen */}
        <Box p={2}>
          <MetricCard 
            title="Today's Revenue"
            value="$45,231"
            trend="+12%"
            sparkline={revenueData}
          />
          <Grid container spacing={2}>
            <Grid item xs={6}>
              <CompactMetric label="Orders" value="142" />
            </Grid>
            <Grid item xs={6}>
              <CompactMetric label="AOV" value="$318" />
            </Grid>
          </Grid>
          <DepartmentQuickView departments={departments} />
        </Box>

        {/* Details Screen */}
        <Box p={2}>
          <AlertsList alerts={recentAlerts} compact />
        </Box>
      </SwipeableViews>
    </MobileLayout>
  );
};
### 9. Cross-Functional Workflow Visualization

```tsx
// Workflow Diagram Component using D3.js
const WorkflowVisualization: React.FC<{ workflow: Workflow }> = ({ workflow }) => {
  const svgRef = useRef<SVGSVGElement>(null);

  useEffect(() => {
    if (!svgRef.current) return;

    const svg = d3.select(svgRef.current);
    const { nodes, links } = processWorkflowData(workflow);

    // Create force simulation
    const simulation = d3.forceSimulation(nodes)
      .force('link', d3.forceLink(links).id(d => d.id))
      .force('charge', d3.forceManyBody().strength(-300))
      .force('center', d3.forceCenter(width / 2, height / 2));

    // Draw links
    const link = svg.append('g')
      .selectAll('line')
      .data(links)
      .enter().append('line')
      .attr('stroke', '#999')
      .attr('stroke-opacity', 0.6)
      .attr('stroke-width', d => Math.sqrt(d.value));

    // Draw nodes
    const node = svg.append('g')
      .selectAll('circle')
      .data(nodes)
      .enter().append('circle')
      .attr('r', d => getNodeRadius(d.type))
      .attr('fill', d => getNodeColor(d.status))
      .call(drag(simulation));

    // Add labels
    const label = svg.append('g')
      .selectAll('text')
      .data(nodes)
      .enter().append('text')
      .text(d => d.name)
      .attr('font-size', '12px')
      .attr('dx', 15)
      .attr('dy', 4);

    // Update positions on tick
    simulation.on('tick', () => {
      link
        .attr('x1', d => d.source.x)
        .attr('y1', d => d.source.y)
        .attr('x2', d => d.target.x)
        .attr('y2', d => d.target.y);

      node
        .attr('cx', d => d.x)
        .attr('cy', d => d.y);

      label
        .attr('x', d => d.x)
        .attr('y', d => d.y);
    });
  }, [workflow]);

  return <svg ref={svgRef} width={800} height={600} />;
};
## Implementation Guidelines

### 1. State Management Architecture

```typescript
// Redux store structure
interface RootState {
  auth: AuthState;
  agents: {
    entities: Record<string, Agent>;
    conversations: Record<string, Conversation>;
    status: Record<string, AgentStatus>;
  };
  workflows: {
    executions: Record<string, WorkflowExecution>;
    templates: WorkflowTemplate[];
    activeWorkflows: string[];
  };
  monitoring: {
    metrics: MetricsState;
    alerts: Alert[];
    dashboards: DashboardConfig[];
  };
  ui: {
    theme: 'light' | 'dark';
    sidebarOpen: boolean;
    activeView: string;
  };
}

// RTK Query API slices
const apiSlice = createApi({
  reducerPath: 'api',
  baseQuery: fetchBaseQuery({
    baseUrl: '/api',
    prepareHeaders: (headers, { getState }) => {
      const token = (getState() as RootState).auth.token;
      if (token) headers.set('authorization', `Bearer ${token}`);
      return headers;
    }
  }),
  tagTypes: ['Agent', 'Workflow', 'Metric', 'Alert'],
  endpoints: (builder) => ({
    // Agent endpoints
    getAgents: builder.query<Agent[], void>({
      query: () => 'agents',
      providesTags: ['Agent']
    }),
    // Workflow endpoints
    startWorkflow: builder.mutation<WorkflowExecution, StartWorkflowParams>({
      query: ({ webhookId, data }) => ({
        url: `start-workflow/${webhookId}`,
        method: 'POST',
        body: data
      }),
      invalidatesTags: ['Workflow']
    })
  })
});
### 2. Performance Optimization Strategies

```typescript
// Lazy loading configuration
const routes = [
  {
    path: '/',
    component: lazy(() => import('./pages/Dashboard')),
    preload: true
  },
  {
    path: '/agents',
    component: lazy(() => import('./pages/AgentHub')),
    preload: false
  },
  {
    path: '/workflows',
    component: lazy(() => import('./pages/WorkflowManager')),
    preload: false
  }
];

// Virtual scrolling for large datasets
const VirtualizedAgentList: React.FC<{ agents: Agent[] }> = ({ agents }) => {
  const rowRenderer = ({ index, key, style }) => (
    <div key={key} style={style}>
      <AgentCard agent={agents[index]} />
    </div>
  );

  return (
    <AutoSizer>
      {({ height, width }) => (
        <List
          height={height}
          width={width}
          rowCount={agents.length}
          rowHeight={120}
          rowRenderer={rowRenderer}
        />
      )}
    </AutoSizer>
  );
};

// Memoization for expensive computations
const DashboardMetrics = React.memo(({ data }) => {
  const processedMetrics = useMemo(() => 
    calculateMetrics(data), [data]
  );

  return <MetricsDisplay metrics={processedMetrics} />;
}, (prevProps, nextProps) => {
  return isEqual(prevProps.data, nextProps.data);
});
### 3. Error Handling and Recovery

```typescript
// Global error boundary with recovery
class GlobalErrorBoundary extends ErrorBoundary {
  state = {
    hasError: false,
    error: null,
    errorInfo: null,
    retryCount: 0
  };

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // Log to monitoring service
    errorReporter.captureException(error, {
      errorInfo,
      userContext: this.context.user,
      timestamp: new Date().toISOString()
    });

    // Check if recoverable
    if (this.isRecoverableError(error)) {
      this.attemptRecovery();
    }
  }

  attemptRecovery = async () => {
    const { retryCount } = this.state;
    
    if (retryCount < 3) {
      this.setState({ retryCount: retryCount + 1 });
      
      // Clear error state after delay
      setTimeout(() => {
        this.setState({ hasError: false, error: null });
      }, 1000 * (retryCount + 1));
    }
  };

  render() {
    if (this.state.hasError) {
      return (
        <ErrorFallback
          error={this.state.error}
          resetError={() => this.setState({ hasError: false })}
          retry={() => this.attemptRecovery()}
        />
      );
    }

    return this.props.children;
  }
}
### 4. Accessibility Implementation

```tsx
// Accessible dashboard component
const AccessibleDashboard: React.FC = () => {
  const [announcements, announce] = useAriaLive();
  
  return (
    <div role="main" aria-label="VividWalls Dashboard">
      <SkipLinks />
      
      <h1 className="sr-only">VividWalls Multi-Agent System Dashboard</h1>
      
      <nav role="navigation" aria-label="Main navigation">
        <ul>
          <li>
            <Link to="/" aria-current={location.pathname === '/' ? 'page' : undefined}>
              Dashboard
            </Link>
          </li>
          <li>
            <Link to="/agents" aria-current={location.pathname === '/agents' ? 'page' : undefined}>
              Agents
            </Link>
          </li>
        </ul>
      </nav>

      <section aria-labelledby="metrics-heading">
        <h2 id="metrics-heading">Key Metrics</h2>
        <MetricsGrid 
          onUpdate={(metric) => announce(`${metric.name} updated to ${metric.value}`)}
        />
      </section>

      <section aria-labelledby="alerts-heading" role="complementary">
        <h2 id="alerts-heading">
          Active Alerts 
          <span aria-live="polite" aria-atomic="true">
            ({activeAlerts.length})
          </span>
        </h2>
        <AlertsList alerts={activeAlerts} />
      </section>

      {/* Aria live region for announcements */}
      <div aria-live="polite" aria-atomic="true" className="sr-only">
        {announcements}
      </div>
    </div>
  );
};
## Testing Strategy Implementation

### Unit Testing

```typescript
// Component testing example
describe('WorkflowExecutionMonitor', () => {
  it('should poll for updates when execution is selected', async () => {
    const mockExecution = {
      id: 'test-123',
      status: 'running',
      nodes: []
    };

    const { rerender } = render(
      <WorkflowExecutionMonitor selectedExecution={mockExecution.id} />
    );

    // Wait for initial fetch
    await waitFor(() => {
      expect(fetchExecutionDetails).toHaveBeenCalledWith('test-123');
    });

    // Verify polling continues
    act(() => {
      jest.advanceTimersByTime(1000);
    });

    expect(fetchExecutionDetails).toHaveBeenCalledTimes(2);
  });

  it('should show wait node interface when workflow is waiting', async () => {
    const mockExecution = {
      id: 'test-123',
      status: 'waiting',
      waitingNode: {
        id: 'wait-1',
        type: 'wait',
        data: { message: 'Please provide input' }
      }
    };

    render(<WorkflowExecutionMonitor selectedExecution={mockExecution.id} />);

    await waitFor(() => {
      expect(screen.getByText('Please provide input')).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'Continue Workflow' })).toBeInTheDocument();
    });
  });
});
### Integration Testing

```typescript
// E2E test for complete workflow
describe('Complete Workflow Journey', () => {
  it('should execute marketing campaign workflow end-to-end', async () => {
    // Start workflow
    await page.goto('http://localhost:3000');
    await page.click('[data-testid="start-campaign-workflow"]');
    
    // Fill initial parameters
    await page.fill('[name="campaignName"]', 'Summer Art Collection');
    await page.selectOption('[name="targetAudience"]', 'art-collectors');
    await page.click('[data-testid="submit-workflow"]');

    // Wait for execution to start
    await page.waitForSelector('[data-testid="execution-id"]');
    const executionId = await page.textContent('[data-testid="execution-id"]');

    // Monitor execution progress
    await page.waitForSelector('[data-testid="workflow-status-running"]');
    
    // Handle wait node when it appears
    await page.waitForSelector('[data-testid="wait-node-input"]', { timeout: 30000 });
    await page.fill('[data-testid="budget-input"]', '5000');
    await page.click('[data-testid="continue-workflow"]');

    // Verify completion
    await page.waitForSelector('[data-testid="workflow-status-completed"]', { timeout: 60000 });
    
    // Check results
    const results = await page.textContent('[data-testid="workflow-results"]');
    expect(results).toContain('Campaign created successfully');
  });
});
```

## Deployment Configuration

```yaml
# Docker configuration for frontend
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
## Environment Configuration

```typescript
// Environment-specific configuration
interface EnvironmentConfig {
  development: {
    apiUrl: 'http://localhost:3000/api';
    n8nUrl: 'http://localhost:5678';
    wsUrl: 'ws://localhost:3000';
    mockData: true;
    debugMode: true;
  };
  staging: {
    apiUrl: 'https://staging-api.vividwalls-mas.com';
    n8nUrl: 'https://staging-n8n.vividwalls-mas.com';
    wsUrl: 'wss://staging-ws.vividwalls-mas.com';
    mockData: false;
    debugMode: false;
  };
  production: {
    apiUrl: 'https://api.vividwalls-mas.com';
    n8nUrl: 'https://n8n.vividwalls-mas.com';
    wsUrl: 'wss://ws.vividwalls-mas.com';
    mockData: false;
    debugMode: false;
  };
}

// Feature flags
const featureFlags = {
  enableBetaFeatures: process.env.REACT_APP_ENABLE_BETA === 'true',
  enableMobileApp: process.env.REACT_APP_ENABLE_MOBILE === 'true',
  enableAdvancedAnalytics: process.env.REACT_APP_ENABLE_ANALYTICS === 'true',
  maxConcurrentWorkflows: parseInt(process.env.REACT_APP_MAX_WORKFLOWS || '10'),
  pollingInterval: parseInt(process.env.REACT_APP_POLLING_INTERVAL || '1000')
};
```

## Summary

This implementation prompt provides a comprehensive blueprint for building the VividWalls MAS frontend with:

1. **n8n Integration**: Complete workflow management via the n8nui pattern
2. **Real-time Monitoring**: Executive and department-specific dashboards
3. **Agent Communication**: Multi-threaded chat with status indicators
4. **Mobile Support**: Responsive design with native-like experience
5. **Performance**: Optimized rendering and data management
6. **Accessibility**: WCAG 2.1 AA compliant implementation
7. **Testing**: Comprehensive unit and E2E test coverage
8. **Deployment**: Docker-based containerization

The frontend serves as the central hub for stakeholders to interact with the multi-agent system, monitor business operations, and manage automated workflows efficiently.

---

*Implementation Version: 2.0*
*Last Updated: January 2025*
*Status: Ready for Development*