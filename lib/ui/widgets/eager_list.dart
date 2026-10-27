import 'package:flutter/material.dart';

/// A scrolling column that builds all of its children at once.
/// Used on MVP pages so every button exists in the tree (and in tests),
/// unlike ListView, which builds children lazily.
class EagerList extends StatelessWidget {
  const EagerList({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
