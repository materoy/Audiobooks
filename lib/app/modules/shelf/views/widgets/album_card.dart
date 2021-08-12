import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/data/models/track.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/shelf/controllers/shelf_controller.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';

class AlbumCard extends GetView<AlbumController> {
  const AlbumCard({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  AlbumController get controller => Get.put<AlbumController>(
      AlbumController(localDatabase: Get.find<DatabaseController>().localDatabase, album: album),
      tag: album.albumId.toString());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PLAYER, arguments: album),
      child: Column(
        children: [
          Container(
            // height: SizeConfig.blockSizeVertical * 33.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4), borderRadius: BorderRadius.circular(5.0)),
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 2,
                horizontal: SizeConfig.blockSizeHorizontal * 3),
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    /// The album art
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: double.infinity,
                      height: SizeConfig.blockSizeVertical * 20.0,
                      decoration: BoxDecoration(
                        color: Colors.brown[50],
                      ),
                      child: album.albumArt != null
                          ? Image.memory(album.albumArt!, fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey,
                              // child: ,
                            ),
                    ),

                    /// Play pause controlls overlay
                    Obx(() => controller.currentTrack.path != null
                        ? Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(color: Colors.white12, spreadRadius: 2.0, blurRadius: 4.0)
                            ], shape: BoxShape.circle),
                            child: IntrinsicWidth(
                              child: StreamBuilder<PlaybackState>(
                                  stream: AudioService.playbackStateStream,
                                  builder: (context, snapshot) {
                                    return PlayPauseButton(
                                      audioFilePath: controller.currentTrack.path!,
                                      color: Colors.black,
                                      size: 40,
                                      albumController: controller,
                                      onPressed: () async {
                                        if (controller.playing) {
                                          await controller.onPause();
                                        } else {
                                          await controller.onPlay();
                                        }
                                      },
                                    );
                                  }),
                            ),
                          )
                        : const SizedBox())
                  ],
                ),

                /// The [album] name
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  height: SizeConfig.blockSizeVertical * 3.0,
                  child: MarqueeText(
                    text: album.albumName,
                    style: Theme.of(context).textTheme.bodyText2,
                    speed: 7.0,
                  ),
                ),

                if (album.albumAuthor != '')

                  // /// Author names
                  Container(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 8.0),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: album.albumAuthor,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // ListenViewButton(currenTrack: controller.currentTrack, controler: controller),
                // const Spacer(),
              ],
            ),
          ),
          // SizedBox(
          //     height: SizeConfig.blockSizeVertical * 2,
          //     child: ),
        ],
      ),
    );
  }
}

class ListenViewButton extends StatefulWidget {
  const ListenViewButton({Key? key, required this.currenTrack, required this.controler})
      : super(key: key);
  final AlbumController controler;
  final Track currenTrack;
  @override
  _ListenViewButtonState createState() => _ListenViewButtonState();
}

class _ListenViewButtonState extends State<ListenViewButton> {
  final ShelfController _shelfController = Get.find<ShelfController>();
  AlbumController get controller => widget.controler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() => controller.currentTrack.path != null
            ? PlayPauseButton(
                audioFilePath: controller.currentTrack.path!,
                color: Colors.white,
                albumController: controller,
                onPressed: () async {
                  if (controller.playing) {
                    await controller.onPause();
                  } else {
                    await controller.onPlay();
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.ease,
                  switchOutCurve: Curves.ease,
                  child: controller.playing
                      ? Container(
                          key: UniqueKey(),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).buttonColor,
                          ),
                          child: const Icon(CupertinoIcons.pause_fill),
                        )
                      : Container(
                          key: UniqueKey(),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).buttonColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text(_shelfController.shelf.shelfName == 'Recently added'
                              ? 'Listen'
                              : 'Continue'),
                        ),
                ),
              )
            : const CircularProgressIndicator.adaptive()),
        TextButton(onPressed: () {}, child: const Text('View'))
      ],
    );
  }
}
