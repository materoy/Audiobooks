import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  final LocalDatabase localDatabase = LocalDatabase();

  final databaseOpen = false.obs;

  Future<bool> checkDirectoryPathsExist() async {
    final results =
        await localDatabase.query(table: LocalDatabase.directoryPaths);
    return !results.isBlank!;
  }

  Future<bool> openLocalDatabase() async => localDatabase.openLocalDatabase();
  @override
  void onInit() {
    // Checks if the databse schema is initialized
    openLocalDatabase().then((isOpen) async {
      if (isOpen) {
        databaseOpen.value = true;
        await localDatabase.initializeDatabaseSchema();
        // Checks if there are loaded paths
        await checkDirectoryPathsExist().then((directoryLoaded) =>
            !directoryLoaded
                ? Get.toNamed(Routes.MEDIA_FOLDERS)!
                    .then((value) => Get.offAllNamed(Routes.HOME))
                : Get.offAndToNamed(Routes.HOME));
      }
    });

    super.onInit();
  }
}
