import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/audio_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/home_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coverage.dart';

class AlbumCard extends GetView<AlbumController> {
  AlbumCard({Key? key, required this.album}) : super(key: key);

  final Album album;
  final HomeController homeController = Get.find<HomeController>();

  final AudioController audioController = Get.find<AudioController>();

  @override
  AlbumController get controller => Get.put(
      AlbumController(
          localDatabase: homeController.localDatabase, album: album),
      tag: album.albumId.toString());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PLAYER),
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: SizeConfig.blockSizeVertical * 17,
        width: SizeConfig.blockSizeHorizontal * 80,
        decoration: BoxDecoration(
            color: const Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(20.0)),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 2,
            horizontal: SizeConfig.blockSizeHorizontal * 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal * 25,
              decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(13)),
            ),
            const Spacer(),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 35,
              child: Obx(() => Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(text: album.albumName),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      // Text(
                      //     trackEntry.name != null
                      //         ? trackEntry.name!.substring(0, 20)
                      //         : '',
                      //     textAlign: TextAlign.center),
                      const Spacer(),
                      if (controller.tracks.isNotEmpty)
                        ...List.generate(
                            controller.tracks.length > 3
                                ? 3
                                : controller.tracks.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      text: controller
                                                  .tracks[index].trackName !=
                                              null
                                          ? controller.tracks[index].trackName!
                                          : '',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              controller.currentTrack.trackId ==
                                                      controller
                                                          .tracks[index].trackId
                                                  ? Colors.blue
                                                  : Colors.black54),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      const Spacer(flex: 3),
                      SeekBar(
                          duration: audioController.audioDuration,
                          position: audioController.audioPlayer.position,
                          bufferedPosition:
                              audioController.audioPlayer.bufferedPosition),

                      const Spacer(),
                    ],
                  )),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Coverage(),
                      Obx(() => controller.currentTrack.path != null
                          ? PlayPauseButton(
                              audioFilePath: controller.currentTrack.path!,
                              onPressed: () {
                                controller.updateCurrentTrack(
                                    controller.currentTrack.trackId!);
                              },
                            )
                          : const CircularProgressIndicator.adaptive()),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
