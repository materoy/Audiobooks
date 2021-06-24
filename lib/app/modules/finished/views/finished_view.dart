import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/finished_controller.dart';

class FinishedView extends GetView<FinishedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinishedView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'FinishedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
