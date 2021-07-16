import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:collection/collection.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
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
    // await _audioPlayer.set/
    await _audioPlayer.play();

    return super.onPlay();
  }

  @override
  Future<void> onPause() async {
    if (_audioPlayer.playing) _audioPlayer.pause();
    return super.onPause();
  }

  @override
  Future<void> onUpdateMediaItem(MediaItem mediaItem) async {
    if (!(AudioServiceBackground.mediaItem == mediaItem)) {
      await AudioServiceBackground.setMediaItem(mediaItem);
      await _audioPlayer.setFilePath(mediaItem.id);
    }
    return super.onUpdateMediaItem(mediaItem);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    if (!eq(AudioServiceBackground.queue, queue)) {
      await AudioServiceBackground.setQueue(queue);
    }
    try {
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children:
            queue.map((item) => AudioSource.uri(Uri.file(item.id))).toList(),
      ));
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
}
