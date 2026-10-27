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
  testWidgets('inventory: using a tonic consumes one and updates the count',
      (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
        BeyondApp(home: MainShell(character: testCharacter())));

    await _tapVisible(tester, const Key('nav-inventory'));
    expect(find.text('FIELD TONIC ×3'), findsOneWidget);

    await _tapVisible(tester, const Key('use-tonic'));
    expect(find.text('FIELD TONIC ×2'), findsOneWidget);
  });
}
