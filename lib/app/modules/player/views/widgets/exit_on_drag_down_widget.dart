import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExitOnDragDownWidget extends StatefulWidget {
  const ExitOnDragDownWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _ExitOnDragDownWidgetState createState() => _ExitOnDragDownWidgetState();
}

class _ExitOnDragDownWidgetState extends State<ExitOnDragDownWidget> {
  Offset _offset = Offset.zero;
  double _scale = 1;

  void updatePosition(double dy) {
    setState(() {
      _offset = Offset(0, dy);
    });
  }

  void resetPosition() {
    setState(() {
      _offset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _offset,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          updatePosition(details.globalPosition.dy);
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0.0) {
            Get.back();
          } else {
            resetPosition();
          }
        },
        onVerticalDragCancel: resetPosition,
        child: widget.child,
      ),
    );
  }
}
