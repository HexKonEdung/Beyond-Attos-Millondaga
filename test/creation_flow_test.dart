import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/app.dart';

void main() {
  testWidgets('home → create → story → main game', (tester) async {
    await tester.pumpWidget(const BeyondApp());

    await tester.tap(find.byKey(const Key('home-start')));
    await tester.pumpAndSettle();

    // Begin is blocked: no name, and no points allocated yet.
    await tester.tap(find.byKey(const Key('create-begin')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('story-begin')), findsNothing);

    await tester.enterText(find.byKey(const Key('name-field')), 'Mara');
    await tester.pump();
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byKey(const Key('alloc-plus-ATK')));
      await tester.pump();
    }

    await tester.tap(find.byKey(const Key('create-begin')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('story-begin')), findsOneWidget);

    await tester.tap(find.byKey(const Key('story-begin')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('nav-map')), findsOneWidget);
    expect(find.text('MARA'), findsOneWidget);
  });
}
