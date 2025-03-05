#!/bin/bash

echo "🔍 Checking MCP server status..."

check_server() {
  if [ -f "$HOME/.claude-mcp/logs/$1.pid" ]; then
    PID=$(cat "$HOME/.claude-mcp/logs/$1.pid")
    if ps -p $PID > /dev/null; then
      echo "✅ $2 server is running (PID: $PID)"
    else
      echo "❌ $2 server is not running"
    fi
  else
    echo "❌ $2 server has not been started"
  fi
}

check_server "filesystem" "Filesystem"
check_server "brave-search" "Brave Search"
check_server "memory" "Memory"
check_server "neon" "Neon Database"
check_server "git" "Git"
check_server "puppeteer" "Puppeteer"
check_server "github" "GitHub"
check_server "custom-prompts" "Custom Prompts"
check_server "custom-tools" "Custom Tools"
check_server "sequential-thinking" "Sequential Thinking"

echo ""
echo "To view logs for a specific server:"
echo "cat ~/.claude-mcp/logs/<server-name>.log"