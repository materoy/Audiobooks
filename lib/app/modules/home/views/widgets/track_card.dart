import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/modules/home/controllers/audio_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/home_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/track_controller.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coverage.dart';
import 'play_pause.dart';

class TrackCard extends GetView<TrackController> {
  TrackCard({Key? key, required this.trackEntry}) : super(key: key);
  final TrackEntry trackEntry;

  final HomeController homeController = Get.find<HomeController>();

  @override
  TrackController get controller => Get.put(
      TrackController(
          localDatabase: homeController.localDatabase, trackEntry: trackEntry),
      tag: trackEntry.name);

  final AudioController audioController = Get.put(AudioController());

  @override
  Widget build(BuildContext context) {
    // print(trackEntry.name);
    return Container(
      clipBehavior: Clip.hardEdge,
      height: SizeConfig.blockSizeVertical * 17,
      width: SizeConfig.blockSizeHorizontal * 80,
      decoration: BoxDecoration(
          color: const Color(0xFFC4C4C4),
          borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 2,
          horizontal: SizeConfig.blockSizeHorizontal * 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 25,
            decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(13)),
          ),
          const Spacer(),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(trackEntry.name, textAlign: TextAlign.center)],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Coverage(),
                    PlayPauseButton(
                        audioFilePath: controller.singleTrack.path!),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
