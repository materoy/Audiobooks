import 'package:get/get.dart';

import '../controllers/now_listening_controller.dart';

class NowListeningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NowListeningController>(
      () => NowListeningController(),
    );
  }
}
