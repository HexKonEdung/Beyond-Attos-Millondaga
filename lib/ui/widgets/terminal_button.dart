import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Terminal-style button rendered as `[ LABEL ]`. Null onPressed = disabled.
class TerminalButton extends StatelessWidget {
  const TerminalButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final color = enabled ? AppColors.text : AppColors.disabled;

    final button = InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: color)),
        child: Text(
          '[ ${label.toUpperCase()} ]',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
