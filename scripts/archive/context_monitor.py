#!/usr/bin/env python3
"""
Context Monitoring System for VividWalls MAS Restoration
Monitors agent progress and alerts on stalls or blockers
"""

import json
import os
import glob
import time
from datetime import datetime, timedelta
from pathlib import Path
import subprocess
import sys

# Colors for terminal output
class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

class ContextMonitor:
    def __init__(self, context_dir=".context"):
        self.context_dir = Path(context_dir)
        self.check_interval = 300  # 5 minutes
        self.stall_threshold = timedelta(minutes=30)
        self.blocker_age_threshold = timedelta(hours=2)
        
    def read_json(self, filepath):
        """Read JSON file safely"""
        try:
            with open(filepath, 'r') as f:
                return json.load(f)
        except Exception as e:
            print(f"{Colors.RED}Error reading {filepath}: {e}{Colors.RESET}")
            return None
    
    def check_agent_progress(self):
        """Check all agent checkpoints for stalls"""
        print(f"\n{Colors.BLUE}=== Checking Agent Progress ==={Colors.RESET}")
        
        checkpoint_files = glob.glob(str(self.context_dir / "agent_checkpoints" / "*.json"))
        stalled_agents = []
        
        for checkpoint_file in checkpoint_files:
            checkpoint = self.read_json(checkpoint_file)
            if not checkpoint:
                continue
                
            agent_name = checkpoint.get('agent', 'unknown')
            last_update = checkpoint.get('timestamp', '')
            
            try:
                last_update_time = datetime.fromisoformat(last_update.replace('Z', '+00:00'))
                time_since_update = datetime.now(last_update_time.tzinfo) - last_update_time
                
                if time_since_update > self.stall_threshold:
                    stalled_agents.append({
                        'agent': agent_name,
                        'last_action': checkpoint.get('last_action', 'unknown'),
                        'stalled_for': str(time_since_update).split('.')[0]
                    })
                    print(f"{Colors.YELLOW}⚠️  {agent_name} may be stalled (no update for {time_since_update}){Colors.RESET}")
                else:
                    print(f"{Colors.GREEN}✓ {agent_name} is active (last update: {time_since_update} ago){Colors.RESET}")
                    
            except Exception as e:
                print(f"{Colors.RED}Error processing {agent_name}: {e}{Colors.RESET}")
        
        return stalled_agents
    
    def check_blockers(self):
        """Check for unresolved blockers"""
        print(f"\n{Colors.BLUE}=== Checking Blockers ==={Colors.RESET}")
        
        blockers_file = self.context_dir / "blockers_and_risks.md"
        project_state = self.read_json(self.context_dir / "project_state.json")
        
        if project_state:
            current_blockers = project_state.get('current_blockers', [])
            
            critical_blockers = []
            for blocker in current_blockers:
                if blocker.get('status') == 'active':
                    discovered = datetime.fromisoformat(blocker.get('discovered', '').replace('Z', '+00:00'))
                    age = datetime.now(discovered.tzinfo) - discovered
                    
                    if blocker.get('severity') == 'critical':
                        critical_blockers.append(blocker)
                        print(f"{Colors.RED}🔴 CRITICAL: {blocker.get('description')} (Age: {age}){Colors.RESET}")
                    elif age > self.blocker_age_threshold:
                        print(f"{Colors.YELLOW}⚠️  OLD BLOCKER: {blocker.get('description')} (Age: {age}){Colors.RESET}")
                    else:
                        print(f"{Colors.BLUE}ℹ️  Active: {blocker.get('description')} (Age: {age}){Colors.RESET}")
            
            return critical_blockers
        
        return []
    
    def check_phase_progress(self):
        """Check overall phase progress"""
        print(f"\n{Colors.BLUE}=== Phase Progress ==={Colors.RESET}")
        
        project_state = self.read_json(self.context_dir / "project_state.json")
        if not project_state:
            return
        
        current_phase = project_state.get('restoration_phase', 'unknown')
        overall_progress = project_state.get('overall_progress', 0)
        completed_phases = project_state.get('completed_phases', [])
        
        print(f"Current Phase: {Colors.YELLOW}{current_phase}{Colors.RESET}")
        print(f"Overall Progress: {Colors.YELLOW}{overall_progress}%{Colors.RESET}")
        print(f"Completed Phases: {Colors.GREEN}{', '.join(completed_phases) or 'None'}{Colors.RESET}")
        
        # Check phase-specific status
        phase_file = self.context_dir / "phase_status" / f"{current_phase}_status.json"
        if phase_file.exists():
            phase_status = self.read_json(phase_file)
            if phase_status:
                tasks = phase_status.get('tasks', {})
                print(f"\n{Colors.BLUE}Current Phase Tasks:{Colors.RESET}")
                for task, status in tasks.items():
                    color = Colors.GREEN if status == 'complete' else Colors.YELLOW if status == 'in_progress' else Colors.RED
                    symbol = '✓' if status == 'complete' else '⏳' if status == 'in_progress' else '⏸'
                    print(f"  {symbol} {task}: {color}{status}{Colors.RESET}")
    
    def check_git_branches(self):
        """Check active git branches"""
        print(f"\n{Colors.BLUE}=== Git Branch Status ==={Colors.RESET}")
        
        try:
            # Get current branch
            current = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], text=True).strip()
            print(f"Current Branch: {Colors.YELLOW}{current}{Colors.RESET}")
            
            # Get restoration branches
            branches = subprocess.check_output(['git', 'branch', '--list', 'restoration/*'], text=True).strip().split('\n')
            active_branches = [b.strip().replace('* ', '') for b in branches if b.strip()]
            
            if active_branches:
                print(f"\n{Colors.BLUE}Restoration Branches:{Colors.RESET}")
                for branch in active_branches:
                    is_current = '* ' if branch == current else '  '
                    print(f"{is_current}{branch}")
            
        except Exception as e:
            print(f"{Colors.RED}Error checking git branches: {e}{Colors.RESET}")
    
    def generate_summary_report(self):
        """Generate a summary report"""
        print(f"\n{Colors.BLUE}{'='*60}{Colors.RESET}")
        print(f"{Colors.BLUE}=== VividWalls MAS Restoration Monitor Summary ==={Colors.RESET}")
        print(f"{Colors.BLUE}{'='*60}{Colors.RESET}")
        
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"Report Generated: {timestamp}")
        
        # Get key metrics
        project_state = self.read_json(self.context_dir / "project_state.json")
        if project_state:
            metrics = project_state.get('key_metrics', {})
            print(f"\n{Colors.BLUE}System Metrics:{Colors.RESET}")
            print(f"  Total Agents: {metrics.get('total_agents', 'unknown')}")
            print(f"  MCP Servers: {metrics.get('mcp_servers', 'unknown')}")
            print(f"  Workflows: {metrics.get('workflows', 'unknown')}")
            print(f"  Readiness Score: {metrics.get('readiness_score', 'unknown')}%")
            
            target = project_state.get('restoration_target', {})
            print(f"\n{Colors.BLUE}Restoration Target:{Colors.RESET}")
            print(f"  Completion Time: {target.get('completion_time', 'unknown')}")
            print(f"  Target Readiness: {target.get('target_readiness', 'unknown')}%")
    
    def run_continuous_monitoring(self):
        """Run continuous monitoring loop"""
        print(f"{Colors.GREEN}Starting VividWalls MAS Context Monitor...{Colors.RESET}")
        print(f"Check interval: {self.check_interval} seconds")
        print(f"Stall threshold: {self.stall_threshold}")
        print(f"Press Ctrl+C to stop\n")
        
        try:
            while True:
                # Clear screen for fresh output
                os.system('clear' if os.name == 'posix' else 'cls')
                
                # Run all checks
                stalled_agents = self.check_agent_progress()
                critical_blockers = self.check_blockers()
                self.check_phase_progress()
                self.check_git_branches()
                self.generate_summary_report()
                
                # Alert on critical issues
                if stalled_agents or critical_blockers:
                    print(f"\n{Colors.RED}⚠️  ALERTS ⚠️{Colors.RESET}")
                    if stalled_agents:
                        print(f"{Colors.YELLOW}Stalled Agents: {len(stalled_agents)}{Colors.RESET}")
                    if critical_blockers:
                        print(f"{Colors.RED}Critical Blockers: {len(critical_blockers)}{Colors.RESET}")
                
                # Wait for next check
                print(f"\n{Colors.BLUE}Next check in {self.check_interval} seconds...{Colors.RESET}")
                time.sleep(self.check_interval)
                
        except KeyboardInterrupt:
            print(f"\n{Colors.YELLOW}Monitoring stopped by user{Colors.RESET}")
            sys.exit(0)
    
    def run_single_check(self):
        """Run a single check and exit"""
        self.check_agent_progress()
        self.check_blockers()
        self.check_phase_progress()
        self.check_git_branches()
        self.generate_summary_report()


if __name__ == "__main__":
    monitor = ContextMonitor()
    
    if len(sys.argv) > 1 and sys.argv[1] == "--continuous":
        monitor.run_continuous_monitoring()
    else:
        monitor.run_single_check()
        print(f"\n{Colors.BLUE}Tip: Run with --continuous for ongoing monitoring{Colors.RESET}")