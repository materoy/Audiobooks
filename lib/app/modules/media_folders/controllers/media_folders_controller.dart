import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/utils/media_scanner.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class MediaFoldersController extends GetxController {
  final LocalDatabase _localDatabase = Get.find<DatabaseController>().localDatabase;
  final _mediaFolders = List<String>.empty(growable: true).obs;

  List<String> get mediaFolders => _mediaFolders;
  @override
  void onInit() {
    super.onInit();
    queryMediaFolders();
  }

  Future<void> queryMediaFolders() async {
    final results = await _localDatabase.database
        .transaction((txn) async => txn.query(LocalDatabase.directoryPaths));
    for (final result in results) {
      final String path = result['directoryPath']! as String;
      if (!_mediaFolders.contains(path)) {
        _mediaFolders.add(path);
        await MediaScanner(_localDatabase).queryMediaFolders();
      }
    }
  }

  /// Adds the newly selected folder to the database
  Future<void> addMediaFolder(String path) async {
    await _localDatabase.insert(table: LocalDatabase.directoryPaths, values: {
      'directoryPath': path,
    });
    queryMediaFolders();
  }

  Future<String?> selectFolder() async {
    // final PermissionStatus status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }

    final String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      await addMediaFolder(path);
    }
    return path;
  }
}
