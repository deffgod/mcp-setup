#!/bin/bash

# MCP Management Interface
# Unified CLI for managing Model Context Protocol integration

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Clear screen
clear

# Display header
echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}   Model Context Protocol Management Console   ${NC}"
echo -e "${BLUE}===============================================${NC}"
echo

# Function to display menu
show_menu() {
    echo -e "${CYAN}Available Commands:${NC}"
    echo -e "${YELLOW}deploy${NC}    - Run complete deployment process"
    echo -e "${YELLOW}start${NC}     - Start all MCP servers"
    echo -e "${YELLOW}stop${NC}      - Stop all MCP servers"
    echo -e "${YELLOW}status${NC}    - Check server status"
    echo -e "${YELLOW}monitor${NC}   - Monitor servers in real-time"
    echo -e "${YELLOW}test${NC}      - Test server connectivity"
    echo -e "${YELLOW}config${NC}    - Generate configuration template"
    echo -e "${YELLOW}validate${NC}  - Validate system dependencies"
    echo -e "${YELLOW}help${NC}      - Show this help message"
    echo -e "${YELLOW}exit${NC}      - Exit management console"
    echo
}

# Function to execute commands
execute_command() {
    local cmd=$1
    case $cmd in
        "deploy")
            bash ~/Documents/GitHub/mcp-setup/deploy-mcp.sh
            ;;
        "start")
            echo -e "${BLUE}Starting MCP servers...${NC}"
            bash ~/Documents/GitHub/mcp-setup/scripts/server/run-all-servers.sh
            ;;
        "stop")
            echo -e "${BLUE}Stopping MCP servers...${NC}"
            bash ~/Documents/GitHub/mcp-setup/scripts/server/stop-all-servers.sh
            ;;
        "status")
            echo -e "${BLUE}Checking server status...${NC}"
            bash ~/Documents/GitHub/mcp-setup/scripts/server/check-status.sh
            ;;
        "monitor")
            echo -e "${BLUE}Starting monitoring...${NC}"
            bash ~/Documents/GitHub/mcp-setup/monitor-services.sh
            # After exiting monitoring, show menu again
            show_menu
            ;;
        "test")
            echo -e "${BLUE}Testing server connectivity...${NC}"
            bash ~/Documents/GitHub/mcp-setup/scripts/server/test-mcp.sh
            ;;
        "config")
            echo -e "${BLUE}Generating configuration template...${NC}"
            bash ~/Documents/GitHub/mcp-setup/generate-config.sh
            ;;
        "validate")
            echo -e "${BLUE}Validating system dependencies...${NC}"
            bash ~/Documents/GitHub/mcp-setup/validate-dependencies.sh
            ;;
        "help")
            show_menu
            ;;
        "exit")
            echo -e "${GREEN}Exiting management console. Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown command '${cmd}'${NC}"
            show_menu
            ;;
    esac
}

# Interactive mode
if [ $# -eq 0 ]; then
    show_menu
    
    while true; do
        echo -e "${CYAN}Enter command:${NC} \c"
        read cmd
        execute_command "$cmd"
        echo
    done
else
    # Command-line mode
    execute_command "$1"
fi
