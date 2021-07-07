import 'package:audiobooks/app/data/models/shelf.dart';
import 'package:audiobooks/app/modules/library/providers/library_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

enum ShelfMode { RecentlyAdded, Listening, Completed, Favorites }

class LibraryController extends GetxController {
  LibraryProvider get _libraryProvider =>
      LibraryProvider(database: Get.find<DatabaseController>().localDatabase);

  final _shelves = List<Shelf>.empty(growable: true).obs;

  set shelves(List<Shelf> value) => _shelves.addAll(value);
  List<Shelf> get shelves => _shelves;

  @override
  Future onInit() async {
    super.onInit();
    shelves = await _libraryProvider.getShelves();
    if (shelves.isEmpty) {
      await _libraryProvider.initializeDefaultShelves();
      shelves = await _libraryProvider.getShelves();
    }
  }

  @override
  void onClose() {}
}
