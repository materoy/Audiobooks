import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TracksMenu extends StatelessWidget {
  const TracksMenu({Key? key, required this.controller}) : super(key: key);

  final AlbumController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0,
      itemBuilder: (context) {
        return List.generate(
          controller.tracks.length,
          (index) => PopupMenuItem(
            child: ClipRRect(
              child: Obx(
                () => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "${controller.tracks[index].discNumber ?? controller.tracks[index].trackNumber ?? index}. ",
                      style: TextStyle(
                        color: controller.tracks[index].trackId == controller.currentTrack.trackId
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
                      ]),
                ),
              ),
            ),
          ),
        );
      },
      icon: const Icon(CupertinoIcons.chevron_down),
    );
  }
}
