import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/app.dart';
import 'package:beyond_flutter/logic/game_shell_state.dart';

void main() {
  testWidgets('starts on Character with all five nav items', (tester) async {
    await tester.pumpWidget(const BeyondApp());

    for (final tab in GameTab.values) {
      expect(find.byKey(Key('nav-${tab.name}')), findsOneWidget);
    }
    expect(find.byKey(const Key('title-character')), findsOneWidget);
  });

  testWidgets('each nav item shows its own page', (tester) async {
    await tester.pumpWidget(const BeyondApp());

    for (final tab in GameTab.values) {
      await tester.tap(find.byKey(Key('nav-${tab.name}')));
      await tester.pump();
      expect(find.byKey(Key('title-${tab.name}')), findsOneWidget,
          reason: 'Expected ${tab.name} page to be visible');
    }
  });

  testWidgets('selecting a map area does not move the player', (tester) async {
    await tester.pumpWidget(const BeyondApp());

    await tester.tap(find.byKey(const Key('nav-map')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('map-area-whispering_wood')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('nav-adventure')));
    await tester.pump();
    final currentArea = tester
        .widget<Text>(find.byKey(const Key('adventure-current-area')))
        .data;
    expect(currentArea, 'GREYHAVEN');
  });

  testWidgets('player can always return to Adventure from any tab',
      (tester) async {
    await tester.pumpWidget(const BeyondApp());

    await tester.tap(find.byKey(const Key('nav-settings')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('nav-adventure')));
    await tester.pump();
    expect(find.byKey(const Key('title-adventure')), findsOneWidget);
  });
}
