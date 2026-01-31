#!/usr/bin/env python3
"""Fix JSON escaping issues in workflow files."""

import json
import re
import sys
from pathlib import Path

def fix_json_escaping(file_path):
    """Fix common JSON escaping issues."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix improperly escaped quotes in JavaScript strings
    # Replace \' with ' inside JavaScript code blocks
    def fix_js_quotes(match):
        js_code = match.group(1)
        # Replace escaped single quotes with regular single quotes
        js_code = js_code.replace("\\'", "'")
        return '"jsCode": "' + js_code + '"'
    
    # Pattern to match jsCode fields
    pattern = r'"jsCode":\s*"((?:[^"\\]|\\.)*)"'
    content = re.sub(pattern, fix_js_quotes, content, flags=re.DOTALL)
    
    # Try to parse and re-serialize to ensure valid JSON
    try:
        data = json.loads(content)
        # Write back with proper formatting
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"✓ Fixed {file_path}")
        return True
    except json.JSONDecodeError as e:
        print(f"✗ Failed to fix {file_path}: {e}")
        # Save backup
        backup_path = str(file_path) + '.broken'
        with open(backup_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  Saved backup to {backup_path}")
        return False

if __name__ == "__main__":
    files_to_fix = [
        "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/copywriting_knowledge_gatherer_agent.json",
        "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/technology_automation_knowledge_gatherer_agent.json"
    ]
    
    for file_path in files_to_fix:
        if Path(file_path).exists():
            fix_json_escaping(file_path)
        else:
            print(f"File not found: {file_path}")