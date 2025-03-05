#!/bin/bash

echo "🔍 Validating system dependencies..."

# Function to check for command presence
check_dependency() {
  if command -v $1 >/dev/null 2>&1; then
    echo "✅ $2 is installed: $(command -v $1)"
    return 0
  else
    echo "❌ $2 is not installed"
    return 1
  fi
}

# Required system dependencies
check_dependency "node" "Node.js"
check_dependency "npm" "NPM"
check_dependency "python3" "Python 3"
check_dependency "pip3" "PIP"
check_dependency "curl" "cURL"

# Check Node.js version
if command -v node >/dev/null 2>&1; then
  node_version=$(node -v | cut -d 'v' -f 2)
  node_major=$(echo $node_version | cut -d '.' -f 1)
  
  if [ $node_major -ge 16 ]; then
    echo "✅ Node.js version $node_version is compatible"
  else
    echo "❌ Node.js version $node_version is below minimum required (v16.0+)"
  fi
fi

# Check Python version
if command -v python3 >/dev/null 2>&1; then
  python_version=$(python3 --version | cut -d ' ' -f 2)
  python_major=$(echo $python_version | cut -d '.' -f 1)
  python_minor=$(echo $python_version | cut -d '.' -f 2)
  
  if [ $python_major -ge 3 ] && [ $python_minor -ge 8 ]; then
    echo "✅ Python version $python_version is compatible"
  else
    echo "❌ Python version $python_version is below minimum required (3.8+)"
  fi
fi

echo "Dependency validation complete."
