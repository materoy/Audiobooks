import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton(
      {Key? key,
      required this.audioFilePath,
      this.onPressed,
      this.size,
      this.child,
      this.playing})
      : super(key: key);

  final String audioFilePath;
  final VoidCallback? onPressed;
  final double? size;
  final Widget? child;
  final bool? playing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: child ??
          Center(
              child: Icon(
            AudioService.currentMediaItem != null &&
                    audioFilePath == AudioService.currentMediaItem!.id &&
                    AudioService.playbackState.playing
                ? Icons.pause_circle_outline_rounded
                : Icons.play_circle_fill_rounded,
            size: size ?? 40.0,
            color: const Color(0xFF2E429C),
          )),
    );
  }
}
