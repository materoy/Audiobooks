import 'package:audiobooks/app/modules/media_folders/views/media_folders_view.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:audiobooks/app/utils/logger.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  final LocalDatabase localDatabase = LocalDatabase();

  final databaseOpen = false.obs;

  Future<bool> checkDirectoryPathsExist() async {
    final results = await localDatabase.database
        .transaction((txn) async => txn.query(LocalDatabase.directoryPaths));
    return results.isNotEmpty;
  }

  Future<bool> openLocalDatabase() async => localDatabase.openLocalDatabase();
  @override
  void onInit() {
    // Checks if the databse schema is initialized
    openLocalDatabase().then((isOpen) async {
      if (isOpen) {
        await localDatabase.initializeDatabaseSchema();
        databaseOpen.value = true;
      }
    });
    super.onInit();
  }

  @override
  Future onReady() async {
    super.onReady();
    Logger.log(databaseOpen.value.toString());
    Future.delayed(const Duration(seconds: 2), () async {
      if (databaseOpen.value) {
        await checkDirectoryPathsExist().then((directoryLoaded) async {
          // And if there are no directories configured open the select
          // media directory dialog
          if (!directoryLoaded) MediaFoldersDialog.open();
        });
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    localDatabase.database.close();
  }
}
