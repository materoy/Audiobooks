import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerControlls extends StatefulWidget {
  const PlayerControlls(
      {Key? key, required this.controller, required this.iconColor, required this.iconSize})
      : super(key: key);
  final AlbumController controller;
  final Color iconColor;
  final double iconSize;

  @override
  _PlayerControllsState createState() => _PlayerControllsState();
}

class _PlayerControllsState extends State<PlayerControlls> {
  AlbumController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Rewind 10 secs button
        IconButton(
            onPressed: () async {
              await AudioService.seekBackward(true);
            },
            icon: Icon(
              Icons.replay_10_rounded,
              size: widget.iconSize - 5.0,
              color: widget.iconColor,
            )),

        /// Seek to next track button
        IconButton(
            onPressed: () => controller.goToPreviousTrack(),
            icon: Icon(
              Icons.fast_rewind_rounded,
              size: widget.iconSize,
              color: widget.iconColor,
            )),

        /// Play pause button
        Obx(() => controller.currentTrack.path != null
            ? StreamBuilder<PlaybackState>(
                stream: AudioService.playbackStateStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return PlayPauseButton(
                    audioFilePath: controller.currentTrack.path!,
                    size: widget.iconSize + 10.0,
                    playing: controller.playing,
                    color: widget.iconColor,
                    albumController: controller,
                    onPressed: () async {
                      if (snapshot.data!.playing) {
                        controller.onPause();
                      } else {
                        controller.onPlay();
                      }
                    },
                  );
                })
            : const CircularProgressIndicator.adaptive()),

        /// Next track button
        IconButton(
          onPressed: () => controller.goToNextTrack(),
          icon: Icon(Icons.fast_forward_rounded, size: widget.iconSize),
          color: widget.iconColor,
        ),

        /// Forward 10 seconds
        IconButton(
          onPressed: () async {
            await AudioService.seekForward(true);
          },
          icon: Icon(Icons.forward_10_rounded, size: widget.iconSize),
          color: widget.iconColor,
        ),
      ],
    );
  }
}
