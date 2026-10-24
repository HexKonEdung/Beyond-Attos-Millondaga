import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../widgets/terminal_button.dart';
import 'create_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'BEYOND',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A TEXTBOUND ROLE-PLAYING GAME',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'THE PATH REMEMBERS',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              const Spacer(),
              TerminalButton(
                key: const Key('home-start'),
                label: 'Start new game',
                expand: true,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateScreen()),
                ),
              ),
              const SizedBox(height: 12),
              const TerminalButton(
                key: Key('home-continue'),
                label: 'Continue journey (planned)',
                expand: true,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
