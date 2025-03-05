#!/bin/bash

echo "🧪 Testing MCP server connections..."

# Helper function to test HTTP server
test_http_server() {
  local name=$1
  local url=$2
  local pattern=$3
  
  echo -n "Testing $name server... "
  
  # Send request with 3-second timeout
  response=$(curl -s -m 3 "$url" 2>/dev/null)
  
  if [ $? -eq 0 ] && echo "$response" | grep -q "$pattern"; then
    echo "✅ $name server is working"
    return 0
  else
    echo "❌ $name server is not working"
    return 1
  fi
}

# Test filesystem server
test_http_server "filesystem" "http://localhost:3000/health" "ok"

# Test brave-search server
test_http_server "brave-search" "http://localhost:3001/health" "ok"

# Test memory server
test_http_server "memory" "http://localhost:3002/health" "ok"

# Test neon server
test_http_server "neon" "http://localhost:3003/health" "ok"

# Test git server
test_http_server "git" "http://localhost:3004/health" "ok"

# Test puppeteer server
test_http_server "puppeteer" "http://localhost:3005/health" "ok"

# Test github server
test_http_server "github" "http://localhost:3006/health" "ok"

# Test custom-prompts server
test_http_server "custom-prompts" "http://localhost:3010/api/prompts" "analyze-code"

# Test custom-tools server
test_http_server "custom-tools" "http://localhost:3200/api/tools" "calculate"

# Test sequential-thinking server
test_http_server "sequential-thinking" "http://localhost:3007/health" "ok"

echo ""
echo "🔍 Testing complete!"
echo ""
echo "Note: If some servers are showing as not working, make sure they are running."
echo "You can start all servers with: ~/Documents/GitHub/mcp-setup/scripts/server/run-all-servers.sh"