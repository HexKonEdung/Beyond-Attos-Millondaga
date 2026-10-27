import 'package:flutter/material.dart';

import '../../logic/character.dart';
import '../../logic/objectives.dart';
import '../../logic/story_data.dart';
import '../../theme/app_theme.dart';
import '../shell/main_shell.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';
import 'package:beyond_flutter/ui/widgets/eager_list.dart';

/// Opening story and first objective, shown once after character creation.
class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: EagerList(
          padding: const EdgeInsets.all(16),
          children: [
            ScreenHeader(id: 'story', title: kStoryTitle),
            for (final paragraph in kIntroParagraphs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(paragraph, style: const TextStyle(height: 1.5)),
              ),
            const SizedBox(height: 8),
            TerminalPanel(
              title: 'First objective',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(findOldWatchPath.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(findOldWatchPath.text),
                  const SizedBox(height: 6),
                  Text('Status: NOT STARTED',
                      style: const TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TerminalButton(
              key: const Key('story-begin'),
              label: 'Enter Greyhaven',
              primary: true,
              expand: true,
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MainShell(character: character),
                ),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
