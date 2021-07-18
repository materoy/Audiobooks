import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayPauseButton extends StatefulWidget {
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
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _playPauseAnimation;
  @override
  void initState() {
    super.initState();
    _playPauseAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.onPressed != null) {
          widget.onPressed!();
          if (AudioService.currentMediaItem != null &&
              widget.audioFilePath == AudioService.currentMediaItem!.id &&
              AudioService.playbackState.playing) {
            _playPauseAnimation.reverse();
          } else {
            _playPauseAnimation.forward();
          }
        }
      },
      child: widget.child ??
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue, width: 2.0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AnimatedIcon(
                progress: _playPauseAnimation,
                icon: AnimatedIcons.play_pause,
                size: 35.0,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
    );
  }
}
