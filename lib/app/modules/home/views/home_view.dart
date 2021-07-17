import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shelf/views/widgets/albums_list.dart';
import '../controllers/home_controller.dart';
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
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TabLabel(
                          label: 'New',
                          onPressed: () async {
                            _pageController.jumpToPage(0);
                            // await _pageController.animateToPage(0,
                            // duration: const Duration(milliseconds: 300),
                            // curve: Curves.elasticIn);
                            controller.tabState = TabState.New;
                          },
                          selected: controller.tabState == TabState.New),
                      TabLabel(
                          label: 'Jump back in',
                          onPressed: () async {
                            _pageController.jumpToPage(1);
                            // await _pageController.animateToPage(1,
                            // duration: const Duration(milliseconds: 300),
                            // curve: Curves.elasticIn);
                            controller.tabState = TabState.NowListening;
                          },
                          selected:
                              controller.tabState == TabState.NowListening),
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
                      controller.tabState = TabState.New;
                      break;
                    case 1:
                      controller.tabState = TabState.NowListening;
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
