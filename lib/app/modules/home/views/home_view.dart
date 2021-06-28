import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/media_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.onReady();
    // controller.localDatabase.resetDatabase();
    // MediaScanner(controller.localDatabase).queryMediaFolders();
    // MediaScanner(controller.localDatabase).getAudiobooks();
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: OutlinedButton(
            onPressed: () => Get.toNamed(Routes.MEDIA_FOLDERS),
            child: const Text('Media folders'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () =>
                    MediaScanner(controller.localDatabase).queryMediaFolders(),
                child: Text('Query media Folders')),
            ElevatedButton(
                onPressed: () =>
                    MediaScanner(controller.localDatabase).getAudiobooks(),
                child: Text('Get abooks')),
            ElevatedButton(
                onPressed: () => controller.localDatabase.resetDatabase(),
                child: Text('Reset Db')),
          ],
        ));
  }
}
