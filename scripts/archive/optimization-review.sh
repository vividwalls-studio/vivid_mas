#!/bin/bash

# This script enforces optimization review before code changes

echo "🔍 OPTIMIZATION REVIEW REQUIRED"
echo "================================"
echo ""
echo "Before generating code, you MUST:"
echo "1. Review existing codebase structure"
echo "2. Check for reusable components"
echo "3. Consider performance implications"
echo "4. Ensure proper error handling"
echo "5. Verify security best practices"
echo ""
echo "Reviewing optimization principles..."
echo ""

# Display the optimization principles
if [ -f "/Volumes/SeagatePortableDrive/Projects/vivid_mas/documentation/04-development/optimization-principles.md" ]; then
    cat "/Volumes/SeagatePortableDrive/Projects/vivid_mas/documentation/04-development/optimization-principles.md"
else
    echo "⚠️  WARNING: Optimization principles document not found!"
    echo "Create it at: /Volumes/SeagatePortableDrive/Projects/vivid_mas/documentation/04-development/optimization-principles.md"
fi

echo ""
echo "📋 CHECKLIST:"
echo "- [ ] Have you reviewed the existing codebase?"
echo "- [ ] Have you identified optimization opportunities?"
echo "- [ ] Have you considered performance implications?"
echo "- [ ] Have you planned for error handling?"
echo "- [ ] Have you verified security considerations?"
echo ""
echo "⚠️  IMPORTANT: Do not proceed without completing the optimization review!"
echo ""

# Return success to allow continuation, but the message serves as a strong reminder
exit 0