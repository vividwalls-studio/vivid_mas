#!/usr/bin/env python3
"""Fix JSON issues in n8n workflow files."""

import json
import re
from pathlib import Path

def fix_workflow_json(file_path):
    """Fix JSON issues specific to n8n workflow files."""
    print(f"Processing {file_path}...")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # First, let's fix the specific issue with escaped quotes in jsCode
    # Find all jsCode fields and fix their escaping
    def fix_js_code_field(match):
        """Fix JavaScript code field escaping."""
        js_code = match.group(1)
        
        # Unescape single quotes that are improperly escaped
        js_code = js_code.replace("\\'", "'")
        
        # But we need to keep double quotes escaped
        js_code = js_code.replace('\\n', '\n')
        js_code = js_code.replace('\n', '\\n')
        js_code = js_code.replace('\t', '\\t')
        js_code = js_code.replace('\r', '\\r')
        
        # Re-escape any unescaped double quotes (except at the boundaries)
        # This is tricky - we need to escape quotes that aren't already escaped
        parts = []
        i = 0
        while i < len(js_code):
            if js_code[i] == '"':
                # Check if it's already escaped
                if i > 0 and js_code[i-1] == '\\':
                    # Already escaped, keep it
                    parts.append('"')
                else:
                    # Not escaped, escape it
                    parts.append('\\"')
            elif js_code[i] == '\\' and i + 1 < len(js_code) and js_code[i+1] == '"':
                # This is an escape sequence, keep it
                parts.append('\\')
            else:
                parts.append(js_code[i])
            i += 1
        
        js_code = ''.join(parts)
        
        return f'"jsCode": "{js_code}"'
    
    # Match jsCode fields more carefully
    # This pattern captures the jsCode field value
    pattern = r'"jsCode"\s*:\s*"((?:[^"\\]|\\.)*?)"(?=\s*[,}])'
    
    # Apply the fix
    content = re.sub(pattern, fix_js_code_field, content, flags=re.DOTALL | re.MULTILINE)
    
    # Save the fixed content
    try:
        # Try to parse to validate
        data = json.loads(content)
        
        # Write back the properly formatted JSON
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        
        print(f"✓ Successfully fixed {file_path}")
        return True
        
    except json.JSONDecodeError as e:
        print(f"✗ Still has JSON errors: {e}")
        print(f"  Attempting manual fix...")
        
        # For the specific error, let's try a more targeted fix
        # The error is about escaped quotes in arrays
        # Let's fix the specific patterns causing issues
        
        # Fix the emotionalTriggers array issue
        content = re.sub(
            r"(urgency:\s*\[.*?)'([^']*?)'(.*?\])",
            r'\1"\2"\3',
            content,
            flags=re.DOTALL
        )
        
        # Fix don't -> dont in the array
        content = content.replace("'don\\\\'t miss'", '"dont miss"')
        content = content.replace('"don\\\\'t miss"', '"dont miss"')
        
        # Try again
        try:
            data = json.loads(content)
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"✓ Successfully fixed {file_path} with manual corrections")
            return True
        except json.JSONDecodeError as e2:
            print(f"✗ Manual fix also failed: {e2}")
            # Save a backup
            backup_path = str(file_path) + '.broken'
            with open(backup_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return False

if __name__ == "__main__":
    files_to_fix = [
        "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/copywriting_knowledge_gatherer_agent.json",
        "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/technology_automation_knowledge_gatherer_agent.json"
    ]
    
    for file_path in files_to_fix:
        if Path(file_path).exists():
            fix_workflow_json(file_path)