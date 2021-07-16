import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/data/models/shelf.dart';
import 'package:audiobooks/app/modules/shelf/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class ShelfController extends GetxController {
  ShelfController({required this.shelf});
  ShelfProvider get _shelfProvider =>
      ShelfProvider(database: Get.find<DatabaseController>().localDatabase);

  final Shelf shelf;

  final _albums = List<Album>.empty(growable: true).obs;

  set albums(List<Album> value) => _albums.addAll(value);
  List<Album> get albums => _albums;

  Future<void> moveFromRecentlyAddedToListening({
    required int currentAlbumId,
  }) async {
    final ShelfProvider shelfProvider =
        ShelfProvider(database: Get.find<DatabaseController>().localDatabase);

    shelfProvider.moveAlbumToAnotherShelf(
        fromShelfId: shelf.shelfId,
        toShelfName: 'Listening',
        albumId: currentAlbumId);
  }

  @override
  Future onInit() async {
    super.onInit();
    albums = await _shelfProvider.getAlbumsInShelf(shelfId: shelf.shelfId);
  }

  @override
  void onClose() {}
}
