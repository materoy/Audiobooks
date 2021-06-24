import 'package:sqflite/sqflite.dart';

class DBase {
  late Database database;

  DBase() {
    openDatabase('audiobooks.db').then((value) => database = value);
  }

  void initDatabase() {
    database.execute('''CREATE TABLE Audiobooks (
        id int,
        name VarChar(255),
        author VarChar(255),
        coverage int
    )''');
  }
}
