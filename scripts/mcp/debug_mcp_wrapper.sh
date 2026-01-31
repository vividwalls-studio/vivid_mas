#!/bin/bash

# Debug wrapper for MCP servers
LOG_FILE="/tmp/mcp_debug_$(date +%s).log"

echo "=== MCP Debug Wrapper Started ===" >> "$LOG_FILE"
echo "Command: $0" >> "$LOG_FILE"
echo "Args: $@" >> "$LOG_FILE"
echo "PWD: $(pwd)" >> "$LOG_FILE"
echo "Environment:" >> "$LOG_FILE"
env | grep -E "(NODE|PATH|MCP)" >> "$LOG_FILE"

echo "=== Starting MCP Server ===" >> "$LOG_FILE"

# Execute the actual server and log all output
exec node "$@" 2>&1 | tee -a "$LOG_FILE"