import 'package:audiobooks/app/modules/home/views/widgets/tracks_list.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/modules/home/providers/media_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/tab_label.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF3C404B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Get.toNamed(Routes.MEDIA_FOLDERS),
                child: const Text('Media folders'),
              ),
              ElevatedButton(
                  onPressed: () => MediaScanner(controller.localDatabase)
                      .queryMediaFolders(),
                  child: const Text('Query media Folders')),
              ElevatedButton(
                  onPressed: () =>
                      MediaScanner(controller.localDatabase).getAudiobooks(),
                  child: const Text('Get abooks')),
              ElevatedButton(
                  onPressed: () =>
                      MediaScanner(controller.localDatabase).getCollection(),
                  child: const Text('Get collections')),
              ElevatedButton(
                  onPressed: () =>
                      MediaScanner(controller.localDatabase).getUnread(),
                  child: const Text('Get unread')),
              ElevatedButton(
                  onPressed: () => controller.localDatabase.resetDatabase(),
                  child: const Text('Reset Db')),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TabLabel(
                          label: 'Unread',
                          onPressed: () =>
                              controller.tabState = TabState.Unread,
                          selected: controller.tabState == TabState.Unread),
                      TabLabel(
                          label: 'Jump back in',
                          onPressed: () =>
                              controller.tabState = TabState.Reading,
                          selected: controller.tabState == TabState.Reading),
                      TabLabel(
                          label: 'Finished',
                          onPressed: () =>
                              controller.tabState = TabState.Finished,
                          selected: controller.tabState == TabState.Finished),
                    ],
                  )),
              Expanded(
                  child: PageView(
                controller: controller.pageController,
                onPageChanged: (value) {
                  switch (value) {
                    case 0:
                      controller.tabState = TabState.Unread;
                      break;
                    case 1:
                      controller.tabState = TabState.Reading;
                      break;
                    case 2:
                      controller.tabState = TabState.Finished;
                      break;
                    default:
                  }
                },
                children: [
                  TracksList(tracks: controller.unreadTracks),
                  TracksList(tracks: controller.nowReadingTracks),
                  TracksList(tracks: controller.finishedTracks),
                ],
              )),
            ],
          ),
        ));
  }
}
