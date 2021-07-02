import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/modules/home/providers/media_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/albums_list.dart';
import 'widgets/tab_label.dart';

class HomeView extends GetView<HomeController> {
  final PageController _pageController = PageController(initialPage: 1);
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
              // ElevatedButton(
              //     onPressed: () =>
              //         TrackProvider(controller.localDatabase).getAudiobooks(),
              //     child: const Text('Get abooks')),
              // ElevatedButton(
              //     onPressed: () =>
              //         TrackProvider(controller.localDatabase).getCollection(),
              //     child: const Text('Get collections')),
              // ElevatedButton(
              //     onPressed: () =>
              //         TrackProvider(controller.localDatabase).getUnread(),
              //     child: const Text('Get unread')),
              ElevatedButton(
                  onPressed: () => controller.localDatabase.resetDatabase(),
                  child: const Text('Reset Db')),
              ElevatedButton(
                  onPressed: () =>
                      controller.localDatabase.initializeDatabaseSchema(),
                  child: const Text('Initialize db schema')),
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
                          onPressed: () async {
                            _pageController.jumpToPage(0);
                            // await _pageController.animateToPage(0,
                            // duration: const Duration(milliseconds: 300),
                            // curve: Curves.elasticIn);
                            controller.tabState = TabState.Unread;
                          },
                          selected: controller.tabState == TabState.Unread),
                      TabLabel(
                          label: 'Jump back in',
                          onPressed: () async {
                            _pageController.jumpToPage(1);
                            // await _pageController.animateToPage(1,
                            // duration: const Duration(milliseconds: 300),
                            // curve: Curves.elasticIn);
                            controller.tabState = TabState.Reading;
                          },
                          selected: controller.tabState == TabState.Reading),
                      TabLabel(
                          label: 'Finished',
                          onPressed: () async {
                            _pageController.jumpToPage(2);
                            // await _pageController.animateToPage(2,
                            // duration: const Duration(milliseconds: 300),
                            // curve: Curves.elasticIn);
                            controller.tabState = TabState.Finished;
                          },
                          selected: controller.tabState == TabState.Finished),
                    ],
                  )),
              Expanded(
                  child: PageView(
                controller: _pageController,
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
                  AlbumsList(albums: controller.newAlbums),
                  AlbumsList(albums: controller.nowListeningAlbums),
                  AlbumsList(albums: controller.finishedAlbums),
                ],
              )),
            ],
          ),
        ));
  }
}
