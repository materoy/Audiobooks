import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double? screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double topPadding;
  static double? bottomPadding;
  static double? longestSide;
  static double? shortestSide;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight / 100;
    topPadding = _mediaQueryData.padding.top;
    bottomPadding = _mediaQueryData.padding.bottom;
    longestSide = _mediaQueryData.size.longestSide;
    shortestSide = _mediaQueryData.size.shortestSide;
  }
}
