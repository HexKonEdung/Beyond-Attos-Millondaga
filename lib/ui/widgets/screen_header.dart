import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Page title. The key `title-<id>` is used by tests to confirm the visible page.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.id, required this.title});

  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        key: Key('title-$id'),
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontFamily: AppTheme.fontFamily,
        ),
      ),
    );
  }
}
