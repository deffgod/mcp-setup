#!/bin/bash

# Configuration Template Generator for MCP Integration
# This script generates a configuration template with sensible defaults

# Determine home directory consistently across platforms
HOME_DIR=$(eval echo ~${USER})

# Detect operating system for path normalization
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CONFIG_DIR="$HOME_DIR/.config/claude-desktop"
    SYSTEM="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    CONFIG_DIR="$HOME_DIR/.config/claude-desktop"
    SYSTEM="Linux"
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
    # Windows (using MSYS)
    CONFIG_DIR="$APPDATA/claude-desktop"
    SYSTEM="Windows"
else
    # Unknown system, fallback to sensible default
    CONFIG_DIR="$HOME_DIR/.config/claude-desktop"
    SYSTEM="Unknown"
fi

echo "🔧 Generating MCP configuration template for $SYSTEM"
echo "Target configuration directory: $CONFIG_DIR"

# Create config template with normalized paths
cat > ~/Documents/claude_desktop_config.json << EOL
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "$HOME_DIR/Desktop",
        "$HOME_DIR/Documents",
        "$HOME_DIR/Downloads"
      ]
    },
    "brave-search": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-brave-search"
      ],
      "env": {
        "BRAVE_API_KEY": "YOUR_BRAVE_API_KEY"
      }
    },
    "memory": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-memory"
      ]
    },
    "neon": {
      "command": "npx",
      "args": [
        "-y",
        "@smithery/cli"
      ],
      "env": {
        "NEON_API_KEY": "YOUR_NEON_API_KEY"
      }
    },
    "git": {
      "command": "python",
      "args": [
        "-m",
        "mcp_server_git",
        "--repository",
        "$HOME_DIR/Documents/GitHub/servers"
      ]
    },
    "puppeteer": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-puppeteer"
      ]
    },
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_TOKEN"
      }
    },
    "custom-prompts": {
      "command": "node",
      "args": [
        "$HOME_DIR/Documents/GitHub/mcp-setup/servers/prompts/mcp-prompts.js"
      ]
    },
    "custom-tools": {
      "command": "node",
      "args": [
        "$HOME_DIR/Documents/GitHub/mcp-setup/servers/tools/mcp-tools.js"
      ]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ]
    }
  }
}
EOL

echo "✅ Configuration template generated at ~/Documents/claude_desktop_config.json"
echo ""
echo "Next steps:"
echo "1. Edit the configuration file to add your API keys"
echo "2. Create the Claude Desktop configuration directory if it doesn't exist:"
echo "   mkdir -p \"$CONFIG_DIR\""
echo "3. Copy the configuration file to the Claude Desktop directory:"
echo "   cp ~/Documents/claude_desktop_config.json \"$CONFIG_DIR/\""
