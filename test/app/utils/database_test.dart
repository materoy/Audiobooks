import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

class MockAudiobook extends Mock implements Audiobook {}

@GenerateMocks([])
Future<void> main() async {
  // Init ffi loader if needed.
  sqfliteFfiInit();
  await GetStorage.init('testx');

  group('Database ', () {
    test('initialization and closing ...', () async {
      final Database db =
          await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

      final LocalDatabase localDatabase = LocalDatabase(testDatabase: db);

      expect(localDatabase.database.isOpen, true);

      await db.close();

      expect(localDatabase.database.isOpen, false);
    });

    test('schema initializes ...', () async {
      final Database db =
          await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

      final LocalDatabase localDatabase = LocalDatabase(testDatabase: db);

      expect(await localDatabase.initializeDatabaseSchema(), true);

      await db.close();
    });

    test('inserts and queries ...', () async {
      final Database db =
          await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

      final LocalDatabase localDatabase = LocalDatabase(testDatabase: db);

      final Audiobook audiobook = MockAudiobook();
      when(() => audiobook.albumName).thenReturn(() => 'Mock book');
      expect(audiobook.albumName, 'Mock book');

      // localDatabase.database.insert(table, values)
      await db.close();
    });
  });
}
