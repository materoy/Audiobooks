import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final LocalDatabase localDatabase = LocalDatabase();
  final GetStorage _localStorage = GetStorage();

  @override
  void onInit() {
    openDatabase().then((databaseOpen) async {
      if (databaseOpen) await localDatabase.initializeDatabaseSchema();
    });
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  Future<bool> openDatabase() async => localDatabase.openLocalDatabase();

  Future<bool> checkDirectoryPathsExist() async {
    final results =
        await localDatabase.query(table: LocalDatabase.directoryPaths);
    return results.isBlank!;
  }
}
