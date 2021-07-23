import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/providers/album_provider.dart';
import 'package:audiobooks/app/utils/base/base_provider.dart';
import 'package:audiobooks/app/utils/database.dart';

class ShelfProvider extends BaseProvider {
  const ShelfProvider({required LocalDatabase database})
      : super(database: database);

  Future<List<Album>> getAlbumsInShelf({required int shelfId}) async {
    final AlbumProvider albumProvider = AlbumProvider(localDatabase);
    List<Album> albums;
    final resultsSet = await localDatabase.database.transaction((txn) async =>
        txn.query(LocalDatabase.shelfMembersTable,
            where: 'shelfId = ?', whereArgs: [shelfId]));
    albums = [];
    for (final result in resultsSet) {
      final Album album =
          await albumProvider.getAlbumById(result['albumId']! as int);
      albums.add(album);
    }

    return albums;
  }

  Future moveAlbumToAnotherShelf(
      {required int fromShelfId,
      required String toShelfName,
      required int albumId}) async {
    await localDatabase.database.transaction((txn) async {
      /// Checks if the album being moved exists in the said table
      var resultSet = await txn.query(LocalDatabase.shelfMembersTable,
          where: 'shelfId = ? AND albumId = ?',
          whereArgs: [fromShelfId, albumId]);

      if (resultSet.isNotEmpty) {
        /// Gets the shelfId for the shelf to be moved to
        /// provided the shelf name
        resultSet = await txn.query(LocalDatabase.shelvesTable,
            where: 'shelfName = ?',
            whereArgs: [toShelfName],
            columns: ['shelfId']);

        if (resultSet.isEmpty) throw Exception('Shelf not found');
        final int toShelfId = resultSet.first['shelfId']! as int;
        await txn.insert(LocalDatabase.shelfMembersTable,
            {'shelfId': toShelfId, 'albumId': albumId});

        /// This removes the moved album from the original record
        await txn.delete(LocalDatabase.shelfMembersTable,
            where: 'shelfId = ? AND albumId =  ?',
            whereArgs: [fromShelfId, albumId]);

        /// Decrements the amount in the from shelf by 1
        await incrementDecrementAmountInShelf(
            shelfId: fromShelfId, increment: false);

        /// Increment the amount in the shelf where the album
        /// is to be added by one
        await incrementDecrementAmountInShelf(
            shelfId: toShelfId, increment: true);
      }

      // await
    });
  }

  /// Updates the amount in shelf and increments it or decrements it
  Future incrementDecrementAmountInShelf(
      {required int shelfId, required bool increment}) async {
    localDatabase.database.transaction((txn) async {
      final resultSet = await txn.query(LocalDatabase.shelvesTable,
          where: 'shelfId = ?', whereArgs: [shelfId], columns: ['amount']);

      if (resultSet.isNotEmpty) {
        int amount = resultSet.first['amount']! as int;
        amount = increment ? amount + 1 : amount - 1;
        txn.update(LocalDatabase.shelvesTable, {'amount': amount},
            where: 'shelfId = ?', whereArgs: [shelfId]);
      }
    });
  }
}
