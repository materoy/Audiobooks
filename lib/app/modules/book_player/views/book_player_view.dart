import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_player_controller.dart';

class BookPlayerView extends GetView<BookPlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BookPlayerView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'BookPlayerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
