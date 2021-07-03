import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/audio_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/modules/home/views/widgets/seek_bar.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PlayerView extends GetView<AlbumController> {
  final AudioController audioController = Get.find<AudioController>();
  @override
  AlbumController get controller => Get.find<AlbumController>(
      tag: (Get.arguments as Album).albumId.toString());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Album Title
        Text(
          controller.album.albumName,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),

        Text(
          controller.album.albumAuthor ??
              controller.currentTrack.albumArtistName ??
              controller.currentTrack.authorName ??
              controller.currentTrack.trackArtistNames!.toList().first!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),

        CircleAvatar(
          radius: SizeConfig.blockSizeHorizontal * 35,
        ),

        SeekBar(
            duration:
                Duration(milliseconds: controller.currentTrack.trackDuration!),
            position: Duration(
                milliseconds: controller.currentTrack.currentPosition ?? 0)),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_previous_rounded, size: 40)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.replay_10_rounded, size: 40)),
            PlayPauseButton(
              audioFilePath: controller.currentTrack.path!,
              size: 50,
              onPressed: () {
                audioController.currentAlbumId = controller.album.albumId!;
                audioController.currentTrackId =
                    controller.currentTrack.trackId!;
                controller.updateCurrentTrack(controller.currentTrack.trackId!);
              },
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.forward_10_rounded, size: 40)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_next_rounded, size: 40)),
          ],
        )
      ],
    ));
  }
}
