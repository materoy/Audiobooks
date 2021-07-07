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
    final resultsSet = await localDatabase.database.query(
        LocalDatabase.shelfMembersTable,
        where: 'shelfId = ?',
        whereArgs: [shelfId]);
    albums = [];
    for (final result in resultsSet) {
      final Album album =
          await albumProvider.getAlbumById(result['albumId']! as int);
      albums.add(album);
    }

    return albums;
  }
}
