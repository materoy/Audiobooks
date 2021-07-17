import 'dart:async';

import 'package:audio_service/audio_service.dart';

import 'package:get/get.dart';

class AudioController extends GetxController {
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

}
