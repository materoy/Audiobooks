import 'package:get/get.dart';

import '../controllers/book_player_controller.dart';

class BookPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookPlayerController>(
      () => BookPlayerController(),
    );
  }
}
