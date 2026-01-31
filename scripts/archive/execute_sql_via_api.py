#!/usr/bin/env python3
"""Execute SQL chunks via Supabase API."""

import os
import sys
import time

print("=" * 60)
print("SQL EXECUTION INSTRUCTIONS")
print("=" * 60)
print()
print("The MCP Supabase server has limitations with executing large SQL scripts.")
print("To populate your database with the agent data, please follow these steps:")
print()
print("1. Open your Supabase Dashboard at: https://supabase.vividwalls.blog")
print()
print("2. Navigate to the SQL Editor (usually in the left sidebar)")
print()
print("3. Execute the SQL chunks in order:")
print()

# List the chunks
chunks_dir = "sql_chunks"
if os.path.exists(chunks_dir):
    chunks = sorted([f for f in os.listdir(chunks_dir) if f.endswith('.sql')])
    for i, chunk in enumerate(chunks, 1):
        chunk_path = os.path.join(chunks_dir, chunk)
        print(f"   {i}. Open and execute: {chunk_path}")
        
        # Get line count to give an idea of size
        with open(chunk_path, 'r') as f:
            lines = len(f.readlines())
        print(f"      (Contains ~{lines} lines)")
    print()
    print("4. Each chunk is wrapped in a transaction (BEGIN/COMMIT) for safety")
    print()
    print("5. After execution, verify with:")
    print("   SELECT COUNT(*) FROM agents;")
    print("   -- Should return 30")
    print()
else:
    print("Error: sql_chunks directory not found!")
    print("Please run split_sql.py first to create the chunks.")

print("=" * 60)
print()
print("Alternative: Execute the complete file at once")
print("If your SQL editor can handle large files:")
print("- Open scripts/populate_mas_complete.sql")
print("- Execute the entire script")
print()
print("Note: The script will DELETE existing agent data before inserting new data.")
print("If you want to preserve existing data, edit the script to comment out DELETE statements.")
print()
print("=" * 60)