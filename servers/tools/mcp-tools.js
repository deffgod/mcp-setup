/**
 * MCP Custom Tools Server
 * 
 * Provides specialized utility functions as REST endpoints accessible via 
 * Model Context Protocol. Implements comprehensive computational, analysis, 
 * and data processing capabilities.
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const port = 3200;

/**
 * Mathematical expression evaluator with comprehensive sanitization
 * @param {string} expression - Mathematical expression to evaluate
 * @returns {Object} - Result object with calculated value or error details
 */
function calculate(expression) {
  try {
    // Sanitize input to prevent code injection
    const sanitizedExpression = expression.replace(/[^0-9+\-*/.() ]/g, '');
    
    // Use Function constructor for isolated evaluation context
    return { 
      result: Function('"use strict";return (' + sanitizedExpression + ')')(),
      expression: expression
    };
  } catch (error) {
    return { 
      error: "Invalid expression", 
      details: error.message 
    };
  }
}

/**
 * Advanced text analyzer with NLP-inspired metrics
 * @param {string} text - Text content to analyze
 * @returns {Object} - Comprehensive text analysis metrics
 */
function analyzeText(text) {
  const words = text.trim().split(/\s+/);
  const sentences = text.match(/[^.!?]+[.!?]+/g) || [];
  const characters = text.length;
  const charactersNoSpaces = text.replace(/\s/g, '').length;
  
  // Calculate word frequencies with proper normalization
  const wordFrequency = {};
  words.forEach(word => {
    const normalizedWord = word.toLowerCase().replace(/[^\w']/g, '');
    if (normalizedWord) {
      wordFrequency[normalizedWord] = (wordFrequency[normalizedWord] || 0) + 1;
    }
  });
  
  // Identify top frequency words for keyword extraction
  const topWords = Object.entries(wordFrequency)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([word, count]) => ({ word, count }));
  
  // Calculate readability metrics (approximation)
  const averageWordLength = charactersNoSpaces / words.length || 0;
  const averageSentenceLength = words.length / sentences.length || 0;
  const readabilityScore = 206.835 - (1.015 * averageSentenceLength) - (84.6 * averageWordLength);
  
  return {
    stats: {
      characters,
      charactersNoSpaces,
      words: words.length,
      sentences: sentences.length,
      averageWordLength,
      averageSentenceLength,
      readabilityScore: Math.max(0, Math.min(100, readabilityScore))
    },
    topWords,
    summary: sentences.length > 3 ? sentences.slice(0, 3).join(' ') + '...' : text
  };
}

/**
 * CSV data parser with robust error handling and type conversion
 * @param {string} csvText - Raw CSV data
 * @returns {Object} - Structured data with headers and parsed rows
 */
function parseCSV(csvText) {
  try {
    const lines = csvText.trim().split('\n');
    const headers = lines[0].split(',').map(header => header.trim());
    
    const results = [];
    for (let i = 1; i < lines.length; i++) {
      // Handle potential quoted values with commas
      let inQuote = false;
      let currentValue = '';
      const values = [];
      
      for (let j = 0; j < lines[i].length; j++) {
        const char = lines[i][j];
        
        if (char === '"' && (j === 0 || lines[i][j-1] !== '\\')) {
          inQuote = !inQuote;
        } else if (char === ',' && !inQuote) {
          values.push(currentValue.trim());
          currentValue = '';
        } else {
          currentValue += char;
        }
      }
      
      // Add the last value
      values.push(currentValue.trim());
      
      if (values.length === headers.length) {
        const row = {};
        headers.forEach((header, index) => {
          // Intelligent type conversion
          const value = values[index];
          
          // Check if value is numeric
          if (!isNaN(value) && value !== '') {
            row[header] = Number(value);
          } 
          // Check if value is boolean
          else if (value.toLowerCase() === 'true' || value.toLowerCase() === 'false') {
            row[header] = value.toLowerCase() === 'true';
          }
          // Check if value is date
          else if (/^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2})?/.test(value)) {
            row[header] = new Date(value);
          }
          // Otherwise keep as string
          else {
            row[header] = value;
          }
        });
        results.push(row);
      }
    }
    
    return { 
      results, 
      headers,
      rowCount: results.length,
      columnCount: headers.length
    };
  } catch (error) {
    return { 
      error: "Failed to parse CSV", 
      details: error.message 
    };
  }
}

/**
 * System information collector
 * @returns {Object} - System metrics and configuration details
 */
