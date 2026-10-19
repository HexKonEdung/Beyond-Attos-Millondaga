import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/game_shell_state.dart';
import 'package:beyond_flutter/logic/world_data.dart';

void main() {
  test('viewing an area never moves the player', () {
    final shell = GameShellState(unlockedAreaIds: {'whispering_wood'});
    shell.viewArea('whispering_wood');
    expect(shell.currentAreaId, kStartingAreaId);
  });

  test('travel is refused for locked areas', () {
    final shell = GameShellState();
    expect(shell.travelTo('whispering_wood'), isFalse);
    expect(shell.currentAreaId, kStartingAreaId);
  });

  test('travel succeeds after unlocking', () {
    final shell = GameShellState();
    shell.unlockArea('whispering_wood');
    expect(shell.travelTo('whispering_wood'), isTrue);
    expect(shell.currentAreaId, 'whispering_wood');
    expect(shell.statusOf('whispering_wood'), LocationStatus.current);
  });

  test('status reflects current, available, locked', () {
    final shell = GameShellState(unlockedAreaIds: {'whispering_wood'});
    expect(shell.statusOf(kStartingAreaId), LocationStatus.current);
    expect(shell.statusOf('whispering_wood'), LocationStatus.available);
    expect(shell.statusOf('old_watch'), LocationStatus.locked);
  });
}
