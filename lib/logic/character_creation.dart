import 'character.dart';

enum CreationIssue { emptyName, nameTooLong, noClass, wrongPointTotal }

class CreationRules {
  CreationRules._();

  static const int maxNameLength = 16;
  static const int bonusPoints = 5;
  static const List<String> allocatableStats = [
    'ATK', 'MAG', 'DEF', 'RES', 'SPD', 'LUK',
  ];
}

/// Returns every problem with the draft character. Empty list = valid.
List<CreationIssue> validateCreation({
  required String name,
  required HeroClass? heroClass,
  required Map<String, int> allocation,
}) {
  final issues = <CreationIssue>[];
  final trimmed = name.trim();

  if (trimmed.isEmpty) {
    issues.add(CreationIssue.emptyName);
  } else if (trimmed.length > CreationRules.maxNameLength) {
    issues.add(CreationIssue.nameTooLong);
  }

  if (heroClass == null) issues.add(CreationIssue.noClass);

  final total = allocation.values.fold<int>(0, (sum, value) => sum + value);
  final anyNegative = allocation.values.any((value) => value < 0);
  if (total != CreationRules.bonusPoints || anyNegative) {
    issues.add(CreationIssue.wrongPointTotal);
  }

  return issues;
}

String creationMessage(CreationIssue issue) {
  switch (issue) {
    case CreationIssue.emptyName:
      return 'Enter a character name.';
    case CreationIssue.nameTooLong:
      return 'Name must be ${CreationRules.maxNameLength} characters or fewer.';
    case CreationIssue.noClass:
      return 'Choose a base class.';
    case CreationIssue.wrongPointTotal:
      return 'Assign exactly ${CreationRules.bonusPoints} bonus points.';
  }
}
