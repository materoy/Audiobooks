import 'package:get/get.dart';

import '../controllers/shelf_controller.dart';

class ShelfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShelfController>(
      () => ShelfController(shelfId: Get.arguments as int),
    );
  }
}
