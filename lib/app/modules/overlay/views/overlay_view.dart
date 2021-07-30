import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
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
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                        type: MaterialType.card,
                        child: Column(
                          children: [
                            StreamBuilder<PlaybackState>(
                              stream: AudioService.playbackStateStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.playing) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        width: SizeConfig.blockSizeHorizontal * 90,
                                        height: SizeConfig.blockSizeVertical * 3,
                                        child: MarqueeText(
                                          text: controller.albumController.currentTrack.trackName ??
                                              '',
                                          speed: 20.0,
                                        ),
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
                            PlayerControlls(
                              controller: controller.albumController,
                              iconColor: Colors.black54,
                              iconSize: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
