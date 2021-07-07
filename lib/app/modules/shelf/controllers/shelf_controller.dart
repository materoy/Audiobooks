import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/shelf/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class ShelfController extends GetxController {
  ShelfController({required this.shelfId});
  late final ShelfProvider _shelfProvider;

  final int shelfId;

  final _albums = List<Album>.empty(growable: true).obs;

  set albums(List<Album> value) => _albums.addAll(value);
  List<Album> get albums => _albums;

  @override
  Future onInit() async {
    super.onInit();
    _shelfProvider =
        ShelfProvider(database: Get.find<DatabaseController>().localDatabase);
    albums = await _shelfProvider.getAlbumsInShelf(shelfId: shelfId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
