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
import 'package:marquee/marquee.dart';

class AlbumCard extends GetView<AlbumController> {
  const AlbumCard({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  AlbumController get controller => Get.put<AlbumController>(
      AlbumController(
          localDatabase: Get.find<DatabaseController>().localDatabase,
          album: album),
      tag: album.albumId.toString());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PLAYER, arguments: album),
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 33.0,
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

                /// The [album] name
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 10.0),
                    height: SizeConfig.blockSizeVertical * 3.0,
                    child: Marquee(
                      text: album.albumName,
                      style: Theme.of(context).textTheme.bodyText2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 100.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 4),
                      startPadding: 15.0,
                      accelerationDuration: const Duration(seconds: 2),
                      accelerationCurve: Curves.easeOut,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    )),

                if (album.albumAuthor != '')

                  // /// Author names
                  Container(
                    padding:
                        const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 8.0),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: album.albumAuthor,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 10)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ListenViewButton(
                    currenTrack: controller.currentTrack,
                    controler: controller),
                const Spacer(),
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
  const ListenViewButton(
      {Key? key, required this.currenTrack, required this.controler})
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).buttonColor,
                          ),
                          child: const Icon(CupertinoIcons.pause_fill),
                        )
                      : Container(
                          key: UniqueKey(),
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
                ),
              )
            : const CircularProgressIndicator.adaptive()),
        TextButton(onPressed: () {}, child: const Text('View'))
      ],
    );
  }
}
