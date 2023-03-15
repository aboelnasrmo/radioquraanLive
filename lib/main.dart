import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:radioquraan/radio_station.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  AudioPlayer? audioPlayer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Radio App',
      home: RadioStationsPage(),
    );
  }
}
