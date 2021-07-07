import 'package:get/get.dart';

class ShelfController extends GetxController {
  ShelfController({required this.shelfId});

  final int shelfId;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print(shelfId);
  }

  @override
  void onClose() {}
}
