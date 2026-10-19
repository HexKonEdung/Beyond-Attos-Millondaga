import 'package:flutter/material.dart';

import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';

/// Settings tab. Help & Rules (TICKET-009) and History Logs are kept separate.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ScreenHeader(id: 'settings', title: 'Settings'),
        TerminalPanel(
          title: 'Options',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TerminalButton(label: 'Help & Rules (planned)', expand: true),
              SizedBox(height: 8),
              TerminalButton(label: 'History Logs (planned)', expand: true),
            ],
          ),
        ),
      ],
    );
  }
}
