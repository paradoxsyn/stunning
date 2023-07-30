import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchSummonerData(
    String summonerName, String apiKey) async {
  const baseUrl = 'https://na1.api.riotgames.com';
  final endpoint = '/lol/summoner/v4/summoners/by-name/$summonerName';
  final url = Uri.parse(baseUrl + endpoint);

  final headers = {
    'X-Riot-Token': apiKey,
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return json.decode(response.body);
  } else {
    // If the call was not successful, throw an error.
    throw Exception('Failed to load data');
  }
}
