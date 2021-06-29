import 'package:audiobooks/app/utils/database.dart';

class PlayerProvider {
  PlayerProvider(this._localDatabase);
  final LocalDatabase _localDatabase;

  Future<void> updateCurrentTrackInCollection(int trackId) async {
    await _localDatabase.database
        .update(LocalDatabase.audiobooksCollectionTable, {
      'currentTrackId': trackId,
    });
  }

  Future<void> updateCurrentTrackPosition(int currentPosition) async {
    await _localDatabase.database.update(
        LocalDatabase.audiobooksTable, {'currentPosition': currentPosition});
  }

//   Future<void> doWhatever() async{}
//   Future<void> doWhatever() async{}
//   Future<void> doWhatever() async{}
}
