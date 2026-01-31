#!/usr/bin/env python3
"""Test Facebook Analytics MCP Server"""

import json
import subprocess
import time
import sys
import os

def test_facebook_mcp():
    """Test the Facebook Analytics MCP server"""
    print("🧪 Testing Facebook Analytics MCP Server")
    print("=" * 60)
    
    server_path = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/social-media/facebook-analytics-mcp"
    
    # Start the server process
    print("\n1️⃣ Starting server...")
    process = subprocess.Popen(
        [sys.executable, "server.py"],
        cwd=server_path,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env={**os.environ, "FACEBOOK_ACCESS_TOKEN": "test_token"}
    )
    
    # Send initialization message
    init_message = {
        "jsonrpc": "2.0",
        "method": "initialize",
        "params": {
            "protocolVersion": "1.0.0",
            "capabilities": {},
            "clientInfo": {
                "name": "test-client",
                "version": "1.0.0"
            }
        },
        "id": 1
    }
    
    print("2️⃣ Sending initialization...")
    process.stdin.write(json.dumps(init_message) + "\n")
    process.stdin.flush()
    
    # Send tools list request
    time.sleep(0.5)
    list_message = {
        "jsonrpc": "2.0",
        "method": "tools/list",
        "params": {},
        "id": 2
    }
    
    print("3️⃣ Requesting tool list...")
    process.stdin.write(json.dumps(list_message) + "\n")
    process.stdin.flush()
    
    # Read responses
    print("\n4️⃣ Reading responses...")
    time.sleep(1)
    
    try:
        # Read stdout
        process.stdin.close()
        stdout, stderr = process.communicate(timeout=2)
        
        if stderr:
            print(f"  📝 Server logs: {stderr[:200]}")
        
        if stdout:
            print("\n5️⃣ Parsing responses...")
            lines = stdout.strip().split('\n')
            for line in lines:
                if line.strip():
                    try:
                        response = json.loads(line)
                        if response.get('id') == 1:
                            print("  ✅ Initialization response received")
                            if 'result' in response:
                                print(f"    Server: {response['result'].get('serverInfo', {}).get('name', 'Unknown')}")
                                print(f"    Capabilities: {list(response['result'].get('capabilities', {}).keys())}")
                        elif response.get('id') == 2:
                            print("  ✅ Tools list received")
                            if 'result' in response and 'tools' in response['result']:
                                tools = response['result']['tools']
                                print(f"    Found {len(tools)} tools:")
                                for tool in tools[:5]:  # Show first 5 tools
                                    print(f"      • {tool.get('name')}: {tool.get('description', '')[:50]}...")
                    except json.JSONDecodeError:
                        pass
        else:
            print("  ⚠️ No stdout response received")
            
    except subprocess.TimeoutExpired:
        print("  ⏱️ Timeout waiting for response")
    except Exception as e:
        print(f"  ❌ Error: {e}")
    finally:
        process.terminate()
        process.wait()
    
    print("\n✅ Test completed")
    print("=" * 60)

if __name__ == "__main__":
    test_facebook_mcp()