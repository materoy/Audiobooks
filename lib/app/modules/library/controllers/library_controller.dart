import 'package:audiobooks/app/data/models/shelf.dart';
import 'package:audiobooks/app/modules/library/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

enum ShelfMode { RecentlyAdded, Listening, Completed, Favorites }

class LibraryController extends GetxController {
  ShelfProvider get _shelfProvider =>
      ShelfProvider(database: Get.find<DatabaseController>().localDatabase);

  final _shelves = List<Shelf>.empty(growable: true).obs;

  set shelves(List<Shelf> value) => _shelves.addAll(value);
  List<Shelf> get shelves => _shelves;

  @override
  Future onInit() async {
    super.onInit();
    shelves = await _shelfProvider.getShelves();
    if (shelves.isEmpty) {
      await _shelfProvider.initializeDefaultShelves();
      shelves = await _shelfProvider.getShelves();
    }
  }

  @override
  void onClose() {}
}
