import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/player/views/widgets/audio_player_controlls.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';

import '../controllers/overlay_controller.dart';

class OverlayView extends GetView<OverlayController> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Obx(
          () => controller.currentAlbum == Album.empty()
              ? const SizedBox()
              : SizedBox(
                  // height: SizeConfig.blockSizeVertical * 16,
                  // height: 50.0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Material(
                        color: Colors.black12,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                        type: MaterialType.card,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockSizeVertical * 1.0,
                              horizontal: SizeConfig.blockSizeHorizontal * 5.0),
                          child: Column(
                            children: [
                              StreamBuilder<PlaybackState>(
                                stream: AudioService.playbackStateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              width: SizeConfig.blockSizeHorizontal * 82.0,
                                              height: SizeConfig.blockSizeVertical * 3,
                                              child: Text(
                                                controller.albumController.currentTrack.trackName ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            PlayPauseButton(
                                              audioFilePath:
                                                  controller.albumController.currentTrack.path!,
                                              color: Colors.black,
                                              size: 30,
                                              albumController: controller.albumController,
                                              playing: controller.albumController.playing,
                                              onPressed: () async {
                                                if (controller.albumController.playing) {
                                                  await controller.albumController.onPause();
                                                } else {
                                                  await controller.albumController.onPlay();
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        StreamBuilder(
                                            stream: AudioService.positionStream,
                                            builder: (context, AsyncSnapshot<Duration> snapshot) {
                                              if (snapshot.hasData) {
                                                return SeekBar(
                                                    onChanged: (value) {
                                                      AudioService.seekTo(value);
                                                    },
                                                    duration: Duration(
                                                        milliseconds: controller.albumController
                                                                .currentTrack.trackDuration ??
                                                            0),
                                                    position: snapshot.data!);
                                              }
                                              return Container();
                                            }),
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
