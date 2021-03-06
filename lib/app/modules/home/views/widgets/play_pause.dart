import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton(
      {Key? key,
      required this.audioFilePath,
      this.onPressed,
      this.size,
      this.child,
      this.playing,
      required this.color,
      required this.albumController})
      : super(key: key);

  final String audioFilePath;
  final VoidCallback? onPressed;
  final double? size;
  final Widget? child;
  final bool? playing;
  final Color color;
  final AlbumController albumController;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> with SingleTickerProviderStateMixin {
  late final AnimationController _playPauseAnimation;
  @override
  void initState() {
    super.initState();
    _playPauseAnimation =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    if (widget.playing != null && widget.playing!) {
      _playPauseAnimation.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.albumController.playing) {
      _playPauseAnimation.forward();
    } else {
      _playPauseAnimation.reverse();
    }
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
          Center(
            child: AnimatedIcon(
              progress: _playPauseAnimation,
              icon: AnimatedIcons.play_pause,
              size: widget.size,
              color: widget.color,
            ),
          ),
    );
  }
}
