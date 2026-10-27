import 'package:flutter/material.dart';

import '../../logic/game_shell_state.dart';
import '../../logic/world_data.dart';
import '../../theme/app_theme.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_panel.dart';
import 'package:beyond_flutter/ui/widgets/eager_list.dart';

/// Map tab. Selecting an area only shows its details. It never moves the player.
class MapPage extends StatelessWidget {
  const MapPage({super.key, required this.shell});

  final GameShellState shell;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: shell,
      builder: (context, _) {
        final viewedId = shell.viewedAreaId;
        final viewed = viewedId == null ? null : areaById(viewedId);

        return EagerList(
          padding: const EdgeInsets.all(16),
          children: [
            const ScreenHeader(id: 'map', title: 'Map'),
            for (final area in mvpAreas)
              _AreaCard(
                area: area,
                status: shell.statusOf(area.id),
                selected: area.id == viewedId,
                onTap: () => shell.viewArea(area.id),
              ),
            const SizedBox(height: 12),
            if (viewed != null)
              TerminalPanel(
                title: 'Details',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewed.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(viewed.description),
                    const SizedBox(height: 6),
                    Text('Status: ${_statusLabel(shell.statusOf(viewed.id))}'),
                    if (!shell.isUnlocked(viewed.id)) ...[
                      const SizedBox(height: 6),
                      Text('Requires: ${viewed.requirement}',
                          style: const TextStyle(color: AppColors.textMuted)),
                    ],
                    const SizedBox(height: 10),
                    const Text(
                      'Travel is handled from ADVENTURE.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  static String _statusLabel(LocationStatus status) {
    switch (status) {
      case LocationStatus.current:
        return 'CURRENT';
      case LocationStatus.available:
        return 'AVAILABLE';
      case LocationStatus.locked:
        return 'LOCKED';
    }
  }
}

class _AreaCard extends StatelessWidget {
  const _AreaCard({
    required this.area,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final AreaInfo area;
  final LocationStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        key: Key('map-area-${area.id}'),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: selected ? AppColors.text : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  area.name,
                  style: TextStyle(
                    color: status == LocationStatus.locked
                        ? AppColors.textMuted
                        : AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                status == LocationStatus.locked
                    ? 'LOCKED'
                    : status == LocationStatus.current
                        ? 'YOU ARE HERE'
                        : 'THREAT ${area.threat}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
