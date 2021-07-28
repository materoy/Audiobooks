import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/player/views/player_view.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/overlay_controller.dart';

class OverlayView extends GetView<OverlayController> {
  @override
  Widget build(BuildContext context) {
    return controller.currentAlbum == Album.empty()
        ? const SizedBox()
        : GetBuilder<OverlayController>(builder: (controller) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: SizeConfig.blockSizeVertical * 18,
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Text(controller.albumController.album.albumName,
                          style: const TextStyle(fontSize: 10)),
                      Text(controller.albumController.currentTrack.trackName!,
                          style: const TextStyle(fontSize: 10)),
                      StreamBuilder(
                          stream: AudioService.positionStream,
                          builder: (context, AsyncSnapshot<Duration> snapshot) {
                            if (snapshot.hasData) {
                              return SeekBar(
                                  onChanged: (value) {
                                    AudioService.seekTo(value);
                                  },
                                  onChangeEnd: (value) {
                                    // audioController.updatePlayPosition(
                                    //     newPosition: value.inMilliseconds);
                                  },
                                  duration: Duration(
                                      milliseconds: controller.albumController
                                          .currentTrack.trackDuration!),
                                  position: snapshot.data!);
                            }
                            return Container();
                          }),

                      PlayerControlls(controller: controller.albumController),
                      // PlayerControlls(controller: Ge)
                    ],
                  ),
                ),
              ),
            );
          });
  }
}
