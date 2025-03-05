# Model Context Protocol (MCP) Setup for Claude Desktop

This repository contains a comprehensive setup for integrating Claude Desktop with Model Context Protocol (MCP) servers, enabling bidirectional communication between Claude and various external systems and services through standardized API interfaces.

## Architecture Overview

The MCP integration architecture consists of a distributed network of microservices exposing standardized protocol interfaces that enable Claude to interact with:

- **File Systems**: Native file read/write operations across designated directories
- **Web Services**: Web search capabilities through the Brave Search API
- **Persistence Layer**: Stateful conversation memory with cross-session retention
- **Database Connectors**: PostgreSQL connectivity via Neon API
- **Version Control**: Git repository interactions via Python bridge
- **Browser Automation**: Headless browser control via Puppeteer
- **GitHub Integration**: Repository management via GitHub API
- **Custom Prompts**: Templatized prompt library with parameterized interfaces
- **Custom Tools**: High-performance utility functions for computation and data processing
- **Sequential Thinking**: Enhanced problem decomposition and reasoning capabilities

## Implementation Requirements

- Node.js v16.0+ (v18.0+ recommended for optimal performance)
- Python 3.8+ with pip
- Operating System: macOS, Linux, or Windows with WSL
- API Keys: Brave Search, Neon, GitHub (for respective integrations)
- Port availability: 3000-3010, 3200 (for service binding)

## Quick Start Guide

### 1. Initial Setup

To initialize the MCP environment, execute:

```bash
# Clone this repository
git clone https://github.com/yourusername/mcp-setup.git
cd mcp-setup

# Make the setup script executable
chmod +x make-all-executable.sh
./make-all-executable.sh

# Run the setup script
./setup-mcp.sh
```

### 2. Configuration

Update your Claude Desktop configuration with API keys:

```bash
# Edit the configuration file
nano ~/.config/claude-desktop/claude_desktop_config.json
```

Replace placeholder values with your actual API keys:
- `YOUR_BRAVE_API_KEY` → Your Brave Search API key
- `YOUR_NEON_API_KEY` → Your Neon database API key
- `YOUR_GITHUB_TOKEN` → Your GitHub Personal Access Token

### 3. Server Management

```bash
# Start all MCP servers
~/Documents/GitHub/mcp-setup/scripts/server/run-all-servers.sh

# Check server status
~/Documents/GitHub/mcp-setup/scripts/server/check-status.sh

# Test server connectivity
~/Documents/GitHub/mcp-setup/scripts/server/test-mcp.sh

# Stop all servers
~/Documents/GitHub/mcp-setup/scripts/server/stop-all-servers.sh
```

## Server Endpoints and Capabilities

### Filesystem Server
- **Port**: 3000
- **Endpoints**: 
  - `/health` - Server health check
  - `/api/files` - List files in a directory
  - `/api/read` - Read file content
  - `/api/write` - Write content to a file

### Brave Search Server
- **Port**: 3001
- **Endpoints**:
  - `/health` - Server health check
  - `/api/search` - Perform web search
  - `/api/local` - Perform local search

### Memory Server
- **Port**: 3002
- **Endpoints**:
  - `/health` - Server health check
  - `/api/memories` - List stored memories
  - `/api/store` - Store new memory
  - `/api/retrieve` - Retrieve specific memory

### Custom Prompts Server
- **Port**: 3010
- **Endpoints**:
  - `/api/prompts` - List available prompts
  - `/api/prompts/:id` - Get specific prompt

### Custom Tools Server
- **Port**: 3200
- **Endpoints**:
  - `/api/tools` - List available tools
  - `/api/health` - Server health check
  - `/api/calculate` - Calculate mathematical expressions
  - `/api/analyze-text` - Analyze text for statistics
  - `/api/parse-csv` - Parse CSV data
  - `/api/system-info` - Get system information

## Advanced Configuration

### Security Considerations

For production environments, consider implementing:

1. **API Key Rotation**: Establish a key rotation policy for all external service credentials
2. **Restricted File Access**: Limit filesystem server to specific directories
3. **TLS/SSL**: Implement HTTPS for all service endpoints
4. **Authentication**: Add authentication layer to custom services
5. **Request Validation**: Implement comprehensive input validation and sanitization

### Performance Optimization

For high-throughput environments:

1. **Connection Pooling**: Implement connection pooling for database connections
2. **Caching**: Add Redis caching layer for frequently accessed data
3. **Load Balancing**: Distribute service instances behind a load balancer
4. **Resource Limits**: Configure memory and CPU limits for each service
5. **Monitoring**: Implement Prometheus metrics for performance tracking

## Troubleshooting

### Common Issues

#### Port Conflicts
```
Error: listen EADDRINUSE: address already in use :::3000
```
**Solution**: Identify and stop the process using the port:
```bash
lsof -i :3000
kill -9 <PID>
```

#### API Key Authentication Failures
```
Error: Authentication failed for API request
```
**Solution**: Verify API key validity and proper environment variable configuration.

#### Filesystem Permissions
```
Error: EACCES: permission denied
```
**Solution**: Ensure proper read/write permissions for the target directories.

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
