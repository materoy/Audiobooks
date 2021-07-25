import 'package:get/get.dart';

import '../controllers/overlay_controller.dart';

class OverlayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OverlayController>(
      () => OverlayController(),
    );
  }
}
