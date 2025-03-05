// mcp-prompts.js - MCP Prompt Examples and Implementation
const { Server } = require("@modelcontextprotocol/sdk/server");
const { 
  ListPromptsRequestSchema, 
  GetPromptRequestSchema 
} = require("@modelcontextprotocol/sdk/types");

// Define prompts for different use cases
const PROMPTS = {
  // Standard code analysis prompt
  "analyze-code": {
    name: "analyze-code",
    description: "Analyze code for potential improvements",
    arguments: [
      {
        name: "language",
        description: "Programming language",
        required: true
      },
      {
        name: "code",
        description: "Code to analyze",
        required: true
      }
    ]
  },
  
  // Git commit message generator
  "git-commit": {
    name: "git-commit",
    description: "Generate a Git commit message",
    arguments: [
      {
        name: "changes",
        description: "Git diff or description of changes",
        required: true
      }
    ]
  },
  
  // Code explanation prompt
  "explain-code": {
    name: "explain-code",
    description: "Explain how code works",
    arguments: [
      {
        name: "code",
        description: "Code to explain",
        required: true
      },
      {
        name: "language",
        description: "Programming language",
        required: false
      }
    ]
  },
  
  // Project analysis with logs and code
  "analyze-project": {
    name: "analyze-project",
    description: "Analyze project logs and code",
    arguments: [
      {
        name: "timeframe",
        description: "Time period to analyze logs",
        required: true
      },
      {
        name: "fileUri",
        description: "URI of code file to review",
        required: true
      }
    ]
  },
  
  // Debugging workflow
  "debug-error": {
    name: "debug-error",
    description: "Debug an error message with guided workflow",
    arguments: [
      {
        name: "error",
        description: "Error message or stack trace",
        required: true
      }
    ]
  }
};

// Create the MCP server
const server = new Server({
  name: "custom-prompts-server",
  version: "1.0.0"
}, {
  capabilities: {
    prompts: {}
  }
});

// List available prompts
server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: Object.values(PROMPTS)
  };
});

// Get specific prompt with arguments
server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  const prompt = PROMPTS[request.params.name];
  if (!prompt) {
    throw new Error(`Prompt not found: ${request.params.name}`);
  }

  // Handle different prompt types
  switch (request.params.name) {
    case "analyze-code":
      const codeLanguage = request.params.arguments?.language || "Unknown";
      return {
        description: `Analyze ${codeLanguage} code for potential improvements`,
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: `Please analyze the following ${codeLanguage} code for potential improvements:\n\n\`\`\`${codeLanguage}\n${request.params.arguments?.code}\n\`\`\``
            }
          }
        ]
      };
    
    case "git-commit":
      return {
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: `Generate a concise but descriptive commit message for these changes:\n\n${request.params.arguments?.changes}`
            }
          }
        ]
      };

    case "explain-code":
      const expLanguage = request.params.arguments?.language || "Unknown";
      return {
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: `Explain how this ${expLanguage} code works:\n\n${request.params.arguments?.code}`
            }
          }
        ]
      };
    
    case "analyze-project":
      return {
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: "Analyze these system logs and the code file for any issues:"
            }
          },
          {
            role: "user",
            content: {
              type: "resource",
              resource: {
                uri: `logs://recent?timeframe=${request.params.arguments?.timeframe}`,
                mimeType: "text/plain"
              }
            }
          },
          {
            role: "user",
            content: {
              type: "resource",
              resource: {
                uri: request.params.arguments?.fileUri,
                mimeType: "text/x-python" // Adjust based on file type
              }
            }
          }
        ]
      };
      
    case "debug-error":
      return {
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: `Here's an error I'm seeing: ${request.params.arguments?.error}`
            }
          },
          {
            role: "assistant",
            content: {
              type: "text",
              text: "I'll help analyze this error. What have you tried so far?"
            }
          },
          {
            role: "user",
            content: {
              type: "text",
              text: "I've tried restarting the service, but the error persists."
            }
          }
        ]
      };
    
    default:
      throw new Error("Prompt implementation not found");
  }
});

// Start the server
const port = process.env.PORT || 3010;
server.listen(port, () => {
  console.log(`Custom prompts server running on port ${port}`);
});

// Export for use in other modules
module.exports = { server, PROMPTS };
