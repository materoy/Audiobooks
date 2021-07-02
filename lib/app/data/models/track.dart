import 'dart:typed_data';

class Track {
  Track({
    required this.trackId,
    this.albumId,
    this.trackName,
    this.trackArtistNames,
    this.albumName,
    this.albumArtistName,
    this.trackNumber,
    this.albumLength,
    this.year,
    this.genre,
    this.authorName,
    this.writerName,
    this.discNumber,
    this.mimeType,
    this.trackDuration,
    this.bitrate,
    required this.path,
    this.albumArt,
    this.currentPosition,
  });

  factory Track.fromMap(Map<String, dynamic> trackMap) {
    return Track(
      trackId: trackMap['trackId'],
      albumId: trackMap['albumId'],
      trackName: trackMap['trackName'],

      /// Sometime this part is a bitch , you may need to spit
      /// with pattern '|' if it return a runtime of string
      trackArtistNames: trackMap['trackArtistNames'] == null
          ? null
          : trackMap['trackArtistNames'].runtimeType == String
              ? (trackMap['trackArtistNames'] as String).split('|')
              : trackMap['trackArtistNames'],
      albumName: trackMap['albumName'],
      albumArtistName: trackMap['albumArtistName'],
      trackNumber: trackMap['trackNumber'],
      albumLength: trackMap['albumLength'],
      year: trackMap['year'],
      genre: trackMap['genre'],
      authorName: trackMap['authorName'],
      writerName: trackMap['writerName'],
      discNumber: trackMap['discNumber'],
      mimeType: trackMap['mimeType'],
      trackDuration: trackMap['trackDuration'],
      bitrate: trackMap['bitrate'],
      path: trackMap['path'],
      albumArt: trackMap['albumArt'],
      currentPosition: trackMap['currentPosition'],
    );
  }
  final int? trackId;
  final int? albumId;
  final String? trackName;
  final List<String?>? trackArtistNames;
  final String? albumName;
  final String? albumArtistName;
  final int? trackNumber;
  final int? albumLength;
  final int? year;
  final String? genre;
  final String? authorName;
  final String? writerName;
  final int? discNumber;
  final String? mimeType;
  final int? trackDuration;
  final int? bitrate;
  String? path;
  Uint8List? albumArt;
  final int? currentPosition;

  Map<String, dynamic> toMap() {
    return {
      // 'trackId': trackId,
      'albumId': albumId,
      'trackName': trackName,
      'trackArtistNames': trackArtistNames,
      'albumName': albumName,
      'albumArtistName': albumArtistName,
      'trackNumber': trackNumber,
      'albumLength': albumLength,
      'year': year,
      'genre': genre,
      'authorName': authorName,
      'writerName': writerName,
      'discNumber': discNumber,
      'mimeType': mimeType,
      'trackDuration': trackDuration,
      'bitrate': bitrate,
      'path': path,
      'albumArt': albumArt,
      'currentPosition': currentPosition,
    };
  }

  factory Track.empty() {
    return Track(trackId: null, path: null);
  }

  @override
  String toString() => trackName ?? albumName ?? 'Unnamed track';
}
