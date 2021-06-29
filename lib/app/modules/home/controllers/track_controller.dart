import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/modules/home/providers/track_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

class TrackController extends GetxController {
  TrackController(
      {required LocalDatabase localDatabase, required this.trackEntry})
      : _localDatabase = localDatabase;

  final LocalDatabase _localDatabase;
  final TrackEntry trackEntry;
  TrackProvider get provider => TrackProvider(_localDatabase);

  final _singleTrack = Audiobook.empty().obs;

  Audiobook get singleTrack => _singleTrack.value;

  @override
  void onInit() {
    getSingleTrack();
    super.onInit();
  }

  Future<void> getSingleTrack() async {
    await provider
        .getSingleTrack(trackEntry.audiobookId!)
        .then((value) => _singleTrack.value = value);
  }
}
