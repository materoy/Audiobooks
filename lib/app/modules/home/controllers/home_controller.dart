import 'package:audiobooks/app/data/models/track_.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

enum TabState { Unread, Reading, Finished }

class HomeController extends GetxController {
  final LocalDatabase localDatabase = LocalDatabase();

  final _tabState = TabState.Reading.obs;
  final _unreadTracks = List<Track>.empty(growable: true).obs;
  final _nowReadingTracks = List<Track>.empty(growable: true).obs;
  final _finishedTracks = List<Track>.empty(growable: true).obs;

  TabState get tabState => _tabState.value;
  set tabState(TabState value) => _tabState.value = value;

  @override
  void onInit() {
    // Checks if the databse schema is initialized
    openDatabase().then((databaseOpen) async {
      if (databaseOpen) await localDatabase.initializeDatabaseSchema();
      // Checks if there are loaded paths
      checkDirectoryPathsExist().then((directoryLoaded) =>
          !directoryLoaded ? Get.toNamed(Routes.MEDIA_FOLDERS) : null);
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
    return !results.isBlank!;
  }

  // Future<void> addTracks() {}
}
