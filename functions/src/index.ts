const { onRequest } = require("firebase-functions/v2/https");
const express = require('express');
const {
  log
} = require("firebase-functions/logger");
const axios = require("axios");

const app = express();

// Function to handle API requests
app.all('/api/*', async (req: any, res: any) => {
  try {
    const apiKey = 'RGAPI-a4ee5246-0f0e-4c89-8a8c-269e4155f767';
    const baseUrl = 'https://na1.api.riotgames.com';
    const riotApiPath = req.url.replace('/api', ''); // Remove the "/api" prefix
    const url = `${baseUrl}${riotApiPath}`;

    // Define a default response in case none of the switch cases match
    let response: any;

    log('GET response', response)
    log('GET req', req)
    log('GET url', url)
    log(res)

    switch (req.method) {
      case 'GET':
        response = await axios.get(url, {
          headers: {
            'X-Riot-Token': apiKey,
          },
        });
        break;
      case 'POST':
        response = await axios.post(url, req.body, {
          headers: {
            'X-Riot-Token': apiKey,
            'Content-Type': 'application/json',
          },
        });
        break;
      case 'PUT':
        response = await axios.put(url, req.body, {
          headers: {
            'X-Riot-Token': apiKey,
            'Content-Type': 'application/json',
          },
        });
        break;
      case 'DELETE':
        response = await axios.delete(url, {
          headers: {
            'X-Riot-Token': apiKey,
          },
        });
        break;
      default:
        return res.status(405).json({ error: 'Method not allowed' });
    }

    // Ensure that a response is returned in all cases
    res.json(response.data);
  } catch (error: any) {

      const statusCode = error.response?.status || 500;
      const responseData = error.response?.data || { error: 'Unknown error' };
      return res.status(statusCode).json(responseData);
  }
  return res.end();
});

// Export the Cloud Function
export const proxy = onRequest({ cors: true }, app);