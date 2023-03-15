import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:radioquraan/model.dart';

class PlayerWidget extends StatefulWidget {
  final RadioStation radioStation;

  const PlayerWidget({required this.radioStation, Key? key}) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late AudioPlayer _audioPlayer;
  late PlayerState _playerState;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playerState = PlayerState.STOPPED;
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _playerState = PlayerState.STOPPED;
    _audioPlayer.dispose();
    _playerStateSubscription.cancel();
  }

  void _play() async {
    await _audioPlayer.play(widget.radioStation.url);
  }

  void _pause() async {
    await _audioPlayer.pause();
  }

  void _stop() async {
    await _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.radioStation.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.radioStation.name),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: _playerState == PlayerState.PLAYING ||
                        _playerState == PlayerState.COMPLETED
                    ? null
                    : _play,
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: _playerState == PlayerState.PLAYING ? _pause : null,
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: _playerState == PlayerState.PLAYING ||
                        _playerState == PlayerState.PAUSED
                    ? _stop
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
