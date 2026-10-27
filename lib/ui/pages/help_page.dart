import 'package:flutter/material.dart';

import '../../logic/help_data.dart';
import '../widgets/eager_list.dart';
import '../widgets/terminal_panel.dart';

/// Help & Rules (TICKET-009). Opened from Settings. Separate from History Logs.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = buildHelpSections();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HELP & RULES',
          key: Key('help-title'),
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: SafeArea(
        child: EagerList(
          padding: const EdgeInsets.all(16),
          children: [
            for (final section in sections) ...[
              TerminalPanel(
                title: section.title,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in section.lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(line),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
