import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/app.dart';
import 'package:beyond_flutter/ui/shell/main_shell.dart';

import 'test_helpers.dart';

Future<void> _tapVisible(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('objective → new route → battle → victory → continue',
      (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
        BeyondApp(home: MainShell(character: testCharacter())));

    await _tapVisible(tester, const Key('nav-adventure'));
    await _tapVisible(tester, const Key('route-whispering_wood'));

    // Complete the objective: the Old Watch route opens.
    await _tapVisible(tester, const Key('objective-search'));
    expect(find.text('[ GO TO THE OLD WATCH ]'), findsOneWidget);

    // Fight the Mire Hound in Whispering Wood until victory.
    await _tapVisible(tester, const Key('fight-hound'));
    expect(find.byKey(const Key('battle-strike')), findsOneWidget);
    for (var i = 0; i < 7; i++) {
      await _tapVisible(tester, const Key('battle-strike'));
    }
    expect(find.textContaining('Victory!'), findsWidgets);

    await _tapVisible(tester, const Key('battle-continue'));
    expect(find.byKey(const Key('fight-hound')), findsOneWidget);
    expect(find.text('[ GO TO THE OLD WATCH ]'), findsOneWidget);
  });
}
