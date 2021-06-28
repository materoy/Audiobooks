import 'dart:typed_data';

class AudiobookCollection {
  AudiobookCollection({
    this.collectionId,
    this.currentTrackId,
    this.collectionDuration,
    required this.collectionName,
    this.collectionAuthor,
    this.collectionLength,
    this.collectionArt,
  });

  factory AudiobookCollection.fromMap(Map<String, dynamic> abookCollectionMap) {
    return AudiobookCollection(
      collectionId: abookCollectionMap['collectionId'],
      currentTrackId: abookCollectionMap['currentTrackId'],
      collectionDuration: abookCollectionMap['collectionDuration'],
      collectionName: abookCollectionMap['collectionName'],
      collectionAuthor: abookCollectionMap['collectionAuthor'],
      collectionLength: abookCollectionMap['collectionLength'],
      collectionArt: abookCollectionMap['collectionArt'],
    );
  }

  Map<String, dynamic> toMap(AudiobookCollection audiobookCollection) {
    return {
      'collectionId': audiobookCollection.collectionId,
      'currentTrackId': audiobookCollection.currentTrackId,
      'collectionDuration': audiobookCollection.collectionDuration,
      'collectionName': audiobookCollection.collectionName,
      'collectionAuthor': audiobookCollection.collectionAuthor,
      'collectionLength': audiobookCollection.collectionLength,
      'collectionArt': audiobookCollection.collectionArt,
    };
  }

  final int? collectionId;
  final int? currentTrackId;
  final int? collectionDuration;
  final String collectionName;
  final String? collectionAuthor;
  final int? collectionLength;
  final Uint8List? collectionArt;
}
