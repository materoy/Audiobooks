import 'dart:developer';
import 'dart:typed_data';

class Audiobook {
  Audiobook({
    required this.trackId,
    this.collectionId,
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
    this.trackArt,
    this.currentPosition,
    this.single,
  });

  factory Audiobook.fromMap(Map<String, dynamic> audiobookMap) {
    return Audiobook(
      trackId: audiobookMap['trackId'],
      collectionId: audiobookMap['collectionId'],
      trackName: audiobookMap['trackName'],
      trackArtistNames: audiobookMap['trackArtistNames'].toList(),
      albumName: audiobookMap['albumName'],
      albumArtistName: audiobookMap['albumArtistName'],
      trackNumber: audiobookMap['trackNumber'],
      albumLength: audiobookMap['albumLength'],
      year: audiobookMap['year'],
      genre: audiobookMap['genre'],
      authorName: audiobookMap['authorName'],
      writerName: audiobookMap['writerName'],
      discNumber: audiobookMap['discNumber'],
      mimeType: audiobookMap['mimeType'],
      trackDuration: audiobookMap['trackDuration'],
      bitrate: audiobookMap['bitrate'],
      path: audiobookMap['path'],
      albumArt: audiobookMap['albumArt'],
      trackArt: audiobookMap['trackArt'],
      currentPosition: audiobookMap['currentPosition'],
      single: audiobookMap['single'],
    );
  }
  final int? trackId;
  final int? collectionId;
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
  final Uint8List? albumArt;
  final Uint8List? trackArt;
  final int? currentPosition;
  int? single;

  Map<String, dynamic> toMap() {
    return {
      // 'trackId': trackId,
      'collectionId': collectionId,
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
      'trackArt': trackArt,
      'currentPosition': currentPosition,
      'single': single,
    };
  }

  factory Audiobook.empty() {
    return Audiobook(trackId: null, path: null);
  }

  @override
  String toString() => trackName ?? albumName ?? 'Unnamed track';
}
