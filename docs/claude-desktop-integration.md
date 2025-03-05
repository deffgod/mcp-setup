# Claude Desktop Integration

This document describes how to integrate the Model Context Protocol (MCP) with desktop applications.

## Configuration

The desktop integration requires proper configuration of environment variables and dependencies.

### Environment Variables

Required environment variables:

```json
{
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "<REPLACE_WITH_YOUR_GITHUB_TOKEN>"
  }
}
```

### Dependencies

Make sure you have the following dependencies installed:

- Node.js 14+
- npm 6+
- Git

### Installation

1. Install the MCP package:
```bash
npm install @modelcontextprotocol/desktop
```

2. Configure your environment variables as shown above

3. Initialize the desktop integration:
```bash
npx mcp-desktop init
```

## Usage

The desktop integration provides several features:

1. File system access
2. Git integration
3. Custom tool execution
4. Desktop notifications

### File System Access

The MCP desktop integration provides secure access to the local file system:

```javascript
const { fs } = require('@modelcontextprotocol/desktop');

// Read a file
const content = await fs.readFile('path/to/file');

// Write a file
await fs.writeFile('path/to/file', content);
```

### Git Integration

Git operations are available through the desktop integration:

```javascript
const { git } = require('@modelcontextprotocol/desktop');

// Clone a repository
await git.clone('repository-url');

// Commit changes
await git.commit('commit message');
```

### Custom Tool Execution

Execute custom tools securely:

```javascript
const { tools } = require('@modelcontextprotocol/desktop');

// Execute a custom tool
const result = await tools.execute('tool-name', params);
```

### Desktop Notifications

Send desktop notifications:

```javascript
const { notify } = require('@modelcontextprotocol/desktop');

// Send a notification
await notify.send('Title', 'Message');
```

## Security Considerations

1. Always use environment variables for sensitive information
2. Never hardcode tokens or credentials
3. Use secure file system operations
4. Validate all inputs before execution

## Troubleshooting

Common issues and solutions:

1. Token not found
   - Check environment variables are set correctly
   - Verify token permissions

2. File access denied
   - Check file permissions
   - Verify path is correct

3. Git operations failing
   - Verify git is installed
   - Check repository permissions

## Support

For additional support:

1. Check the documentation
2. Open an issue on GitHub
3. Contact the support team
