import 'dart:developer';

import 'package:audiobooks/app/modules/home/controllers/home_controller.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/home/providers/track_provider.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  PlayerProvider get _playerProvider =>
      PlayerProvider(Get.find<HomeController>().localDatabase);

  TrackProvider get _trackProvider =>
      TrackProvider(Get.find<HomeController>().localDatabase);

  late int? _currentTrackId;
  late int? _currentEntryId;
  set currentTrackId(int value) => _currentTrackId = value;
  set currentEntryId(int value) => _currentEntryId = value;
  int get currentTrackId => _currentTrackId!;
  int get currentEntryId => _currentEntryId!;

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
    final int currentPosition = await getCurrentPlayPosition();
    await audioPlayer.seek(Duration(milliseconds: currentPosition));
    _playing.value = true;
    await audioPlayer.play();
    if (Get.find<HomeController>().tabState == TabState.Unread) {
      moveFromUnreadToReading();
    }
  }

  Future<void> pause() async {
    await updatePlayPosition();
    if (audioPlayer.playing) {
      _playing.value = false;
      audioPlayer.pause();
    }
  }

  Future<void> updatePlayPosition() async {
    _playerProvider.updateCurrentTrackPosition(
        currentPosition: audioPlayer.position.inMilliseconds,
        trackId: _currentTrackId!);
  }

  Future<int> getCurrentPlayPosition() async {
    return _playerProvider.getCurrentTrackPlayPosition(_currentTrackId!);
  }

  Future<void> moveFromUnreadToReading() async {
    await _trackProvider.changeReadingState(
        trackEntryId: _currentEntryId!,
        fromTable: LocalDatabase.unreadTracksTable,
        toTable: LocalDatabase.nowListeningTracksTable);
    log('Moved to now reading ');
  }

  Stream<Duration> streamPosition() async* {
    if (audioPlayer.playing) {
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
