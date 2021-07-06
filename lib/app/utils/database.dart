import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  late Database database;

  late Future<bool> _databaseOpen;

  static const String databaseName = 'Audiobooks.db';
  static const String databaseInitialisedStatusStorage = 'DatabaseStatus';
  static const String tracksTable = 'Tracks';
  static const String albumsTable = 'Albums';
  static const String shelvesTable = 'Shelves';
  static const String recentlyAddedTable = 'RecentlyAdded';
  static const String completedTable = 'Completed';
  static const String listeningTable = 'Listening';
  static const String favoritesTable = 'Favorites';
  static const String directoryPaths = 'AudiobooksDirectoryPaths';

  LocalDatabase({Database? testDatabase}) {
    if (testDatabase != null) {
      database = testDatabase;
    } else {
      _databaseOpen = openLocalDatabase();
    }
  }

  Future<bool> get databaseOpened => _databaseOpen;

  Future<bool> openLocalDatabase() async {
    database = await openDatabase(databaseName);
    return database.isOpen;
  }

  Future<bool> checkDatabaseExist({String? path}) async {
    return databaseExists(path ?? databaseName);
  }

  Future<bool?> initializeDatabaseSchema() async {
    final localStorage = GetStorage();

    if (!localStorage.hasData(databaseInitialisedStatusStorage)) {
      // if (true) {
      try {
        log('Creating database schema');

        await database.transaction((txn) async {
          /// Create audiobooks collection table
          await txn.execute('''
      CREATE TABLE $albumsTable (
        albumId INTEGER PRIMARY KEY,
        albumDuration INTEGER,
        currentTrackId INTEGER,
        albumName TEXT,
        albumAuthor TEXT,
        albumLength INTEGER,
        albumArt BLOB,
        albumCoverage INTEGER,
        UNIQUE(albumName),
        FOREIGN KEY (currentTrackId) REFERENCES $tracksTable(trackId)
    )''');

          /// Create audiobooks table
          await txn.execute('''
      CREATE TABLE $tracksTable (
        trackId INTEGER PRIMARY KEY,
        path TEXT,
        trackName TEXT,
        trackArtistNames TEXT,
        albumId INTEGER,
        albumName INTEGER,
        albumArtistName TEXT,
        trackNumber INTEGER,
        albumLength INTEGER,
        year INTEGER,
        genre TEXT,
        authorName TEXT,
        writerName TEXT,
        discNumber INTEGER,
        mimeType TEXT,
        trackDuration INTEGER,
        bitrate INTEGER,
        currentPosition INTEGER,
        albumArt BLOB,
        UNIQUE(path),
        FOREIGN KEY (albumId) REFERENCES $albumsTable (albumId)
    )''');

          /// Create paths table
          await txn.execute('''
      CREATE TABLE $directoryPaths (
        pathId INTEGER PRIMARY KEY,
        directoryPath TEXT NOT NULL
    )''');

          await txn.execute('''
      CREATE TABLE $shelvesTable (
        shelfId INTEGER PRIMARY KEY,
        shelfName TEXT NOT NULL,
        rank INTEGER NOT NULL
    )''');

          /// Create unread table
          await txn.execute('''
      CREATE TABLE $recentlyAddedTable (
        shelfId INTEGER NOT NULL,
        albumId INTEGER NOT NULL,
        numberOf INTEGER NOT NULL,
        FOREIGN KEY (albumId) REFERENCES $albumsTable (albumId),
        FOREIGN KEY (shelfId) REFERENCES $shelvesTable (shelfId)
    )''');

          /// Create now reading table
          await txn.execute('''
      CREATE TABLE $listeningTable (
        albumId INTEGER,
        shelfId INTEGER,
        numberOf INTEGER NOT NULL,
        FOREIGN KEY (albumId) REFERENCES $albumsTable (albumId),
        FOREIGN KEY (shelfId) REFERENCES $shelvesTable (shelfId)
          )''');

          /// Create finished table
          await txn.execute('''
      CREATE TABLE $completedTable (
        albumId INTEGER,
        shelfId INTEGER,
        numberOf INTEGER NOT NULL,
        FOREIGN KEY (albumId) REFERENCES $albumsTable (albumId),
        FOREIGN KEY (shelfId) REFERENCES $shelvesTable (shelfId)
          )''');

          /// Create finished table
          await txn.execute('''
      CREATE TABLE $favoritesTable (
        albumId INTEGER,
        shelfId INTEGER,
        numberOf INTEGER NOT NULL,
        FOREIGN KEY (albumId) REFERENCES $albumsTable (albumId),
        FOREIGN KEY (shelfId) REFERENCES $shelvesTable (shelfId)
          )''');
        });

        /// Rat to the app that the database is ok
        GetStorage().write(databaseInitialisedStatusStorage, true);

        log('The database schema has been initialised');

        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }
  }

  Future<List<Map<String, Object?>>?> query(
      {required String table, List<String>? columns, bool? distinct}) async {
    final bool open = await databaseOpened;
    if (open) {
      final List<Map<String, dynamic>> results = await database.query(
        table,
        columns: columns,
        distinct: distinct,
      );
      return results;
    }
  }

  Future<int> insert(
      {required String table, required Map<String, dynamic> values}) async {
    final bool open = await databaseOpened;

    if (open) {
      final int returnCode = await database.insert(table, values);
      return returnCode;
    }
    return -1;
  }

  Future<void> resetDatabase() async {
    await deleteDatabase(databaseName);
    await database.close();
    final localStorage = GetStorage();
    localStorage.remove(databaseInitialisedStatusStorage);
    log('The database has been reset');
  }
}
