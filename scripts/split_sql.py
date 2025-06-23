#!/usr/bin/env python3
"""Split large SQL file into smaller chunks for execution."""

import os
import re

def split_sql_file(input_file, output_dir='sql_chunks', chunk_size=500):
    """Split SQL file into smaller chunks."""
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    with open(input_file, 'r') as f:
        content = f.read()
    
    # Split by semicolons but keep the semicolons
    statements = content.split(';')
    
    # Clean up statements
    cleaned_statements = []
    for stmt in statements:
        stmt = stmt.strip()
        if stmt and not stmt.startswith('--'):
            cleaned_statements.append(stmt + ';')
    
    # Group statements into chunks
    chunks = []
    current_chunk = []
    current_size = 0
    
    for stmt in cleaned_statements:
        lines = stmt.count('\n') + 1
        if current_size + lines > chunk_size and current_chunk:
            chunks.append('\n\n'.join(current_chunk))
            current_chunk = [stmt]
            current_size = lines
        else:
            current_chunk.append(stmt)
            current_size += lines
    
    if current_chunk:
        chunks.append('\n\n'.join(current_chunk))
    
    # Write chunks to files
    for i, chunk in enumerate(chunks):
        chunk_file = os.path.join(output_dir, f'chunk_{i+1:03d}.sql')
        with open(chunk_file, 'w') as f:
            f.write(f"-- Chunk {i+1} of {len(chunks)}\n")
            f.write("BEGIN;\n\n")
            f.write(chunk)
            f.write("\n\nCOMMIT;")
        print(f"Created {chunk_file}")
    
    print(f"\nTotal chunks created: {len(chunks)}")
    return chunks

if __name__ == "__main__":
    input_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/populate_mas_complete.sql"
    split_sql_file(input_file)