#!/bin/bash

# Create structured directory hierarchy for MCP runtime environment
mkdir -p ~/.claude-mcp/logs
mkdir -p ~/.claude-mcp/data
mkdir -p ~/.claude-mcp/config

# Set appropriate permissions on runtime directories
chmod 755 ~/.claude-mcp
chmod 755 ~/.claude-mcp/logs
chmod 755 ~/.claude-mcp/data
chmod 750 ~/.claude-mcp/config

echo "✅ MCP runtime directory structure initialized"
