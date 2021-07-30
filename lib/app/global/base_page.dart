import 'package:audiobooks/app/modules/overlay/views/overlay_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    CupertinoTabBar(backgroundColor: Colors.transparent, items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.my_library_books_rounded)),
                      BottomNavigationBarItem(icon: Icon(CupertinoIcons.search)),
                      BottomNavigationBarItem(icon: Icon(CupertinoIcons.headphones)),
                      BottomNavigationBarItem(icon: Icon(CupertinoIcons.bookmark_fill)),
                    ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
