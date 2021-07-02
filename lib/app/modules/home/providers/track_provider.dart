import 'dart:developer';

import 'package:audiobooks/app/data/models/track.dart';
import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/utils/database.dart';

class TrackProvider {
  final LocalDatabase localDatabase;

  TrackProvider(this.localDatabase);

  Future<void> getAudiobooks() async {
    final results = await localDatabase.query(table: LocalDatabase.tracksTable);
    // for (final result in results!) {
    //   print(result['single']);
    // }
    print(results);
  }

  Future<void> getCollection() async {
    final results = await localDatabase.query(table: LocalDatabase.albumsTable);
    // for (final result in results!) {
    //   print(result);
    // }
    print(results);
  }

  Future<Track> getTrackById(int trackId) async {
    try {
      final resultSet = await localDatabase.database.query(
          LocalDatabase.tracksTable,
          where: 'trackId = ?',
          whereArgs: [trackId]);
      if (resultSet.isNotEmpty) {
        return Track.fromMap(resultSet.first);
      }
      return Track.empty();
    } catch (e) {
      log(e.toString());
      return Track.empty();
    }
  }

  Future<List<TrackEntry>> getTrackEntries(String tableName) async {
    final results = await localDatabase.query(table: tableName);
    List<TrackEntry> tracks;
    tracks = [];
    for (final result in results!) {
      final TrackEntry track = TrackEntry.fromMap(result);
      tracks.add(track);
    }
    return tracks;
  }

  Future<void> getTrack(int trackId) async {
    await localDatabase.database.query(LocalDatabase.tracksTable,
        where: 'trackId = ?', whereArgs: [trackId]);
  }

  Future<List<Track>> getTracksInCollection(int collectionId) async {
    List<Track> tracksInCollection;
    tracksInCollection = [];
    final results = await localDatabase.database.query(
      LocalDatabase.tracksTable,
      where: 'collectionId = ?',
      whereArgs: [collectionId],
    );
    for (final result in results) {
      tracksInCollection.add(Track.fromMap(result));
    }
    return tracksInCollection;
  }

  Future<Track> getSingleTrack(int trackId) async {
    final resultsSet = await localDatabase.database.query(
      LocalDatabase.tracksTable,
      where: 'trackId = ?',
      whereArgs: [trackId],
    );
    return Track.fromMap(resultsSet.first);
  }

  /// This function moves track entries from Given table to another table
  /// eg . from unread to now reading table
  Future<int> changeReadingState(
      {required int trackEntryId,
      required String fromTable,
      required String toTable}) async {
    try {
      print(trackEntryId);
      await localDatabase.database.transaction((txn) async {
        final resultSet = await txn
            .query(fromTable, where: 'entryId = ?', whereArgs: [trackEntryId]);
        if (resultSet.isNotEmpty) {
          final int newId = await txn.rawInsert('''
          INSERT OR REPLACE INTO $toTable
            (entryId, trackId, collectionId, name) VALUES (?, ?, ?, ?)
        ''', [
            resultSet.first['entryId'],
            resultSet.first['trackId'],
            resultSet.first['collectionId'],
            resultSet.first['name']
          ]);

          final int rowsDeleted = await txn.delete(fromTable,
              where: 'entryId = ?', whereArgs: [trackEntryId]);
          return newId;
        }
      });
      return 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }
}
