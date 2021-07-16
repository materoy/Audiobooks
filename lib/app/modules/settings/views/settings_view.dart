import 'package:audiobooks/app/utils/media_scanner.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          OutlinedButton(
            onPressed: () => Get.toNamed(Routes.MEDIA_FOLDERS),
            child: const Text('Media folders'),
          ),
          if (kDebugMode) ...[
            ElevatedButton(
                onPressed: () =>
                    MediaScanner(Get.find<DatabaseController>().localDatabase)
                        .queryMediaFolders(),
                child: const Text('Query media Folders')),
            ElevatedButton(
                onPressed: () => Get.find<DatabaseController>()
                    .localDatabase
                    .resetDatabase(),
                child: const Text('Reset Db')),
            ElevatedButton(
                onPressed: () => Get.find<DatabaseController>()
                    .localDatabase
                    .initializeDatabaseSchema(),
                child: const Text('Initialize db schema')),
          ],
        ],
      )),
    );
  }
}
