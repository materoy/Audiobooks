import 'dart:async';
import 'dart:io';

import 'package:audiobooks/app/data/models/audiobook.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as p;

import 'package:audiobooks/app/utils/database.dart';

class MediaScanner {
  MediaScanner(this.localDatabase);
  final LocalDatabase localDatabase;

  /// These are the audiobok media types accepted
  static const List<String> AUDIO_MEDIA_TYPES = ['.mp3'];

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
          print(audiobook.path);
        }
      }
    }
  }

  Future<Audiobook> getMediaInfo(String mediaPath) async {
    final retriever = MetadataRetriever();
    await retriever.setFile(File(mediaPath));
    final Metadata metadata = await retriever.metadata;
    final Audiobook _audiobook = Audiobook.fromMap(metadata.toMap())
      ..path = mediaPath;
    return _audiobook;
  }
}
