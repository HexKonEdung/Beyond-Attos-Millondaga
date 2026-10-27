import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/help_data.dart';

void main() {
  final sections = buildHelpSections();
  final titles = sections.map((s) => s.title).toList();

  test('help covers navigation, battle, rewards, items, unlocking, defeat, threats', () {
    expect(titles, containsAll([
      'Navigation',
      'Battle actions',
      'XP, EP, and coins',
      'Items',
      'Locations and unlocking',
      'Defeat',
      'Known threats',
    ]));
  });

  test('help text uses live rewards and tonic values', () {
    final all = sections.expand((s) => s.lines).join('\n');
    expect(all, contains('+15 XP'));
    expect(all, contains('restores 24 HP'));
    expect(all, contains('Mire Hound (COMMON)'));
  });

  test('every section has at least one line', () {
    for (final section in sections) {
      expect(section.lines, isNotEmpty, reason: section.title);
    }
  });
}
