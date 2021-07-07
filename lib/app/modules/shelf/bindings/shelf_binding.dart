import 'package:audiobooks/app/data/models/shelf.dart';
import 'package:get/get.dart';

import '../controllers/shelf_controller.dart';

class ShelfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShelfController>(
      () => ShelfController(shelf: Get.arguments as Shelf),
    );
  }
}
