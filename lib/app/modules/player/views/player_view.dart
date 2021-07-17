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
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: controller.album.albumArt != null
                      ? Image.memory(
                          controller.album.albumArt!,
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.softLight,
                        )
                      : GenerativeArt(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
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
                          ? Image.memory(controller.album.albumArt!)
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

                        return Row(
                          children: [
                            Text(
                                "${controller.tracks[index].discNumber ?? controller.tracks[index].trackNumber ?? index}"),
                            // Text(controller.)
                          ],
                        );
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () => controller.goToPreviousTrack(),
                            icon: const Icon(Icons.skip_previous_rounded,
                                size: 40)),
                        IconButton(
                            onPressed: () {
                              AudioService.skipToNext();
                              // audioController.updatePlayPosition(
                              //     newPosition: AudioService.playbackState
                              //             .currentPosition.inMilliseconds -
                              //         const Duration(seconds: 10).inMilliseconds);
                              // AudioService.seekBackward(begin)
                            },
                            icon:
                                const Icon(Icons.replay_10_rounded, size: 40)),
                        Obx(() => controller.currentTrack.path != null
                            ? StreamBuilder<PlaybackState>(
                                stream: AudioService.playbackStateStream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return Container();
                                  return PlayPauseButton(
                                    audioFilePath:
                                        controller.currentTrack.path!,
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
                            icon:
                                const Icon(Icons.forward_10_rounded, size: 40)),
                        IconButton(
                            onPressed: () => controller.goToNextTrack(),
                            icon:
                                const Icon(Icons.skip_next_rounded, size: 40)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
