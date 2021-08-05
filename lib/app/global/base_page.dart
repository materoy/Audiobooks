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
                    CupertinoTabBar(
                        currentIndex: getIndex(),
                        onTap: (value) {
                          switch (value) {
                            case 0:
                              if (getIndex() != 0) {
                                Get.offNamed(Routes.LIBRARY);
                              }
                              break;

                            // case 1:
                            //   if (getIndex() != 1) {
                            //     Get.toNamed(Routes.EXPLORE);
                            //   }
                            //   break;

                            case 1:
                              if (getIndex() != 1) {
                                Get.toNamed(Routes.SEARCH);
                              }
                              break;

                            case 2:
                              if (getIndex() != 2) {
                                Get.toNamed(Routes.SETTINGS);
                              }
                              break;
                            default:
                          }
                        },
                        backgroundColor: Colors.transparent,
                        items: const [
                          BottomNavigationBarItem(icon: Icon(CupertinoIcons.book)),
                          // BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded)),
                          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search)),
                          BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings_solid)),
                        ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  int getIndex() {
    switch (Get.currentRoute) {
      case Routes.LIBRARY:
        return 0;

      case Routes.EXPLORE:
        return 1;

      case Routes.SEARCH:
        return 2;

      case Routes.SETTINGS:
        return 3;

      default:
        return 0;
    }
  }
}
