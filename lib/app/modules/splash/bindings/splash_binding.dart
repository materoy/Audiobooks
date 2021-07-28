import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/overlay/controllers/overlay_controller.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DatabaseController());

    Get.put<SplashController>(SplashController());

    Get.put<AudioController>(AudioController(), permanent: true);

    Get.put<OverlayController>(OverlayController(), permanent: true);
  }
}
