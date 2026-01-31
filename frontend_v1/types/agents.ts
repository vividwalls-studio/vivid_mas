"use client"

export type AgentStatus = 'active' | 'idle' | 'error' | 'offline'

export interface AgentWorkflow {
  name: string
  status: 'completed' | 'in-progress' | 'pending'
  progress: number
}

export interface AgentSettings {
  llmProvider: string
  model: string
  temperature: number
  maxTokens: number
  webhookUrl: string
}

export interface Agent {
  id: string
  name: string
  type: 'agent' | 'director' | 'business-manager'
  department: string
  status: AgentStatus
  avatar?: string
  role?: string
  specialization?: string
  currentTask?: string
  tools: string[]
  workflows: AgentWorkflow[]
  systemPrompt?: string
  settings?: AgentSettings
  isDirector?: boolean
}

export interface Director {
  id: string
  name: string
  department: string
  agentCount: number
  activeAgents: number
  avatar?: string
  description: string
  agents: string[]
}

export interface AgentStatusCounts {
  total: number
  active: number
  idle: number
  error: number
}