function getSystemInfo() {
  try {
    const info = {
      platform: process.platform,
      architecture: process.arch,
      nodeVersion: process.version,
      memoryUsage: process.memoryUsage(),
      cpuUsage: process.cpuUsage(),
      uptime: process.uptime(),
      timestamp: new Date().toISOString()
    };
    
    // Add OS-specific information
    if (process.platform === 'linux') {
      try {
        info.distribution = execSync('cat /etc/*release | grep PRETTY_NAME').toString().split('=')[1].replace(/"/g, '').trim();
        info.cpuInfo = execSync('cat /proc/cpuinfo | grep "model name" | head -1').toString().split(':')[1].trim();
        info.memInfo = {
          total: parseInt(execSync('grep MemTotal /proc/meminfo').toString().split(':')[1].trim().split(' ')[0]),
          free: parseInt(execSync('grep MemFree /proc/meminfo').toString().split(':')[1].trim().split(' ')[0])
        };
      } catch (e) {
        info.osDetails = 'Could not retrieve detailed Linux information';
      }
    } else if (process.platform === 'darwin') {
      try {
        info.osVersion = execSync('sw_vers -productVersion').toString().trim();
        info.cpuInfo = execSync('sysctl -n machdep.cpu.brand_string').toString().trim();
        info.memInfo = {
          total: parseInt(execSync('sysctl -n hw.memsize').toString()) / (1024 * 1024),
          pageSize: parseInt(execSync('sysctl -n hw.pagesize').toString())
        };
      } catch (e) {
        info.osDetails = 'Could not retrieve detailed macOS information';
      }
    } else if (process.platform === 'win32') {
      try {
        info.osVersion = execSync('ver').toString().trim();
        info.computerName = process.env.COMPUTERNAME;
        info.username = process.env.USERNAME;
      } catch (e) {
        info.osDetails = 'Could not retrieve detailed Windows information';
      }
    }
    
    return info;
  } catch (error) {
    return { 
      error: "Could not retrieve system information", 
      details: error.message 
    };
  }
}

// Create the HTTP server with proper error handling
const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  
  // Enable CORS for client-side integration
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.statusCode = 204;
    res.end();
    return;
  }
  
  if (req.method === 'POST') {
    let body = '';
    
    // Collect request body chunks
    req.on('data', chunk => {
      body += chunk.toString();
    });
    
    // Process complete request
    req.on('end', () => {
      let data;
      try {
        data = JSON.parse(body);
      } catch (e) {
        res.statusCode = 400;
        res.end(JSON.stringify({ 
          error: 'Invalid JSON', 
          details: e.message 
        }));
        return;
      }
      
      // Route to appropriate handler based on endpoint
      if (req.url === '/api/calculate') {
        res.statusCode = 200;
        res.end(JSON.stringify(calculate(data.expression)));
        return;
      }
      
      if (req.url === '/api/analyze-text') {
        res.statusCode = 200;
        res.end(JSON.stringify(analyzeText(data.text)));
        return;
      }
      
      if (req.url === '/api/parse-csv') {
        res.statusCode = 200;
        res.end(JSON.stringify(parseCSV(data.csv)));
        return;
      }
      
      if (req.url === '/api/system-info') {
        res.statusCode = 200;
        res.end(JSON.stringify(getSystemInfo()));
        return;
      }
      
      // Handle unknown endpoints
      res.statusCode = 404;
      res.end(JSON.stringify({ 
        error: 'Tool not found',
        availableEndpoints: [
          '/api/calculate',
          '/api/analyze-text',
          '/api/parse-csv',
          '/api/system-info'
        ]
      }));
    });
  } else if (req.method === 'GET') {
    // List available tools
    if (req.url === '/api/tools' || req.url === '/api') {
      const tools = [
        { 
          id: 'calculate', 
          name: 'Calculator', 
          description: 'Perform mathematical calculations',
          endpoint: '/api/calculate',
          parameters: [
            { name: 'expression', type: 'string', description: 'Mathematical expression to evaluate' }
          ],
          example: '{"expression": "2 * (3 + 4) / 2"}'
        },
        { 
          id: 'analyze-text', 
          name: 'Text Analyzer', 
          description: 'Analyze text for statistics and insights',
          endpoint: '/api/analyze-text',
          parameters: [
            { name: 'text', type: 'string', description: 'Text content to analyze' }
          ],
          example: '{"text": "This is a sample text for analysis. It contains multiple sentences."}'
        },
        { 
          id: 'parse-csv', 
          name: 'CSV Parser', 
          description: 'Parse CSV data into structured format',
          endpoint: '/api/parse-csv',
          parameters: [
            { name: 'csv', type: 'string', description: 'CSV data to parse' }
          ],
          example: '{"csv": "Name,Age,City\\nJohn,30,New York\\nJane,25,San Francisco"}'
        },
        { 
          id: 'system-info', 
          name: 'System Information', 
          description: 'Get information about the system',
          endpoint: '/api/system-info',
          parameters: [],
          example: '{}'
        }
      ];
      
      res.statusCode = 200;
      res.end(JSON.stringify({
        service: 'MCP Custom Tools Server',
        version: '1.0.0',
        tools
      }));
      return;
    }
    
    // Health check endpoint
    if (req.url === '/health' || req.url === '/api/health') {
      res.statusCode = 200;
      res.end(JSON.stringify({ 
        status: 'ok',
        timestamp: new Date().toISOString()
      }));
      return;
    }
    
    // Handle unknown GET endpoints
    res.statusCode = 404;
    res.end(JSON.stringify({ 
      error: 'Endpoint not found',
      availableEndpoints: [
        '/api/tools',
        '/api/health'
      ]
    }));
  } else {
    // Handle unsupported HTTP methods
    res.statusCode = 405;
    res.end(JSON.stringify({ 
      error: 'Method not allowed',
      allowedMethods: ['GET', 'POST', 'OPTIONS']
    }));
  }
});

// Start the HTTP server with error handling
server.on('error', (error) => {
  console.error(`Server error: ${error.message}`);
  
  if (error.code === 'EADDRINUSE') {
    console.error(`Port ${port} is already in use. Please choose another port.`);
    process.exit(1);
  }
});

server.listen(port, 'localhost', () => {
  console.log(`Custom tools server running at http://localhost:${port}`);
  console.log('Available endpoints:');
  console.log('- GET /api/tools - List available tools');
  console.log('- GET /api/health - Health check');
  console.log('- POST /api/calculate - Calculate mathematical expressions');
  console.log('- POST /api/analyze-text - Analyze text for statistics');
  console.log('- POST /api/parse-csv - Parse CSV data');
  console.log('- POST /api/system-info - Get system information');
});