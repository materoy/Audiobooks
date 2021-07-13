import 'dart:async';
import 'dart:developer' as dev;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audiobooks/app/modules/audio/audio_controller.dart';
import 'package:audiobooks/app/modules/home/controllers/album_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerTask extends BackgroundAudioTask {
  // AudioPlayerTask({required this.albumId});

  // final int albumId;
  final AudioPlayer _player = AudioPlayer();
  AudioProcessingState? _skipState;
  Seeker? _seeker;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  AudioController get _audioController => Get.find<AudioController>();
  AlbumController get _albumController => Get.find<AlbumController>(
      tag: _audioController.currentAlbumId.toString());

  // List<MediaItem> get queue => _albumController.mediaItemsQueue;
  MediaItem? get mediaItem =>
      _albumController.getMediaItemFromTrack(_albumController.currentTrack);

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    dev.log('You know what it started');
    AudioService.connect();

    // Broadcast media item changes.
    // _player.currentIndexStream.listen((index) {
    //   print(index);
    //   if (index != null) {
    //     // AudioServiceBackground.setMediaItem(_albumController
    //     //     .getMediaItemFromTrack(_albumController.currentTrack));
    //   }
    // });
    // // Propagate all events from the audio player to AudioService clients.
    // _eventSubscription = _player.playbackEventStream.listen((event) {
    //   _broadcastState();
    // });
    // // Special processing for state transitions.
    // _player.processingStateStream.listen((state) {
    //   switch (state) {
    //     case ProcessingState.completed:
    //       // In this example, the service stops when reaching the end.
    //       onStop();
    //       break;
    //     case ProcessingState.ready:
    //       // If we just came from skipping between tracks, clear the skip
    //       // state now that we're ready to play.
    //       _skipState = null;
    //       break;
    //     default:
    //       break;
    //   }
    // });

    // Load and broadcast the queue
    // AudioServiceBackground.setQueue(_albumController.mediaItemsQueue);
    // try {
    //   await _player.setAudioSource(ConcatenatingAudioSource(
    //     children: _albumController.mediaItemsQueue
    //         .map((item) => AudioSource.uri(Uri.file(item.id)))
    //         .toList(),
    //   ));

    //   // In this example, we automatically start playing on start.
    //   onPlay();
    // } catch (e) {
    //   print("Error: $e");
    //   onStop();
    // }
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.
    final newIndex = _albumController.mediaItemsQueue
        .indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could use for skipping to next and
    // previous. This variable holds the preferred state to send instead of
    // buffering during a skip, and it is cleared as soon as the player exits
    // buffering (see the listener in onStart).

    /// TODO: Add skip item

    // _skipState = newIndex > index!
    //     ? AudioProcessingState.skippingToNext
    //     : AudioProcessingState.skippingToPrevious;
    // This jumps to the beginning of the queue item at newIndex.
    _player.seek(Duration.zero, index: newIndex);
    // Demonstrate custom events.
    AudioServiceBackground.sendCustomEvent('skip to $newIndex');
  }

  @override
  Future<void> onPlay() {
    dev.log("Now playing");
    dev.log(_player.isBlank.toString());

    return _player.play();
  }

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  @override
  Future<void> onStop() async {
    await _player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem!.duration!) newPosition = mediaItem!.duration!;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }

  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.
  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(_player, Duration(seconds: 10 * direction),
          const Duration(seconds: 1), mediaItem!)
        ..start();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
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
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_player.processingState) {
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
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}

class QueueState {
  final List<MediaItem>? queue;
  final MediaItem? mediaItem;

  QueueState(this.queue, this.mediaItem);
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

/// An object that performs interruptable sleep.
class Sleeper {
  Completer? _blockingCompleter;

  /// Sleep for a duration. If sleep is interrupted, a
  /// [SleeperInterruptedException] will be thrown.
  Future<void> sleep([Duration? duration]) async {
    _blockingCompleter = Completer();
    if (duration != null) {
      await Future.any([Future.delayed(duration), _blockingCompleter!.future]);
    } else {
      await _blockingCompleter!.future;
    }
    final interrupted = _blockingCompleter!.isCompleted;
    _blockingCompleter = null;
    if (interrupted) {
      throw SleeperInterruptedException();
    }
  }

  /// Interrupt any sleep that's underway.
  void interrupt() {
    if (_blockingCompleter?.isCompleted == false) {
      _blockingCompleter!.complete();
    }
  }
}

class SleeperInterruptedException {}

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
    this.player,
    this.positionInterval,
    this.stepInterval,
    this.mediaItem,
  );

  Future<void> start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration!) newPosition = mediaItem.duration!;
      player.seek(newPosition);
      await Future.delayed(stepInterval);
    }
  }

  void stop() {
    _running = false;
  }
}
