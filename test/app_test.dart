// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:audiobooks/app/modules/home/views/home_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:audiobooks/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders home page', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
