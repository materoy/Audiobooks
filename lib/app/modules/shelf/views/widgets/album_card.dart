import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/shelf/controllers/shelf_controller.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlbumCard extends GetView<AlbumController> {
  AlbumCard({Key? key, required this.album}) : super(key: key);

  final Album album;

  final AudioController audioController = Get.find<AudioController>();

  final ShelfController _shelfController = Get.find<ShelfController>();

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
                  : Container(
                      color: Colors.black,
                    ),
            ),

            /// The [album] name
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              child: RichText(
                text: TextSpan(
                    text: album.albumName,
                    style: Theme.of(context).textTheme.bodyText1),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /// Author names
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              child: RichText(
                text: TextSpan(
                    text: album.albumAuthor,
                    style: Theme.of(context).textTheme.bodyText1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => controller.currentTrack.path != null
                    ? PlayPauseButton(
                        audioFilePath: controller.currentTrack.path!,
                        onPressed: () {
                          audioController.currentAlbumId =
                              controller.album.albumId!;
                          audioController.currentTrackId =
                              controller.currentTrack.trackId!;
                          controller.updateCurrentTrack(
                              controller.currentTrack.trackId!);
                        },
                        child: controller.currentTrack.path ==
                                    audioController.audioPath &&
                                audioController.playing
                            ? Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).buttonColor,
                                ),
                                child: const Icon(CupertinoIcons.pause_fill),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).buttonColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(_shelfController.shelf.shelfName ==
                                        'Recently added'
                                    ? 'Listen'
                                    : 'Continue'),
                              ),
                      )
                    : const CircularProgressIndicator.adaptive()),
                TextButton(onPressed: () {}, child: const Text('View'))
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
