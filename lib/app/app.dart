// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:audiobooks/app/modules/splash/bindings/splash_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:audiobooks/l10n/l10n.dart';
import 'package:get/get.dart';

import 'data/theme/theme.dart';
import 'routes/app_pages.dart';
import 'utils/size_config.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes().lightTheme,
      // darkTheme: Themes.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      title: 'Audiobooks',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: SplashBinding(),
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        SizeConfig().init(context);
        return child!;
      },
    );
  }
}
