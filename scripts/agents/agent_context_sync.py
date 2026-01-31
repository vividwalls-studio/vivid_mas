#!/usr/bin/env python3
"""
Agent Context Synchronization Library
Provides context management functions for restoration agents
"""

import json
import os
from datetime import datetime
from pathlib import Path
import subprocess
from typing import Dict, List, Any, Optional

class AgentContextManager:
    """Context management for restoration agents"""
    
    def __init__(self, agent_name: str, phase: int, context_dir: str = ".context"):
        self.agent_name = agent_name
        self.phase = phase
        self.context_dir = Path(context_dir)
        self.checkpoint_file = self.context_dir / "agent_checkpoints" / f"{agent_name}.json"
        self.ensure_directories()
    
    def ensure_directories(self):
        """Ensure context directories exist"""
        (self.context_dir / "agent_checkpoints").mkdir(parents=True, exist_ok=True)
        (self.context_dir / "phase_status").mkdir(parents=True, exist_ok=True)
    
    def read_json(self, filepath: Path) -> Optional[Dict]:
        """Read JSON file safely"""
        try:
            with open(filepath, 'r') as f:
                return json.load(f)
        except Exception:
            return None
    
    def write_json(self, filepath: Path, data: Dict):
        """Write JSON file with pretty formatting"""
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=2, default=str)
    
    def append_markdown(self, filepath: Path, content: str):
        """Append to markdown file"""
        with open(filepath, 'a') as f:
            f.write(f"\n{content}\n")
    
    def get_current_branch(self) -> str:
        """Get current git branch"""
        try:
            return subprocess.check_output(
                ['git', 'rev-parse', '--abbrev-ref', 'HEAD'], 
                text=True
            ).strip()
        except:
            return "unknown"
    
    def startup(self) -> Dict[str, Any]:
        """Agent startup protocol - load all context"""
        print(f"🚀 {self.agent_name} starting up...")
        
        context = {
            'agent_name': self.agent_name,
            'phase': self.phase,
            'startup_time': datetime.now().isoformat()
        }
        
        # 1. Read overall project state
        project_state = self.read_json(self.context_dir / "project_state.json")
        if project_state:
            context['project_state'] = project_state
            print(f"✓ Loaded project state: Phase {project_state.get('restoration_phase')}, "
                  f"Progress {project_state.get('overall_progress')}%")
        
        # 2. Read agent-specific checkpoint
        if self.checkpoint_file.exists():
            checkpoint = self.read_json(self.checkpoint_file)
            if checkpoint:
                context['last_checkpoint'] = checkpoint
                print(f"✓ Restored from checkpoint: {checkpoint.get('last_action')}")
        
        # 3. Check for blockers affecting this agent
        project_blockers = project_state.get('current_blockers', []) if project_state else []
        relevant_blockers = [b for b in project_blockers if b.get('status') == 'active']
        context['active_blockers'] = relevant_blockers
        if relevant_blockers:
            print(f"⚠️  Found {len(relevant_blockers)} active blockers")
        
        # 4. Load phase-specific context
        phase_file = self.context_dir / "phase_status" / f"phase{self.phase}_status.json"
        if phase_file.exists():
            phase_status = self.read_json(phase_file)
            if phase_status:
                context['phase_status'] = phase_status
                print(f"✓ Loaded phase {self.phase} status")
        
        # 5. Check shared discoveries
        discoveries = []
        discoveries_file = self.context_dir / "shared_discoveries.md"
        if discoveries_file.exists():
            # Parse discoveries (simplified - in production would parse markdown properly)
            context['discoveries_acknowledged'] = False
            print("📋 Review shared discoveries required")
        
        return context
    
    def update_progress(self, action: str, result: Any, status: str = "success"):
        """Update agent progress"""
        checkpoint = {
            "agent": self.agent_name,
            "phase": self.phase,
            "last_action": action,
            "result": str(result),
            "status": status,
            "timestamp": datetime.now().isoformat(),
            "git_branch": self.get_current_branch()
        }
        
        # Save checkpoint
        self.write_json(self.checkpoint_file, checkpoint)
        
        # Update phase status if needed
        self.update_phase_status(action, result)
        
        # Log coordination message if needed
        if self.requires_coordination(action):
            self.add_coordination_message(action, result)
        
        print(f"✓ Progress updated: {action}")
    
    def update_phase_status(self, action: str, result: Any):
        """Update phase-specific status"""
        phase_file = self.context_dir / "phase_status" / f"phase{self.phase}_status.json"
        
        phase_status = self.read_json(phase_file) or {
            "phase": self.phase,
            "status": "in_progress",
            "start_time": datetime.now().isoformat(),
            "tasks": {}
        }
        
        # Update task status based on action
        task_key = self.extract_task_key(action)
        if task_key:
            phase_status["tasks"][task_key] = "complete" if "complete" in str(result).lower() else "in_progress"
            phase_status["last_updated"] = datetime.now().isoformat()
            self.write_json(phase_file, phase_status)
    
    def extract_task_key(self, action: str) -> Optional[str]:
        """Extract task key from action description"""
        # Map common actions to task keys
        action_lower = action.lower()
        if "directory" in action_lower:
            return "directory_structure"
        elif "docker" in action_lower and "compose" in action_lower:
            return "docker_compose"
        elif "caddy" in action_lower:
            return "caddy_config"
        elif "credential" in action_lower or "env" in action_lower:
            return "credentials"
        elif "migration" in action_lower:
            return "data_migration"
        return None
    
    def requires_coordination(self, action: str) -> bool:
        """Determine if action requires coordination with other agents"""
        coordination_triggers = [
            "complete", "ready", "blocked", "failed", "discovered",
            "waiting", "depends", "requires"
        ]
        return any(trigger in action.lower() for trigger in coordination_triggers)
    
    def add_coordination_message(self, action: str, result: Any, target_agents: List[str] = None):
        """Add inter-agent coordination message"""
        if target_agents is None:
            target_agents = ["ALL"]
        
        message = f"""
### {datetime.now().isoformat()} - {self.agent_name} → {', '.join(target_agents)}
**Status**: {action}
**Message**: {result}
**Action Required**: Review and proceed with dependent tasks
**Branch**: {self.get_current_branch()}
"""
        
        coord_file = self.context_dir / "agent_coordination.md"
        self.append_markdown(coord_file, message)
    
    def report_blocker(self, description: str, severity: str = "high", affected_agents: List[str] = None):
        """Report a new blocker"""
        if affected_agents is None:
            affected_agents = []
        
        # Update project state
        project_state_file = self.context_dir / "project_state.json"
        project_state = self.read_json(project_state_file) or {}
        
        blocker = {
            "id": f"BLOCK-{datetime.now().strftime('%Y%m%d-%H%M')}",
            "description": description,
            "severity": severity,
            "discovered": datetime.now().isoformat(),
            "discovered_by": self.agent_name,
            "affected_agents": affected_agents,
            "status": "active"
        }
        
        current_blockers = project_state.get("current_blockers", [])
        current_blockers.append(blocker)
        project_state["current_blockers"] = current_blockers
        project_state["last_updated"] = datetime.now().isoformat()
        
        self.write_json(project_state_file, project_state)
        
        # Add to blockers document
        blocker_md = f"""
### {blocker['id']} {'🔴' if severity == 'critical' else '🟡'} {description}
**Discovered By**: {self.agent_name}
**Date**: {datetime.now().strftime('%Y-%m-%d')}
**Description**: {description}
**Affected Agents**: {', '.join(affected_agents) or 'Unknown'}
**Status**: Active
"""
        
        blockers_file = self.context_dir / "blockers_and_risks.md"
        self.append_markdown(blockers_file, blocker_md)
        
        # Notify affected agents
        self.add_coordination_message(
            f"BLOCKER: {description}",
            f"New {severity} severity blocker discovered",
            affected_agents
        )
        
        print(f"🚨 Blocker reported: {description}")
    
    def acknowledge_discovery(self, discovery_id: str):
        """Acknowledge a shared discovery"""
        # This would update the shared discoveries file
        # For now, just log the acknowledgment
        self.update_progress(
            f"Acknowledged discovery {discovery_id}",
            "Discovery reviewed and understood"
        )
    
    def complete_phase(self):
        """Mark current phase as complete"""
        # Update phase status
        phase_file = self.context_dir / "phase_status" / f"phase{self.phase}_status.json"
        phase_status = self.read_json(phase_file) or {}
        phase_status["status"] = "complete"
        phase_status["end_time"] = datetime.now().isoformat()
        self.write_json(phase_file, phase_status)
        
        # Update project state
        project_state_file = self.context_dir / "project_state.json"
        project_state = self.read_json(project_state_file) or {}
        
        completed_phases = project_state.get("completed_phases", [])
        if f"phase{self.phase}" not in completed_phases:
            completed_phases.append(f"phase{self.phase}")
        
        project_state["completed_phases"] = completed_phases
        project_state["last_updated"] = datetime.now().isoformat()
        
        # Calculate new progress (rough estimate)
        progress_per_phase = 100 / 5  # 5 phases total
        project_state["overall_progress"] = len(completed_phases) * progress_per_phase
        
        self.write_json(project_state_file, project_state)
        
        # Announce completion
        self.add_coordination_message(
            f"Phase {self.phase} Complete",
            f"All tasks in phase {self.phase} have been completed successfully",
            ["ALL"]
        )
        
        print(f"🎉 Phase {self.phase} marked as complete!")


# Example usage for agents
if __name__ == "__main__":
    # Example: Architecture Agent startup and task
    agent = AgentContextManager("architecture_agent", phase=1)
    
    # Startup
    context = agent.startup()
    
    # Simulate work
    agent.update_progress("Creating docker-compose.yml", "File created with proper n8n volume mounts")
    
    # Report a discovery
    agent.add_coordination_message(
        "Docker compose ready",
        "All services configured with proper volume mounts",
        ["migration_agent"]
    )
    
    # Complete the phase
    # agent.complete_phase()