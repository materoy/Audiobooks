import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bottom_overlay_controller.dart';

class BottomOverlayView extends GetView<BottomOverlayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BottomOverlayView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'BottomOverlayView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
