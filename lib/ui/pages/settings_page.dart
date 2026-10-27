import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../widgets/eager_list.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';
import 'help_page.dart';

/// Settings tab. Help & Rules is live (TICKET-009). History Logs is planned.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EagerList(
      padding: const EdgeInsets.all(16),
      children: [
        const ScreenHeader(id: 'settings', title: 'Settings'),
        TerminalPanel(
          title: 'Guide',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TerminalButton(
                key: const Key('open-help'),
                label: 'Help & Rules',
                expand: true,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HelpPage()),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'How navigation, battles, rewards, items, and defeat work.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const TerminalPanel(
          title: 'Records',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TerminalButton(label: 'History Logs (planned)', expand: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const TerminalPanel(
          title: 'Prototype build',
          child: Text(
            'Focused MVP: Fallen and Scavenger paths, one complete encounter loop, and short readable story beats.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
