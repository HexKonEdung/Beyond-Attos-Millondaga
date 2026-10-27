import 'package:beyond_flutter/logic/character.dart';
import 'package:beyond_flutter/logic/player_state.dart';

/// A valid fixed character for widget tests (allocation totals 5).
Character testCharacter() => Character(
      name: 'Tester',
      heroClass: HeroClass.fallen,
      allocation: const {'ATK': 2, 'MAG': 1, 'DEF': 1, 'SPD': 1},
    );

/// Player with the test character's max HP (92). Pass [hp] to start lower.
PlayerState testPlayer({int? hp}) => PlayerState(
      maxHp: testCharacter().finalStats['HP']!,
      hp: hp,
    );
