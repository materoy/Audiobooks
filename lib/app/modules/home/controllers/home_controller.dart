import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final LocalDatabase _localDatabase = LocalDatabase();
  final GetStorage _localStorage = GetStorage();

  @override
  void onInit() async {
    // Open the database connection
    final bool databaseOpenened = await _localDatabase.databaseOpened;
    print(databaseOpenened);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  bool checkDatabaseSchemaInitialised() {
    final bool? initialized = _localStorage.read('LocalDatabaseStatus');
    return initialized ?? false;
  }

  void initializeDatabaseSchema() {
    // _localDatabase.initializeDatabase()
  }
}
