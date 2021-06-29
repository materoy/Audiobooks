import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _audioPath = ''.obs;
  final _audioDuration = const Duration().obs;

  String get audioPath => _audioPath.value;
  Duration get audioDuration => _audioDuration.value;
  bool get playing => _audioPlayer.playing;

  Future<void> setAudioPath(String path) async {
    if (_audioPath.value != path) {
      _audioPath.value = path;
      _audioDuration.value = (await _audioPlayer.setFilePath(path))!;
    }
  }

  Future<void> play(String path) async {
    await setAudioPath(path);
    await _audioPlayer.play();
  }

  void pause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   _audioPlayer.setFilePath(audioPath);
  // }
}
