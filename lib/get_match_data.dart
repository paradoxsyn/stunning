import 'package:flutter/material.dart';
import 'api.dart';

class RiotApiExample extends StatelessWidget {
  final String apiKey =
      'YOUR_API_KEY'; // Replace 'YOUR_API_KEY' with your actual Riot API key
  final String summonerName =
      'SummonerName';

  const RiotApiExample({super.key}); // Replace this with the summoner name you want to look up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riot API Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final summonerData =
                  await fetchSummonerData(summonerName, apiKey);
              // Process the summonerData as needed
              print(summonerData);
            } catch (e) {
              print('Error: $e');
            }
          },
          child: const Text('Fetch Summoner Data'),
        ),
      ),
    );
  }
}
