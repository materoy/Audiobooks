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

  /// Refreshes the shelves state incase of an update
  /// in any of the shelves
  /// Also called during initial state to get the shelves
  /// or initialize the table in the database
  Future refreshShelves() async {
    if (_shelves.isNotEmpty) _shelves.clear();
    await _libraryProvider.initializeDefaultShelves();

    shelves = await _libraryProvider.getShelves();
  }

  @override
  Future onInit() async {
    super.onInit();
    await refreshShelves();
  }

  @override
  void onClose() {}
}
