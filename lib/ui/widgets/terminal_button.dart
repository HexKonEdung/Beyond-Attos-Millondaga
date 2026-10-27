import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Terminal-style button rendered as `[ LABEL ]`.
/// - onPressed null = disabled (grey, not tappable).
/// - tint sets the border and text color (for battle action colors).
/// - primary fills the button with the accent color (main call to action).
class TerminalButton extends StatelessWidget {
  const TerminalButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = false,
    this.tint,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final Color? tint;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final base = tint ?? (primary ? AppColors.accent : AppColors.text);
    final color = enabled ? base : AppColors.disabled;
    final filled = enabled && primary;
    final textColor = filled ? AppColors.background : color;

    final button = InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.accent : Colors.transparent,
          border: Border.all(color: color),
        ),
        child: Text(
          '[ ${label.toUpperCase()} ]',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            letterSpacing: 1,
            fontWeight: filled ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
