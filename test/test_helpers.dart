import 'package:beyond_flutter/logic/character.dart';

/// A valid fixed character for widget tests (allocation totals 5).
Character testCharacter() => Character(
      name: 'Tester',
      heroClass: HeroClass.fallen,
      allocation: const {'ATK': 2, 'MAG': 1, 'DEF': 1, 'SPD': 1},
    );
