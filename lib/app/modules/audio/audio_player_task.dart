import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    await AudioServiceBackground.setState(
      controls: [MediaControl.play, MediaControl.pause],
      playing: true,
      processingState: AudioProcessingState.none,
    );
    return super.onStart(params);
  }

  @override
  Future<void> onPlay() async {
    AudioServiceBackground.setState(
      controls: [MediaControl.play, MediaControl.pause],
      playing: true,
      processingState: AudioProcessingState.none,
    );

    await _audioPlayer.play();
    return super.onPlay();
  }

  @override
  Future<void> onPause() {
    if (_audioPlayer.playing) _audioPlayer.pause();
    return super.onPause();
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    await AudioServiceBackground.setMediaItem(mediaItem);
    await _audioPlayer.setFilePath(mediaItem.id);
    await _audioPlayer.play();
    return super.onPlayMediaItem(mediaItem);
  }

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    await _audioPlayer.setFilePath(mediaId);
    await _audioPlayer.play();
    AudioServiceBackground.setState(
      controls: [MediaControl.play, MediaControl.pause],
      playing: true,
      processingState: AudioProcessingState.ready,
    );
    return super.onPlayFromMediaId(mediaId);
  }
}
