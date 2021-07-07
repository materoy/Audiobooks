import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/shelf_controller.dart';

class ShelfView extends GetView<ShelfController> {
  @override
  Widget build(BuildContext context) {
    controller.onReady();
    return CupertinoPageScaffold(child: Material());
  }
}
