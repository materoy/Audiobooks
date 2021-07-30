import 'dart:developer';

import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/shelf/providers/shelf_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:audiobooks/app/utils/logger.dart';

class AlbumProvider {
  const AlbumProvider(LocalDatabase database) : _localDatabase = database;

  final LocalDatabase _localDatabase;

  Future<Album> getAlbumById(int albumId) async {
    try {
      final resultsSet = await _localDatabase.database.transaction((txn) async =>
          txn.query(LocalDatabase.albumsTable, where: 'albumId = ?', whereArgs: [albumId]));

      if (resultsSet.isNotEmpty) {
        return Album.fromMap(resultsSet.first);
      }
      return Album.empty();
    } catch (e) {
      log(e.toString());

      final resultsSet = await _localDatabase.database
          .transaction((txn) async => txn.query(LocalDatabase.albumsTable,
              columns: [
                'albumId',
                'albumDuration',
                'currentTrackId',
                'albumName',
                'albumAuthor',
                'albumLength',
                'albumCoverage'
              ],
              where: 'albumId = ?',
              whereArgs: [albumId]));

      if (resultsSet.isNotEmpty) {
        return Album.fromMap(resultsSet.first);
      }
      return Album.empty();
    }
  }

  Future<int> getCurrentTrackId(int albumId) async {
    try {
      final resultsSet = await _localDatabase.database.transaction((txn) async =>
          txn.query(LocalDatabase.albumsTable, where: 'albumId = ?', whereArgs: [albumId]));
      if (resultsSet.isNotEmpty) {
        return resultsSet.first['currentTrackId']! as int;
      }
      return 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<void> updateCurrentTrackInCollection({required int trackId, required int albumId}) async {
    await _localDatabase.database.transaction((txn) async => txn.update(
        LocalDatabase.albumsTable,
        {
          'currentTrackId': trackId,
        },
        where: 'albumId = ?',
        whereArgs: [albumId]));
  }

  Future updateCurrentPlayngAlbum({required int albumId}) async {
    await _localDatabase.database.transaction((txn) async {
      await txn.rawQuery('''
          INSERT OR REPLACE INTO ${LocalDatabase.metadataTable} (key, value)
          VALUES ("currentAlbum", $albumId)
        ''');
    });
  }

  Future<int?> getCurrentPlayingAlbum() async {
    try {
      final resultSet = await _localDatabase.query(table: LocalDatabase.metadataTable);
      if (resultSet != null && resultSet.isNotEmpty) {
        return int.parse(resultSet.first['value'].toString());
      }
    } catch (e) {
      Logger.log(e.toString());
    }
  }

  Future<List<Album>> getAlbumsInCategory(String categoryTableName) async {
    final resultsSet =
        await _localDatabase.database.transaction((txn) async => txn.query(categoryTableName));
    List<Album> albums;
    albums = [];
    for (final result in resultsSet) {
      final Album album = await getAlbumById(result['albumId']! as int);
      albums.add(album);
    }

    return albums;
  }

  /// This function moves track entries from Given table to another table
  /// eg . from unread to now reading table
  Future<int> changeReadingState(
      {required int albumId, required String fromTable, required String toTable}) async {
    try {
      print(albumId);
      await _localDatabase.database.transaction((txn) async {
        final resultSet = await txn.query(fromTable, where: 'albumId = ?', whereArgs: [albumId]);
        if (resultSet.isNotEmpty) {
          final int newId = await txn.rawInsert('''
          INSERT OR REPLACE INTO $toTable
            (albumId) VALUES (?)
        ''', [
            resultSet.first['albumId'],
          ]);

          await txn.delete(fromTable, where: 'albumId = ?', whereArgs: [albumId]);
          return newId;
        }
      });
      return 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  ShelfProvider get _shelfProvider => ShelfProvider(database: _localDatabase);

  Future likeAlbum(int albumId) async {
    await _localDatabase.database.transaction((txn) async {
      final resultsSet = await txn.query(LocalDatabase.shelvesTable,
          where: 'shelfName =?', whereArgs: ['Favorites'], columns: ['shelfId']);
      final int favoritesShelfId = resultsSet.first['shelfId']! as int;

      await txn.insert(
        LocalDatabase.shelfMembersTable,
        {'shelfId': favoritesShelfId, 'albumId': albumId},
      );

      await _shelfProvider.incrementDecrementAmountInShelf(
          shelfId: favoritesShelfId, increment: true);
    });
  }

  Future unlikeAlbum(int albumId) async {
    await _localDatabase.database.transaction((txn) async {
      final resultsSet = await txn.query(LocalDatabase.shelvesTable,
          where: 'shelfName =?', whereArgs: ['Favorites'], columns: ['shelfId']);
      final int favoritesShelfId = resultsSet.first['shelfId']! as int;

      await txn.delete(
        LocalDatabase.shelfMembersTable,
        where: 'shelfId = ? AND albumId = ?',
        whereArgs: [favoritesShelfId, albumId],
      );
      await _shelfProvider.incrementDecrementAmountInShelf(
          shelfId: favoritesShelfId, increment: false);
    });
  }

  Future<bool> checkLiked(int albumId) async {
    List records = [];
    await _localDatabase.database.transaction((txn) async {
      final resultsSet = await txn.query(LocalDatabase.shelvesTable,
          where: 'shelfName =?', whereArgs: ['Favorites'], columns: ['shelfId']);
      final int favoritesShelfId = resultsSet.first['shelfId']! as int;

      records = await txn.query(LocalDatabase.shelfMembersTable,
          where: 'albumId = ? AND shelfId = ?', whereArgs: [albumId, favoritesShelfId]);
    });
    return records.isNotEmpty;
  }
}
