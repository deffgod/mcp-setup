#!/bin/bash

# MCP Services Continuous Monitoring
# This script provides real-time monitoring of all MCP service processes

# ANSI color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define monitored services
SERVICES=(
  "filesystem"
  "brave-search"
  "memory"
  "neon"
  "git"
  "puppeteer"
  "github"
  "custom-prompts"
  "custom-tools"
  "sequential-thinking"
)

# Function to check service status
check_service() {
  local service=$1
  local pid_file="$HOME/.claude-mcp/logs/${service}.pid"
  
  if [ -f "$pid_file" ]; then
    local pid=$(cat "$pid_file")
    if ps -p $pid > /dev/null; then
      # Get memory and CPU usage
      local mem=$(ps -o rss= -p $pid | awk '{print $1/1024}')
      local cpu=$(ps -o %cpu= -p $pid | awk '{print $1}')
      echo -e "${GREEN}✓${NC} ${BLUE}${service}${NC} (PID: ${pid}) - Memory: ${mem:.1f}MB - CPU: ${cpu}%"
      return 0
    else
      echo -e "${RED}✗${NC} ${BLUE}${service}${NC} - Process died (PID was: ${pid})"
      return 1
    fi
  else
    echo -e "${RED}✗${NC} ${BLUE}${service}${NC} - Not started"
    return 1
  fi
}

# Function to check service endpoint
check_endpoint() {
  local service=$1
  local port=$2
  local endpoint=$3
  local pattern=$4
  
  # Skip endpoint check if service process is not running
  check_service $service > /dev/null
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  local response=$(curl -s -m 1 "http://localhost:${port}${endpoint}" 2>/dev/null)
  if [ $? -eq 0 ] && echo "$response" | grep -q "$pattern"; then
    echo -e "  ${GREEN}✓${NC} Endpoint: http://localhost:${port}${endpoint} - ${GREEN}Available${NC}"
    return 0
  else
    echo -e "  ${RED}✗${NC} Endpoint: http://localhost:${port}${endpoint} - ${RED}Unavailable${NC}"
    return 1
  fi
}

# Main monitoring loop
echo -e "${BLUE}MCP Services Monitoring${NC}"
echo -e "${BLUE}======================${NC}"

# Single run monitoring mode
if [ "$1" == "--once" ]; then
  echo -e "${YELLOW}Running single status check...${NC}"
  
  # Check each service
  check_service "filesystem"
  check_endpoint "filesystem" "3000" "/health" "ok"
  
  check_service "brave-search"
  check_endpoint "brave-search" "3001" "/health" "ok"
  
  check_service "memory"
  check_endpoint "memory" "3002" "/health" "ok"
  
  check_service "neon"
  check_endpoint "neon" "3003" "/health" "ok"
  
  check_service "git"
  check_endpoint "git" "3004" "/health" "ok"
  
  check_service "puppeteer"
  check_endpoint "puppeteer" "3005" "/health" "ok"
  
  check_service "github"
  check_endpoint "github" "3006" "/health" "ok"
  
  check_service "custom-prompts"
  check_endpoint "custom-prompts" "3010" "/api/prompts" "analyze-code"
  
  check_service "custom-tools"
  check_endpoint "custom-tools" "3200" "/api/tools" "calculate"
  
  check_service "sequential-thinking"
  check_endpoint "sequential-thinking" "3007" "/health" "ok"
  
  exit 0
fi

# Continuous monitoring mode
echo -e "${YELLOW}Starting continuous monitoring (Ctrl+C to exit)...${NC}"

while true; do
  clear
  echo -e "${BLUE}MCP Services Monitoring${NC} - $(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${BLUE}======================${NC}"
  
  # Check each service
  for service in "${SERVICES[@]}"; do
    check_service "$service"
  done
  
  echo -e "\n${YELLOW}Press Ctrl+C to exit monitoring${NC}"
  sleep 5
done
