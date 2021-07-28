import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/utils/logger.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerControlls extends StatefulWidget {
  const PlayerControlls({Key? key, required this.controller}) : super(key: key);
  final AlbumController controller;
  @override
  _PlayerControllsState createState() => _PlayerControllsState();
}

class _PlayerControllsState extends State<PlayerControlls> {
  AlbumController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4.0),
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical * 8.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.3),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () => controller.goToPreviousTrack(),
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 30,
                      color: Theme.of(context).iconTheme.color,
                    )),
                IconButton(
                    onPressed: () async {
                      await AudioService.seekBackward(true);
                    },
                    icon: Icon(
                      Icons.replay_10_rounded,
                      size: 30,
                      color: Theme.of(context).iconTheme.color,
                    )),
                Obx(() => controller.currentTrack.path != null
                    ? StreamBuilder<PlaybackState>(
                        stream: AudioService.playbackStateStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return PlayPauseButton(
                            audioFilePath: controller.currentTrack.path!,
                            size: 50,
                            playing: controller.playing,
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
                IconButton(
                  onPressed: () async {
                    await AudioService.seekForward(true);
                  },
                  icon: const Icon(Icons.forward_10_rounded, size: 30),
                  color: Theme.of(context).iconTheme.color,
                ),
                IconButton(
                  onPressed: () => controller.goToNextTrack(),
                  icon: const Icon(Icons.skip_next_rounded, size: 30),
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
