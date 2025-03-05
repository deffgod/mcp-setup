#!/bin/bash

# Apply execution permissions recursively to all shell scripts
find ~/Documents/GitHub/mcp-setup -name "*.sh" -type f -exec chmod +x {} \;

echo "✅ Execution permissions applied to all shell scripts"
