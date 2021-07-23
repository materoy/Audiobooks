import 'dart:developer';

import 'package:audiobooks/app/data/models/track.dart';
import 'package:audiobooks/app/utils/database.dart';

class TrackProvider {
  final LocalDatabase localDatabase;

  TrackProvider(this.localDatabase);

  Future<Track> getTrackById(int trackId) async {
    try {
      final resultSet = await localDatabase.database.transaction((txn) async =>
          txn.query(LocalDatabase.tracksTable,
              where: 'trackId = ?', whereArgs: [trackId]));
      if (resultSet.isNotEmpty) {
        return Track.fromMap(resultSet.first);
      }
      return Track.empty();
    } catch (e) {
      log(e.toString());
      return Track.empty();
    }
  }

  Future<Track> getTrackByPath(String path) async {
    try {
      final resultSet = await localDatabase.database.transaction((txn) async =>
          txn.query(LocalDatabase.tracksTable,
              where: 'path = ?', whereArgs: [path]));
      if (resultSet.isNotEmpty) {
        return Track.fromMap(resultSet.first);
      }
      return Track.empty();
    } catch (e) {
      log(e.toString());
      return Track.empty();
    }
  }

  Future<List<Track>> getTracksInAlbum(int albumId) async {
    List<Track> tracksInCollection;
    tracksInCollection = [];
    final results =
        await localDatabase.database.transaction((txn) async => txn.query(
              LocalDatabase.tracksTable,
              where: 'albumId = ?',
              whereArgs: [albumId],
              orderBy: 'trackNumber',
            ));

    for (final result in results) {
      tracksInCollection.add(Track.fromMap(result));
    }
    return tracksInCollection;
  }
}
