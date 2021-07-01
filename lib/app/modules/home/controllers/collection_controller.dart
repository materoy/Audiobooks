import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/modules/home/providers/collection_provider.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/home/providers/track_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

class CollectionController extends GetxController {
  CollectionController(
      {required LocalDatabase localDatabase, required this.trackEntry})
      : _localDatabase = localDatabase;

  final LocalDatabase _localDatabase;
  final TrackEntry trackEntry;
  TrackProvider get _trackProvider => TrackProvider(_localDatabase);
  PlayerProvider get _playerProvider => PlayerProvider(_localDatabase);
  CollectionProvider get _collectionProvider =>
      CollectionProvider(database: _localDatabase);

  final _tracks = List<Audiobook>.empty(growable: true).obs;
  final _currentTrack = Audiobook.empty().obs;

  List<Audiobook> get tracks => _tracks;
  Audiobook get currentTrack => _currentTrack.value;

  Future<void> getTracksInCollection() async {
    List<Audiobook> tracks;
    tracks = [];
    await _trackProvider
        .getTracksInCollection(trackEntry.collectionId!)
        .then((value) => tracks.addAll(value));
    _tracks.value = tracks.reversed.toList();
  }

  Future<void> updateCurrentTrack(int trackId) async {
    await _collectionProvider.updateCurrentTrackInCollection(trackId);
  }

  Future<void> getCurrentTrack() async {
    final int currentTrackId =
        await _collectionProvider.getCurrentTrackId(trackEntry.collectionId!);
    if (currentTrackId != 0) {
      _currentTrack.value = await _playerProvider.getTrackById(currentTrackId);
    } else {
      _currentTrack.value = _tracks.first;
    }
  }

  @override
  void onInit() {
    getTracksInCollection().then((value) => getCurrentTrack());
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    print(_currentTrack.value);
  }
}
