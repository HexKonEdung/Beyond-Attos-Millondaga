import 'package:flutter/material.dart';

import '../../logic/game_shell_state.dart';
import '../../logic/world_data.dart';
import '../../theme/app_theme.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';

/// Adventure tab. Owns movement along routes. Battles arrive in TICKET-006.
class AdventurePage extends StatelessWidget {
  const AdventurePage({super.key, required this.shell});

  final GameShellState shell;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: shell,
      builder: (context, _) {
        final area = areaById(shell.currentAreaId);
        final routes = area.connectedAreaIds.map(areaById).toList();

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
            TerminalPanel(
              title: 'Routes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final next in routes) ...[
                    _RouteButton(shell: shell, area: next),
                    if (shell.statusOf(next.id) == LocationStatus.locked)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          next.requirement,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                      )
                    else
                      const SizedBox(height: 8),
                  ],
                  if (shell.lastEvent != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        shell.lastEvent!,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ),
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
      },
    );
  }
}

class _RouteButton extends StatelessWidget {
  const _RouteButton({required this.shell, required this.area});

  final GameShellState shell;
  final AreaInfo area;

  @override
  Widget build(BuildContext context) {
    final open = shell.statusOf(area.id) == LocationStatus.available;
    return TerminalButton(
      key: Key('route-${area.id}'),
      label: open ? 'Go to ${area.name}' : 'Locked: ${area.name}',
      expand: true,
      onPressed: open
          ? () {
              shell.travelTo(area.id);
            }
          : null,
    );
  }
}
