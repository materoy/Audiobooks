import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/utils/base/base_provider.dart';
import 'package:audiobooks/app/utils/database.dart';

class LocalSearchProvider extends BaseProvider {
  LocalSearchProvider({required LocalDatabase database}) : super(database: database);

  Future<List<Album>> searchByTitle(String searchTerm) async {
    List<Album> foundAlbums;
    foundAlbums = [];
    final resultSet = await localDatabase.database.transaction((txn) => txn.rawQuery(
          '''
        SELECT *
        FROM ${LocalDatabase.albumsTable}
        WHERE albumName LIKE  '%$searchTerm%' OR albumAuthor LIKE  '%$searchTerm%'
    ''',
        ));

    if (resultSet.isNotEmpty) {
      for (final result in resultSet) {
        foundAlbums.add(Album.fromMap(result));
      }
    }
    return foundAlbums;
  }
}
