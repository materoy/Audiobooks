import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/player_controller.dart';

class PlayerView extends GetView<PlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlayerView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PlayerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
