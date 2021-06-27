import 'dart:developer';

import 'package:audiobooks/app/utils/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class MediaFoldersController extends GetxController {
  final LocalDatabase _localDatabase = LocalDatabase();
  final _mediaFolders = List<String>.empty(growable: true).obs;

  List<String> get mediaFolders => _mediaFolders;
  @override
  void onInit() {
    super.onInit();
    queryMediaFolders();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {}

  Future<void> queryMediaFolders() async {
    final results =
        await _localDatabase.query(table: LocalDatabase.directoryPaths);
    for (final result in results!) {
      final String path = result['directoryPath']! as String;
      if (!_mediaFolders.contains(path)) {
        _mediaFolders.add(path);
      }
    }
  }

  Future<void> addMediaFolder(String path) async {
    await _localDatabase.insert(table: LocalDatabase.directoryPaths, values: {
      'directoryPath': path,
    });
    queryMediaFolders();
  }

  Future<String?> selectFolder() async {
    final String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      await addMediaFolder(path);
    }
    return path;
  }
}