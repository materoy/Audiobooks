import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Album extends Equatable {
  const Album({
    this.albumId,
    this.currentTrackId,
    this.albumDuration,
    required this.albumName,
    this.albumAuthor,
    this.albumLength,
    this.albumArt,
    this.albumCoverage,
  });

  factory Album.fromMap(Map<String, dynamic> albumsMap) {
    return Album(
      albumId: albumsMap['albumId'],
      currentTrackId: albumsMap['currentTrackId'],
      albumDuration: albumsMap['albumDuration'],
      albumName: albumsMap['albumName'],
      albumAuthor: albumsMap['albumAuthor'],
      albumLength: albumsMap['albumLength'],
      albumArt: albumsMap['albumArt'],
      albumCoverage: albumsMap['albumCoverage'],
    );
  }

  factory Album.empty() {
    return const Album(albumName: '');
  }

  Map<String, dynamic> toMap(Album audiobookCollection) {
    return {
      'albumId': audiobookCollection.albumId,
      'currentTrackId': audiobookCollection.currentTrackId,
      'albumDuration': audiobookCollection.albumDuration,
      'albumName': audiobookCollection.albumName,
      'albumAuthor': audiobookCollection.albumAuthor,
      'albumLength': audiobookCollection.albumLength,
      'albumArt': audiobookCollection.albumArt,
    };
  }

  final int? albumId;
  final int? currentTrackId;
  final int? albumDuration;
  final String albumName;
  final String? albumAuthor;
  final int? albumLength;
  final Uint8List? albumArt;
  final int? albumCoverage;

  @override
  List<Object?> get props => [
        albumId,
        currentTrackId,
        albumDuration,
        albumName,
        albumAuthor,
        albumLength,
        albumArt,
        albumCoverage
      ];

  @override
  String toString() {
    return albumName;
  }
}
