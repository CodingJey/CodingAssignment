import fetch from 'node-fetch';

async function downloadJsonData(apiUrls) {
  const combinedData = [];

  for (const apiUrl of apiUrls) {
    try {
      const response = await fetch(apiUrl, { timeout: 5000 }); // 5 seconds timeout

      if (!response.ok) {
        console.error(`API request failed for URL: ${apiUrl}`);
        console.error(`Status Code: ${response.status}`);
        const errorText = await response.text(); // Get error text from response if available
        console.error(`Error Body: ${errorText}`);
        continue; // Skip to the next URL
      }

      const jsonData = await response.json();
      combinedData.push(jsonData);
      console.log(`Successfully fetched data from: ${apiUrl}`);

    } catch (error) {
      console.error(`Error downloading data from URL: ${apiUrl}`);
      console.error(`Error details: ${error.message}`);
      continue; // Skip to the next URL
    }
  }

  return combinedData;
}

// Example usage:
async function main() {
  const urls = [
    'https://jsonplaceholder.typicode.com/todos/1', // Valid URL
    'https://jsonplaceholder.typicode.com/posts/1', // Another valid URL
    'https://rickandmortyapi.com/api/character/1', // Valid URL from another API
    'https://httpbin.org/status/404',          // URL that will return 404 error
    'https://non-existent-api.example.com',    // URL that will likely timeout or cause network error
    'https://api.publicapis.org/entries'        // Valid and larger JSON to test
  ];

  const allData = await downloadJsonData(urls);
  console.log('\nCombined JSON Data:');
  console.log(JSON.stringify(allData, null, 2)); // Pretty print the JSON output
}

main();