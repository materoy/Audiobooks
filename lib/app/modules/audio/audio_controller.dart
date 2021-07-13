import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/audio/audio_player_task.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/library/controllers/library_controller.dart';
import 'package:audiobooks/app/modules/shelf/controllers/shelf_controller.dart';
import 'package:audiobooks/app/modules/shelf/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

void _backgroundAudioEntryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  PlayerProvider get _playerProvider =>
      PlayerProvider(Get.find<DatabaseController>().localDatabase);

  AlbumController get _albumController =>
      Get.find<AlbumController>(tag: currentAlbumId.toString());

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

  /// The function handles alot at a time
  /// Checks if there is any audio playing and pauses it
  /// Starts the audio player with the provider path
  /// If new path is provided new playback will start
  /// Subscribes to the playing position stream
  /// seeks to last played position
  /// If the album is in Recently added it moves it to now listening
  Future<void> play(String path) async {
    _playing.value = true;
    await setAudioPath(path);
    // AudioServiceBackground.setQueue(
    //     Get.find<AlbumController>(tag: currentAlbumId.toString())
    //         .mediaItemsQueue);

    await startBackgroundAudioService();
    // AudioServiceBackground.setMediaItem(_albumController.currentMediaItem);
    // print(AudioService.currentMediaItem!.id);

    // await AudioService.play();
    final int currentPosition = await getCurrentPlayPosition();
    await audioPlayer.seek(Duration(milliseconds: currentPosition));
    // await audioPlayer.play();
    // AudioServiceBackground.setMediaItem(
    //     MediaItem(id: path, album: 'Test', title: "Title"));

    await AudioService.playMediaItem(
        MediaItem(id: path, album: "album", title: 'title'));
    audioPlayer.durationStream.listen((event) {
      if (event != null && event.compareTo(audioPlayer.duration!) >= 0) {
        Get.find<AlbumController>(tag: currentAlbumId.toString())
            .goToNextTrack();
      }
    });

    if (Get.find<ShelfController>().shelf.shelfName == 'Recently added') {
      await moveFromRecentlyAddedToListening();
      await Get.find<LibraryController>().refreshShelves();
    }
  }

  Future startBackgroundAudioService() async {
    /// Starts the background audio service
    await AudioService.start(
      backgroundTaskEntrypoint: _backgroundAudioEntryPoint,
      androidNotificationChannelName: 'Audiobooks',
      // Enable this if you want the Android service to exit the foreground state on pause.
      //androidStopForegroundOnPause: true,
      androidNotificationColor: 0xFF0683E9,
      androidEnableQueue: true,
    );
  }

  Future<void> pause() async {
    await updatePlayPosition();
    // if (audioPlayer.playing) {
    _playing.value = false;
    // audioPlayer.pause();
    AudioService.pause();
    // AudioService.stop();
    // }
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
