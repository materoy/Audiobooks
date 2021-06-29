import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  AudioController({required this.audioPath});

  final AudioPlayer _audioPlayer = AudioPlayer();
  final String audioPath;

  void setAudioPath(String path) {}

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.setFilePath(audioPath);
  }
}
