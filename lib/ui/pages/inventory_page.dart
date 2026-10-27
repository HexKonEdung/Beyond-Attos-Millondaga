import 'package:flutter/material.dart';

import '../../logic/player_state.dart';
import '../../theme/app_theme.dart';
import '../widgets/key_value_row.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';
import 'package:beyond_flutter/ui/widgets/eager_list.dart';

/// Inventory tab. Field tonic is usable (TICKET-008). Other items are shown
/// as planned, without working controls.
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key, required this.player});

  final PlayerState player;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool _showEquipment = false;

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        return EagerList(
          padding: const EdgeInsets.all(16),
          children: [
            const ScreenHeader(id: 'inventory', title: 'Inventory'),
            Row(
              children: [
                _SegButton(
                  key: const Key('tab-supplies'),
                  label: 'SUPPLIES',
                  selected: !_showEquipment,
                  onTap: () => setState(() => _showEquipment = false),
                ),
                const SizedBox(width: 8),
                _SegButton(
                  key: const Key('tab-equipment'),
                  label: 'EQUIPMENT',
                  selected: _showEquipment,
                  onTap: () => setState(() => _showEquipment = true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!_showEquipment) ...[
              TerminalPanel(
                title: 'Field tonic ×${player.tonics}',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Restores 24 HP. Bitter, but dependable.'),
                    const SizedBox(height: 8),
                    TerminalButton(
                      key: const Key('use-tonic'),
                      label: 'Use tonic',
                      expand: true,
                      onPressed: player.tonics > 0 ? () => player.useTonic() : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const TerminalPanel(
                title: 'Brass waymark ×1',
                child: Text(
                  "A quest item stamped with Greyhaven's crest. Cannot be discarded.",
                ),
              ),
              const SizedBox(height: 12),
              const TerminalPanel(
                title: 'Wakeleaf ×2',
                child: Text('Planned. Not usable in this build.',
                    style: TextStyle(color: AppColors.textMuted)),
              ),
            ] else ...[
              const TerminalPanel(
                title: 'Equipment',
                child: Text(
                  'Ashwood guard and Notched shortsword are planned for a later build.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ],
            const SizedBox(height: 12),
            TerminalPanel(
              title: 'Wallet',
              child: Column(
                children: [
                  KeyValueRow(label: 'COINS', value: '${player.coins}'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SegButton extends StatelessWidget {
  const _SegButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : AppColors.surface,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.background : AppColors.textMuted,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
