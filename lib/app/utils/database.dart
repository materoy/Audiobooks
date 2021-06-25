import 'dart:developer';
import 'dart:ffi';

import 'package:sqflite/sqflite.dart';

class DBase {
  late Database database;

  static const String databaseName = 'Audiobooks.db';
  static const String tableName = 'Audiobooks';

  DBase() {
    openDatabase('audiobooks.db').then((value) => database = value);
  }

  Future<bool> initializeDatabase() async {
    database = await openDatabase(databaseName);
    return database.isOpen;
  }

  void initDatabase() async {
    bool open = await initializeDatabase();
    if (open) {
      await database.execute('''CREATE TABLE $tableName (
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

      log("The database has been initialised");
    }
  }

  Future<List<Map<String, Object?>>?> query(
      {String? table, List<String>? columns, bool? distinct}) async {
    bool open = await initializeDatabase();
    if (open) {
      var results = database.query(
        table ?? tableName,
        columns: columns,
        distinct: distinct,
      );
      return results;
    }
  }

  void insert({String? table, required Map<String, dynamic> values}) async {
    bool open = await initializeDatabase();

    if (open) {
      database.insert(table ?? tableName, values);
    }
  }
}
