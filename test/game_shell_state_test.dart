import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/game_shell_state.dart';
import 'package:beyond_flutter/logic/world_data.dart';

void main() {
  test('viewing an area never moves the player', () {
    final shell = GameShellState();
    shell.viewArea('whispering_wood');
    expect(shell.currentAreaId, kStartingAreaId);
  });

  test('travel refused for a locked, unconnected area', () {
    final shell = GameShellState();
    expect(shell.travelTo('old_watch'), isFalse);
    expect(shell.currentAreaId, kStartingAreaId);
    expect(shell.lastEvent, isNotNull);
  });

  test('travel to a connected open area succeeds', () {
    final shell = GameShellState();
    expect(shell.travelTo('whispering_wood'), isTrue);
    expect(shell.currentAreaId, 'whispering_wood');
    expect(shell.statusOf('whispering_wood'), LocationStatus.current);
  });

  test('unlocked but unconnected area is still refused', () {
    final shell = GameShellState();
    shell.unlockArea('old_watch');
    expect(shell.travelTo('old_watch'), isFalse);
    expect(shell.currentAreaId, kStartingAreaId);
  });

  test('route opens after its objective unlocks it', () {
    final shell = GameShellState();
    shell.unlockArea('old_watch');
    expect(shell.travelTo('whispering_wood'), isTrue);
    expect(shell.travelTo('old_watch'), isTrue);
    expect(shell.currentAreaId, 'old_watch');
  });

  test('status reflects current, available, locked', () {
    final shell = GameShellState();
    expect(shell.statusOf(kStartingAreaId), LocationStatus.current);
    expect(shell.statusOf('whispering_wood'), LocationStatus.available);
    expect(shell.statusOf('old_watch'), LocationStatus.locked);
  });
}
