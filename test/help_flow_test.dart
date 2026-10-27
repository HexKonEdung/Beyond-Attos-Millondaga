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
  testWidgets('settings → help & rules shows the rules and returns',
      (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
        BeyondApp(home: MainShell(character: testCharacter())));

    await _tapVisible(tester, const Key('nav-settings'));
    await _tapVisible(tester, const Key('open-help'));

    expect(find.byKey(const Key('help-title')), findsOneWidget);
    expect(find.text('BATTLE ACTIONS'), findsOneWidget);
    expect(find.text('KNOWN THREATS'), findsOneWidget);
    expect(find.textContaining('Field tonic'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('open-help')), findsOneWidget);
  });
}
