import 'package:get/get.dart';

import '../controllers/bottom_overlay_controller.dart';

class BottomOverlayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomOverlayController>(
      () => BottomOverlayController(),
    );
  }
}
