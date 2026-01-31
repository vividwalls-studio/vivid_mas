#!/bin/bash

# This script enforces optimization review and can block operations

# Extract the file path from the input if available
FILE_PATH=$(echo "$1" | grep -oE '"file_path":\s*"[^"]+' | cut -d'"' -f4)

echo "🛡️ OPTIMIZATION & DESIGN REVIEW GATE"
echo "===================================="
echo ""

# Check if this is a critical file modification
CRITICAL_PATTERNS=(
    "services/agents/"
    "services/mcp-servers/"
    "services/n8n/"
    "docker-compose"
    "database"
    "schema"
)

IS_CRITICAL=false
for pattern in "${CRITICAL_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == *"$pattern"* ]]; then
        IS_CRITICAL=true
        break
    fi
done

if [ "$IS_CRITICAL" = true ]; then
    echo "⚠️  CRITICAL FILE MODIFICATION DETECTED: $FILE_PATH"
    echo ""
    echo "This file requires EXTRA careful review:"
    echo "1. Have you analyzed the impact on dependent systems?"
    echo "2. Have you checked for existing similar functionality?"
    echo "3. Have you verified this won't break existing workflows?"
    echo "4. Have you considered performance at scale?"
    echo ""
fi

echo "📋 MANDATORY OPTIMIZATION CHECKLIST:"
echo ""
echo "Before proceeding, Claude Code MUST:"
echo "☐ Review existing codebase for similar functionality"
echo "☐ Check CLAUDE.md for project-specific patterns"
echo "☐ Identify potential performance bottlenecks"
echo "☐ Plan proper error handling strategy"
echo "☐ Consider security implications"
echo "☐ Verify alignment with project architecture"
echo ""
echo "🎨 DESIGN REVIEW REQUIREMENTS:"
echo "☐ Check for existing UI/UX patterns"
echo "☐ Ensure consistency with current design"
echo "☐ Consider component reusability"
echo "☐ Plan for responsive behavior"
echo "☐ Include error and loading states"
echo "☐ Verify accessibility compliance"
echo ""

# Display specific guidelines based on file type
if [[ "$FILE_PATH" == *.py ]]; then
    echo "🐍 Python Optimization Guidelines:"
    echo "- Use type hints for clarity"
    echo "- Prefer generators for large datasets"
    echo "- Implement proper exception handling"
    echo "- Follow PEP 8 standards"
elif [[ "$FILE_PATH" == *.js ]] || [[ "$FILE_PATH" == *.ts ]]; then
    echo "📦 JavaScript/TypeScript Guidelines:"
    echo "- Check for async/await optimization"
    echo "- Verify proper error boundaries"
    echo "- Use TypeScript strict mode"
    echo "- Implement proper null checks"
elif [[ "$FILE_PATH" == *.css ]] || [[ "$FILE_PATH" == *.scss ]] || [[ "$FILE_PATH" == *.jsx ]] || [[ "$FILE_PATH" == *.tsx ]]; then
    echo "🎨 Design & UI Guidelines:"
    echo "- Follow existing component patterns"
    echo "- Ensure responsive design principles"
    echo "- Check theme consistency"
    echo "- Optimize for performance (bundle size)"
    echo "- Include proper ARIA labels"
elif [[ "$FILE_PATH" == *"workflow"* ]] || [[ "$FILE_PATH" == *"agent"* ]]; then
    echo "🤖 Agent/Workflow Design Guidelines:"
    echo "- Maintain clear agent boundaries"
    echo "- Follow orchestrator-worker pattern"
    echo "- Ensure proper error handling"
    echo "- Include monitoring hooks"
    echo "- Document communication flows"
fi

# Check if design review guidelines should be displayed
if [[ "$FILE_PATH" == *".md" ]] || [[ "$FILE_PATH" == *"design"* ]] || [[ "$FILE_PATH" == *"ui"* ]]; then
    echo ""
    echo "📖 Loading Design Review Guidelines..."
    if [ -f "/Volumes/SeagatePortableDrive/Projects/vivid_mas/documentation/04-development/design-review-guidelines.md" ]; then
        head -n 30 "/Volumes/SeagatePortableDrive/Projects/vivid_mas/documentation/04-development/design-review-guidelines.md"
    fi
fi

echo ""
echo "🔍 REMINDER: You are an AI assistant. Take time to:"
echo "- THINK through the optimization strategy"
echo "- REVIEW the existing codebase thoroughly"
echo "- PLAN the implementation carefully"
echo ""

# For critical files, we could potentially block with exit code 2
# For now, we'll allow but with strong warnings
if [ "$IS_CRITICAL" = true ]; then
    echo "⚠️  PROCEEDING WITH CRITICAL FILE - EXTRA CAUTION REQUIRED!"
fi

exit 0