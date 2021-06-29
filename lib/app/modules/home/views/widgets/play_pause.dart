import 'package:audiobooks/app/modules/home/controllers/audio_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlayPauseButton extends GetView<AudioController> {
  const PlayPauseButton({Key? key, required this.audioFilePath})
      : super(key: key);
  final String audioFilePath;

  @override
  Widget build(BuildContext context) {
    print(controller.playing);
    return GestureDetector(
      onTap: () => controller.playing
          ? controller.pause()
          : controller.play(audioFilePath),
      child: Center(
          child: Icon(!controller.playing
              ? Icons.play_circle_fill_rounded
              : Icons.pause_circle_outline_rounded)),
    );
  }
}
