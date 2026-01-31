"use client"

import { useState } from "react"
import {
  Search,
  Bell,
  Settings,
  MessageSquare,
  TrendingUp,
  TrendingDown,
  Users,
  Bot,
  Zap,
  AlertTriangle,
  CheckCircle,
  ArrowRight,
  ArrowDown,
  Maximize2,
  Minimize2,
  Menu,
} from "lucide-react"
import { useMobileSidebar } from "./hooks/use-mobile-sidebar"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { X, MessageCircle, AlertCircle, Clock } from "lucide-react"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Slider } from "@/components/ui/slider"
import { Label } from "@/components/ui/label"
import { UnifiedChatPanel } from "./components/unified-chat-panel"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"
import { SearchCommand } from "./components/search-command"
import { NotificationDropdown } from "./components/notification-dropdown"
import { QuickActionModals } from "./components/quick-action-modals"
import { useQuickActions } from "./hooks/use-quick-actions"
import { useAgents } from "./hooks/use-agents"

export default function VividWallsDashboard() {
  const [activeTab, setActiveTab] = useState("overview")
  const [selectedDirector, setSelectedDirector] = useState<string | null>(null)

  // Mobile sidebar state
  const { isOpen: isSidebarOpen, isMobile, toggle: toggleSidebar, close: closeSidebar } = useMobileSidebar()

  // Quick actions state
  const { activeAction, isSubmitting, openAction, closeAction, submitAction } = useQuickActions()

  // Centralized agent status management (prevents status flickering)
  const { getAgentStatus, calculateStatusCounts, getActiveAgentCount, registerAgents } = useAgents()

  // Agent detail panel and chat modal state
  const [selectedAgent, setSelectedAgent] = useState<any>(null)
  const [showAgentDetail, setShowAgentDetail] = useState(false)

  // Unified Chat System State
  const [showUnifiedChat, setShowUnifiedChat] = useState(false)
  const [chatExpanded, setChatExpanded] = useState(false)
  const [activeChats, setActiveChats] = useState<Record<string, any>>({})
  const [currentChatId, setCurrentChatId] = useState<string | null>(null)

  // Mock agent data with comprehensive details
  const getAgentDetails = (agentName: string, directorId: string, isDirector = false) => {
    const baseAgent = {
      name: agentName,
      status: getAgentStatus(agentName),
      currentTask: getCurrentTask(agentName),
      tools: getAgentTools(agentName),
      workflows: getAgentWorkflows(agentName),
      systemPrompt: getSystemPrompt(agentName, isDirector),
      settings: {
        llmProvider: "OpenAI",
        model: "gpt-4o",
        temperature: 0.7,
        maxTokens: 2000,
        webhookUrl: `https://n8n.vividwalls.blog/webhook/${agentName.toLowerCase().replace(/\s+/g, "-")}-agent`,
      },
      isDirector: isDirector,
    }
    return baseAgent
  }

  const getCurrentTask = (agentName: string) => {
    const tasks = {
      "Facebook Agent": "Creating holiday campaign posts",
      "Instagram Agent": "Generating story content for product launch",
      "Pinterest Agent": "Optimizing pin descriptions for SEO",
      "Email Marketing Agent": "Sending welcome sequence to new subscribers",
      "Copy Writer Agent": "Writing product descriptions for new arrivals",
      "Copy Editor Agent": "Reviewing blog post content",
      "Newsletter Agent": "Preparing weekly newsletter content",
      "Marketing Research Agent": "Analyzing competitor pricing strategies",
      "Keyword Agent": "Researching trending keywords for Q4",
      "Creative Content Agent": "Designing social media graphics",
      "Audience Intelligence Agent": "Segmenting customer database",
      "Campaign Analytics Agent": "Analyzing Black Friday campaign performance",
      "A/B Testing Agent": "Testing email subject lines",
    }
    return tasks[agentName as keyof typeof tasks] || "Monitoring system performance"
  }

  const getAgentTools = (agentName: string) => {
    const directorToolSets = {
      "Marketing Director": [
        "Campaign Manager",
        "Analytics Dashboard",
        "Brand Guidelines",
        "ROI Calculator",
        "Team Coordination Hub",
        "Strategy Planner",
      ],
      "Social Media Director": [
        "Social Media Scheduler",
        "Content Calendar",
        "Engagement Analytics",
        "Hashtag Research",
        "Influencer Database",
        "Brand Monitor",
      ],
      "Creative Director": [
        "Design System",
        "Brand Asset Library",
        "Creative Brief Generator",
        "Quality Assurance",
        "Style Guide",
        "Creative Analytics",
      ],
      "Sales Director": [
        "CRM Integration",
        "Sales Pipeline",
        "Persona Manager",
        "Performance Tracker",
        "Training Portal",
        "Revenue Analytics",
      ],
      "Operations Director": [
        "Inventory System",
        "Supply Chain Monitor",
        "Quality Control",
        "Vendor Portal",
        "Workflow Optimizer",
        "Operations Dashboard",
      ],
      "Customer Experience Director": [
        "Support Ticketing",
        "Satisfaction Surveys",
        "Feedback Analyzer",
        "Loyalty Platform",
        "Customer Journey Map",
        "Retention Analytics",
      ],
      "Finance Director": [
        "Financial Dashboard",
        "Budget Tracker",
        "ROI Calculator",
        "Cash Flow Monitor",
        "Financial Reports",
        "Investment Analyzer",
      ],
      "Analytics Director": [
        "Data Warehouse",
        "BI Tools",
        "KPI Dashboard",
        "Report Generator",
        "Predictive Analytics",
        "Data Visualization",
      ],
      "Product Director": [
        "Product Roadmap",
        "Market Research",
        "Competitive Analysis",
        "User Feedback",
        "Feature Tracker",
        "Launch Coordinator",
      ],
      "Technology Director": [
        "System Monitor",
        "Infrastructure Manager",
        "Security Scanner",
        "Integration Hub",
        "Performance Tracker",
        "Tech Stack Optimizer",
      ],
      "Compliance & Risk Director": [
        "Risk Assessment",
        "Compliance Monitor",
        "Policy Manager",
        "Audit Trail",
        "Security Protocols",
        "Crisis Response",
      ],
    }

    const agentToolSets = {
      "Facebook Agent": ["Facebook API", "Meta Business", "Ad Manager", "Analytics", "Content Scheduler"],
      "Instagram Agent": ["Instagram API", "Story Creator", "Reels Editor", "Hashtag Generator", "Analytics"],
      "Pinterest Agent": ["Pinterest API", "Pin Scheduler", "Rich Pins", "Analytics", "Trend Analyzer"],
      "Email Marketing Agent": ["SendGrid", "Automation Builder", "Segmentation", "A/B Testing", "Analytics"],
      "Copy Writer Agent": [
        "AI Writing Assistant",
        "Tone Analyzer",
        "Grammar Check",
        "Style Guide",
        "Brand Voice",
        "SEO Optimizer",
        "Content Templates",
      ],
      "Copy Editor Agent": ["Grammar Check", "Style Guide", "Brand Voice", "SEO Optimizer", "Plagiarism Check"],
    }

    return (
      directorToolSets[agentName as keyof typeof directorToolSets] ||
      agentToolSets[agentName as keyof typeof agentToolSets] || ["System Monitor", "Data Processor", "Report Generator"]
    )
  }

  const getAgentWorkflows = (agentName: string) => {
    // Director-specific workflows
    const directorWorkflows = {
      "Marketing Director": [
        { name: "Campaign Strategy Coordination", status: "completed", progress: 100 },
        { name: "Brand Consistency Monitoring", status: "in-progress", progress: 75 },
        { name: "ROI Analysis & Reporting", status: "in-progress", progress: 60 },
        { name: "Team Performance Review", status: "pending", progress: 0 },
      ],
      "Social Media Director": [
        { name: "Platform Strategy Alignment", status: "completed", progress: 100 },
        { name: "Content Calendar Management", status: "in-progress", progress: 80 },
        { name: "Engagement Analytics Review", status: "in-progress", progress: 45 },
        { name: "Influencer Partnership Planning", status: "pending", progress: 0 },
      ],
      "Sales Director": [
        { name: "Sales Pipeline Optimization", status: "completed", progress: 100 },
        { name: "Persona Strategy Implementation", status: "in-progress", progress: 70 },
        { name: "Team Training Coordination", status: "in-progress", progress: 55 },
        { name: "Quarterly Sales Planning", status: "pending", progress: 0 },
      ],
    }

    return (
      directorWorkflows[agentName as keyof typeof directorWorkflows] || [
        { name: "Daily Content Creation", status: "completed", progress: 100 },
        { name: "Campaign Optimization", status: "in-progress", progress: 65 },
        { name: "Performance Analysis", status: "pending", progress: 0 },
        { name: "Weekly Reporting", status: "in-progress", progress: 30 },
      ]
    )
  }

  const getSystemPrompt = (agentName: string, isDirector = false) => {
    if (isDirector) {
      const directorPrompts = {
        "Marketing Director":
          "You are the Marketing Director, responsible for overseeing all marketing operations and strategy. Your role includes coordinating with marketing agents, optimizing CAC/LTV ratios, and ensuring brand consistency across all campaigns. You manage content strategy, email marketing, SEO, and campaign analytics to drive business growth.",
        "Social Media Director":
          "You are the Social Media Director, specializing in platform-specific campaigns across Facebook, Instagram, and Pinterest. Your expertise lies in creating engaging content, managing social media presence, and coordinating with social media agents to maximize reach and engagement.",
        "Creative Director":
          "You are the Creative Director, leading visual identity and creative excellence initiatives. You oversee visual design, content creation, brand management, and creative strategy to ensure all creative outputs align with brand standards and business objectives.",
        "Sales Director":
          "You are the Sales Director, implementing persona-based selling strategies across multiple customer segments. You coordinate with specialized sales agents for different industries and customer types to maximize conversion rates and revenue growth.",
        "Operations Director":
          "You are the Operations Director, managing fulfillment and supply chain operations. You oversee inventory management, vendor relationships, quality control, and ensure smooth operational workflows to support business scalability.",
        "Customer Experience Director":
          "You are the Customer Experience Director, focused on support and retention strategies. You manage customer support operations, satisfaction monitoring, feedback analysis, and loyalty programs to enhance customer lifetime value.",
        "Finance Director":
          "You are the Finance Director, responsible for financial management and ROI optimization. You oversee budget management, financial analysis, cash flow monitoring, and provide strategic financial insights to support business decisions.",
        "Analytics Director":
          "You are the Analytics Director, leading business intelligence initiatives. You coordinate data analysis, performance tracking, KPI monitoring, and provide actionable insights to drive data-driven decision making across the organization.",
        "Product Director":
          "You are the Product Director, managing strategy and market positioning. You oversee product development, market research, competitive analysis, and ensure products meet market demands and business objectives.",
        "Technology Director":
          "You are the Technology Director, responsible for systems and innovation. You manage system monitoring, infrastructure, security, and integration to ensure robust technical foundations for business operations.",
        "Compliance & Risk Director":
          "You are the Compliance & Risk Director, managing risk assessment and regulatory compliance. You oversee data privacy, regulatory adherence, risk management, and crisis response to protect the organization from potential threats.",
      }
      return (
        directorPrompts[agentName as keyof typeof directorPrompts] ||
        "You are a Director Agent responsible for overseeing department operations and coordinating with specialized agents to achieve business objectives."
      )
    }

    const agentPrompts = {
      "Facebook Agent":
        "You are a Facebook marketing specialist. Create engaging posts, manage ad campaigns, and optimize for maximum reach and engagement on the Facebook platform.",
      "Instagram Agent":
        "You are an Instagram content creator. Generate visually appealing posts, stories, and reels that align with brand aesthetics and drive engagement.",
      "Pinterest Agent":
        "You are a Pinterest marketing expert. Create and optimize pins, manage boards, and implement SEO strategies to increase visibility and traffic.",
      "Email Marketing Agent":
        "You are an email marketing specialist. Design and execute email campaigns, manage subscriber lists, and optimize for deliverability and conversions.",
      "Copy Writer Agent":
        "You are a professional copywriter. Create compelling, brand-consistent content that drives action and resonates with target audiences.",
      "Copy Editor Agent":
        "You are a copy editor focused on maintaining brand voice, grammar accuracy, and content quality across all marketing materials.",
    }
    return (
      agentPrompts[agentName as keyof typeof agentPrompts] ||
      "You are a helpful AI assistant specialized in your designated tasks. Always provide actionable insights and maintain brand consistency."
    )
  }

  // Agent Directory Component
  const AgentDirectory = ({ director }: { director: any }) => {
    const handleAgentClick = (agentName: string) => {
      const agentDetails = getAgentDetails(agentName, director.id)
      setSelectedAgent(agentDetails)
      setShowAgentDetail(true)
    }

    const handleOpenAgentChat = (agentName: string, type: string) => {
      // Find the agent in availableAgents and open chat
      const agent = availableAgents.find((a) => a.name === agentName)
      if (!agent) return

      const chatId = `chat-${agent.id}-${Date.now()}`
      const newChat = {
        id: chatId,
        title: `Chat with ${agentName}`,
        participants: [agent],
        messages: [
          {
            id: `msg-${Date.now()}`,
            agentId: agent.id,
            agentName: agent.name,
            content: `Hello! I'm ${agentName}. How can I help you today?`,
            timestamp: new Date(),
            mentions: [],
          },
        ],
        lastActivity: new Date(),
      }

      setActiveChats((prev) => ({ ...prev, [chatId]: newChat }))
      setCurrentChatId(chatId)
      setShowUnifiedChat(true)
    }

    return (
      <>
        <Card>
          <CardHeader>
            <CardTitle>Department Agents</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {director.agents.map((agent: string, index: number) => {
                const agentDetails = getAgentDetails(agent, director.id)
                return (
                  <div
                    key={index}
                    className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors cursor-pointer"
                    onClick={() => handleAgentClick(agent)}
                  >
                    <div className="space-y-3">
                      {/* Agent Header with Chat Button */}
                      <div className="flex items-start gap-3">
                        <Avatar className="w-10 h-10">
                          <AvatarImage src={director.avatar || "/placeholder.svg"} />
                          <AvatarFallback>{agent.split(" ")[0][0]}</AvatarFallback>
                        </Avatar>
                        <div className="flex-1">
                          <h4 className="font-medium text-sm">{agent}</h4>
                          <div className="flex items-center gap-2 mt-1">
                            <div
                              className={`w-2 h-2 rounded-full ${
                                agentDetails.status === "active"
                                  ? "bg-green-500"
                                  : agentDetails.status === "idle"
                                    ? "bg-yellow-500"
                                    : "bg-red-500"
                              }`}
                            ></div>
                            <span className="text-xs text-gray-500 capitalize">{agentDetails.status}</span>
                          </div>
                        </div>
                        {/* Chat Icon Button - Moved to top-right */}
                        <TooltipProvider>
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Button
                                size="sm"
                                variant="ghost"
                                className="w-8 h-8 p-0 text-gray-600 hover:text-purple-600 hover:bg-purple-50 border border-gray-300 shrink-0"
                                onClick={(e) => {
                                  e.stopPropagation()
                                  handleOpenAgentChat(agent, "agent")
                                }}
                              >
                                <MessageCircle className="w-4 h-4" />
                              </Button>
                            </TooltipTrigger>
                            <TooltipContent>
                              <p>Chat with Agent</p>
                            </TooltipContent>
                          </Tooltip>
                        </TooltipProvider>
                      </div>

                      {/* N8N Workflows */}
                      <div className="space-y-2">
                        <span className="text-xs font-medium text-gray-700">N8N Workflows:</span>
                        <div className="space-y-2">
                          {agentDetails.workflows.slice(0, 2).map((workflow: any, workflowIndex: number) => (
                            <div key={workflowIndex} className="bg-gray-50 p-2 rounded text-xs">
                              <div className="flex items-center justify-between mb-1">
                                <span className="font-medium text-gray-700">{workflow.name}</span>
                                <div className="flex items-center gap-1">
                                  {workflow.status === "completed" && (
                                    <CheckCircle className="w-3 h-3 text-green-500" />
                                  )}
                                  {workflow.status === "in-progress" && <Clock className="w-3 h-3 text-blue-500" />}
                                  {workflow.status === "pending" && <AlertCircle className="w-3 h-3 text-gray-500" />}
                                  <span className="text-xs capitalize text-gray-600">{workflow.status}</span>
                                </div>
                              </div>
                              <Progress value={workflow.progress} className="h-1 mb-1" />
                              <span className="text-xs text-gray-500">{workflow.progress}% complete</span>
                            </div>
                          ))}
                          {agentDetails.workflows.length > 2 && (
                            <div className="text-xs text-gray-500">
                              +{agentDetails.workflows.length - 2} more workflows
                            </div>
                          )}
                        </div>
                      </div>

                      {/* Tools */}
                      <div className="space-y-2">
                        <span className="text-xs font-medium text-gray-700">Available Tools:</span>
                        <div className="flex flex-wrap gap-1">
                          {agentDetails.tools.slice(0, 3).map((tool: string, toolIndex: number) => (
                            <Badge key={toolIndex} variant="secondary" className="text-xs">
                              {tool}
                            </Badge>
                          ))}
                          {agentDetails.tools.length > 3 && (
                            <Badge variant="outline" className="text-xs">
                              +{agentDetails.tools.length - 3} more
                            </Badge>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          </CardContent>
        </Card>

        {/* Agent Detail Panel */}
        {showAgentDetail && selectedAgent && (
          <AgentDetailPanel agent={selectedAgent} onClose={() => setShowAgentDetail(false)} />
        )}
      </>
    )
  }

  // Agent Detail Panel Component with Enhanced Settings Management
  const AgentDetailPanel = ({ agent, onClose }: { agent: any; onClose: () => void }) => {
    const [settings, setSettings] = useState(agent.settings)
    const [isLoading, setIsLoading] = useState(false)
    const [saveStatus, setSaveStatus] = useState<"idle" | "success" | "error">("idle")
    const [errors, setErrors] = useState<Record<string, string>>({})
    const [isExpanded, setIsExpanded] = useState(false)
    const [systemPrompt, setSystemPrompt] = useState(
      agent.systemPrompt ||
        "You are a helpful AI assistant specialized in marketing tasks. Your role is to help with content creation, campaign optimization, and performance analysis. Always provide actionable insights and maintain brand consistency.",
    )
    const [promptSaveStatus, setPromptSaveStatus] = useState<"idle" | "success" | "error">("idle")

    // Collapsible sections state
    const [collapsedSections, setCollapsedSections] = useState<Record<string, boolean>>({
      settings: false,
      prompt: false,
      workflows: false,
      tools: false,
      performance: false,
    })

    const toggleSection = (section: string) => {
      setCollapsedSections((prev) => ({ ...prev, [section]: !prev[section] }))
    }

    // Validation function
    const validateSettings = () => {
      const newErrors: Record<string, string> = {}

      if (!settings.webhookUrl.trim()) {
        newErrors.webhookUrl = "Webhook URL is required"
      } else if (!isValidUrl(settings.webhookUrl)) {
        newErrors.webhookUrl = "Please enter a valid URL"
      }

      if (settings.maxTokens < 100 || settings.maxTokens > 4000) {
        newErrors.maxTokens = "Max tokens must be between 100 and 4000"
      }

      if (settings.temperature < 0 || settings.temperature > 1) {
        newErrors.temperature = "Temperature must be between 0 and 1"
      }

      setErrors(newErrors)
      return Object.keys(newErrors).length === 0
    }

    // URL validation helper
    const isValidUrl = (string: string) => {
      try {
        new URL(string)
        return true
      } catch (_) {
        return false
      }
    }

    // Handle save settings
    const handleSaveSettings = async () => {
      if (!validateSettings()) {
        return
      }

      setIsLoading(true)
      setSaveStatus("idle")

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1500))

        // Update agent settings (in real implementation, this would be an API call)
        agent.settings = { ...settings }

        setSaveStatus("success")
        setTimeout(() => setSaveStatus("idle"), 3000)
      } catch (error) {
        setSaveStatus("error")
        setTimeout(() => setSaveStatus("idle"), 3000)
      } finally {
        setIsLoading(false)
      }
    }

    // Handle save system prompt
    const handleSavePrompt = async () => {
      setPromptSaveStatus("idle")

      try {
        // Simulate API call to n8n-mcp-server
        await new Promise((resolve) => setTimeout(resolve, 1000))

        // Update agent prompt (in real implementation, this would trigger n8n workflow update)
        agent.systemPrompt = systemPrompt

        setPromptSaveStatus("success")
        setTimeout(() => setPromptSaveStatus("idle"), 3000)
      } catch (error) {
        setPromptSaveStatus("error")
        setTimeout(() => setPromptSaveStatus("idle"), 3000)
      }
    }

    // Reset settings to original values
    const handleResetSettings = () => {
      setSettings(agent.settings)
      setErrors({})
      setSaveStatus("idle")
    }

    const panelContent = (
      <div className="space-y-6">
        {/* Header - Only show when NOT expanded */}
        {!isExpanded && (
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <h2 className="text-xl font-semibold">{agent.name}</h2>
              {agent.isDirector && (
                <Badge variant="default" className="bg-purple-600">
                  Director
                </Badge>
              )}
            </div>
            <div className="flex items-center gap-2">
              <Button variant="outline" size="icon" onClick={() => setIsExpanded(true)}>
                <Maximize2 className="w-4 h-4" />
              </Button>
              <Button variant="ghost" size="icon" onClick={onClose}>
                <X className="w-4 h-4" />
              </Button>
            </div>
          </div>
        )}

        {/* Performance Metrics - View Only */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <TrendingUp className="w-4 h-4" />
                Performance Metrics
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={() => toggleSection("performance")}>
                {collapsedSections.performance ? <ArrowRight className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
              </Button>
            </div>
          </CardHeader>
          {!collapsedSections.performance && (
            <CardContent className="space-y-3">
              <div className="grid grid-cols-2 gap-4">
                <div className="text-center p-3 bg-green-50 rounded-lg">
                  <div className="text-2xl font-bold text-green-600">94%</div>
                  <div className="text-xs text-green-700">Success Rate</div>
                </div>
                <div className="text-center p-3 bg-blue-50 rounded-lg">
                  <div className="text-2xl font-bold text-blue-600">2.3s</div>
                  <div className="text-xs text-blue-700">Avg Response</div>
                </div>
              </div>
              <div className="text-center p-3 bg-purple-50 rounded-lg">
                <div className="text-lg font-bold text-purple-600">1,247</div>
                <div className="text-xs text-purple-700">Tasks Completed Today</div>
              </div>
            </CardContent>
          )}
        </Card>

        {/* System Prompt - Editable */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <MessageSquare className="w-4 h-4" />
                System Prompt
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={() => toggleSection("prompt")}>
                {collapsedSections.prompt ? <ArrowRight className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
              </Button>
            </div>
          </CardHeader>
          {!collapsedSections.prompt && (
            <CardContent className="space-y-4">
              <div>
                <Label htmlFor="system-prompt">Agent System Prompt</Label>
                <textarea
                  id="system-prompt"
                  value={systemPrompt}
                  onChange={(e) => setSystemPrompt(e.target.value)}
                  className="w-full h-[300px] p-3 border border-gray-300 rounded-md resize-none focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                  placeholder="Enter the system prompt for this agent..."
                />
                <p className="text-xs text-gray-500 mt-1">
                  This prompt will be sent to the N8N workflow to update the agent's behavior
                </p>
              </div>

              {/* Prompt Save Status */}
              {promptSaveStatus !== "idle" && (
                <div
                  className={`p-3 rounded-lg ${
                    promptSaveStatus === "success" ? "bg-green-50 text-green-700" : "bg-red-50 text-red-700"
                  }`}
                >
                  <div className="flex items-center gap-2">
                    {promptSaveStatus === "success" ? (
                      <CheckCircle className="w-4 h-4" />
                    ) : (
                      <AlertCircle className="w-4 h-4" />
                    )}
                    <span className="text-sm">
                      {promptSaveStatus === "success"
                        ? "System prompt updated successfully!"
                        : "Failed to update system prompt. Please try again."}
                    </span>
                  </div>
                </div>
              )}

              <div className="flex gap-2">
                <Button onClick={handleSavePrompt} className="flex-1">
                  Update N8N Workflow
                </Button>
                <Button variant="outline" onClick={() => setSystemPrompt(agent.systemPrompt || "")}>
                  Reset
                </Button>
              </div>
            </CardContent>
          )}
        </Card>

        {/* Agent Settings - Editable */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Settings className="w-4 h-4" />
                Agent Settings
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={() => toggleSection("settings")}>
                {collapsedSections.settings ? <ArrowRight className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
              </Button>
            </div>
          </CardHeader>
          {!collapsedSections.settings && (
            <CardContent className="space-y-4">
              {/* LLM Provider Selection */}
              <div>
                <Label htmlFor="llm-provider">LLM Provider</Label>
                <Select
                  value={settings.llmProvider}
                  onValueChange={(value) => setSettings({ ...settings, llmProvider: value })}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="OpenAI">OpenAI</SelectItem>
                    <SelectItem value="Anthropic">Anthropic (Claude)</SelectItem>
                    <SelectItem value="Google">Google (Gemini)</SelectItem>
                    <SelectItem value="xAI">xAI (Grok)</SelectItem>
                    <SelectItem value="Groq">Groq</SelectItem>
                    <SelectItem value="DeepInfra">DeepInfra</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Model Selection */}
              <div>
                <Label htmlFor="model">Model</Label>
                <Select value={settings.model} onValueChange={(value) => setSettings({ ...settings, model: value })}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {settings.llmProvider === "OpenAI" && (
                      <>
                        <SelectItem value="gpt-4o">GPT-4o</SelectItem>
                        <SelectItem value="gpt-4">GPT-4</SelectItem>
                        <SelectItem value="gpt-3.5-turbo">GPT-3.5 Turbo</SelectItem>
                      </>
                    )}
                    {settings.llmProvider === "Anthropic" && (
                      <>
                        <SelectItem value="claude-3-opus">Claude 3 Opus</SelectItem>
                        <SelectItem value="claude-3-sonnet">Claude 3 Sonnet</SelectItem>
                        <SelectItem value="claude-3-haiku">Claude 3 Haiku</SelectItem>
                      </>
                    )}
                    {settings.llmProvider === "Google" && (
                      <>
                        <SelectItem value="gemini-pro">Gemini Pro</SelectItem>
                        <SelectItem value="gemini-pro-vision">Gemini Pro Vision</SelectItem>
                      </>
                    )}
                    {settings.llmProvider === "xAI" && <SelectItem value="grok-3">Grok 3</SelectItem>}
                    {settings.llmProvider === "Groq" && (
                      <>
                        <SelectItem value="llama-3-70b">Llama 3 70B</SelectItem>
                        <SelectItem value="mixtral-8x7b">Mixtral 8x7B</SelectItem>
                      </>
                    )}
                    {settings.llmProvider === "DeepInfra" && (
                      <>
                        <SelectItem value="llama-3-70b">Llama 3 70B</SelectItem>
                        <SelectItem value="mixtral-8x7b">Mixtral 8x7B</SelectItem>
                      </>
                    )}
                  </SelectContent>
                </Select>
              </div>

              {/* N8N Webhook URL */}
              <div>
                <Label htmlFor="webhook-url">N8N Webhook URL</Label>
                <Input
                  id="webhook-url"
                  type="url"
                  placeholder="https://n8n.vividwalls.blog/webhook/agent-name"
                  value={settings.webhookUrl}
                  onChange={(e) => setSettings({ ...settings, webhookUrl: e.target.value })}
                  className={errors.webhookUrl ? "border-red-500" : ""}
                />
                {errors.webhookUrl && <p className="text-sm text-red-500 mt-1">{errors.webhookUrl}</p>}
                <p className="text-xs text-gray-500 mt-1">Public URL for connecting to the agent's N8N workflows</p>
              </div>

              {/* Temperature */}
              <div>
                <Label>Temperature: {settings.temperature}</Label>
                <Slider
                  value={[settings.temperature]}
                  onValueChange={([value]) => setSettings({ ...settings, temperature: value })}
                  max={1}
                  min={0}
                  step={0.1}
                  className="mt-2"
                />
                {errors.temperature && <p className="text-sm text-red-500 mt-1">{errors.temperature}</p>}
                <p className="text-xs text-gray-500 mt-1">
                  Controls randomness in responses (0 = deterministic, 1 = creative)
                </p>
              </div>

              {/* Max Tokens */}
              <div>
                <Label>Max Tokens: {settings.maxTokens}</Label>
                <Slider
                  value={[settings.maxTokens]}
                  onValueChange={([value]) => setSettings({ ...settings, maxTokens: value })}
                  max={4000}
                  min={100}
                  step={100}
                  className="mt-2"
                />
                {errors.maxTokens && <p className="text-sm text-red-500 mt-1">{errors.maxTokens}</p>}
                <p className="text-xs text-gray-500 mt-1">Maximum number of tokens in the response</p>
              </div>

              {/* Save Status */}
              {saveStatus !== "idle" && (
                <div
                  className={`p-3 rounded-lg ${
                    saveStatus === "success" ? "bg-green-50 text-green-700" : "bg-red-50 text-red-700"
                  }`}
                >
                  <div className="flex items-center gap-2">
                    {saveStatus === "success" ? (
                      <CheckCircle className="w-4 h-4" />
                    ) : (
                      <AlertCircle className="w-4 h-4" />
                    )}
                    <span className="text-sm">
                      {saveStatus === "success"
                        ? "Settings saved successfully!"
                        : "Failed to save settings. Please try again."}
                    </span>
                  </div>
                </div>
              )}

              {/* Action Buttons */}
              <div className="flex gap-2 pt-2">
                <Button onClick={handleSaveSettings} disabled={isLoading} className="flex-1">
                  {isLoading ? (
                    <>
                      <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2" />
                      Saving...
                    </>
                  ) : (
                    "Save Changes"
                  )}
                </Button>
                <Button variant="outline" onClick={handleResetSettings} disabled={isLoading}>
                  Reset
                </Button>
              </div>
            </CardContent>
          )}
        </Card>

        {/* N8N Workflows - View Only */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Zap className="w-4 h-4" />
                N8N Workflows
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={() => toggleSection("workflows")}>
                {collapsedSections.workflows ? <ArrowRight className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
              </Button>
            </div>
          </CardHeader>
          {!collapsedSections.workflows && (
            <CardContent>
              <div className="space-y-3">
                {agent.workflows.map((workflow: any, index: number) => (
                  <div key={index} className="p-3 border rounded-lg">
                    <div className="flex items-center justify-between mb-2">
                      <span className="font-medium text-sm">{workflow.name}</span>
                      <div className="flex items-center gap-1">
                        {workflow.status === "completed" && <CheckCircle className="w-4 h-4 text-green-500" />}
                        {workflow.status === "in-progress" && <Clock className="w-4 h-4 text-blue-500" />}
                        {workflow.status === "pending" && <AlertCircle className="w-4 h-4 text-gray-500" />}
                        <span className="text-xs capitalize">{workflow.status}</span>
                      </div>
                    </div>
                    <Progress value={workflow.progress} className="h-2" />
                    <span className="text-xs text-gray-500">{workflow.progress}% complete</span>
                  </div>
                ))}
              </div>
            </CardContent>
          )}
        </Card>

        {/* Tools & Capabilities - View Only */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Bot className="w-4 h-4" />
                Tools & Capabilities
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={() => toggleSection("tools")}>
                {collapsedSections.tools ? <ArrowRight className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
              </Button>
            </div>
          </CardHeader>
          {!collapsedSections.tools && (
            <CardContent>
              <div className="space-y-2">
                {agent.tools.map((tool: string, index: number) => (
                  <div key={index} className="flex items-center justify-between p-2 border rounded">
                    <span className="text-sm">{tool}</span>
                    <Badge variant="outline" className="text-xs">
                      Available
                    </Badge>
                  </div>
                ))}
              </div>
            </CardContent>
          )}
        </Card>
      </div>
    )

    if (isExpanded) {
      return (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg w-full max-w-4xl h-full max-h-[90vh] overflow-hidden flex flex-col">
            <div className="flex items-center justify-between p-6 border-b">
              <div className="flex items-center gap-3">
                <h2 className="text-2xl font-semibold">{agent.name} - Detailed View</h2>
                {agent.isDirector && (
                  <Badge variant="default" className="bg-purple-600">
                    Director
                  </Badge>
                )}
              </div>
              <div className="flex items-center gap-2">
                <Button variant="outline" size="icon" onClick={() => setIsExpanded(false)}>
                  <Minimize2 className="w-4 h-4" />
                </Button>
                <Button variant="ghost" size="icon" onClick={onClose}>
                  <X className="w-4 h-4" />
                </Button>
              </div>
            </div>
            <div className="flex-1 overflow-y-auto p-6">{panelContent}</div>
          </div>
        </div>
      )
    }

    return (
      <div className="fixed right-0 top-0 h-full w-96 bg-white border-l border-gray-200 shadow-lg z-50 overflow-y-auto">
        <div className="p-6">{panelContent}</div>
      </div>
    )
  }

  // Agent avatars mapping
  const agentAvatars = {
    business: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%202-eewWehHfWpQFHre8bt7ErqcEKyaLOZ.png",
    marketing: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%201-3Kodq0AOYio1NhlHdBI4fdKeYSFm5q.svg",
    sales: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%206-eOFP9PjDNijCnUulLZ0fXnhlf1G4np.svg",
    operations: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%207-a2WFLZWXZFZRPokVsmoXq5RUNa9n9K.svg",
    customer: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%204-bKZDd6s4HQ3qfrxOVuDXia3hNSHVji.svg",
    product: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%203-1DbvR4zGycnpqpwq0p2Kb4Ri0fzCe0.svg",
    finance: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%205-111xUYlEFis8GWD3YBoy1o1m4W3oGt.svg",
    analytics: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%202-6dECwfVWm6BBv3yzHE2zNcmDf3Qxyr.svg",
    technology: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%202-eewWehHfWpQFHre8bt7ErqcEKyaLOZ.png",
    social: "https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Frame%201-3Kodq0AOYio1NhlHdBI4fdKeYSFm5q.svg",
  }

  // Updated directors array with all 10 Director agents from the compendium
  const directors = [
    {
      id: "marketing",
      name: "Marketing Director",
      department: "Marketing Department",
      agentCount: 9,
      activeAgents: 8,
      avatar: agentAvatars.marketing,
      description: "CAC/LTV Optimization",
      agents: [
        "Content Strategy Agent",
        "Copy Writer Agent",
        "Copy Editor Agent",
        "Email Marketing Agent",
        "SEO Agent",
        "A/B Testing Agent",
        "Campaign Analytics Agent",
      ],
    },
    {
      id: "social-media",
      name: "Social Media Director",
      department: "Social Media Department",
      agentCount: 3,
      activeAgents: 3,
      avatar: agentAvatars.social,
      description: "Platform-Specific Campaigns",
      agents: ["Facebook Agent", "Instagram Agent", "Pinterest Agent"],
    },
    {
      id: "creative",
      name: "Creative Director",
      department: "Creative Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.marketing,
      description: "Visual Identity & Creative Excellence",
      agents: ["Visual Design Agent", "Content Creation Agent", "Brand Management Agent", "Creative Strategy Agent"],
    },
    {
      id: "sales",
      name: "Sales Director",
      department: "Sales Department",
      agentCount: 12,
      activeAgents: 11,
      avatar: agentAvatars.sales,
      description: "Persona-Based Selling",
      agents: [
        "Hospitality Sales Agent",
        "Corporate Sales Agent",
        "Healthcare Sales Agent",
        "Retail Sales Agent",
        "Real Estate Sales Agent",
        "Homeowner Sales Agent",
        "Renter Sales Agent",
        "Interior Designer Agent",
        "Art Collector Agent",
        "Gift Buyer Agent",
        "Millennial/Gen Z Agent",
        "Global Customer Agent",
      ],
    },
    {
      id: "operations",
      name: "Operations Director",
      department: "Operations Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.operations,
      description: "Fulfillment & Supply Chain",
      agents: ["Inventory Management Agent", "Fulfillment Agent", "Vendor Management Agent", "Quality Control Agent"],
    },
    {
      id: "customer",
      name: "Customer Experience Director",
      department: "Customer Experience Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.customer,
      description: "Support & Retention",
      agents: [
        "Customer Support Agent",
        "Satisfaction Monitoring Agent",
        "Feedback Analysis Agent",
        "Loyalty Program Agent",
      ],
    },
    {
      id: "finance",
      name: "Finance Director",
      department: "Finance Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.finance,
      description: "Financial Management & ROI",
      agents: ["Budget Management Agent", "ROI Analysis Agent", "Cash Flow Agent", "Financial Reporting Agent"],
    },
    {
      id: "analytics",
      name: "Analytics Director",
      department: "Analytics Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.analytics,
      description: "Business Intelligence",
      agents: [
        "Performance Analytics Agent",
        "Data Insights Agent",
        "KPI Tracking Agent",
        "Business Intelligence Agent",
      ],
    },
    {
      id: "product",
      name: "Product Director",
      department: "Product Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.product,
      description: "Strategy & Market Positioning",
      agents: [
        "Product Strategy Agent",
        "Market Research Agent",
        "Competitive Analysis Agent",
        "Product Development Agent",
      ],
    },
    {
      id: "technology",
      name: "Technology Director",
      department: "Technology Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.technology,
      description: "Systems & Innovation",
      agents: ["System Monitoring Agent", "Infrastructure Agent", "Security Agent", "Integration Agent"],
    },
    {
      id: "compliance",
      name: "Compliance & Risk Director",
      department: "Compliance & Risk Department",
      agentCount: 4,
      activeAgents: 4,
      avatar: agentAvatars.finance,
      description: "Risk Management & Compliance",
      agents: ["Data Privacy Agent", "Regulatory Compliance Agent", "Risk Assessment Agent", "Crisis Management Agent"],
    },
  ]

  // Available agents data structure
  const availableAgents = [
    ...directors.flatMap((director) =>
      director.agents.map((agentName) => ({
        id: `${director.id}-${agentName.toLowerCase().replace(/\s+/g, "-")}`,
        name: agentName,
        type: "agent",
        avatar: director.avatar,
        role: agentName.split(" ").pop() || "Agent",
        status: getAgentStatus(agentName),
        specialization: getCurrentTask(agentName),
      })),
    ),
    {
      id: "business-manager",
      name: "Business Manager",
      type: "business-manager",
      avatar: agentAvatars.business,
      role: "Central Orchestrator",
      status: "active",
      specialization: "Strategic coordination and workflow management",
    },
  ]

  // Chat management functions
  const handleOpenAgentChat = (agentName: string, agentType: string) => {
    const agent = availableAgents.find((a) => a.name === agentName)
    if (!agent) return

    const chatId = `chat-${agent.id}-${Date.now()}`
    const newChat = {
      id: chatId,
      title: `Chat with ${agentName}`,
      participants: [agent],
      messages: [
        {
          id: `msg-${Date.now()}`,
          agentId: agent.id,
          agentName: agent.name,
          content: `Hello! I'm ${agentName}. How can I help you today?`,
          timestamp: new Date(),
          mentions: [],
        },
      ],
      lastActivity: new Date(),
    }

    setActiveChats((prev) => ({ ...prev, [chatId]: newChat }))
    setCurrentChatId(chatId)
    setShowUnifiedChat(true)
  }

  const handleSendMessage = (message: string, mentions: string[]) => {
    if (!currentChatId || !activeChats[currentChatId]) return

    const userMessage = {
      id: `msg-${Date.now()}`,
      agentId: "user",
      agentName: "You",
      content: message,
      timestamp: new Date(),
      mentions,
    }

    // Simulate agent responses
    const agentResponse = {
      id: `msg-${Date.now() + 1}`,
      agentId: activeChats[currentChatId].participants[0].id,
      agentName: activeChats[currentChatId].participants[0].name,
      content: generateAgentResponse(message, activeChats[currentChatId].participants[0]),
      timestamp: new Date(),
      mentions: [],
    }

    setActiveChats((prev) => ({
      ...prev,
      [currentChatId]: {
        ...prev[currentChatId],
        messages: [...prev[currentChatId].messages, userMessage, agentResponse],
        lastActivity: new Date(),
      },
    }))
  }

  const handleAddAgent = (agentId: string) => {
    if (!currentChatId) return

    const agent = availableAgents.find((a) => a.id === agentId)
    if (!agent) return

    setActiveChats((prev) => ({
      ...prev,
      [currentChatId]: {
        ...prev[currentChatId],
        participants: [...prev[currentChatId].participants, agent],
        title: `Group Chat (${prev[currentChatId].participants.length + 1} participants)`,
      },
    }))
  }

  const generateAgentResponse = (userMessage: string, agent: any) => {
    // Context-aware responses based on agent type and user message
    if (agent.name === "Business Manager") {
      return `I understand your request regarding "${userMessage}". Let me coordinate with the appropriate agents to address this. I'll analyze our current performance metrics and provide strategic recommendations.`
    }

    return `Thank you for your message. As a ${agent.role}, I can help you with ${agent.specialization.toLowerCase()}. Let me process your request: "${userMessage}"`
  }

  // Calculate total agents and get status counts from centralized store
  const allAgentNames = [
    'Business Manager',
    ...directors.flatMap((dir) => dir.agents)
  ]
  const statusCounts = calculateStatusCounts(allAgentNames)
  const totalAgents = statusCounts.total
  const activeAgents = statusCounts.active
  const idleAgents = statusCounts.idle
  const errorAgents = statusCounts.error

  // Navigation items mapped to all directors
  const navigationItems = [
    { id: "overview", label: "Executive Overview", avatar: agentAvatars.business, director: null },
    {
      id: "marketing",
      label: "Marketing",
      avatar: agentAvatars.marketing,
      director: directors.find((d) => d.id === "marketing"),
    },
    {
      id: "social-media",
      label: "Social Media",
      avatar: agentAvatars.social,
      director: directors.find((d) => d.id === "social-media"),
    },
    {
      id: "creative",
      label: "Creative",
      avatar: agentAvatars.marketing,
      director: directors.find((d) => d.id === "creative"),
    },
    {
      id: "sales",
      label: "Sales",
      avatar: agentAvatars.sales,
      director: directors.find((d) => d.id === "sales"),
    },
    {
      id: "operations",
      label: "Operations",
      avatar: agentAvatars.operations,
      director: directors.find((d) => d.id === "operations"),
    },
    {
      id: "customer",
      label: "Customer Experience",
      avatar: agentAvatars.customer,
      director: directors.find((d) => d.id === "customer"),
    },
    {
      id: "finance",
      label: "Finance",
      avatar: agentAvatars.finance,
      director: directors.find((d) => d.id === "finance"),
    },
    {
      id: "analytics",
      label: "Analytics",
      avatar: agentAvatars.analytics,
      director: directors.find((d) => d.id === "analytics"),
    },
    {
      id: "product",
      label: "Product",
      avatar: agentAvatars.product,
      director: directors.find((d) => d.id === "product"),
    },
    {
      id: "technology",
      label: "Technology",
      avatar: agentAvatars.technology,
      director: directors.find((d) => d.id === "technology"),
    },
    {
      id: "compliance",
      label: "Compliance & Risk",
      avatar: agentAvatars.finance,
      director: directors.find((d) => d.id === "compliance"),
    },
  ]

  // Recent alerts
  const alerts = [
    { id: 1, type: "warning", message: "Marketing ROI below target (12x vs 15x)", time: "2 min ago", priority: "high" },
    { id: 2, type: "success", message: "Email list reached 2,847 subscribers", time: "15 min ago", priority: "medium" },
    { id: 3, type: "error", message: "LinkedIn scraping agent offline", time: "1 hour ago", priority: "critical" },
    { id: 4, type: "info", message: "New high-value lead: Marriott Hotels", time: "2 hours ago", priority: "medium" },
  ]

  // KPI data
  const kpis = [
    {
      title: "Monthly Revenue",
      value: "$28,450",
      target: "$30,000",
      change: "+18.2%",
      trend: "up",
      description: "Target: $30K by month 3",
    },
    {
      title: "Marketing ROI",
      value: "12.4x",
      target: "15x",
      change: "+2.1x",
      trend: "up",
      description: "From $2K investment",
    },
    {
      title: "Email Subscribers",
      value: "2,847",
      target: "3,000",
      change: "+156",
      trend: "up",
      description: "Goal: 3K by month 3",
    },
    {
      title: "Conversion Rate",
      value: "3.2%",
      target: "3.5%",
      change: "+0.3%",
      trend: "up",
      description: "Art sales conversion",
    },
  ]

  const handleDirectorClick = (directorId: string) => {
    setActiveTab(directorId)
    setSelectedDirector(directorId)

    // If agent detail panel is open, update it to show the Director Agent
    if (showAgentDetail) {
      const director = directors.find((d) => d.id === directorId)
      if (director) {
        const directorDetails = getAgentDetails(director.name, director.id, true)
        setSelectedAgent(directorDetails)
      }
    }
  }

  const renderDirectorView = () => {
    const director = directors.find((d) => d.id === selectedDirector)
    if (!director) return null

    const directorActiveCount = getActiveAgentCount(director.agents)

    return (
      <div className="space-y-6">
        {/* Director Header */}
        <Card>
          <CardHeader>
            <div className="flex items-center gap-4">
              <Avatar className="w-16 h-16">
                <AvatarImage src={director.avatar || "/placeholder.svg"} />
                <AvatarFallback>
                  {director.name
                    .split(" ")
                    .map((n) => n[0])
                    .join("")}
                </AvatarFallback>
              </Avatar>
              <div>
                <CardTitle className="text-2xl">{director.name}</CardTitle>
                <p className="text-gray-600">{director.description}</p>
                <div className="flex items-center gap-4 mt-2">
                  <Badge variant="outline">{director.agents.length} Total Agents</Badge>
                  <Badge variant="default">{directorActiveCount} Active</Badge>
                </div>
              </div>
              <div className="ml-auto">
                <Button
                  className="bg-purple-600 hover:bg-purple-700"
                  onClick={() => handleOpenAgentChat("Business Manager", "business-manager")}
                >
                  <MessageSquare className="w-4 h-4 mr-2" />
                  Chat with Director
                </Button>
              </div>
            </div>
          </CardHeader>
        </Card>

        {/* Agent Directory Grid */}
        <AgentDirectory director={director} />
      </div>
    )
  }

  // Handle navigation click with sidebar close on mobile
  const handleNavClick = (itemId: string, director: any) => {
    if (director) {
      handleDirectorClick(itemId)
    } else {
      setActiveTab(itemId)
      setSelectedDirector(null)
    }
    // Close sidebar on mobile after navigation
    if (isMobile) {
      closeSidebar()
    }
  }

  return (
    <div className="flex h-screen bg-gray-50">
      {/* Mobile Header */}
      <div className="md:hidden fixed top-0 left-0 right-0 h-16 bg-white border-b border-gray-200 z-50 flex items-center px-4">
        <button
          onClick={toggleSidebar}
          className="p-2 rounded-lg hover:bg-gray-100 transition-colors"
          aria-label={isSidebarOpen ? "Close menu" : "Open menu"}
        >
          {isSidebarOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
        </button>
        <div className="flex items-center gap-2 ml-3">
          <div className="w-8 h-8 bg-gradient-to-br from-purple-600 to-blue-600 rounded-lg flex items-center justify-center">
            <span className="text-white font-bold text-sm">V</span>
          </div>
          <span className="font-semibold text-gray-900">VividWalls</span>
        </div>
      </div>

      {/* Mobile Backdrop Overlay */}
      {isSidebarOpen && isMobile && (
        <div
          className="fixed inset-0 bg-black/50 z-40 md:hidden"
          onClick={closeSidebar}
          aria-hidden="true"
        />
      )}

      {/* Sidebar */}
      <div
        className={`
          fixed md:static inset-y-0 left-0 z-40
          w-64 bg-white border-r border-gray-200 flex flex-col
          transform transition-transform duration-300 ease-in-out
          ${isSidebarOpen ? 'translate-x-0' : '-translate-x-full'}
          md:translate-x-0
          pt-16 md:pt-0
        `}
      >
        <div className="p-6">
          <div className="hidden md:flex items-center gap-3 mb-8">
            <div className="w-10 h-10 bg-gradient-to-br from-purple-600 to-blue-600 rounded-xl flex items-center justify-center">
              <span className="text-white font-bold text-lg">V</span>
            </div>
            <div>
              <h1 className="font-bold text-lg text-gray-900">VividWalls</h1>
              <p className="text-xs text-gray-500">Multi-Agent System</p>
            </div>
          </div>

          <nav className="space-y-2">
            {navigationItems.map((item) => (
              <button
                key={item.id}
                onClick={() => handleNavClick(item.id, item.director)}
                className={`w-full flex items-center gap-3 px-3 py-2 rounded-lg text-left transition-colors ${
                  activeTab === item.id && (item.id === "overview" ? !selectedDirector : true)
                    ? "bg-purple-50 text-purple-700 border border-purple-200"
                    : "text-gray-600 hover:bg-gray-50"
                }`}
              >
                <Avatar className="w-6 h-6">
                  <AvatarImage src={item.avatar || "/placeholder.svg"} />
                  <AvatarFallback>{item.label[0]}</AvatarFallback>
                </Avatar>
                <span className="font-medium text-sm">{item.label}</span>
                {item.director && <ArrowRight className="w-3 h-3 ml-auto" />}
              </button>
            ))}
          </nav>
        </div>

        {/* Agent Status Summary */}
        <div className="px-6 py-4 border-t border-gray-200">
          <h3 className="text-sm font-semibold text-gray-900 mb-3">System Status</h3>
          <div className="space-y-2">
            <div className="flex items-center justify-between text-sm">
              <span className="text-gray-600">Total Agents</span>
              <span className="font-medium">{totalAgents}</span>
            </div>
            <div className="flex items-center justify-between text-sm">
              <span className="text-green-600">Active</span>
              <span className="font-medium text-green-600">{activeAgents}</span>
            </div>
            <div className="flex items-center justify-between text-sm">
              <span className="text-yellow-600">Idle</span>
              <span className="font-medium text-yellow-600">{idleAgents}</span>
            </div>
            <div className="flex items-center justify-between text-sm">
              <span className="text-red-600">Error</span>
              <span className="font-medium text-red-600">{errorAgents}</span>
            </div>
          </div>
          <Progress value={(activeAgents / totalAgents) * 100} className="mt-3" />
        </div>

        {/* Business Manager Agent */}
        <div className="px-6 py-4 border-t border-gray-200 mt-auto">
          <div className="bg-gradient-to-r from-purple-50 to-blue-50 rounded-lg p-4">
            <div className="flex items-center gap-3 mb-2">
              <Avatar className="w-8 h-8">
                <AvatarImage src={agentAvatars.business || "/placeholder.svg"} />
                <AvatarFallback>BM</AvatarFallback>
              </Avatar>
              <div>
                <p className="font-medium text-sm">Business Manager</p>
                <p className="text-xs text-gray-500">Central Orchestrator</p>
              </div>
            </div>
            <Button
              size="sm"
              className="w-full bg-purple-600 hover:bg-purple-700"
              onClick={() => handleOpenAgentChat("Business Manager", "business-manager")}
            >
              <MessageSquare className="w-4 h-4 mr-2" />
              Chat with Agent
            </Button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden pt-16 md:pt-0 md:ml-0">
        {/* Header */}
        <header className="bg-white border-b border-gray-200 px-6 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                {selectedDirector
                  ? directors.find((d) => d.id === selectedDirector)?.department
                  : "Executive Dashboard"}
              </h1>
              <p className="text-gray-600">
                {selectedDirector
                  ? `Manage ${directors.find((d) => d.id === selectedDirector)?.name} operations`
                  : "Monitor your AI-powered e-commerce operations"}
              </p>
            </div>

            <div className="flex items-center gap-4">
              <SearchCommand
                onNavigate={(departmentId) => {
                  handleDirectorClick(departmentId)
                  if (isMobile) {
                    closeSidebar()
                  }
                }}
                className="w-64 hidden sm:block"
              />

              <NotificationDropdown
                onNavigate={(departmentId) => {
                  handleDirectorClick(departmentId)
                  if (isMobile) {
                    closeSidebar()
                  }
                }}
              />

              <Button variant="outline" size="icon">
                <Settings className="w-4 h-4" />
              </Button>

              <Avatar>
                <AvatarImage src="/placeholder.svg?height=32&width=32" />
                <AvatarFallback>SC</AvatarFallback>
              </Avatar>
            </div>
          </div>
        </header>

        {/* Dashboard Content */}
        <main className="flex-1 p-6 overflow-auto">
          {selectedDirector && activeTab !== "overview" ? (
            renderDirectorView()
          ) : (
            <>
              {/* KPI Cards */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                {kpis.map((kpi, index) => (
                  <Card key={index} className="hover:shadow-md transition-shadow">
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm font-medium text-gray-600">{kpi.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-2xl font-bold text-gray-900">{kpi.value}</span>
                        <div
                          className={`flex items-center gap-1 text-sm ${
                            kpi.trend === "up" ? "text-green-600" : "text-red-600"
                          }`}
                        >
                          {kpi.trend === "up" ? (
                            <TrendingUp className="w-4 h-4" />
                          ) : (
                            <TrendingDown className="w-4 h-4" />
                          )}
                          {kpi.change}
                        </div>
                      </div>
                      <p className="text-xs text-gray-500">{kpi.description}</p>
                      <div className="mt-2">
                        <div className="flex justify-between text-xs text-gray-500 mb-1">
                          <span>Progress to target</span>
                          <span>{kpi.target}</span>
                        </div>
                        <Progress
                          value={
                            (Number.parseFloat(kpi.value.replace(/[^0-9.]/g, "")) /
                              Number.parseFloat(kpi.target.replace(/[^0-9.]/g, ""))) *
                            100
                          }
                          className="h-2"
                        />
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Directors Overview */}
                <Card className="lg:col-span-2">
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Bot className="w-5 h-5" />
                      Director Agents Overview
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      {directors.slice(0, 6).map((director, index) => {
                        const directorActiveCount = getActiveAgentCount(director.agents)
                        return (
                          <div
                            key={index}
                            className="p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors cursor-pointer"
                            onClick={() => handleDirectorClick(director.id)}
                          >
                            <div className="flex items-center gap-3 mb-2">
                              <Avatar className="w-10 h-10">
                                <AvatarImage src={director.avatar || "/placeholder.svg"} />
                                <AvatarFallback>
                                  {director.name
                                    .split(" ")
                                    .map((n) => n[0])
                                    .join("")}
                                </AvatarFallback>
                              </Avatar>
                              <div className="flex-1">
                                <h4 className="font-medium text-gray-900 text-sm">{director.name}</h4>
                                <p className="text-xs text-gray-500">{director.description}</p>
                              </div>
                              <Badge variant={directorActiveCount === director.agents.length ? "default" : "secondary"}>
                                {directorActiveCount}/{director.agents.length}
                              </Badge>
                            </div>
                            <div className="flex items-center gap-2">
                              <div className="flex-1">
                                <Progress value={(directorActiveCount / director.agents.length) * 100} className="h-2" />
                              </div>
                              <ArrowRight className="w-4 h-4 text-gray-400" />
                            </div>
                          </div>
                        )
                      })}
                    </div>
                  </CardContent>
                </Card>

                {/* Alerts & Quick Actions */}
                <div className="space-y-6">
                  {/* Alerts */}
                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2">
                        <AlertTriangle className="w-5 h-5" />
                        Recent Alerts
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-3">
                      {alerts.map((alert) => (
                        <div key={alert.id} className="flex items-start gap-3 p-3 rounded-lg bg-gray-50">
                          <div
                            className={`w-2 h-2 rounded-full mt-2 ${
                              alert.type === "error"
                                ? "bg-red-500"
                                : alert.type === "warning"
                                  ? "bg-yellow-500"
                                  : alert.type === "success"
                                    ? "bg-green-500"
                                    : "bg-blue-500"
                            }`}
                          />
                          <div className="flex-1 min-w-0">
                            <p className="text-sm text-gray-900">{alert.message}</p>
                            <p className="text-xs text-gray-500">{alert.time}</p>
                          </div>
                          <Badge
                            variant={
                              alert.priority === "critical"
                                ? "destructive"
                                : alert.priority === "high"
                                  ? "default"
                                  : "secondary"
                            }
                            className="text-xs"
                          >
                            {alert.priority}
                          </Badge>
                        </div>
                      ))}
                    </CardContent>
                  </Card>

                  {/* Quick Actions */}
                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2">
                        <Zap className="w-5 h-5" />
                        Quick Actions
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-3">
                      <Button
                        className="w-full justify-start bg-transparent"
                        variant="outline"
                        onClick={() => openAction("launch-campaign")}
                      >
                        <MessageSquare className="w-4 h-4 mr-2" />
                        Launch Marketing Campaign
                      </Button>
                      <Button
                        className="w-full justify-start bg-transparent"
                        variant="outline"
                        onClick={() => openAction("deploy-persona")}
                      >
                        <Users className="w-4 h-4 mr-2" />
                        Deploy Sales Persona
                      </Button>
                      <Button
                        className="w-full justify-start bg-transparent"
                        variant="outline"
                        onClick={() => openAction("create-workflow")}
                      >
                        <Settings className="w-4 h-4 mr-2" />
                        Create Workflow
                      </Button>
                      <Button
                        className="w-full justify-start bg-transparent"
                        variant="outline"
                        onClick={() => openAction("view-reports")}
                      >
                        <CheckCircle className="w-4 h-4 mr-2" />
                        View Reports
                      </Button>
                    </CardContent>
                  </Card>
                </div>
              </div>
            </>
          )}
        </main>
      </div>
      {/* Unified Chat Panel */}
      <UnifiedChatPanel
        isOpen={showUnifiedChat}
        isExpanded={chatExpanded}
        activeChats={activeChats}
        currentChatId={currentChatId}
        onClose={() => setShowUnifiedChat(false)}
        onToggleExpand={() => setChatExpanded(!chatExpanded)}
        onSwitchChat={setCurrentChatId}
        onSendMessage={handleSendMessage}
        onAddAgent={handleAddAgent}
        availableAgents={availableAgents}
      />

      {/* Quick Action Modals */}
      <QuickActionModals
        activeAction={activeAction}
        isSubmitting={isSubmitting}
        onClose={closeAction}
        onSubmit={submitAction}
      />
    </div>
  )
}
