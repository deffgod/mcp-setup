#!/bin/bash

echo "🔧 MCP Setup Script"
echo "===================="

# Step 1: Create required directories
echo "📁 Creating required directories..."
mkdir -p ~/.claude-mcp/logs
mkdir -p ~/.config/claude-desktop

# Step 2: Make server management scripts executable
echo "📜 Making server management scripts executable..."
chmod +x ~/Documents/GitHub/mcp-setup/scripts/server/*.sh

# Step 3: Install required dependencies
echo "📦 Installing dependencies..."
echo "This step requires npm to be installed."
echo "Press Enter to continue or Ctrl+C to abort..."
read

# Install Node.js dependencies
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-memory
npm install -g @smithery/cli
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-sequential-thinking

# Step 4: Copy configuration file
echo "⚙️ Setting up Claude Desktop configuration..."
cp ~/Documents/claude_desktop_config.json ~/.config/claude-desktop/

# Step 5: Final instructions
echo ""
echo "✅ MCP setup complete!"
echo ""
echo "🚀 To start the MCP servers, run:"
echo "   ~/Documents/GitHub/mcp-setup/scripts/server/run-all-servers.sh"
echo ""
echo "🔍 To check server status, run:"
echo "   ~/Documents/GitHub/mcp-setup/scripts/server/check-status.sh"
echo ""
echo "🛑 To stop the servers, run:"
echo "   ~/Documents/GitHub/mcp-setup/scripts/server/stop-all-servers.sh"
echo ""
echo "⚠️ Important: Before using the MCP servers with Claude Desktop,"
echo "   make sure to edit ~/.config/claude-desktop/claude_desktop_config.json"
echo "   and replace the placeholder API keys with your actual keys."
echo ""
echo "🔑 Required API keys:"
echo "   - BRAVE_API_KEY: For Brave Search"
echo "   - NEON_API_KEY: For Neon database"
echo "   - GITHUB_PERSONAL_ACCESS_TOKEN: For GitHub integration"