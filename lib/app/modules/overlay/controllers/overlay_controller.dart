import 'dart:developer';

import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/providers/album_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class OverlayController extends GetxController {
  late AlbumController albumController;
  late final AlbumProvider _albumProvider;

  final _currentAlbum = Album.empty().obs;
  Album get currentAlbum => _currentAlbum.value;

  Future<Album?> getCurrentPlayingAlbum() async {
    final int? albumId = await _albumProvider.getCurrentPlayingAlbum();
    if (albumId != null) {
      return _albumProvider.getAlbumById(albumId);
    }
  }

  Future<void> refreshAlbum() async {
    _currentAlbum.value = (await getCurrentPlayingAlbum())!;
    if (!Get.isRegistered<AlbumController>(tag: _currentAlbum.value.albumId.toString())) {
      albumController = Get.put(
          AlbumController(
              localDatabase: Get.find<DatabaseController>().localDatabase,
              album: _currentAlbum.value),
          tag: _currentAlbum.value.albumId.toString());
    } else {
      albumController = Get.find<AlbumController>(tag: _currentAlbum.value.albumId.toString());
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _albumProvider = AlbumProvider(Get.find<DatabaseController>().localDatabase);
  }

  @override
  Future onReady() async {
    super.onReady();

    Future.delayed(const Duration(seconds: 1), () async {
      _currentAlbum.value = await getCurrentPlayingAlbum() ?? Album.empty();

      if (_currentAlbum.value != Album.empty()) {
        albumController = Get.put(
            AlbumController(
              localDatabase: Get.find<DatabaseController>().localDatabase,
              album: _currentAlbum.value,
            ),
            tag: _currentAlbum.value.albumId.toString());
      }
      update();
    });
  }

  @override
  void onClose() {}
}
