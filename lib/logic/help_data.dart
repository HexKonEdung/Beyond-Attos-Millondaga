import 'battle.dart';
import 'objectives.dart';
import 'player_state.dart';
import 'world_data.dart';

/// One titled block of rules text on the Help & Rules page.
class HelpSection {
  const HelpSection({required this.title, required this.lines});

  final String title;
  final List<String> lines;
}

/// Help text built from live game constants, so it never disagrees with the rules.
List<HelpSection> buildHelpSections() => [
      HelpSection(
        title: 'Navigation',
        lines: [
          'Five tabs at the bottom: Character, Adventure, Inventory, Map, and Settings.',
          'Adventure is where you move between areas and fight.',
          'Map shows areas. Selecting one only shows its details. It never moves you.',
          'You can switch tabs at any time. A battle keeps its place while you look around.',
        ],
      ),
      HelpSection(
        title: 'Battle actions',
        lines: [
          "Strike: deals your ATK minus half the enemy's DEF. Uses your turn.",
          'Item: uses a Field tonic. Uses your turn, so the enemy still strikes back.',
          'Skill, Interact, Prepare, and Flee are planned and not yet available.',
          'After each of your turns, the enemy strikes back for a fixed amount.',
        ],
      ),
      HelpSection(
        title: 'XP, EP, and coins',
        lines: [
          'Defeating an enemy rewards XP (experience), EP (evolution points), and coins.',
          'Mire Hound: ${mireHound.rewards.summary}.',
          'Rewards are granted once per victory.',
          'XP and EP are shown on the Character tab. Coins are shown on the Inventory tab.',
        ],
      ),
      HelpSection(
        title: 'Items',
        lines: [
          'Field tonic: restores $kTonicHealing HP, up to your maximum HP.',
          'Each tonic is used once. Used tonics stay used.',
          'Use a tonic in battle (Item) or from the Inventory tab outside battle.',
          'Other items and equipment are planned for later builds.',
        ],
      ),
      HelpSection(
        title: 'Locations and unlocking',
        lines: [
          'Greyhaven is your starting town.',
          'Whispering Wood is open from the start.',
          'Locked routes show what is required to open them.',
          'Complete the objective below to open The Old Watch.',
        ],
      ),
      HelpSection(
        title: 'Defeat',
        lines: [
          'If your HP reaches 0, the encounter ends in defeat.',
          'You return to Greyhaven with full HP.',
          'Kept after defeat: XP, EP, coins, completed objectives, unlocked routes, and used tonics.',
        ],
      ),
      HelpSection(
        title: 'Known threats',
        lines: [
          for (final area in mvpAreas) '${area.name}: threat ${area.threat}.',
          'Mire Hound (${mireHound.threat}): ${mireHound.maxHp} HP, hits for ${mireHound.damage} each turn.',
        ],
      ),
      HelpSection(
        title: 'Current objective',
        lines: [findOldWatchPath.title, findOldWatchPath.text],
      ),
    ];
