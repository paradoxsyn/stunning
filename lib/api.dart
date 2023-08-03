import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchSummonerData(String summonerName) async {
  const baseUrl =
      'https://us-central1-stunning-1ee33.cloudfunctions.net/proxy/api';
  final endpoint = '/lol/summoner/v4/summoners/by-name/$summonerName';
  final url = Uri.parse(baseUrl + endpoint);
  final client = http.Client();

  final response = await client.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return json.decode(response.body);
  } else {
    // If the call was not successful, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<Map<String, dynamic>> fetchMatchlist(String encryptedAccountId) async {
  const baseUrl =
      'https://us-central1-stunning-1ee33.cloudfunctions.net/proxy/api';
  final endpoint =
      '/lol/match/v4/matchlists/by-account/$encryptedAccountId?endIndex=10';
  final url = Uri.parse(baseUrl + endpoint);
  final client = http.Client();

  final response = await client.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load matchlist');
  }
}

Future<Map<String, dynamic>> fetchMatchDetails(int matchId) async {
  const baseUrl =
      'https://us-central1-stunning-1ee33.cloudfunctions.net/proxy/api';
  final endpoint = '/lol/match/v4/matches/$matchId';
  final url = Uri.parse(baseUrl + endpoint);
  final client = http.Client();

  final response = await client.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load match details');
  }
}
