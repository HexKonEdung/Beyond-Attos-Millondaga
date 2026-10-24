import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'ui/flow/home_screen.dart';

class BeyondApp extends StatelessWidget {
  const BeyondApp({super.key, this.home});

  /// Optional starting screen. Tests use this to skip the intro flow.
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: home ?? const HomeScreen(),
    );
  }
}
