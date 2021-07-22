import 'package:audiobooks/app/modules/shelf/views/widgets/album_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/shelf_controller.dart';

class ShelfView extends GetView<ShelfController> {
  @override
  Widget build(BuildContext context) {
    controller.onReady();
    return CupertinoPageScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: 'Library',
          backgroundColor: Colors.transparent,
        ),
        child: Material(
          child: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 4.5,
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemCount: controller.albums.length,
              itemBuilder: (context, index) {
                return AlbumCard(album: controller.albums[index]);
              })),
        ));
  }
}
