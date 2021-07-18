import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:get/get.dart';

import '../controllers/media_folders_controller.dart';

class MediaFoldersDialog extends GetView<MediaFoldersController> {
  static void open() {
    Get.lazyPut(() => MediaFoldersController());
    Get.dialog(MediaFoldersDialog());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Media folders'),
      content: Obx(
        () => controller.mediaFolders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5),
                    child: const Text(
                      'There appears to be no audiobooks folders configured please add one',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 4),
                ],
              )
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...List.generate(
                    controller.mediaFolders.length,
                    (index) => Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.blue.shade600,
                                width: 2.0,
                              )),
                          child:
                              Text(p.basename(controller.mediaFolders[index])),
                        )),
              ]),
      ),
      actions: [
        TextButton(
            onPressed: () async => controller.selectFolder(),
            child: const Text('Add folder')),
        TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFFA3434)),
            ))
      ],
    );
  }
}
