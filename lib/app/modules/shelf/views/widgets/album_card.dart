import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlbumCard extends GetView<AlbumController> {
  AlbumCard({Key? key, required this.album}) : super(key: key);

  final Album album;

  final AudioController audioController = Get.find<AudioController>();

  @override
  AlbumController get controller => Get.put(
      AlbumController(
          localDatabase: Get.find<DatabaseController>().localDatabase,
          album: album),
      tag: album.albumId.toString());

  @override
  Widget build(BuildContext context) {
    controller.onReady();
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PLAYER, arguments: album),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: const Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 2,
            horizontal: SizeConfig.blockSizeHorizontal * 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 18,
              decoration: BoxDecoration(
                color: Colors.brown[50],
              ),
              child: album.albumArt != null
                  ? Image.memory(album.albumArt!, fit: BoxFit.cover)
                  : Container(),
            ),
            Flexible(
              child: RichText(
                text: TextSpan(text: album.albumName),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Center(
              child: Obx(() => controller.currentTrack.path != null
                  // ? PlayPauseButton(
                  //     audioFilePath: controller.currentTrack.path!,
                  //     onPressed: () {
                  //       audioController.currentAlbumId =
                  //           controller.album.albumId!;
                  //       audioController.currentTrackId =
                  //           controller.currentTrack.trackId!;
                  //       controller.updateCurrentTrack(
                  //           controller.currentTrack.trackId!);
                  //     },
                  //   )
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      child: const Text('Continue'),
                    )
                  : const CircularProgressIndicator.adaptive()),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
