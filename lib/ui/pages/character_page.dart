import 'package:flutter/material.dart';

import '../../logic/character.dart';
import '../../logic/player_state.dart';
import '../widgets/key_value_row.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_panel.dart';
import 'package:beyond_flutter/ui/widgets/eager_list.dart';

/// Character tab. Shows the created character and live XP / EP.
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key, required this.character, required this.player});

  final Character character;
  final PlayerState player;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        return EagerList(
          padding: const EdgeInsets.all(16),
          children: [
            const ScreenHeader(id: 'character', title: 'Character'),
            TerminalPanel(
              title: 'Status',
              child: Column(
                children: [
                  KeyValueRow(label: 'NAME', value: character.name.toUpperCase()),
                  KeyValueRow(label: 'CLASS', value: character.heroClass.displayName),
                  KeyValueRow(label: 'PATH', value: character.heroClass.evolution),
                  KeyValueRow(label: 'LEVEL', value: '${character.level}'),
                  KeyValueRow(label: 'XP', value: '${player.xp}'),
                  KeyValueRow(label: 'EP', value: '${player.ep}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TerminalPanel(
              title: 'Primary stats',
              child: Column(
                children: [
                  for (final entry in character.finalStats.entries)
                    KeyValueRow(label: entry.key, value: '${entry.value}'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
