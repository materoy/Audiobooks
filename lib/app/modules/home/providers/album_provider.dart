import 'dart:developer';

import 'package:audiobooks/app/utils/database.dart';

class CollectionProvider {
  const CollectionProvider({required LocalDatabase database})
      : _localDatabase = database;

  final LocalDatabase _localDatabase;

  Future<int> getCurrentTrackId(int collectionId) async {
    try {
      final resultsSet = await _localDatabase.database.query(
          LocalDatabase.albumsTable,
          where: 'collectionId = ?',
          whereArgs: [collectionId]);
      if (resultsSet.isNotEmpty) {
        print(resultsSet);
        return resultsSet.first['currentTrackId']! as int;
      }
      return 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<void> updateCurrentTrackInCollection(
      {required int trackId, required int collectionId}) async {
    await _localDatabase.database.update(
        LocalDatabase.albumsTable,
        {
          'currentTrackId': trackId,
        },
        where: 'collectionId = ?',
        whereArgs: [collectionId]);
  }
}
