import 'package:flutter/material.dart';

import '../widgets/key_value_row.dart';
import '../widgets/screen_header.dart';
import '../widgets/terminal_panel.dart';

/// Inventory tab. Empty until items exist (TICKET-008).
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ScreenHeader(id: 'inventory', title: 'Inventory'),
        TerminalPanel(
          title: 'Consumables',
          child: Text('Empty.'),
        ),
        SizedBox(height: 12),
        TerminalPanel(
          title: 'Wallet',
          child: KeyValueRow(label: 'COINS', value: '0'),
        ),
      ],
    );
  }
}
