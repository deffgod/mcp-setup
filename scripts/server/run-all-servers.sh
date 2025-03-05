#!/bin/bash

echo "🚀 Starting MCP servers..."

# Create logs directory if it doesn't exist
mkdir -p ~/.claude-mcp/logs

# Start each server in the background
npx -y @modelcontextprotocol/server-filesystem "$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads" > ~/.claude-mcp/logs/filesystem.log 2>&1 &
echo $! > ~/.claude-mcp/logs/filesystem.pid

export BRAVE_API_KEY="YOUR_BRAVE_API_KEY"
npx -y @modelcontextprotocol/server-brave-search > ~/.claude-mcp/logs/brave-search.log 2>&1 &
echo $! > ~/.claude-mcp/logs/brave-search.pid

npx -y @modelcontextprotocol/server-memory > ~/.claude-mcp/logs/memory.log 2>&1 &
echo $! > ~/.claude-mcp/logs/memory.pid

export NEON_API_KEY="YOUR_NEON_API_KEY"
npx -y @smithery/cli > ~/.claude-mcp/logs/neon.log 2>&1 &
echo $! > ~/.claude-mcp/logs/neon.pid

python -m mcp_server_git --repository "$HOME/Documents/GitHub/servers" > ~/.claude-mcp/logs/git.log 2>&1 &
echo $! > ~/.claude-mcp/logs/git.pid

npx -y @modelcontextprotocol/server-puppeteer > ~/.claude-mcp/logs/puppeteer.log 2>&1 &
echo $! > ~/.claude-mcp/logs/puppeteer.pid

export GITHUB_PERSONAL_ACCESS_TOKEN="YOUR_GITHUB_TOKEN"
npx -y @modelcontextprotocol/server-github > ~/.claude-mcp/logs/github.log 2>&1 &
echo $! > ~/.claude-mcp/logs/github.pid

node "$HOME/Documents/GitHub/mcp-setup/servers/prompts/mcp-prompts.js" > ~/.claude-mcp/logs/custom-prompts.log 2>&1 &
echo $! > ~/.claude-mcp/logs/custom-prompts.pid

node "$HOME/Documents/GitHub/mcp-setup/servers/tools/mcp-tools.js" > ~/.claude-mcp/logs/custom-tools.log 2>&1 &
echo $! > ~/.claude-mcp/logs/custom-tools.pid

npx -y @modelcontextprotocol/server-sequential-thinking > ~/.claude-mcp/logs/sequential-thinking.log 2>&1 &
echo $! > ~/.claude-mcp/logs/sequential-thinking.pid

echo "✅ All MCP servers started successfully!"
echo "Logs are available in ~/.claude-mcp/logs/"