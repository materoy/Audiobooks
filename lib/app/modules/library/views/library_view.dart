import 'package:audiobooks/app/global/base_page.dart';
import 'package:audiobooks/app/modules/library/views/widgets/shelf_card.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/library_controller.dart';

class LibraryView extends GetView<LibraryController> {
  @override
  Widget build(BuildContext context) {
    controller.onReady();
    return BasePage(
      navigationBar: CupertinoNavigationBar(
        leading: Text(
          "Library",
          style: Theme.of(context).textTheme.headline5,
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Obx(() => ListView(
                children: [
                  ...List.generate(controller.shelves.length, (index) {
                    return ShelfCard(
                        shelf: controller.shelves[index],
                        onPressed: () =>
                            Get.toNamed(Routes.SHELF, arguments: controller.shelves[index]));
                  }),
                  // ShelfCard(
                  //     shelfName: 'New shelf',
                  //     shelfIcon: const Icon(Icons.menu_book_rounded),
                  //     onPressed: (value) =>
                  //         Get.toNamed(Routes.SHELF, arguments: value)),
                ],
              )),
        ),
      ),
    );
  }
}
