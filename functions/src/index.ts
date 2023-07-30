import * as functions from 'firebase-functions';
import * as cors from 'cors';
import * as express from 'express';
import axios, { AxiosError } from 'axios';

const app = express();

// Middleware to enable CORS
app.use(cors());

// Function to handle API requests
app.all('/api/*', async (req, res) => {
  try {
    const apiKey = 'RGAPI-40a346c6-d3f7-409d-9578-43091c321ad2';
    const baseUrl = 'https://na1.api.riotgames.com';
    const riotApiPath = req.url.replace('/api', ''); // Remove the "/api" prefix
    const url = `${baseUrl}${riotApiPath}`;

    let response;

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

    res.json(response.data);
  } catch (error) {
    if (axios.isAxiosError(error)) {
      const statusCode = error.response?.status || 500;
      const responseData = error.response?.data || { error: 'Unknown error' };
      return res.status(statusCode).json(responseData);
    }
    res.status(500).json({ error: 'Unknown error' });
  }
});

// Export the Cloud Function
export const proxy = functions.https.onRequest(app);