import 'package:audiobooks/app/utils/base/base_provider.dart';
import 'package:audiobooks/app/utils/database.dart';

class LibraryProvider extends BaseProvider {
  LibraryProvider({required LocalDatabase database})
      : super(database: database);
}
