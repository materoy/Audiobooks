import 'dart:developer';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/library/controllers/library_controller.dart';
import 'package:audiobooks/app/modules/player/views/widgets/exit_on_drag_down_widget.dart';
import 'package:audiobooks/app/modules/player/views/widgets/generative_art.dart';
import 'package:audiobooks/app/modules/player/views/widgets/tracks_menu.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';

import 'widgets/audio_player_controlls.dart';

class PlayerView extends StatefulWidget {
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final AudioController audioController = Get.find<AudioController>();

  late final String id;
  AlbumController get controller => Get.find<AlbumController>(tag: id);

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      log(Get.arguments.toString());
      id = (Get.arguments as Album).albumId.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExitOnDragDownWidget(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: 'Shelf',
            backgroundColor: Colors.transparent,
            trailing:
                Material(color: Colors.transparent, child: TracksMenu(controller: controller)),
          ),
          child: Material(
            child: Stack(
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: controller.album.albumArt != null
                        ? Image.memory(
                            controller.album.albumArt!,
                            fit: BoxFit.cover,
                          )

                        /// Would not play in debug mode to save for some perfomance
                        : kDebugMode
                            ? null
                            : GenerativeArt(),
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Album Title
                      Text(
                        controller.album.albumName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),

                      /// The album art image
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 40,
                        width: SizeConfig.blockSizeHorizontal * 88,
                        child: controller.album.albumArt != null
                            ? Card(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 10.0,
                                shadowColor: Colors.black,
                                child: Image.memory(
                                  controller.album.albumArt!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(flex: 5),

                          /// Book author(s)
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 70,
                            child: Center(
                              child: MarqueeText(
                                text: controller.album.albumAuthor ??
                                    controller.currentTrack.albumArtistName ??
                                    controller.currentTrack.authorName ??
                                    controller.currentTrack.trackArtistNames?.toList().first ??
                                    "",
                                speed: 8.0,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),

                          /// Like button
                          Obx(() => IconButton(
                              onPressed: () async {
                                controller.liked
                                    ? await controller.unlikeAlbum()
                                    : await controller.likeAlbum();
                                await Get.find<LibraryController>().refreshShelves();
                              },
                              icon: Icon(
                                controller.liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                size: 30.0,
                                color: controller.liked ? CupertinoColors.systemRed : Colors.white,
                              ))),

                          const Spacer(),
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
                                  onChangeEnd: (value) {
                                    // audioController.updatePlayPosition(
                                    //     newPosition: value.inMilliseconds);
                                  },
                                  duration: Duration(
                                      milliseconds: controller.currentTrack.trackDuration!),
                                  position: snapshot.data!);
                            }
                            return Container();
                          }),

                      PlayerControlls(
                        controller: controller,
                        iconColor: Colors.white,
                        iconSize: 35.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
