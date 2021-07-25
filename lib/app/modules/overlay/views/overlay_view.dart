import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/overlay_controller.dart';

class OverlayView extends GetView<OverlayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OverlayView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'OverlayView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
