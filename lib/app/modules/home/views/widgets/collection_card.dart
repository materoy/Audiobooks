import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/modules/home/controllers/collection_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/home_controller.dart';
import 'package:audiobooks/app/modules/home/views/widgets/play_pause.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coverage.dart';

class CollectionCard extends GetView<CollectionController> {
  CollectionCard({Key? key, required this.trackEntry}) : super(key: key);
  final TrackEntry trackEntry;

  final HomeController homeController = Get.find<HomeController>();

  @override
  CollectionController get controller => Get.put(
      CollectionController(
          localDatabase: homeController.localDatabase, trackEntry: trackEntry),
      tag: trackEntry.name);

  @override
  Widget build(BuildContext context) {
    // print(controller.tracks == null);

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
                    Obx(() => controller.currentTrack.path != null
                        ? PlayPauseButton(
                            trackId: controller.currentTrack.trackId!,
                            audioFilePath: controller.currentTrack.path!,
                            onPressed: () {
                              controller.updateCurrentTrack(
                                  controller.currentTrack.trackId!);
                            },
                          )
                        : const CircularProgressIndicator.adaptive()),
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
