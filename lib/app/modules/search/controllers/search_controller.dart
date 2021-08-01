import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/search/providers/local_search_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  LocalSearchProvider get _localSearchProvider =>
      LocalSearchProvider(database: Get.find<DatabaseController>().localDatabase);

  final _searchText = ''.obs;
  set searchText(String value) => _searchText.value = value;
  String get searchText => _searchText.value;

  final _foundAlbums = List<Album>.empty(growable: true).obs;
  List<Album> get foundAlbums => _foundAlbums;

  Future searchDatabase() async {
    _foundAlbums.value = await _localSearchProvider.searchByTitle(_searchText.value);
  }
}
