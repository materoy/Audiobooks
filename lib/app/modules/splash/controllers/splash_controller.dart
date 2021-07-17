import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/modules/audio/audio_player_task.dart';
import 'package:audiobooks/app/modules/splash/controllers/database_controller.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:get/get.dart';

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
  Future onReady() async {
    super.onReady();

    /// Navigates to route [Library] when database is open
    databaseOpenStream((data) {
      if (data != null && data) Get.offAndToNamed(Routes.LIBRARY);
    });

    /// Starts the background audio service which runs on another isolate
    /// This is lazy loading to ensure it'll be available when needed
    /// when the audio is to be played, the service will be warmed up
    await startBackgroundAudioService();
  }

  @override
  void dispose() {
    super.dispose();
    databaseOpenStream(null).cancel();
  }
}

void _backgroundAudioEntryPoint() {
  AudioServiceBackground.run(
    () => AudioPlayerTask(),
  );
}

Future startBackgroundAudioService({Map<String, dynamic>? params}) async {
  /// Starts the background audio service
  await AudioService.start(
    backgroundTaskEntrypoint: _backgroundAudioEntryPoint,
    androidNotificationChannelName: 'Audiobooks',
    //androidStopForegroundOnPause: true,
    androidNotificationColor: 0xFF0683E9,
    androidShowNotificationBadge: true,
    params: params,
    androidEnableQueue: true,
  );
}
