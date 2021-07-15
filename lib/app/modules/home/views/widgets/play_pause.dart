import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton(
      {Key? key,
      required this.audioFilePath,
      this.onPressed,
      this.size,
      this.child})
      : super(key: key);

  final String audioFilePath;
  final VoidCallback? onPressed;
  final double? size;
  final Widget? child;
  // @override
  // String? get tag => entryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // AudioServiceBackground.state.playing
        //     ? controller.pause()
        //     : controller.play(audioFilePath);
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: child ??
          Center(
              child: Obx(() => Icon(
                    AudioServiceBackground.state.playing &&
                            AudioServiceBackground.mediaItem != null &&
                            AudioServiceBackground.mediaItem?.id ==
                                audioFilePath
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_fill_rounded,
                    size: size ?? 40.0,
                    color: const Color(0xFF2E429C),
                  ))),
    );
  }
}
