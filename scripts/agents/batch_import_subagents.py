#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Batch import Business Manager sub-agent workflows to n8n
"""

import json
from pathlib import Path

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
WORKFLOWS_PATH = BASE_PATH / "services/n8n/agents/workflows/core/subagents"
PROMPTS_PATH = BASE_PATH / "services/n8n/agents/prompts/core/subagents"

# Sub-agent configurations to import
SUBAGENTS = [
    "performance_analytics",
    "budget_optimization",
    "campaign_coordination",
    "workflow_automation",
    "stakeholder_communications"
]

def prepare_workflow_for_import(workflow_data, prompt_content):
    """Prepare workflow data for n8n import by embedding system prompt"""
    
    # Find the agent node and update its system message
    for node in workflow_data.get("nodes", []):
        if node.get("type") == "@n8n/n8n-nodes-langchain.agent":
            # Replace file reference with actual prompt content
            if "systemMessage" in node.get("parameters", {}):
                node["parameters"]["systemMessage"] = prompt_content
    
    # Update workflow IDs to avoid conflicts
    if "analytics-director-workflow" in str(workflow_data):
        # We'll need to map these to actual workflow IDs
        workflow_str = json.dumps(workflow_data)
        workflow_str = workflow_str.replace('"analytics-director-workflow"', '"REPLACE_WITH_ANALYTICS_DIRECTOR_ID"')
        workflow_str = workflow_str.replace('"director-delegation-workflow"', '"FmyORnR3mSnCoXMq"')  # Marketing Director ID as placeholder
        workflow_data = json.loads(workflow_str)
    
    # Remove version ID and instance ID for fresh import
    if "versionId" in workflow_data:
        del workflow_data["versionId"]
    if "meta" in workflow_data and "instanceId" in workflow_data["meta"]:
        del workflow_data["meta"]["instanceId"]
    
    return workflow_data

def main():
    """Main execution function"""
    
    print("📦 Preparing Business Manager Sub-Agent Workflows for Import")
    print("=" * 60)
    
    workflows_to_import = []
    
    for agent_key in SUBAGENTS:
        print(f"\n📝 Processing {agent_key}...")
        
        # Read workflow file
        workflow_file = WORKFLOWS_PATH / f"{agent_key}_workflow.json"
        if not workflow_file.exists():
            print(f"   ⚠️  Workflow file not found: {workflow_file}")
            continue
            
        with open(workflow_file, 'r', encoding='utf-8') as f:
            workflow_data = json.load(f)
        
        # Read system prompt file
        prompt_file = PROMPTS_PATH / f"{agent_key}_system_prompt.md"
        if not prompt_file.exists():
            print(f"   ⚠️  Prompt file not found: {prompt_file}")
            continue
            
        with open(prompt_file, 'r', encoding='utf-8') as f:
            prompt_content = f.read()
        
        # Prepare workflow for import
        prepared_workflow = prepare_workflow_for_import(workflow_data, prompt_content)
        
        # Save prepared workflow
        output_file = BASE_PATH / f"import_{agent_key}_workflow.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(prepared_workflow, f, indent=2, ensure_ascii=False)
        
        print(f"   ✅ Prepared: {output_file}")
        workflows_to_import.append({
            "name": prepared_workflow["name"],
            "file": output_file
        })
    
    # Create import instructions
    instructions = """# n8n Import Instructions

## Workflows to Import

The following workflows have been prepared for import:

"""
    
    for workflow in workflows_to_import:
        instructions += f"- **{workflow['name']}**: `{workflow['file'].name}`\n"
    
    instructions += """
## Import Steps

1. **Open n8n UI** at http://localhost:5678

2. **Import Each Workflow**:
   - Go to Workflows page
   - Click "Add workflow" → "Import from file"
   - Select each prepared JSON file
   - Save the workflow

3. **Update Workflow References**:
   - Note the workflow IDs after import
   - Update any workflow tool references to use correct IDs

4. **Configure Credentials**:
   - Ensure OpenAI credentials are configured
   - Ensure PostgreSQL credentials are configured
   - Configure any MCP client credentials

5. **Test Each Workflow**:
   - Use the chat trigger to test
   - Verify agent responses
   - Check memory persistence

## Workflow ID Mapping

After import, update this mapping:

```json
{
  "strategic_orchestrator": "WORKFLOW_ID_HERE",
  "performance_analytics": "WORKFLOW_ID_HERE",
  "budget_optimization": "WORKFLOW_ID_HERE",
  "campaign_coordination": "WORKFLOW_ID_HERE",
  "workflow_automation": "WORKFLOW_ID_HERE",
  "stakeholder_communications": "WORKFLOW_ID_HERE"
}
```

## Update Business Manager Orchestrator

After importing all sub-agents, update the Business Manager orchestrator workflow to reference the correct sub-agent workflow IDs in the execute workflow nodes.
"""
    
    instructions_file = BASE_PATH / "n8n_import_instructions.md"
    with open(instructions_file, 'w', encoding='utf-8') as f:
        f.write(instructions)
    
    print(f"\n📋 Instructions saved to: {instructions_file}")
    
    print("\n" + "=" * 60)
    print("✅ Workflow preparation complete!")
    print(f"\n📁 Prepared {len(workflows_to_import)} workflows for import")
    print("\n🚀 Next Steps:")
    print("1. Review the prepared workflow files")
    print("2. Follow the import instructions in n8n_import_instructions.md")
    print("3. Update workflow IDs after import")
    print("4. Test each sub-agent individually")

if __name__ == "__main__":
    main()