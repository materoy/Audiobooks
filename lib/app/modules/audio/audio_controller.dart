import 'dart:developer';

import 'package:audiobooks/app/modules/home/providers/album_provider.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/library/controllers/library_controller.dart';
import 'package:audiobooks/app/modules/shelf/controllers/shelf_controller.dart';
import 'package:audiobooks/app/modules/shelf/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  PlayerProvider get _playerProvider =>
      PlayerProvider(Get.find<DatabaseController>().localDatabase);

  late int currentTrackId;
  late int currentAlbumId;

  final _audioPath = ''.obs;
  final _audioDuration = const Duration().obs;
  final _playing = false.obs;

  String get audioPath => _audioPath.value;
  Duration get audioDuration => _audioDuration.value;
  bool get playing => _playing.value;

  Future<void> setAudioPath(String path) async {
    if (_audioPath.value != path) {
      _audioPath.value = path;
      _audioDuration.value = (await audioPlayer.setFilePath(path))!;
    }
  }

  Future<void> play(String path) async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    }
    await setAudioPath(path);
    streamPosition().listen((event) {});
    final int currentPosition = await getCurrentPlayPosition();
    await audioPlayer.seek(Duration(milliseconds: currentPosition));
    _playing.value = true;
    await audioPlayer.play();
    if (Get.find<ShelfController>().shelf.shelfName == 'Recently added') {
      await moveFromRecentlyAddedToListening();
      await Get.find<LibraryController>().refreshShelves();
      print("Hello earthling");
    }
  }

  Future<void> pause() async {
    await updatePlayPosition();
    if (audioPlayer.playing) {
      _playing.value = false;
      audioPlayer.pause();
    }
  }

  Future<void> updatePlayPosition({int? newPosition}) async {
    _playerProvider.updateCurrentTrackPosition(
        currentPosition: newPosition ?? audioPlayer.position.inMilliseconds,
        trackId: currentTrackId);
  }

  Future<int> getCurrentPlayPosition() async {
    return _playerProvider.getCurrentTrackPlayPosition(currentTrackId);
  }

  Future<void> moveFromRecentlyAddedToListening() async {
    final ShelfProvider shelfProvider =
        ShelfProvider(database: Get.find<DatabaseController>().localDatabase);

    shelfProvider.moveAlbumToAnotherShelf(
        fromShelfId: Get.find<ShelfController>().shelf.shelfId,
        toShelfName: 'Listening',
        albumId: currentAlbumId);

    log('Moved to listening');
  }

  Stream<Duration> streamPosition() async* {
    if (audioPlayer.playing) {
      print(audioPlayer.position);
      yield* audioPlayer.positionStream;
    } else {
      final int currentPosition = await getCurrentPlayPosition();
      yield Duration(milliseconds: currentPosition);
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (_audioPath.value != '') {
      audioPlayer.setFilePath(audioPath);
    }
  }
}
