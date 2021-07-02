import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audiobooks/app/data/models/track.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as p;

import 'package:audiobooks/app/utils/database.dart';

class MediaScanner {
  MediaScanner(this.localDatabase);
  final LocalDatabase localDatabase;

  /// These are the audiobok media types accepted
  static const List<String> AUDIO_MEDIA_TYPES = ['.mp3', '.m4b'];

  Future<void> queryMediaFolders() async {
    final results =
        await localDatabase.query(table: LocalDatabase.directoryPaths);
    // ignore: prefer_final_locals
    List<String> paths = [];
    for (final result in results!) {
      paths.add(result['directoryPath']! as String);
    }

    for (final String path in paths) {
      final Directory directory = Directory(path);
      final List<FileSystemEntity> entitites =
          await directory.list(recursive: true).toList();

      for (final FileSystemEntity entity in entitites) {
        final String extensiton = p.extension(entity.path);
        if (AUDIO_MEDIA_TYPES.contains(extensiton)) {
          final Track track = await getMediaInfo(entity.path);
          print('Added ${track.trackName} to db');

          /// Adds album
          if (track.albumName != null) {
            _addCollectionToDatabase(Album(
              albumName: track.albumName!,
              albumAuthor: track.albumArtistName,
              albumArt: track.albumArt,
              albumLength: track.albumLength,
            ));
          }

          /// Adds media to database
          await _addAudiobookToDatabase(track);
        }
      }
    }
  }

  Future<Track> getMediaInfo(String mediaPath) async {
    final retriever = MetadataRetriever();
    await retriever.setFile(File(mediaPath));
    final Metadata metadata = await retriever.metadata;
    final Track _audiobook = Track.fromMap(metadata.toMap())
      ..path = mediaPath
      ..albumArt = retriever.albumArt;
    return _audiobook;
  }

  Future<void> _addCollectionToDatabase(Album album) async {
    final String collectionTable = LocalDatabase.albumsTable;
    final String newTracksTable = LocalDatabase.newTracksTable;

    localDatabase.database.transaction((txn) async {
      final int albumId = await txn.rawInsert('''
        INSERT OR IGNORE INTO $collectionTable (
          currentTrackId, albumDuration, albumName, albumAuthor,
          albumLength
        ) VALUES ( ?,?,?,?,?)
      ''', [
        album.currentTrackId,
        album.albumDuration,
        album.albumName,
        album.albumAuthor,
        album.albumLength,
      ]);

      if (albumId != 0) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO $newTracksTable 
            (albumId) VALUES (?)
        ''', [albumId]);
      }
    });
  }

  Future<void> _addAudiobookToDatabase(Track track) async {
    final String tracksTable = LocalDatabase.tracksTable;
    final String newTracksTable = LocalDatabase.newTracksTable;
    final String collectionTable = LocalDatabase.albumsTable;

    localDatabase.database.transaction((txn) async {
      int? albumId;
      if (track.albumName != null) {
        final resultsSet = await txn.query(collectionTable,
            columns: ['albumId'],
            where: 'albumName = ?',
            whereArgs: [track.albumName]);
        albumId = resultsSet.first['albumId'] as int?;
      }
      final int trackId = await txn.rawInsert('''
          INSERT OR IGNORE INTO $tracksTable
          (albumId, trackName, trackArtistNames,albumName,albumArtistName,
            trackNumber,albumLength, year,genre,authorName,
            writerName, discNumber, mimeType, trackDuration, bitrate, path, currentPosition, single
            ) VALUES (
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
          ) 
          
      ''', [
        albumId,
        track.trackName,
        if (track.trackArtistNames != null)
          track.trackArtistNames!.join('|').toString()
        else
          null,
        track.albumName,
        track.albumArtistName,
        track.trackNumber,
        track.albumLength,
        track.year,
        track.genre,
        track.authorName,
        track.writerName,
        track.discNumber,
        track.mimeType,
        track.trackDuration,
        track.bitrate,
        track.path,
        track.currentPosition,
      ]);

      // if (track.single == 1) {
      //   txn.rawInsert('''
      //     INSERT OR REPLACE INTO $newTracksTable
      //       (trackId, name) VALUES (?, ?)
      //   ''', [trackId, track.trackName]);
      // }
    });
  }
}
