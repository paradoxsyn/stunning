import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<Map<String, dynamic>> fetchSummonerData(
    String summonerName, String apiKey) async {
  const baseUrl =
      'https://us-central1-stunning-1ee33.cloudfunctions.net/proxy/api';
  final endpoint = '/lol/summoner/v4/summoners/by-name/$summonerName';
  final url = Uri.parse(baseUrl + endpoint);
  final client = http.Client();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /*final headers = {
    'X-Riot-Token': apiKey,
    'Origin': 'https://developer.riotgames.com',
  };*/

  final response = await client.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    await analytics.logEvent(
      name: 'api_call',
      parameters: {'endpoint': endpoint, 'status': 'success'},
    );
    return json.decode(response.body);
  } else {
    // If the call was not successful, throw an error.
    throw Exception('Failed to load data');
  }
}
