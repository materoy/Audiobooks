import 'dart:developer';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/library/controllers/library_controller.dart';
import 'package:audiobooks/app/modules/player/views/widgets/exit_on_drag_down_widget.dart';
import 'package:audiobooks/app/modules/player/views/widgets/generative_art.dart';
import 'package:audiobooks/app/modules/player/views/widgets/tracks_overlay.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            trailing: Material(
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () => TracksOverlay.show(context, controller.album.albumId!),
                    icon: const Icon(CupertinoIcons.chevron_down))),
          ),
          child: Material(
            child: Stack(
              children: [
                Opacity(
                  opacity: .8,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
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

                      Text(
                        controller.album.albumAuthor ??
                            controller.currentTrack.albumArtistName ??
                            controller.currentTrack.authorName ??
                            controller.currentTrack.trackArtistNames?.toList().first ??
                            "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),

                      /// The album art image
                      Container(
                        height: SizeConfig.blockSizeVertical * 40,
                        width: SizeConfig.blockSizeHorizontal * 88,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                        child: controller.album.albumArt != null
                            ? Image.memory(
                                controller.album.albumArt!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
                        child: Column(
                          children: List.generate(
                              controller.tracks.length < 4 ? controller.tracks.length : 4, (index) {
                            return Obx(() => RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text:
                                        "${controller.tracks[index].discNumber ?? controller.tracks[index].trackNumber ?? index}. ",
                                    style: TextStyle(
                                      color: controller.tracks[index].trackId ==
                                              controller.currentTrack.trackId
                                          ? Colors.blue
                                          : Colors.black,
                                      fontSize: 11.0,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller.tracks[index].trackName ?? '',
                                        style: TextStyle(
                                          color: AudioService.currentMediaItem != null &&
                                                  controller.tracks[index].path ==
                                                      AudioService.currentMediaItem!.id
                                              ? Colors.blue
                                              : Colors.black,
                                          fontSize: 11.0,
                                        ),
                                      )
                                    ])));
                          }),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() => IconButton(
                              onPressed: () async {
                                controller.liked
                                    ? await controller.unlikeAlbum()
                                    : await controller.likeAlbum();
                                await Get.find<LibraryController>().refreshShelves();
                              },
                              icon: Icon(
                                controller.liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                size: 40,
                                color: CupertinoColors.systemRed,
                              )))
                        ],
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
