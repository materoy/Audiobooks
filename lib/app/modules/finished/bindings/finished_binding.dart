import 'package:get/get.dart';

import '../controllers/finished_controller.dart';

class FinishedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinishedController>(
      () => FinishedController(),
    );
  }
}
