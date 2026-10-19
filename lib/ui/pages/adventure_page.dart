import 'package:flutter/material.dart';

import '../../logic/game_shell_state.dart';
import '../../logic/world_data.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';

/// Adventure tab. Owns movement and battles. Battle actions arrive in TICKET-006.
class AdventurePage extends StatelessWidget {
  const AdventurePage({super.key, required this.shell});

  final GameShellState shell;

  @override
  Widget build(BuildContext context) {
    final area = areaById(shell.currentAreaId);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ScreenHeader(id: 'adventure', title: 'Adventure'),
        TerminalPanel(
          title: 'Current area',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                area.name,
                key: const Key('adventure-current-area'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(area.description),
              const SizedBox(height: 6),
              Text('Threat: ${area.threat}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Disabled on purpose: nothing is presented as working until built.
        const TerminalPanel(
          title: 'Actions',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TerminalButton(label: 'Explore (planned)', expand: true),
              SizedBox(height: 8),
              TerminalButton(label: 'Battle (planned)', expand: true),
            ],
          ),
        ),
      ],
    );
  }
}
