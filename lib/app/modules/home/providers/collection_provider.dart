import 'dart:developer';

import 'package:audiobooks/app/utils/database.dart';

class CollectionProvider {
  const CollectionProvider({required LocalDatabase database})
      : _localDatabase = database;

  final LocalDatabase _localDatabase;

  Future<int> getCurrentTrackId(int collectionId) async {
    try {
      final resultsSet = await _localDatabase.database.query(
          LocalDatabase.audiobooksCollectionTable,
          where: 'collectionId = ?',
          whereArgs: [collectionId]);
      if (resultsSet.isNotEmpty) {
        return resultsSet.first['collectionId']! as int;
      }
      return 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<void> updateCurrentTrackInCollection(int trackId) async {
    await _localDatabase.database
        .update(LocalDatabase.audiobooksCollectionTable, {
      'currentTrackId': trackId,
    });
  }
}
