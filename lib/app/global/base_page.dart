import 'package:audiobooks/app/modules/overlay/views/overlay_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key, required this.child, required this.navigationBar})
      : super(key: key);
  final Widget child;
  final ObstructingPreferredSizeWidget navigationBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoPageScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          navigationBar: navigationBar,
          child: child,
        ),
        OverlayView(),
      ],
    );
  }
}
