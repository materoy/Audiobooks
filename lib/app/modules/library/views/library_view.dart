import 'package:audiobooks/app/modules/library/views/widgets/shelf_card.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/library_controller.dart';

class LibraryView extends GetView<LibraryController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: const Text(
          "Library",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        trailing: Material(
          child: IconButton(
              onPressed: () => Get.toNamed(Routes.SETTINGS),
              icon: const Icon(CupertinoIcons.settings)),
        ),
      ),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => ListView(
                children: [
                  ...List.generate(controller.shelves.length, (index) {
                    return ShelfCard(
                        shelfName: controller.shelves[index + 1] ?? '',
                        number: 2,
                        shelfIcon: const Icon(Icons.menu_book_rounded),
                        onPressed: (value) => null);
                  }),
                  ShelfCard(
                      shelfName: 'New shelf',
                      number: 2,
                      shelfIcon: const Icon(Icons.menu_book_rounded),
                      onPressed: (value) => null),
                ],
              )),
        ),
      ),
    );
  }
}
