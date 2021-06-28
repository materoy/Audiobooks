import 'dart:typed_data';

class Track {
  const Track({
    this.collectionId,
    this.audiobookId,
    required this.name,
    this.thumbnail,
  });
  final String name;
  final Uint8List? thumbnail;
  final int? collectionId;
  final int? audiobookId;

  factory Track.fromMap(Map<String, dynamic> trackMap) {
    return Track(
        name: trackMap['name'],
        collectionId: trackMap['collectionId'],
        audiobookId: trackMap['trackId']);
  }
}
