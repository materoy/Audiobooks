import 'package:get/get.dart';

import '../controllers/media_folders_controller.dart';

class MediaFoldersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MediaFoldersController>(
      () => MediaFoldersController(),
    );
  }
}
