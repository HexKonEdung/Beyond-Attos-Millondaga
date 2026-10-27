import 'package:flutter/material.dart';

import '../../logic/battle.dart';
import '../../logic/game_shell_state.dart';
import '../../logic/player_state.dart';
import '../../theme/app_theme.dart';
import 'key_value_row.dart';
import 'terminal_button.dart';
import 'terminal_panel.dart';

/// Battle view shown inside the Adventure tab while an encounter is active.
class BattlePanel extends StatelessWidget {
  const BattlePanel({super.key, required this.battle, required this.shell});

  final BattleState battle;
  final GameShellState shell;

  static String _bar(int value, int max) {
    const segments = 20;
    var filled = max == 0 ? 0 : (value * segments / max).round();
    if (filled < 0) filled = 0;
    if (filled > segments) filled = segments;
    return '[${'█' * filled}${'░' * (segments - filled)}]';
  }

  @override
  Widget build(BuildContext context) {
    final PlayerState player = battle.player;
    return ListenableBuilder(
      listenable: Listenable.merge([battle, player]),
      builder: (context, _) {
        final enemy = battle.enemy;
        if (enemy == null) return const SizedBox.shrink();

        final log = battle.log;
        final recent = log.length > 8 ? log.sublist(log.length - 8) : log;
        final finished = battle.phase == BattlePhase.victory ||
            battle.phase == BattlePhase.defeat;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TerminalPanel(
              title: 'Encounter · turn ${battle.turn}',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(enemy.name,
                      key: const Key('enemy-name'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Threat: ${enemy.threat}',
                      style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  KeyValueRow(
                      label: 'VIGOR',
                      value: '${battle.enemyHp} / ${enemy.maxHp}'),
                  Text(_bar(battle.enemyHp, enemy.maxHp),
                      key: const Key('enemy-bar')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TerminalPanel(
              title: 'You',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KeyValueRow(
                      label: 'HP',
                      value: '${player.hp} / ${player.maxHp}'),
                  Text(_bar(player.hp, player.maxHp),
                      key: const Key('player-bar')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TerminalPanel(
              title: 'Combat log',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in recent)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(line),
                    ),
                ],
              ),
            ),
            if (finished) ...[
              const SizedBox(height: 12),
              TerminalPanel(
                title: 'Result',
                child: Text(
                  battle.phase == BattlePhase.victory
                      ? 'Victory. Rewards: ${enemy.rewards.summary}.'
                      : 'Defeat. You return to Greyhaven with full HP. '
                          'Kept: XP, EP, coins, objectives, and unlocked routes. '
                          'Used tonics stay used.',
                  key: const Key('result-text'),
                ),
              ),
            ],
            const SizedBox(height: 12),
            TerminalButton(
              key: const Key('battle-strike'),
              label: 'Strike',
              expand: true,
              tint: AppColors.strike,
              onPressed: battle.canAct ? battle.strike : null,
            ),
            const SizedBox(height: 8),
            TerminalButton(
              key: const Key('battle-item'),
              label: 'Item · Field tonic (${player.tonics})',
              expand: true,
              tint: AppColors.item,
              onPressed: battle.canAct && player.tonics > 0
                  ? battle.useTonic
                  : null,
            ),
            const SizedBox(height: 8),
            // Not built yet for the MVP. Shown disabled, never as working.
            const TerminalButton(label: 'Skill (planned)', expand: true),
            const SizedBox(height: 8),
            const TerminalButton(label: 'Interact (planned)', expand: true),
            const SizedBox(height: 8),
            const TerminalButton(label: 'Prepare (planned)', expand: true),
            const SizedBox(height: 8),
            const TerminalButton(label: 'Flee (planned)', expand: true),
            if (battle.phase == BattlePhase.victory) ...[
              const SizedBox(height: 8),
              TerminalButton(
                key: const Key('battle-continue'),
                label: 'Continue',
                expand: true,
                primary: true,
                onPressed: battle.finishEncounter,
              ),
            ],
            if (battle.phase == BattlePhase.defeat) ...[
              const SizedBox(height: 8),
              TerminalButton(
                key: const Key('battle-retreat'),
                label: 'Return to Greyhaven',
                expand: true,
                onPressed: () {
                  shell.returnToSafePoint();
                  battle.finishEncounter();
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
