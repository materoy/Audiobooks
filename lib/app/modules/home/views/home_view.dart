import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final audioPlayer = AudioPlayer().obs;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Player());
  }
}

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          IconButton(
              onPressed: () => audioPlayer.playing
                  ? audioPlayer.pause()
                  : audioPlayer.play(),
              icon: Icon(audioPlayer.playing
                  ? CupertinoIcons.pause
                  : CupertinoIcons.play))
        ],
      ),
    );
  }
}
