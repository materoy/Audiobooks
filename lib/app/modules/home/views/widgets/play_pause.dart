import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlayPauseButton extends GetView<AudioController> {
  const PlayPauseButton(
      {Key? key, required this.audioFilePath, this.onPressed, this.size})
      : super(key: key);

  final String audioFilePath;
  final VoidCallback? onPressed;
  final double? size;
  // @override
  // String? get tag => entryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.playing
            ? controller.pause()
            : controller.play(audioFilePath);
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Center(
          child: Obx(() => Icon(
                controller.playing && controller.audioPath == audioFilePath
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_fill_rounded,
                size: size ?? 40.0,
                color: const Color(0xFF2E429C),
              ))),
    );
  }
}
