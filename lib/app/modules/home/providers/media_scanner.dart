import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:audiobooks/app/data/models/audiobook_collection.dart';
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
          final Audiobook audiobook = await getMediaInfo(entity.path);
          print('Added ${audiobook.trackName} to db');

          /// Adds collection
          if (audiobook.albumName != null) {
            _addCollectionToDatabase(AudiobookCollection(
              collectionName: audiobook.albumName!,
              collectionAuthor: audiobook.albumArtistName,
              collectionArt: audiobook.albumArt,
              collectionLength: audiobook.albumLength,
            ));
          }

          /// Adds media to database
          await _addAudiobookToDatabase(audiobook);
        }
      }
    }
  }

  Future<Audiobook> getMediaInfo(String mediaPath) async {
    final retriever = MetadataRetriever();
    await retriever.setFile(File(mediaPath));
    final Metadata metadata = await retriever.metadata;
    final Audiobook _audiobook = Audiobook.fromMap(metadata.toMap())
      ..path = mediaPath
      ..single = metadata.albumName == null ? 1 : 0;
    return _audiobook;
  }

  Future<void> _addCollectionToDatabase(AudiobookCollection collection) async {
    final String collectionTable = LocalDatabase.audiobooksCollectionTable;
    final String unreadTable = LocalDatabase.unreadAudiobooksTable;

    localDatabase.database.transaction((txn) async {
      final int collectionId = await txn.rawInsert('''
        INSERT OR IGNORE INTO $collectionTable (
          currentTrackId, collectionDuration, collectionName, collectionAuthor,
          collectionLength
        ) VALUES ( ?,?,?,?,?)
      ''', [
        collection.currentTrackId,
        collection.collectionDuration,
        collection.collectionName,
        collection.collectionAuthor,
        collection.collectionLength,
      ]);

      if (collectionId != 0) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO $unreadTable 
            (collectionId, name) VALUES (?, ?)
        ''', [collectionId, collection.collectionName]);
      }
    });
  }

  Future<void> _addAudiobookToDatabase(Audiobook audiobook) async {
    final String aTable = LocalDatabase.audiobooksTable;
    final String unreadTable = LocalDatabase.unreadAudiobooksTable;
    final String collectionTable = LocalDatabase.audiobooksCollectionTable;

    localDatabase.database.transaction((txn) async {
      int? collectionId;
      if (audiobook.albumName != null) {
        final resultsSet = await txn.query(collectionTable,
            columns: ['collectionId'],
            where: 'collectionName = ?',
            whereArgs: [audiobook.albumName]);
        collectionId = resultsSet.first['collectionId'] as int?;
      }
      final int trackId = await txn.rawInsert('''
          INSERT OR IGNORE INTO $aTable
          (collectionId, trackName, trackArtistNames,albumName,albumArtistName,
            trackNumber,albumLength, year,genre,authorName,
            writerName, discNumber, mimeType, trackDuration, bitrate, path, currentPosition, single
            ) VALUES (
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
          ) 
          
      ''', [
        collectionId,
        audiobook.trackName,
        if (audiobook.trackArtistNames != null)
          audiobook.trackArtistNames!.join('|').toString()
        else
          null,
        audiobook.albumName,
        audiobook.albumArtistName,
        audiobook.trackNumber,
        audiobook.albumLength,
        audiobook.year,
        audiobook.genre,
        audiobook.authorName,
        audiobook.writerName,
        audiobook.discNumber,
        audiobook.mimeType,
        audiobook.trackDuration,
        audiobook.bitrate,
        audiobook.path,
        audiobook.currentPosition,
        audiobook.single,
      ]);

      if (audiobook.single == 1) {
        txn.rawInsert('''
          INSERT OR REPLACE INTO $unreadTable 
            (trackId, name) VALUES (?, ?)
        ''', [trackId, audiobook.trackName]);
      }
    });
  }
}
