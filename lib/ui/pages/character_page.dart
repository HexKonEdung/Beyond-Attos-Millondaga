import 'package:flutter/material.dart';

import '../../logic/character.dart';
import '../widgets/key_value_row.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_panel.dart';

/// Character tab. Shows the character created in TICKET-003.
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
              KeyValueRow(label: 'EP', value: '${character.ep}'),
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
  }
}
