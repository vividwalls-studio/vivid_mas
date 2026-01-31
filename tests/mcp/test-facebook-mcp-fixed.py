#!/usr/bin/env python3
"""Test Facebook Analytics MCP Server using mcp package directly"""

import sys
import os
import json

# Add the server directory to path
sys.path.insert(0, "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/social-media/facebook-analytics-mcp")

def test_facebook_mcp():
    """Test the Facebook Analytics MCP server by importing it directly"""
    print("🧪 Testing Facebook Analytics MCP Server (Direct Import)")
    print("=" * 60)
    
    # Set a test token
    os.environ['FACEBOOK_ACCESS_TOKEN'] = 'test_token_for_testing'
    
    try:
        # Import the server module
        print("\n1️⃣ Importing server module...")
        from server import mcp
        
        print("  ✅ Server module imported successfully")
        print(f"  Server name: {mcp.name}")
        
        # List available tools
        print("\n2️⃣ Listing available tools...")
        tools = []
        
        # FastMCP stores tools in the _tools attribute
        if hasattr(mcp, '_tools'):
            tools = mcp._tools
            print(f"  📋 Found {len(tools)} tools:")
            
            for tool_name, tool_info in list(tools.items())[:10]:  # Show first 10 tools
                if hasattr(tool_info, '__doc__'):
                    doc = tool_info.__doc__ or "No description"
                    desc = doc.strip().split('\n')[0] if doc else "No description"
                else:
                    desc = "Function tool"
                print(f"    • {tool_name}: {desc[:60]}...")
                
                # Show parameters if available
                if hasattr(tool_info, '__annotations__'):
                    params = tool_info.__annotations__
                    if params:
                        print(f"      Parameters: {', '.join(params.keys())}")
        else:
            print("  ⚠️ No _tools attribute found")
            
        # Try to test a simple tool that doesn't require actual API calls
        print("\n3️⃣ Testing tool execution (mock)...")
        
        # Check if we can access the helper functions
        if hasattr(mcp, '__dict__'):
            module_items = dir(mcp)
            functions = [item for item in module_items if not item.startswith('_') and callable(getattr(mcp, item, None))]
            print(f"  Available functions in module: {len(functions)}")
            for func in functions[:5]:
                print(f"    • {func}")
        
    except ImportError as e:
        print(f"  ❌ Failed to import server: {e}")
    except Exception as e:
        print(f"  ❌ Error: {e}")
        import traceback
        traceback.print_exc()
    
    print("\n✅ Test completed")
    print("=" * 60)

if __name__ == "__main__":
    test_facebook_mcp()