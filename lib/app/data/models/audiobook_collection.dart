class AudiobookCollection {
  AudiobookCollection(
      {required this.audiobooksId,
      required this.currentIndex,
      required this.collectionDuration});

  factory AudiobookCollection.fromMap(Map<String, dynamic> abookCollectionMap) {
    return AudiobookCollection(
        audiobooksId: abookCollectionMap['audiobooksId'],
        collectionDuration: abookCollectionMap['abookCollectionMap'],
        currentIndex: abookCollectionMap['currentIndex']);
  }

  Map<String, dynamic> toMap(AudiobookCollection audiobookCollection) {
    return {
      'audiobooksId': audiobookCollection.audiobooksId,
      'currentIndex': audiobookCollection.currentIndex,
    };
  }

  final List<String> audiobooksId;
  final int collectionDuration;
  final int currentIndex;
}
