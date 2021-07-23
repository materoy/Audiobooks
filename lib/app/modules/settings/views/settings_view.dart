import 'package:audiobooks/app/modules/media_folders/views/media_folders_view.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/media_scanner.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        previousPageTitle: 'Library',
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: Material(
          child: Column(
            children: [
              SettingsEntry(
                onPressed: () => MediaFoldersDialog.open(),
                child: const Text('Media folders'),
              ),
              SettingsEntry(
                onPressed: () => Get.toNamed(Routes.FEEDBACK),
                child: const Text('Feedback'),
              ),
              if (kDebugMode) ...[
                SettingsEntry(
                  onPressed: () =>
                      MediaScanner(Get.find<DatabaseController>().localDatabase)
                          .queryMediaFolders(),
                  child: const Text('Query media Folders'),
                ),
                SettingsEntry(
                  onPressed: () => Get.find<DatabaseController>()
                      .localDatabase
                      .resetDatabase(),
                  child: const Text('Reset Db'),
                ),
                SettingsEntry(
                  onPressed: () => Get.find<DatabaseController>()
                      .localDatabase
                      .initializeDatabaseSchema(),
                  child: const Text('Initialize db schema'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsEntry extends StatelessWidget {
  const SettingsEntry({Key? key, required this.child, required this.onPressed})
      : super(key: key);
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed,
          title: child,
          // shape: ,
          trailing: const Icon(CupertinoIcons.chevron_forward),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1.0,
          endIndent: 20.0,
          indent: 10.0,
        ),
      ],
    );
  }
}
