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

  @override
  void onInit() {
    getTracksInCollection().then((value) => getCurrentTrack());
    super.onInit();
  }

  Future<void> getTracksInCollection() async {
    await _trackProvider
        .getTracksInCollection(trackEntry.collectionId!)
        .then((value) => _tracks.addAll(value));
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

  // Future<void> getTrack() {}
}
