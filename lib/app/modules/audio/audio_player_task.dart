import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:collection/collection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final DatabaseController _databaseController;

  PlayerProvider get _playerProvider =>
      PlayerProvider(_databaseController.localDatabase);

  AudioProcessingState? _skipState;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  final Function eq = const ListEquality().equals;

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _audioPlayer.playing,
      position: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }

  Future<void> updatePlayPosition({required Duration newPosition}) async {
    _playerProvider.updateCurrentTrackPosition(
        currentPosition: newPosition.inMilliseconds,
        path: AudioServiceBackground.mediaItem!.id);
  }

  Future<int> getCurrentPlayPosition(String path) async {
    return _playerProvider.getCurrentTrackPlayPosition(path);
  }

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    await GetStorage.init();
    // _databaseController = params['databaseController'];
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        onUpdateMediaItem(AudioServiceBackground.queue![index]);
      }
    });
    _audioPlayer.playbackEventStream.listen((event) async {
      await AudioServiceBackground.setState(
        controls: [
          MediaControl.skipToPrevious,
          if (AudioService.playbackState.playing)
            MediaControl.pause
          else
            MediaControl.play,
          MediaControl.skipToNext
        ],
        playing: true,
        processingState: AudioProcessingState.none,
        position: event.updatePosition,
      );
    });
// Propagate all events from the audio player to AudioService clients.
    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      _broadcastState();
    });
    return super.onStart(params);
  }

  @override
  Future<void> onPlay() async {
    await _audioPlayer.play();
    return super.onPlay();
  }

  @override
  Future<void> onPause() async {
    if (_audioPlayer.playing) await _audioPlayer.pause();
    await updatePlayPosition(newPosition: _audioPlayer.position);
    return super.onPause();
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    if (AudioServiceBackground.mediaItem != mediaItem) {
      await AudioServiceBackground.setMediaItem(mediaItem);
      await AudioServiceBackground.notifyChildrenChanged();
      final int position = await getCurrentPlayPosition(mediaItem.id);
      await onSeekTo(Duration(milliseconds: position));
    }
    return super.onUpdateMediaItem(mediaItem);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    if (!eq(AudioServiceBackground.queue, queue)) {
      log('Update queue');
      await AudioServiceBackground.setQueue(queue);
    }
    try {
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children:
            queue.map((item) => AudioSource.uri(Uri.file(item.id))).toList(),
      ));

      await _audioPlayer.load();
    } catch (e) {
      print("Error: $e");
      onStop();
    }
    return super.onUpdateQueue(queue);
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await _audioPlayer.seek(position);
    return super.onSeekTo(position);
  }

  @override
  Future<void> onSkipToNext() {
    _audioPlayer.seekToNext();
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    _audioPlayer.seekToPrevious();
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    // // Then default implementations of onSkipToNext and onSkipToPrevious will
    // // delegate to this method.
    // final newIndex = queue.indexWhere((item) => item.id == mediaId);
    // if (newIndex == -1) return;
    // // During a skip, the player may enter the buffering state. We could just
    // // propagate that state directly to AudioService clients but AudioService
    // // has some more specific states we could use for skipping to next and
    // // previous. This variable holds the preferred state to send instead of
    // // buffering during a skip, and it is cleared as soon as the player exits
    // // buffering (see the listener in onStart).
    // _skipState = newIndex > index!
    //     ? AudioProcessingState.skippingToNext
    //     : AudioProcessingState.skippingToPrevious;
    // // This jumps to the beginning of the queue item at newIndex.
    // _audioPlayer.seek(Duration.zero, index: newIndex);
    // // Demonstrate custom events.
    // AudioServiceBackground.sendCustomEvent('skip to $newIndex');
  }

  @override
  Future onCustomAction(String name, arguments) {
    switch (name) {
      case "DatabaseController":
        log("I just found the db controller");
        break;
      default:
    }
    return super.onCustomAction(name, arguments);
  }
}
