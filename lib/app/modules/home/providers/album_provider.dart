import 'dart:developer';

import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/utils/database.dart';

class AlbumProvider {
  const AlbumProvider(LocalDatabase database) : _localDatabase = database;

  final LocalDatabase _localDatabase;

  Future<Album> getAlbumById(int albumId) async {
    try {
      final resultsSet = await _localDatabase.database.query(
          LocalDatabase.albumsTable,
          where: 'albumId = ?',
          whereArgs: [albumId]);
      if (resultsSet.isNotEmpty) {
        return Album.fromMap(resultsSet.first);
      }
      return Album.empty();
    } catch (e) {
      log(e.toString());
      return Album.empty();
    }
  }

  Future<int> getCurrentTrackId(int albumId) async {
    try {
      final resultsSet = await _localDatabase.database.query(
          LocalDatabase.albumsTable,
          where: 'albumId = ?',
          whereArgs: [albumId]);
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
      {required int trackId, required int albumId}) async {
    await _localDatabase.database.update(
        LocalDatabase.albumsTable,
        {
          'currentTrackId': trackId,
        },
        where: 'albumId = ?',
        whereArgs: [albumId]);
  }

  Future<List<Album>> getAlbumsInCategory(String categoryTableName) async {
    final resultsSet = await _localDatabase.database.query(categoryTableName);
    List<Album> albums;
    albums = [];
    for (final result in resultsSet) {
      final Album album = await getAlbumById(result['albumId']! as int);
      albums.add(album);
    }

    return albums;
  }
}
