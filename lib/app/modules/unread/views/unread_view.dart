import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/unread_controller.dart';

class UnreadView extends GetView<UnreadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnreadView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UnreadView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
