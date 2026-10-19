import 'package:flutter/material.dart';

import '../widgets/key_value_row.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_panel.dart';

/// Character tab. Shows placeholders until character creation (TICKET-003).
class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  static const List<String> _primaryStats = [
    'HP', 'MP', 'ATK', 'MAG', 'DEF', 'RES', 'SPD', 'LUK',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ScreenHeader(id: 'character', title: 'Character'),
        const TerminalPanel(
          title: 'Status',
          child: Column(
            children: [
              KeyValueRow(label: 'NAME', value: '--'),
              KeyValueRow(label: 'CLASS', value: '--'),
              KeyValueRow(label: 'LEVEL', value: '--'),
              KeyValueRow(label: 'EP', value: '0'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TerminalPanel(
          title: 'Primary stats',
          child: Column(
            children: [
              for (final stat in _primaryStats)
                KeyValueRow(label: stat, value: '--'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'No character yet. Character creation arrives in TICKET-003.',
          style: TextStyle(color: Color(0xFF999999)),
        ),
      ],
    );
  }
}
