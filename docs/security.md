# MCP Security: Handling API Tokens

When working with MCP servers that require API tokens (like GitHub, Brave Search, or Neon), it's important to handle these tokens securely:

## 1. Never commit actual tokens to GitHub

The repository contains placeholder values for all tokens:
- `YOUR_GITHUB_TOKEN` - For GitHub API access
- `YOUR_BRAVE_API_KEY` - For Brave Search API
- `YOUR_NEON_API_KEY` - For Neon API

## 2. Using tokens locally

There are several ways to use your actual tokens locally:

### Option 1: Create a local config file (recommended)
Create a local copy of the configuration that isn't tracked by git:

```bash
cp config/mcp-config.json ~/mcp-config.json
```

Then edit `~/mcp-config.json` to include your actual tokens.

### Option 2: Use environment variables

Use environment variables when starting servers:

```bash
GITHUB_PERSONAL_ACCESS_TOKEN="your_actual_token" \
BRAVE_API_KEY="your_brave_key" \
NEON_API_KEY="your_neon_key" \
./scripts/server/run-all-servers.sh
```

### Option 3: Modify the run-all-servers.sh script

You can edit `scripts/server/run-all-servers.sh` locally to include your tokens, but be careful not to commit these changes.

## 3. Creating API tokens

- **GitHub**: Create a Personal Access Token at GitHub → Settings → Developer settings → Personal access tokens
- **Brave Search**: Sign up for an API key at https://brave.com/search/api/
- **Neon**: Get an API key from your Neon account dashboard

## 4. Testing tokens

To verify your tokens are working correctly:

```bash
# For GitHub
./scripts/server/test-github.sh

# For Brave Search
./scripts/server/test-brave-search.sh
```
