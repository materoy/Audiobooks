import 'package:audiobooks/app/modules/library/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class LibraryController extends GetxController {
  ShelfProvider get shelfProvider =>
      ShelfProvider(database: Get.find<DatabaseController>().localDatabase);

  final _shelves = <int, String>{}.obs;

  set shelves(Map<int, String> value) => _shelves.addAll(value);
  Map<int, String> get shelves => _shelves;

  @override
  Future onInit() async {
    super.onInit();
    await shelfProvider.getShelves().then((value) {
      if (value == null) {
        shelfProvider.initializeDefaultShelves();
      } else {
        _shelves.addAll(value);
      }
    });
  }

  @override
  void onClose() {}
}
