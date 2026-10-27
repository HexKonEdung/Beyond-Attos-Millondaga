import 'package:flutter/material.dart';

import '../../logic/battle.dart';
import '../../logic/game_shell_state.dart';
import '../../logic/objectives.dart';
import '../../logic/world_data.dart';
import '../../theme/app_theme.dart';
import '../widgets/battle_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';
import 'package:beyond_flutter/ui/widgets/eager_list.dart';

/// Adventure tab. Handles movement, the objective, and battles.
class AdventurePage extends StatelessWidget {
  const AdventurePage({super.key, required this.shell, required this.battle});

  final GameShellState shell;
  final BattleState battle;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([shell, battle]),
      builder: (context, _) {
        final area = areaById(shell.currentAreaId);
        final routes = area.connectedAreaIds.map(areaById).toList();
        final objective = findOldWatchPath;
        final objectiveDone = shell.isObjectiveComplete(objective.id);

        return EagerList(
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
            if (battle.isActive)
              BattlePanel(battle: battle, shell: shell)
            else ...[
              TerminalPanel(
                title: 'Objective',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(objective.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(objective.text),
                    const SizedBox(height: 6),
                    Text(
                      objectiveDone ? 'Status: COMPLETE' : 'Status: IN PROGRESS',
                      key: const Key('objective-status'),
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
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
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12),
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
              TerminalPanel(
                title: 'Actions',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (shell.canCompleteObjective(objective.id)) ...[
                      TerminalButton(
                        key: const Key('objective-search'),
                        label: 'Search the Old Watch Path',
                        expand: true,
                        onPressed: () => shell.completeObjective(objective.id),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (area.id == kEncounterAreaId) ...[
                      TerminalButton(
                        key: const Key('fight-hound'),
                        label: 'Face the Mire Hound',
                        expand: true,
                        onPressed: () => battle.startEncounter(mireHound),
                      ),
                      const SizedBox(height: 8),
                    ],
                    const TerminalButton(
                        label: 'Explore (planned)', expand: true),
                  ],
                ),
              ),
            ],
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
