import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/media_folders_controller.dart';

class MediaFoldersView extends GetView<MediaFoldersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MediaFoldersView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MediaFoldersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
