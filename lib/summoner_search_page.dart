import 'package:flutter/material.dart';
import 'api.dart';

class SummonerSearchPage extends StatefulWidget {
  const SummonerSearchPage({super.key});

  @override
  SummonerSearchPageState createState() => SummonerSearchPageState();
}

class SummonerSearchPageState extends State<SummonerSearchPage> {
  final String apiKey = 'RGAPI-40a346c6-d3f7-409d-9578-43091c321ad2';
  final TextEditingController _summonerController = TextEditingController();
  Map<String, dynamic> _summonerData = {};

  void _searchSummoner() async {
    final summonerName = _summonerController.text;

    try {
      final summonerData = await fetchSummonerData(summonerName, apiKey);
      setState(() {
        _summonerData = summonerData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summoner Search'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _summonerController,
                decoration: const InputDecoration(
                  labelText: 'Enter Summoner Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _searchSummoner,
                child: const Text('Search'),
              ),
              const SizedBox(height: 16.0),
              if (_summonerData.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Summoner ID: ${_summonerData['id']}'),
                    Text('Summoner Name: ${_summonerData['name']}'),
                    Text('Summoner Level: ${_summonerData['summonerLevel']}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
