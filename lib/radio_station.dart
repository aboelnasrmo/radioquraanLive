import 'package:flutter/material.dart';
import 'package:radioquraan/playerWidget.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'model.dart';

class RadioStationsPage extends StatefulWidget {
  const RadioStationsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RadioStationsPageState createState() => _RadioStationsPageState();
}

class _RadioStationsPageState extends State<RadioStationsPage> {
  late Future<List<RadioStation>> _radioStationsFuture;
  late List<RadioStation> _searchResults;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _radioStationsFuture = fetchRadioStations();
    _searchResults = [];
  }

  Future<List<RadioStation>> fetchRadioStations() async {
    final response =
        await http.get(Uri.parse('https://mp3quran.net/api/v3/radios'));

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body)['radios'] as List<dynamic>;
      return jsonList.map((json) => RadioStation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load radio stations');
    }
  }

  List<RadioStation> _getSearchResults(
      String query, List<RadioStation> radioStations) {
    if (query.isEmpty) {
      return [];
    }

    final lowercaseQuery = query.toLowerCase();
    return radioStations
        .where((radioStation) =>
            radioStation.name.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: (query) async {
            final radioStations = await _radioStationsFuture;
            setState(() {
              _searchResults = _getSearchResults(query, radioStations);
            });
          },
        ),
      ),
      body: FutureBuilder<List<RadioStation>>(
        future: _radioStationsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final radioStations = snapshot.data!;
            final displayStations =
                _searchController.text.isEmpty ? radioStations : _searchResults;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: displayStations.length,
              itemBuilder: (context, index) {
                final radioStation = displayStations[index];
                return ListTile(
                  title: Text(radioStation.name),
                  onTap: () {
                    _onRadioStationSelected(radioStation);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load radio stations'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _onRadioStationSelected(RadioStation radioStation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerWidget(radioStation: radioStation),
      ),
    );
  }
}
