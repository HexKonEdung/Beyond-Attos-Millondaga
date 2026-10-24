import 'package:flutter/material.dart';

import '../../logic/character.dart';
import '../../logic/game_shell_state.dart';
import '../../theme/app_theme.dart';
import '../pages/adventure_page.dart';
import '../pages/character_page.dart';
import '../pages/inventory_page.dart';
import '../pages/map_page.dart';
import '../pages/settings_page.dart';

/// Main game shell: five destinations in an IndexedStack, so each page keeps
/// its state when the player switches tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.character});

  final Character character;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GameShellState _shell = GameShellState();

  @override
  void dispose() {
    _shell.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _shell,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            // Child order MUST match GameTab.values order.
            child: IndexedStack(
              index: _shell.currentTab.index,
              children: [
                CharacterPage(character: widget.character),
                AdventurePage(shell: _shell),
                const InventoryPage(),
                MapPage(shell: _shell),
                const SettingsPage(),
              ],
            ),
          ),
          bottomNavigationBar: _BottomNav(
            current: _shell.currentTab,
            onSelect: _shell.selectTab,
          ),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onSelect});

  final GameTab current;
  final ValueChanged<GameTab> onSelect;

  static const Map<GameTab, String> _labels = {
    GameTab.character: 'CHARACTER',
    GameTab.adventure: 'ADVENTURE',
    GameTab.inventory: 'INVENTORY',
    GameTab.map: 'MAP',
    GameTab.settings: 'SETTINGS',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            for (final tab in GameTab.values)
              Expanded(
                child: _NavItem(
                  key: Key('nav-${tab.name}'),
                  label: _labels[tab]!,
                  active: tab == current,
                  onTap: () => onSelect(tab),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.text : AppColors.textMuted;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: active ? AppColors.text : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
