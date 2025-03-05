#!/bin/bash

echo "🛑 Stopping MCP servers..."

stop_server() {
  if [ -f "$HOME/.claude-mcp/logs/$1.pid" ]; then
    PID=$(cat "$HOME/.claude-mcp/logs/$1.pid")
    if ps -p $PID > /dev/null; then
      kill $PID
      echo "✅ Stopped $2 server (PID: $PID)"
    else
      echo "⚠️ $2 server was not running"
    fi
    rm "$HOME/.claude-mcp/logs/$1.pid"
  else
    echo "⚠️ $2 server was not started"
  fi
}

stop_server "filesystem" "Filesystem"
stop_server "brave-search" "Brave Search"
stop_server "memory" "Memory"
stop_server "neon" "Neon Database"
stop_server "git" "Git"
stop_server "puppeteer" "Puppeteer"
stop_server "github" "GitHub"
stop_server "custom-prompts" "Custom Prompts"
stop_server "custom-tools" "Custom Tools"
stop_server "sequential-thinking" "Sequential Thinking"

echo "✅ All MCP servers stopped successfully!"