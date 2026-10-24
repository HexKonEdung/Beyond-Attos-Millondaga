/// Playable base classes from the design (two for the MVP).
enum HeroClass {
  fallen(
    displayName: 'Fallen',
    role: 'Dark damage · Life drain',
    evolution: 'Wraithblade → Deathbringer → Abyssal Reaper',
    description:
        'A high-risk fighter who turns pain into devastating physical and magical attacks.',
    baseStats: {
      'HP': 92, 'MP': 74, 'ATK': 16, 'MAG': 15,
      'DEF': 7, 'RES': 8, 'SPD': 12, 'LUK': 10,
    },
  ),
  scavenger(
    displayName: 'Scavenger',
    role: 'Agile crit · Item specialist',
    evolution: 'Bounty Hunter → Shadow Raider → Phantom Marauder',
    description:
        'A resourceful fighter who wins through speed, critical strikes, and improved items.',
    baseStats: {
      'HP': 105, 'MP': 52, 'ATK': 14, 'MAG': 7,
      'DEF': 10, 'RES': 9, 'SPD': 17, 'LUK': 16,
    },
  );

  const HeroClass({
    required this.displayName,
    required this.role,
    required this.evolution,
    required this.description,
    required this.baseStats,
  });

  final String displayName;
  final String role;
  final String evolution;
  final String description;
  final Map<String, int> baseStats;
}

/// A player character. Stats = class base + bonus points from creation.
class Character {
  Character({
    required this.name,
    required this.heroClass,
    required Map<String, int> allocation,
  }) : allocation = Map.unmodifiable(allocation);

  final String name;
  final HeroClass heroClass;

  /// Bonus points spent on ATK, MAG, DEF, RES, SPD, LUK.
  final Map<String, int> allocation;

  int get level => 1;
  int get ep => 0;

  Map<String, int> get finalStats => {
        for (final entry in heroClass.baseStats.entries)
          entry.key: entry.value + (allocation[entry.key] ?? 0),
      };
}
