import 'package:audiobooks/app/utils/base/base_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:sqflite/sqlite_api.dart';

class ShelfProvider extends BaseProvider {
  ShelfProvider({required LocalDatabase database}) : super(database: database);

  Future initializeDefaultShelves() async {
    final Batch batch = localDatabase.database.batch();
    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Recently added',
      'rank': 1,
    });

    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Listening',
      'rank': 2,
    });

    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Completed',
      'rank': 3,
    });

    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Favorites',
      'rank': 4,
    });

    batch.commit();
  }

  Future<Map<int, String>?> getShelves() async {
    final resultsSet = await localDatabase.database
        .query(LocalDatabase.shelvesTable, orderBy: 'rank');

    if (resultsSet.isNotEmpty) {
      Map<int, String> shelves;
      shelves = {};
      for (final Map shelf in resultsSet) {
        shelves.addAll({shelf['rank']: shelf['shelfName']});
      }
      return shelves;
    } else {
      return null;
    }
  }
}
