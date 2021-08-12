import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  PlayerController({required this.album});

  Album album;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<AlbumController>(tag: album.albumId.toString())) {
      Get.put(
          AlbumController(
              localDatabase: Get.find<DatabaseController>().localDatabase, album: album),
          tag: album.albumId.toString());
    }
  }
}
