// Test script to verify MCP tools functionality
const fetch = require('node-fetch');

async function testTools() {
  console.log('Testing MCP Custom Tools Server...');
  
  try {
    // Test listing tools
    console.log('\n1. Testing tools/list endpoint:');
    const listResponse = await fetch('http://localhost:3011/tools/list', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ method: 'tools/list' })
    });
    
    const listResult = await listResponse.json();
    console.log(`Found ${listResult.tools.length} tools:`);
    listResult.tools.forEach(t => console.log(`- ${t.name}: ${t.description}`));
    
    // Test calculating sum
    console.log('\n2. Testing calculate_sum tool:');
    const sumResponse = await fetch('http://localhost:3011/tools/call', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        method: 'tools/call',
        params: {
          name: 'calculate_sum',
          arguments: {
            a: 42,
            b: 58
          }
        }
      })
    });
    
    const sumResult = await sumResponse.json();
    console.log('Tool response:');
    console.log(sumResult.content[0].text);
    
    // Test math operations
    console.log('\n3. Testing calculate_math tool:');
    const mathResponse = await fetch('http://localhost:3011/tools/call', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        method: 'tools/call',
        params: {
          name: 'calculate_math',
          arguments: {
            operation: 'multiply',
            values: [2, 5, 10]
          }
        }
      })
    });
    
    const mathResult = await mathResponse.json();
    console.log('Tool response:');
    console.log(mathResult.content[0].text);
    
    console.log('\nTests completed successfully!');
  } catch (error) {
    console.error('Error testing tools:', error);
  }
}

// Run the tests
testTools();
