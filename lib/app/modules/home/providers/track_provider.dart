import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/utils/database.dart';

class TrackProvider {
  final LocalDatabase localDatabase;

  TrackProvider(this.localDatabase);

  Future<void> getAudiobooks() async {
    final results =
        await localDatabase.query(table: LocalDatabase.audiobooksTable);
    // for (final result in results!) {
    //   print(result['single']);
    // }
    print(results);
  }

  Future<void> getCollection() async {
    final results = await localDatabase.query(
        table: LocalDatabase.audiobooksCollectionTable);
    // for (final result in results!) {
    //   print(result);
    // }
    print(results);
  }

  Future<List<TrackEntry>> getUnread() async {
    final results =
        await localDatabase.query(table: LocalDatabase.unreadAudiobooksTable);
    print(results);
    List<TrackEntry> tracks;
    tracks = [];
    for (final result in results!) {
      final TrackEntry track = TrackEntry.fromMap(result);
      tracks.add(track);
    }
    return tracks;
  }

  Future<void> getTrack(int trackId) async {
    await localDatabase.database.query(LocalDatabase.audiobooksTable,
        where: 'trackId = ?', whereArgs: [trackId]);
  }

  Future<List<Audiobook>> getTracksInCollection(int collectionId) async {
    List<Audiobook> tracksInCollection;
    tracksInCollection = [];
    final results = await localDatabase.database.query(
      LocalDatabase.audiobooksTable,
      where: 'collectionId = ?',
      whereArgs: [collectionId],
    );
    for (final result in results) {
      tracksInCollection.add(Audiobook.fromMap(result));
    }
    return tracksInCollection;
  }

  Future<Audiobook> getSingleTrack(int trackId) async {
    final resultsSet = await localDatabase.database.query(
      LocalDatabase.audiobooksTable,
      where: 'trackId = ?',
      whereArgs: [trackId],
    );
    return Audiobook.fromMap(resultsSet.first);
  }
}
