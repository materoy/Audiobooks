import 'package:get/get.dart';

import 'package:audiobooks/app/modules/book_player/bindings/book_player_binding.dart';
import 'package:audiobooks/app/modules/book_player/views/book_player_view.dart';
import 'package:audiobooks/app/modules/finished/bindings/finished_binding.dart';
import 'package:audiobooks/app/modules/finished/views/finished_view.dart';
import 'package:audiobooks/app/modules/home/bindings/home_binding.dart';
import 'package:audiobooks/app/modules/home/views/home_view.dart';
import 'package:audiobooks/app/modules/media_folders/bindings/media_folders_binding.dart';
import 'package:audiobooks/app/modules/media_folders/views/media_folders_view.dart';
import 'package:audiobooks/app/modules/now_listening/bindings/now_listening_binding.dart';
import 'package:audiobooks/app/modules/now_listening/views/now_listening_view.dart';
import 'package:audiobooks/app/modules/unread/bindings/unread_binding.dart';
import 'package:audiobooks/app/modules/unread/views/unread_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_PLAYER,
      page: () => BookPlayerView(),
      binding: BookPlayerBinding(),
    ),
    GetPage(
      name: _Paths.NOW_LISTENING,
      page: () => NowListeningView(),
      binding: NowListeningBinding(),
    ),
    GetPage(
      name: _Paths.FINISHED,
      page: () => FinishedView(),
      binding: FinishedBinding(),
    ),
    GetPage(
      name: _Paths.UNREAD,
      page: () => UnreadView(),
      binding: UnreadBinding(),
    ),
    GetPage(
      name: _Paths.MEDIA_FOLDERS,
      page: () => MediaFoldersView(),
      binding: MediaFoldersBinding(),
    ),
  ];
}
