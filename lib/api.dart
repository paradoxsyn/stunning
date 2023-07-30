import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchSummonerData(
    String summonerName, String apiKey) async {
  const baseUrl = 'https://na1.api.riotgames.com';
  const proxyUrl =
      'https://us-central1-stunning-1ee33.cloudfunctions.net/proxy/api';
  final endpoint = '/lol/summoner/v4/summoners/by-name/$summonerName';
  final url = Uri.parse(proxyUrl + endpoint);

  /*final headers = {
    'X-Riot-Token': apiKey,
    'Origin': 'https://developer.riotgames.com',
  };*/

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return json.decode(response.body);
  } else {
    // If the call was not successful, throw an error.
    throw Exception('Failed to load data');
  }
}
