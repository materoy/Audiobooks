import 'package:get/get.dart';

import '../controllers/unread_controller.dart';

class UnreadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnreadController>(
      () => UnreadController(),
    );
  }
}
