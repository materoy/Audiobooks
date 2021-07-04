import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/media_folders_controller.dart';

class MediaFoldersView extends GetView<MediaFoldersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select folder'),
        centerTitle: true,
      ),
      body: Obx(
        () => Center(
          child: controller.mediaFolders.isBlank!
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'There appears to be no audiobooks folders configured please add one',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () async {
                          final String? path = await controller.selectFolder();
                          print(path);
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Text('Select media folders')),
                  ],
                )
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ...List.generate(
                      controller.mediaFolders.length,
                      (index) => Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.blue.shade600,
                              width: 2.0,
                            )),
                            child: Text(controller.mediaFolders[index]),
                          )),
                  ElevatedButton(
                      onPressed: () async {
                        final String? path = await controller.selectFolder();
                        print(path);
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Add media folders')),
                ]),
        ),
      ),
    );
  }
}
