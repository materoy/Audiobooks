import 'package:get/get.dart';

import 'package:audiobooks/app/modules/home/bindings/home_binding.dart';
import 'package:audiobooks/app/modules/home/views/home_view.dart';
import 'package:audiobooks/app/modules/library/bindings/library_binding.dart';
import 'package:audiobooks/app/modules/library/views/library_view.dart';
import 'package:audiobooks/app/modules/media_folders/bindings/media_folders_binding.dart';
import 'package:audiobooks/app/modules/media_folders/views/media_folders_view.dart';
import 'package:audiobooks/app/modules/player/bindings/player_binding.dart';
import 'package:audiobooks/app/modules/player/views/player_view.dart';
import 'package:audiobooks/app/modules/settings/bindings/settings_binding.dart';
import 'package:audiobooks/app/modules/settings/views/settings_view.dart';
import 'package:audiobooks/app/modules/splash/bindings/splash_binding.dart';
import 'package:audiobooks/app/modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MEDIA_FOLDERS,
      page: () => MediaFoldersDialog(),
      binding: MediaFoldersBinding(),
    ),
    GetPage(
      name: _Paths.PLAYER,
      page: () => PlayerView(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LIBRARY,
      page: () => LibraryView(),
      binding: LibraryBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
