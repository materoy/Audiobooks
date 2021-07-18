import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/modules/player/views/widgets/generative_art.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PlayerView extends GetView<AlbumController> {
  final AudioController audioController = Get.find<AudioController>();
  @override
  AlbumController get controller => Get.find<AlbumController>(
      tag: (Get.arguments as Album).albumId.toString());
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: 'Shelf',
          backgroundColor: Colors.transparent,
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
                          controller.currentTrack.trackArtistNames
                              ?.toList()
                              .first ??
                          "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),

                    /// The album art image
                    Container(
                      height: SizeConfig.blockSizeVertical * 35,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: controller.album.albumArt != null
                          ? Image.memory(
                              controller.album.albumArt!,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),

                    Column(
                      children: List.generate(
                          controller.tracks.length < 4
                              ? controller.tracks.length
                              : 4, (index) {
                        // final int currentTrackIndex = controller.tracks
                        //     .indexWhere((element) =>
                        //         element.trackId ==
                        //         controller.currentTrack.trackId);

                        return RichText(
                            text: TextSpan(
                                text:
                                    "${controller.tracks[index].discNumber ?? controller.tracks[index].trackNumber ?? index}. ",
                                children: [
                              TextSpan(
                                  text:
                                      controller.tracks[index].trackName ?? '')
                            ]));
                      }),
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
                                    milliseconds:
                                        controller.currentTrack.trackDuration!),
                                position: snapshot.data!);
                          }
                          return Container();
                        }),

                    PlayerControlls(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class PlayerControlls extends StatefulWidget {
  const PlayerControlls({Key? key, required this.controller}) : super(key: key);
  final AlbumController controller;
  @override
  _PlayerControllsState createState() => _PlayerControllsState();
}

class _PlayerControllsState extends State<PlayerControlls> {
  AlbumController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 4.0),
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical * 8.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.3),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () => controller.goToPreviousTrack(),
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 40,
                      color: Theme.of(context).iconTheme.color,
                    )),
                IconButton(
                    onPressed: () {
                      AudioService.seekBackward(true);
                      Future.delayed(const Duration(seconds: 2),
                          () => AudioService.seekBackward(false));
                    },
                    icon: Icon(
                      Icons.replay_10_rounded,
                      size: 40,
                      color: Theme.of(context).iconTheme.color,
                    )),
                Obx(() => controller.currentTrack.path != null
                    ? StreamBuilder<PlaybackState>(
                        stream: AudioService.playbackStateStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return PlayPauseButton(
                            audioFilePath: controller.currentTrack.path!,
                            size: 50,
                            playing: snapshot.data!.playing,
                            onPressed: () async {
                              if (snapshot.data!.playing) {
                                controller.onPause();
                              } else {
                                controller.onPlay();
                              }
                            },
                          );
                        })
                    : const CircularProgressIndicator.adaptive()),
                IconButton(
                  onPressed: () {
                    // AudioService.
                    // audioController.updatePlayPosition(
                    //     newPosition: AudioService.playbackState
                    //             .currentPosition.inMilliseconds +
                    //         const Duration(seconds: 10).inMilliseconds);
                  },
                  icon: const Icon(Icons.forward_10_rounded, size: 40),
                  color: Theme.of(context).iconTheme.color,
                ),
                IconButton(
                  onPressed: () => controller.goToNextTrack(),
                  icon: const Icon(Icons.skip_next_rounded, size: 40),
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
