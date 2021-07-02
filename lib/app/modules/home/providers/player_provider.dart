import 'dart:developer';

import 'package:audiobooks/app/utils/database.dart';

class PlayerProvider {
  PlayerProvider(this._localDatabase);
  final LocalDatabase _localDatabase;

  Future<void> updateCurrentTrackPosition(
      {required int currentPosition, required int trackId}) async {
    await _localDatabase.database.update(
        LocalDatabase.tracksTable, {'currentPosition': currentPosition},
        where: 'trackId = ?', whereArgs: [trackId]);
  }

  Future<int> getCurrentTrackPlayPosition(int trackId) async {
    try {
      final resultSet = await _localDatabase.database.query(
          LocalDatabase.tracksTable,
          columns: ['currentPosition'],
          where: 'trackId = ?',
          whereArgs: [trackId]);

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
