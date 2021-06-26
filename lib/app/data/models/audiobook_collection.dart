class AudiobookCollection {
  AudiobookCollection(
      {required this.tracksIds,
      required this.currentTrackId,
      required this.collectionDuration});

  factory AudiobookCollection.fromMap(Map<String, dynamic> abookCollectionMap) {
    return AudiobookCollection(
        tracksIds: abookCollectionMap['tracksIds'],
        collectionDuration: abookCollectionMap['abookCollectionMap'],
        currentTrackId: abookCollectionMap['currentTrackId']);
  }

  Map<String, dynamic> toMap(AudiobookCollection audiobookCollection) {
    return {
      'tracksIds': audiobookCollection.tracksIds,
      'currentTrackId': audiobookCollection.currentTrackId,
    };
  }

  final List<int> tracksIds;
  final int collectionDuration;
  final int currentTrackId;
}
