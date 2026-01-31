"use client"

import { useState, useCallback, useMemo, useRef, useEffect } from 'react'
import type { AgentStatus, AgentStatusCounts } from '@/types/agents'

// Generate a consistent status for an agent based on its name (deterministic)
function generateConsistentStatus(agentName: string): AgentStatus {
  // Use a simple hash of the agent name to determine status
  // This ensures the same agent always gets the same status within a session
  let hash = 0
  for (let i = 0; i < agentName.length; i++) {
    const char = agentName.charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash = hash & hash // Convert to 32bit integer
  }

  // Use the hash to determine status (80% active, 10% idle, 10% error)
  const normalizedHash = Math.abs(hash) % 100

  if (normalizedHash < 80) return 'active'
  if (normalizedHash < 90) return 'idle'
  return 'error'
}

interface AgentStatusMap {
  [agentName: string]: AgentStatus
}

export function useAgents() {
  // Store agent statuses in a ref to persist across renders
  const statusMapRef = useRef<AgentStatusMap>({})
  const [statusMap, setStatusMap] = useState<AgentStatusMap>({})
  const [isInitialized, setIsInitialized] = useState(false)

  // Initialize status map on first render
  useEffect(() => {
    if (!isInitialized) {
      setIsInitialized(true)
    }
  }, [isInitialized])

  // Get status for an agent (creates consistent status if not exists)
  const getAgentStatus = useCallback((agentName: string): AgentStatus => {
    if (statusMapRef.current[agentName]) {
      return statusMapRef.current[agentName]
    }

    // Generate a consistent status based on agent name
    const status = generateConsistentStatus(agentName)
    statusMapRef.current[agentName] = status

    // Update state to trigger re-renders when needed
    setStatusMap(prev => ({ ...prev, [agentName]: status }))

    return status
  }, [])

  // Update agent status manually
  const updateAgentStatus = useCallback((agentName: string, status: AgentStatus) => {
    statusMapRef.current[agentName] = status
    setStatusMap(prev => ({ ...prev, [agentName]: status }))
  }, [])

  // Get status counts from all registered agents
  const getStatusCounts = useCallback((): AgentStatusCounts => {
    const statuses = Object.values(statusMapRef.current)
    return {
      total: statuses.length,
      active: statuses.filter(s => s === 'active').length,
      idle: statuses.filter(s => s === 'idle').length,
      error: statuses.filter(s => s === 'error' || s === 'offline').length,
    }
  }, [])

  // Calculate counts based on a list of agent names
  const calculateStatusCounts = useCallback((agentNames: string[]): AgentStatusCounts => {
    const counts: AgentStatusCounts = {
      total: agentNames.length,
      active: 0,
      idle: 0,
      error: 0,
    }

    agentNames.forEach(name => {
      const status = getAgentStatus(name)
      if (status === 'active') counts.active++
      else if (status === 'idle') counts.idle++
      else counts.error++
    })

    return counts
  }, [getAgentStatus])

  // Get active count for a specific director's agents
  const getActiveAgentCount = useCallback((agentNames: string[]): number => {
    return agentNames.filter(name => getAgentStatus(name) === 'active').length
  }, [getAgentStatus])

  // Batch register agents with consistent statuses
  const registerAgents = useCallback((agentNames: string[]) => {
    const newStatuses: AgentStatusMap = {}

    agentNames.forEach(name => {
      if (!statusMapRef.current[name]) {
        newStatuses[name] = generateConsistentStatus(name)
      }
    })

    if (Object.keys(newStatuses).length > 0) {
      statusMapRef.current = { ...statusMapRef.current, ...newStatuses }
      setStatusMap(prev => ({ ...prev, ...newStatuses }))
    }
  }, [])

  return {
    getAgentStatus,
    updateAgentStatus,
    getStatusCounts,
    calculateStatusCounts,
    getActiveAgentCount,
    registerAgents,
    statusMap,
  }
}
