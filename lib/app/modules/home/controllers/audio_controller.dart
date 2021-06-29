import 'dart:developer';

import 'package:audiobooks/app/modules/home/controllers/home_controller.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerProvider get _playerProvider =>
      PlayerProvider(Get.find<HomeController>().localDatabase);

  int? _currentTrackId;
  set currentTrackId(int trackId) => _currentTrackId = trackId;
  int get currentTrackId => _currentTrackId!;

  final _audioPath = ''.obs;
  final _audioDuration = const Duration().obs;
  final _playing = false.obs;

  String get audioPath => _audioPath.value;
  Duration get audioDuration => _audioDuration.value;
  bool get playing => _playing.value;

  Future<void> setAudioPath(String path) async {
    if (_audioPath.value != path) {
      _audioPath.value = path;
      _audioDuration.value = (await _audioPlayer.setFilePath(path))!;
    }
  }

  Future<void> play(String path) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    }
    await setAudioPath(path);
    final int currentPosition = await getCurrentPlayPosition();
    await _audioPlayer.seek(Duration(milliseconds: currentPosition));
    _playing.value = true;
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await updatePlayPosition();
    if (_audioPlayer.playing) {
      _playing.value = false;
      _audioPlayer.pause();
    }
  }

  Future<void> updatePlayPosition() async {
    _playerProvider.updateCurrentTrackPosition(
        currentPosition: _audioPlayer.position.inMilliseconds,
        trackId: _currentTrackId!);
  }

  Future<int> getCurrentPlayPosition() async {
    return _playerProvider.getCurrentTrackPlayPosition(_currentTrackId!);
  }

  @override
  void onInit() {
    super.onInit();
    if (_audioPath.value != '') {
      _audioPlayer.setFilePath(audioPath);
    }
  }
}
