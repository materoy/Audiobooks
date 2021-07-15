import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/library/controllers/library_controller.dart';
import 'package:audiobooks/app/modules/shelf/controllers/shelf_controller.dart';
import 'package:audiobooks/app/modules/shelf/providers/shelf_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  PlayerProvider get _playerProvider =>
      PlayerProvider(Get.find<DatabaseController>().localDatabase);

  // AlbumController get _albumController =>
  //     Get.find<AlbumController>(tag: currentAlbumId.toString());

  late StreamSubscription<PlaybackState> Function(void Function(PlaybackState)?,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) playbackState;

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
    // await AudioService.updateQueue(_albumController.mediaItemsQueue);
    // await AudioService.updateMediaItem(_albumController.currentMediaItem);

    // final int currentPosition = await getCurrentPlayPosition();

    // await AudioService.seekTo(Duration(milliseconds: currentPosition));
    await AudioService.play();
    playbackState = AudioService.playbackStateStream.listen;

    if (Get.find<ShelfController>().shelf.shelfName == 'Recently added') {
      await moveFromRecentlyAddedToListening();
      await Get.find<LibraryController>().refreshShelves();
    }
  }

  Future moveToNextTrackOnFinish() async {
    // audioPlayer.durationStream.listen((event) {
    //   if (event != null && event.compareTo(audioPlayer.duration!) >= 0) {
    //     Get.find<AlbumController>(tag: currentAlbumId.toString())
    //         .goToNextTrack();
    //   }
    // });
  }

  Future<void> pause() async {
    if (AudioService.playbackState.playing) {
      _playing.value = false;
      // await updatePlayPosition(
      //     newPosition:
      //         AudioService.playbackState.currentPosition.inMilliseconds);
      await AudioService.pause();
      playbackState(null).cancel();
    }
  }

  // Future<void> updatePlayPosition({required int newPosition}) async {
  //   _playerProvider.updateCurrentTrackPosition(
  //       currentPosition: newPosition, trackId: currentTrackId);
  // }

  // Future<int> getCurrentPlayPosition() async {
  //   return _playerProvider.getCurrentTrackPlayPosition(currentTrackId);
  // }

  Future<void> moveFromRecentlyAddedToListening() async {
    final ShelfProvider shelfProvider =
        ShelfProvider(database: Get.find<DatabaseController>().localDatabase);

    shelfProvider.moveAlbumToAnotherShelf(
        fromShelfId: Get.find<ShelfController>().shelf.shelfId,
        toShelfName: 'Listening',
        albumId: currentAlbumId);
  }

  @override
  void onReady() {
    super.onReady();
  }
}
