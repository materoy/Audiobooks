import 'dart:developer';

import 'package:audiobooks/app/utils/database.dart';

class PlayerProvider {
  PlayerProvider(this._localDatabase);
  final LocalDatabase _localDatabase;

  Future<void> updateCurrentTrackPosition(
      {required int currentPosition, required String path}) async {
    await _localDatabase.database.transaction((txn) async => txn.update(
        LocalDatabase.tracksTable, {'currentPosition': currentPosition},
        where: 'path = ?', whereArgs: [path]));
  }

  Future<int> getCurrentTrackPlayPosition(String path) async {
    try {
      final resultSet = await _localDatabase.database.transaction((txn) async =>
          txn.query(LocalDatabase.tracksTable,
              columns: ['currentPosition'],
              where: 'path = ?',
              whereArgs: [path]));

      if (resultSet.isNotEmpty) {
        return resultSet.first['currentPosition']! as int;
      } else {
        return 0;
      }
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }
}
