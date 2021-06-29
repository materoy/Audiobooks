import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setFilePath('/path/to/file.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      child: const Center(child: Icon(CupertinoIcons.play)),
    );
  }
}
