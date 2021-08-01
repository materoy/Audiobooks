import 'package:audiobooks/app/modules/overlay/views/overlay_view.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasePage extends StatelessWidget {
  const BasePage(
      {Key? key, required this.child, required this.navigationBar, this.hasNavigationBar = true})
      : super(key: key);
  final Widget child;
  final bool hasNavigationBar;
  final ObstructingPreferredSizeWidget navigationBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoPageScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          navigationBar: navigationBar,
          child: Stack(
            children: [
              child,
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OverlayView(),
                  if (hasNavigationBar)
                    GetX<BasePageController>(
                      init: BasePageController(),
                      initState: (_) {},
                      builder: (_) {
                        return CupertinoTabBar(
                            currentIndex: _.currentIndex,
                            onTap: (value) {
                              switch (value) {
                                case 0:
                                  if (_.currentIndex != 0) {
                                    _.currentIndex = 0;
                                    Get.toNamed(Routes.LIBRARY);
                                  }
                                  break;

                                case 1:
                                  if (_.currentIndex != 1) {
                                    _.currentIndex = 1;
                                    Get.toNamed(Routes.SEARCH);
                                  }
                                  break;

                                case 2:
                                  if (_.currentIndex != 2) {
                                    _.currentIndex = 2;
                                    // Get.toNamed(Routes.LIBRARY);
                                  }
                                  break;

                                case 3:
                                  if (_.currentIndex != 3) {
                                    _.currentIndex = 3;
                                    Get.toNamed(Routes.SETTINGS);
                                  }
                                  break;
                                default:
                              }
                            },
                            backgroundColor: Colors.transparent,
                            items: const [
                              // BottomNavigationBarItem(icon: Icon(Icons.brows)),
                              BottomNavigationBarItem(icon: Icon(CupertinoIcons.book)),
                              BottomNavigationBarItem(icon: Icon(CupertinoIcons.search)),
                              BottomNavigationBarItem(icon: Icon(CupertinoIcons.bookmark)),
                              BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings_solid)),
                            ]);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BasePageController extends GetxController {
  final _currentIndex = 0.obs;
  set currentIndex(int value) => _currentIndex.value = value;
  int get currentIndex => _currentIndex.value;
}
