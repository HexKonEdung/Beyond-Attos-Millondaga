import 'package:flutter/material.dart';

import '../../logic/character.dart';
import '../../logic/character_creation.dart';
import '../../theme/app_theme.dart';
import '../widgets/terminal_button.dart';
import '../widgets/terminal_panel.dart';
import 'story_screen.dart';
import 'package:beyond_flutter/ui/widgets/eager_list.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  HeroClass? _heroClass = HeroClass.fallen;
  final Map<String, int> _allocation = {
    for (final stat in CreationRules.allocatableStats) stat: 0,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int get _spent => _allocation.values.fold(0, (sum, value) => sum + value);

  List<CreationIssue> get _issues => validateCreation(
        name: _nameController.text,
        heroClass: _heroClass,
        allocation: _allocation,
      );

  void _changeStat(String stat, int delta) {
    final next = _allocation[stat]! + delta;
    if (next < 0) return;
    if (delta > 0 && _spent >= CreationRules.bonusPoints) return;
    setState(() => _allocation[stat] = next);
  }

  void _begin() {
    final character = Character(
      name: _nameController.text.trim(),
      heroClass: _heroClass!,
      allocation: _allocation,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StoryScreen(character: character)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final issues = _issues;
    final pointsLeft = CreationRules.bonusPoints - _spent;

    return Scaffold(
      appBar: AppBar(title: const Text('CREATE CHARACTER')),
      body: EagerList(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('name-field'),
            controller: _nameController,
            maxLength: CreationRules.maxNameLength,
            style: const TextStyle(color: AppColors.text),
            cursorColor: AppColors.text,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'CHARACTER NAME',
              labelStyle: TextStyle(color: AppColors.textMuted),
              hintText: 'Enter a name',
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.text),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('CHOOSE A BASE CLASS',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          for (final heroClass in HeroClass.values) ...[
            _ClassCard(
              key: Key('class-${heroClass.name}'),
              heroClass: heroClass,
              selected: _heroClass == heroClass,
              onTap: () => setState(() => _heroClass = heroClass),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          TerminalPanel(
            title: 'Bonus points: $pointsLeft left of ${CreationRules.bonusPoints}',
            child: Column(
              children: [
                for (final stat in CreationRules.allocatableStats)
                  _StatRow(
                    stat: stat,
                    base: _heroClass?.baseStats[stat] ?? 0,
                    value: _allocation[stat]!,
                    canAdd: pointsLeft > 0,
                    onMinus: () => _changeStat(stat, -1),
                    onPlus: () => _changeStat(stat, 1),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (issues.isNotEmpty)
            for (final issue in issues)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  creationMessage(issue),
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ),
          const SizedBox(height: 12),
          TerminalButton(
            key: const Key('create-begin'),
            label: 'Begin the journey',
            primary: true,
            expand: true,
            onPressed: issues.isEmpty ? _begin : null,
          ),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    super.key,
    required this.heroClass,
    required this.selected,
    required this.onTap,
  });

  final HeroClass heroClass;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heroClass.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(heroClass.role,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 6),
            Text(heroClass.description, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.stat,
    required this.base,
    required this.value,
    required this.canAdd,
    required this.onMinus,
    required this.onPlus,
  });

  final String stat;
  final int base;
  final int value;
  final bool canAdd;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text('$stat  (base $base)',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          _StepButton(key: Key('alloc-minus-$stat'), label: '−', onTap: value > 0 ? onMinus : null),
          SizedBox(
            width: 36,
            child: Text('$value', textAlign: TextAlign.center),
          ),
          _StepButton(key: Key('alloc-plus-$stat'), label: '+', onTap: canAdd ? onPlus : null),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = onTap == null ? AppColors.disabled : AppColors.text;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: color)),
        child: Text(label, style: TextStyle(color: color, fontSize: 18)),
      ),
    );
  }
}
