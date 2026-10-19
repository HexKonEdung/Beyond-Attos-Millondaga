import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'ui/shell/main_shell.dart';

/// Root widget. TICKET-003 will insert the Home / Create screens before the shell.
class BeyondApp extends StatelessWidget {
  const BeyondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const MainShell(),
    );
  }
}
