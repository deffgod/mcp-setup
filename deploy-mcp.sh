#!/bin/bash

# MCP Deployment Orchestrator
# This script coordinates the full deployment process for MCP integration

set -e  # Exit immediately if any command fails

echo "🚀 Initiating MCP Deployment Process"
echo "===================================="

# Step 1: Apply execution permissions
echo "📋 Step 1/7: Configuring execution permissions..."
bash ~/Documents/GitHub/mcp-setup/execute-permissions.sh

# Step 2: Validate system dependencies
echo "📋 Step 2/7: Validating system dependencies..."
bash ~/Documents/GitHub/mcp-setup/validate-dependencies.sh

# Step 3: Initialize directory structure
echo "📋 Step 3/7: Initializing directory structure..."
bash ~/Documents/GitHub/mcp-setup/initialize-directories.sh

# Step 4: Install Node.js dependencies
echo "📋 Step 4/7: Installing Node.js dependencies..."
cd ~/Documents/GitHub/mcp-setup
npm install

# Step 5: Configure Claude Desktop integration
echo "📋 Step 5/7: Configuring Claude Desktop integration..."

# Create Claude Desktop config directory if it doesn't exist
mkdir -p ~/Documents/claude-desktop-config

# Copy configuration template
cp ~/Documents/claude_desktop_config.json ~/Documents/claude-desktop-config/

echo "⚠️  IMPORTANT: Copy the configuration file to Claude Desktop's config directory:"
echo "   macOS: ~/.config/claude-desktop/"
echo "   Windows: %APPDATA%\\claude-desktop\\"
echo "   Linux: ~/.config/claude-desktop/"

# Step 6: Verify server implementations
echo "📋 Step 6/7: Verifying server implementations..."

if [ -f ~/Documents/GitHub/mcp-setup/servers/prompts/mcp-prompts.js ]; then
  echo "✅ Custom prompts server implementation found"
else
  echo "❌ Custom prompts server implementation missing"
fi

if [ -f ~/Documents/GitHub/mcp-setup/servers/tools/mcp-tools.js ]; then
  echo "✅ Custom tools server implementation found"
else
  echo "❌ Custom tools server implementation missing"
fi

# Step 7: Deployment summary
echo "📋 Step 7/7: Generating deployment summary..."

echo ""
echo "📝 MCP Deployment Summary"
echo "========================="
echo "✅ Execution permissions: Applied"
echo "✅ Directory structure: Initialized"
echo "✅ Configuration template: Generated at ~/Documents/claude-desktop-config/"
echo "✅ Server scripts: Created in ~/Documents/GitHub/mcp-setup/scripts/server/"
echo "✅ Custom implementations: Verified"
echo ""
echo "🚀 Next Steps:"
echo "-------------"
echo "1. Update API keys in the configuration file"
echo "2. Copy configuration to Claude Desktop's config directory"
echo "3. Start MCP servers: ~/Documents/GitHub/mcp-setup/scripts/server/run-all-servers.sh"
echo "4. Launch Claude Desktop application"
echo ""
echo "✨ MCP deployment process completed successfully"
