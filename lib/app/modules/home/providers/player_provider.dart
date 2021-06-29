import 'dart:developer';

import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/utils/database.dart';

class PlayerProvider {
  PlayerProvider(this._localDatabase);
  final LocalDatabase _localDatabase;

  Future<Audiobook> getTrackById(int trackId) async {
    try {
      final resultSet = await _localDatabase.database.query(
          LocalDatabase.audiobooksTable,
          where: 'trackId = ?',
          whereArgs: [trackId]);
      if (resultSet.isNotEmpty) {
        return Audiobook.fromMap(resultSet.first);
      }
      return Audiobook.empty();
    } catch (e) {
      log(e.toString());
      return Audiobook.empty();
    }
  }

  Future<void> updateCurrentTrackPosition(
      {required int currentPosition, required int trackId}) async {
    await _localDatabase.database.update(
        LocalDatabase.audiobooksTable, {'currentPosition': currentPosition},
        where: 'trackId = ?', whereArgs: [trackId]);
  }

  Future<int> getCurrentTrackPlayPosition(int trackId) async {
    try {
      final resultSet = await _localDatabase.database.query(
          LocalDatabase.audiobooksTable,
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
