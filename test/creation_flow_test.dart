import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/app.dart';

Future<void> _tapVisible(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('home → create → story → main game', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BeyondApp());
    await _tapVisible(tester, const Key('home-start'));

    await _tapVisible(tester, const Key('create-begin'));
    expect(find.byKey(const Key('story-begin')), findsNothing);

    await tester.enterText(find.byKey(const Key('name-field')), 'Mara');
    await tester.pumpAndSettle();

    for (var i = 0; i < 5; i++) {
      await _tapVisible(tester, const Key('alloc-plus-ATK'));
    }

    await _tapVisible(tester, const Key('create-begin'));
    expect(find.byKey(const Key('story-begin')), findsOneWidget);

    await _tapVisible(tester, const Key('story-begin'));
    expect(find.byKey(const Key('nav-map')), findsOneWidget);
    expect(find.text('MARA'), findsOneWidget);
  });
}
