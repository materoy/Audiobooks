import 'package:audiobooks/app/data/models/album.dart';
import 'package:get/get.dart';

enum TabState { New, NowListening, Finished }

class HomeController extends GetxController {
  final _tabState = TabState.NowListening.obs;
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

  Future<void> addTracks() async {
    /// Gets all the now reading tracks
  }

  @override
  Future<void> onInit() async {
    await addTracks();

    super.onInit();
  }

  @override
  void onClose() {}
}
