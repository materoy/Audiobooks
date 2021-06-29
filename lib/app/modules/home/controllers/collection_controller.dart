import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/data/models/track_entry.dart';
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
  TrackProvider get provider => TrackProvider(_localDatabase);
  PlayerProvider get _playerProvider => PlayerProvider(_localDatabase);

  final _tracks = List<Audiobook>.empty(growable: true).obs;

  List<Audiobook> get tracks => _tracks;

  @override
  void onInit() {
    getTracksInCollection();
    super.onInit();
  }

  Future<void> getTracksInCollection() async {
    await provider
        .getTracksInCollection(trackEntry.collectionId!)
        .then((value) => _tracks.addAll(value));
  }
}
