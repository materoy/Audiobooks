import 'dart:developer';

import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  late Database database;

  late Future<bool> _databaseOpen;

  static const String databaseName = 'Audiobooks.db';
  static const String audiobooksTable = 'Audiobooks';
  static const String audiobooksCollectionTable = 'AudiobooksCollection';
  static const String unreadAudiobooksTable = 'UnreadAudiobooks';
  static const String finishedAudiobooksTable = 'FinishedAudiobooks';
  static const String nowReadingAudiobooksTable = 'NowReadingAudiobooks';
  static const String pathsTable = 'AudiobooksDirectoryPaths';

  LocalDatabase() {
    _databaseOpen = openLocalDatabase();
  }

  Future<bool> get databaseOpened => _databaseOpen;

  Future<bool> openLocalDatabase() async {
    database = await openDatabase(databaseName);
    return database.isOpen;
  }

  // Future<bool> checkInitialised() {}

  Future<void> initializeDatabaseSchema() async {
    final bool open = await databaseOpened;
    if (open) {
      await database.execute('''
      CREATE TABLE $audiobooksTable (
        trackId int AUTO_INCREMENT,
        path VarChar(255),
        trackName VarChar(255),
        trackArtistNames  VarChar(255),
        albumName VarChar(255),
        albumArtistName VarChar(255),
        trackNumber int,
        albumLength int,
        year int,
        genre VarChar(255),
        authorName VarChar(255),
        writerName VarChar(255),
        discNumber int,
        mimeType VarChar(32),
        trackDuration int,
        bitrate int,
        PRIMARY KEY(trackId)
    )''');

      log('The database has been initialised');
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
}
