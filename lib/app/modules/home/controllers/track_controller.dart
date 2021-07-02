import 'package:audiobooks/app/data/models/track.dart';
import 'package:audiobooks/app/modules/home/providers/track_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

class TrackController extends GetxController {
  TrackController({required LocalDatabase localDatabase, required this.track})
      : _localDatabase = localDatabase;

  final LocalDatabase _localDatabase;
  TrackProvider get provider => TrackProvider(_localDatabase);

  final Track track;

  @override
  void onInit() {
    super.onInit();
  }
}
