import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class TrackEntry extends Equatable {
  const TrackEntry({
    this.trackEntryId,
    this.collectionId,
    this.audiobookId,
    required this.name,
    this.thumbnail,
  });
  final int? trackEntryId;
  final String? name;
  final Uint8List? thumbnail;
  final int? collectionId;
  final int? audiobookId;

  factory TrackEntry.fromMap(Map<String, dynamic> trackMap) {
    return TrackEntry(
        trackEntryId: trackMap['entryId'],
        name: trackMap['name'],
        collectionId: trackMap['collectionId'],
        audiobookId: trackMap['trackId']);
  }

  @override
  List<Object?> get props => [trackEntryId, name];
}
