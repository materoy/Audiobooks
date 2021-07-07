import 'package:audiobooks/app/data/models/shelf.dart';
import 'package:audiobooks/app/utils/base/base_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class LibraryProvider extends BaseProvider {
  LibraryProvider({required LocalDatabase database})
      : super(database: database);

  Future initializeDefaultShelves() async {
    final Batch batch = localDatabase.database.batch();
    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Recently added',
      'rank': 1,
      'amount': 0,
    });

    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Listening',
      'rank': 2,
      'amount': 0,
    });

    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Completed',
      'rank': 3,
      'amount': 0,
    });

    batch.insert(LocalDatabase.shelvesTable, {
      'shelfName': 'Favorites',
      'rank': 4,
      'amount': 0,
    });

    batch.commit();
  }

  Future<List<Shelf>> getShelves() async {
    final resultsSet = await localDatabase.database
        .query(LocalDatabase.shelvesTable, orderBy: 'rank');

    if (resultsSet.isNotEmpty) {
      List<Shelf> shelves;
      shelves = [];
      for (final Map<String, dynamic> shelf in resultsSet) {
        shelves.add(Shelf.fromMap(shelf));
      }
      return shelves;
    } else {
      return [];
    }
  }
}
