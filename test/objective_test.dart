import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/game_shell_state.dart';
import 'package:beyond_flutter/logic/objectives.dart';
import 'package:beyond_flutter/logic/world_data.dart';

void main() {
  test('objective cannot be completed outside its area', () {
    final shell = GameShellState();
    expect(shell.canCompleteObjective(findOldWatchPath.id), isFalse);
    shell.completeObjective(findOldWatchPath.id);
    expect(shell.isObjectiveComplete(findOldWatchPath.id), isFalse);
    expect(shell.statusOf('old_watch'), LocationStatus.locked);
  });

  test('completing the objective in its area unlocks exactly one route', () {
    final shell = GameShellState();
    shell.travelTo('whispering_wood');
    shell.completeObjective(findOldWatchPath.id);

    expect(shell.isObjectiveComplete(findOldWatchPath.id), isTrue);
    expect(shell.isUnlocked('old_watch'), isTrue);
    expect(shell.statusOf('old_watch'), LocationStatus.available);
  });

  test('completing twice does nothing extra', () {
    final shell = GameShellState();
    shell.travelTo('whispering_wood');
    shell.completeObjective(findOldWatchPath.id);
    expect(shell.canCompleteObjective(findOldWatchPath.id), isFalse);
  });

  test('objective and unlocked route survive a return to the safe point', () {
    final shell = GameShellState();
    shell.travelTo('whispering_wood');
    shell.completeObjective(findOldWatchPath.id);
    shell.returnToSafePoint();

    expect(shell.currentAreaId, kStartingAreaId);
    expect(shell.isObjectiveComplete(findOldWatchPath.id), isTrue);
    expect(shell.isUnlocked('old_watch'), isTrue);
  });
}
