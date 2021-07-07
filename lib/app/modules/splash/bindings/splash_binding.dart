import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );

    Get.put(DatabaseController());

    Get.lazyPut<AudioController>(() => AudioController());
  }
}
