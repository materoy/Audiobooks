import 'package:audiobooks/app/data/models/album.dart';
import 'package:get/get.dart';

import '../controllers/player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(
      () => PlayerController(album: Get.arguments as Album),
    );
  }
}
