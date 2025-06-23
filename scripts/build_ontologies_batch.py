#!/usr/bin/env python3
"""
Build ontologies in batches to avoid timeouts
"""

import asyncio
import json
import sys
from datetime import datetime
from typing import List, Dict, Any
from crawl4ai import AsyncWebCrawler
from neo4j import GraphDatabase
import time

# Import configurations
from task_agents_config import TASK_AGENTS_CONFIG
from build_complete_ontologies import DIRECTORS_CONFIG, CompleteOntologyBuilder

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

class BatchOntologyBuilder(CompleteOntologyBuilder):
    """Modified builder that can run in batches"""
    
    async def build_director_batch(self, start_idx=0, batch_size=2):
        """Build ontologies for a batch of directors"""
        directors = DIRECTORS_CONFIG["directors"]
        end_idx = min(start_idx + batch_size, len(directors))
        
        print(f"\n=== Building Director Agent Ontologies (Batch {start_idx+1}-{end_idx}) ===")
        
        for i in range(start_idx, end_idx):
            director = directors[i]
            await self.build_agent_ontology(director, "Director")
            
    async def build_task_agent_batch(self, category=None, start_idx=0, batch_size=3):
        """Build ontologies for a batch of task agents"""
        # Task agents are in a list, not dict
        agent_list = TASK_AGENTS_CONFIG["task_agents"]
        
        end_idx = min(start_idx + batch_size, len(agent_list))
        
        print(f"\n=== Building Task Agent Ontologies (Batch {start_idx+1}-{end_idx}) ===")
        
        for i in range(start_idx, end_idx):
            agent = agent_list[i]
            await self.build_agent_ontology(agent, "TaskAgent")

async def main():
    """Main execution with batch options"""
    if len(sys.argv) < 2:
        print("Usage: python build_ontologies_batch.py [directors|task|all] [start_idx] [batch_size]")
        print("\nExamples:")
        print("  python build_ontologies_batch.py directors 0 2")
        print("  python build_ontologies_batch.py task 0 5")
        print("  python build_ontologies_batch.py all")
        return
    
    mode = sys.argv[1]
    start_idx = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    batch_size = int(sys.argv[3]) if len(sys.argv) > 3 else 3
    
    print(f"Starting VividWalls Batch Ontology Building (mode: {mode})...")
    print("=" * 60)
    
    builder = BatchOntologyBuilder()
    await builder.initialize()
    
    if mode == "directors":
        await builder.build_director_batch(start_idx, batch_size)
    elif mode == "task":
        await builder.build_task_agent_batch(None, start_idx, batch_size)
    elif mode == "all":
        # Build all in smaller batches
        directors = DIRECTORS_CONFIG["directors"]
        for i in range(0, len(directors), 2):
            await builder.build_director_batch(i, 2)
            await asyncio.sleep(1)  # Brief pause between batches
        
        # Count all task agents
        total_agents = len(TASK_AGENTS_CONFIG["task_agents"])
        for i in range(0, total_agents, 5):
            await builder.build_task_agent_batch(None, i, 5)
            await asyncio.sleep(1)  # Brief pause between batches
            
        # Create specializations and print summary
        builder.create_agent_specializations()
        builder.print_summary()
    else:
        print(f"Unknown mode: {mode}")
        return
    
    print(f"\n✓ Batch processing completed!")

if __name__ == "__main__":
    asyncio.run(main())