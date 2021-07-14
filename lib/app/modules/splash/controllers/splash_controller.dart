import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/audio/audio_player_task.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:get/get.dart';

void _backgroundAudioEntryPoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

Future startBackgroundAudioService() async {
  /// Starts the background audio service
  await AudioService.start(
    backgroundTaskEntrypoint: _backgroundAudioEntryPoint,
    androidNotificationChannelName: 'Audiobooks',
    //androidStopForegroundOnPause: true,
    androidNotificationColor: 0xFF0683E9,
    androidEnableQueue: true,
  );
}

class SplashController extends GetxController {
  // final DatabaseController _databaseController = Get.find<DatabaseController>();

  final _ready = false.obs;
  set ready(bool value) => _ready.value = value;
  bool get ready => _ready.value;

  late final StreamSubscription<bool?> Function(void Function(bool?)?,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) databaseOpenStream;

  @override
  Future onInit() async {
    super.onInit();
    databaseOpenStream =
        Get.find<DatabaseController>().databaseOpen.stream.listen;
    await AudioService.connect();
  }

  @override
  void onReady() {
    super.onReady();

    /// Navigates to route [Library] when database is open
    databaseOpenStream((data) {
      if (data != null && data) Get.offAndToNamed(Routes.LIBRARY);
      startBackgroundAudioService();
    });
  }

  @override
  void dispose() {
    super.dispose();
    databaseOpenStream(null).cancel();
  }
}
