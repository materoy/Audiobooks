import 'package:audiobooks/app/utils/database.dart';

class BaseProvider {
  const BaseProvider({required LocalDatabase database})
      : localDatabase = database;

  final LocalDatabase localDatabase;
}
