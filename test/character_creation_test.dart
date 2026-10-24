import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/character.dart';
import 'package:beyond_flutter/logic/character_creation.dart';

void main() {
  const fiveAtk = {'ATK': 5};

  test('empty or blank name is rejected', () {
    final issues = validateCreation(
        name: '   ', heroClass: HeroClass.fallen, allocation: fiveAtk);
    expect(issues, contains(CreationIssue.emptyName));
  });

  test('name longer than 16 characters is rejected', () {
    final issues = validateCreation(
        name: 'A' * 17, heroClass: HeroClass.fallen, allocation: fiveAtk);
    expect(issues, contains(CreationIssue.nameTooLong));
  });

  test('missing class is rejected', () {
    final issues =
        validateCreation(name: 'Mara', heroClass: null, allocation: fiveAtk);
    expect(issues, contains(CreationIssue.noClass));
  });

  test('bonus points must total exactly 5', () {
    expect(
        validateCreation(
            name: 'Mara', heroClass: HeroClass.fallen, allocation: const {'ATK': 4}),
        contains(CreationIssue.wrongPointTotal));
    expect(
        validateCreation(
            name: 'Mara', heroClass: HeroClass.fallen, allocation: const {'ATK': 6}),
        contains(CreationIssue.wrongPointTotal));
  });

  test('complete valid draft has no issues', () {
    expect(
        validateCreation(
            name: 'Mara', heroClass: HeroClass.fallen, allocation: fiveAtk),
        isEmpty);
  });

  test('final stats = class base + bonus points', () {
    final character = Character(
        name: 'Mara', heroClass: HeroClass.fallen, allocation: fiveAtk);
    expect(character.finalStats['ATK'], 16 + 5);
    expect(character.finalStats['HP'], 92);
  });
}
