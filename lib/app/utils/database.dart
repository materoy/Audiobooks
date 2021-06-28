import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  late Database database;

  late Future<bool> _databaseOpen;

  static const String databaseName = 'Audiobooks.db';
  static const String databaseInitialisedStatusStorage = 'DatabaseStatus';
  static const String audiobooksTable = 'Audiobooks';
  static const String audiobooksCollectionTable = 'AudiobooksCollection';
  static const String unreadAudiobooksTable = 'UnreadAudiobooks';
  static const String finishedAudiobooksTable = 'FinishedAudiobooks';
  static const String nowReadingAudiobooksTable = 'NowReadingAudiobooks';
  static const String directoryPaths = 'AudiobooksDirectoryPaths';

  LocalDatabase() {
    _databaseOpen = openLocalDatabase();
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
      try {
        log('Creating database schema');

        await database.transaction((txn) async {
          /// Create audiobooks collection table
          await txn.execute('''
      CREATE TABLE $audiobooksCollectionTable (
        collectionId INTEGER PRIMARY_KEY,
        collectionDuration INTEGER,
        currentTrackId INTEGER,
        collectionName TEXT,
        collectionAuthor TEXT,
        collectionLength INTEGER,
        UNIQUE(collectionName)
        FOREIGN KEY (currentTrackId) REFERENCES $audiobooksTable(trackId)
    )''');

          /// Create audiobooks table
          await txn.execute('''
      CREATE TABLE $audiobooksTable (
        trackId INTEGER PRIMARY KEY,
        path TEXT,
        trackName TEXT,
        trackArtistNames TEXT,
        collectionId INTEGER,
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
        UNIQUE(path),
        FOREIGN KEY (collectionId) REFERENCES $audiobooksCollectionTable (collectionId)
    )''');

          /// Create paths table
          await txn.execute('''
      CREATE TABLE $directoryPaths (
        pathId INTEGER PRIMARY KEY,
        directoryPath TEXT
    )''');
        });
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
    final localStorage = GetStorage();
    localStorage.remove(databaseInitialisedStatusStorage);
  }
}
