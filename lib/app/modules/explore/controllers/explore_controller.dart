import 'package:audiobooks/app/modules/explore/providers/librivox_provider.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  LibrivoxProvider _librivoxProvider = LibrivoxProvider();

  @override
  void onInit() {
    super.onInit();
    _librivoxProvider.getFeed();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
