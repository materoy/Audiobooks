import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/now_listening_controller.dart';

class NowListeningView extends GetView<NowListeningController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NowListeningView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'NowListeningView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
