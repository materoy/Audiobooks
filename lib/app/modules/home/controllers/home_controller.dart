import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/modules/home/providers/album_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

enum TabState { Unread, Reading, Finished }

class HomeController extends GetxController {
  final LocalDatabase localDatabase = LocalDatabase();

  AlbumProvider get _albumProvider => AlbumProvider(localDatabase);

  final _tabState = TabState.Reading.obs;
  final _newAlbums = List<Album>.empty(growable: true).obs;
  final _nowListeningAlbums = List<Album>.empty(growable: true).obs;
  final _finishedAlbums = List<Album>.empty(growable: true).obs;

  TabState get tabState => _tabState.value;
  List<Album> get newAlbums => _newAlbums;
  List<Album> get nowListeningAlbums => _nowListeningAlbums;
  List<Album> get finishedAlbums => _finishedAlbums;

  set tabState(TabState value) {
    _tabState.value = value;
    addTracks();
  }

  @override
  void onInit() {
    addTracks();

    super.onInit();
  }

  @override
  void onClose() {}

  Future<bool> openDatabase() async => localDatabase.openLocalDatabase();

  Future<void> addTracks() async {
    /// Gets all the now reading tracks
    switch (_tabState.value) {
      case TabState.Unread:
        await _albumProvider
            .getAlbumsInCategory(LocalDatabase.newTracksTable)
            .then((value) {
          _newAlbums.clear();
          _newAlbums.addAll(value);
        });
        break;

      case TabState.Reading:
        await _albumProvider
            .getAlbumsInCategory(LocalDatabase.nowListeningTracksTable)
            .then((value) {
          _nowListeningAlbums.clear();
          _nowListeningAlbums.addAll(value);
        });
        break;

      case TabState.Finished:
        await _albumProvider
            .getAlbumsInCategory(LocalDatabase.finishedTracksTable)
            .then((value) {
          _finishedAlbums.clear();
          _finishedAlbums.addAll(value);
        });
        break;
      default:
    }
  }
}
