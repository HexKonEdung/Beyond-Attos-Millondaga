import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/player_state.dart';

void main() {
  test('useTonic consumes one tonic and heals 24 HP', () {
    final player = PlayerState(maxHp: 100, hp: 40);
    expect(player.useTonic(), isTrue);
    expect(player.tonics, kStartingTonics - 1);
    expect(player.hp, 64);
  });

  test('useTonic is refused when no tonics are left', () {
    final player = PlayerState(maxHp: 100, hp: 40, tonics: 0);
    expect(player.useTonic(), isFalse);
    expect(player.hp, 40);
  });

  test('healing is capped at max HP', () {
    final player = PlayerState(maxHp: 100, hp: 90);
    player.useTonic();
    expect(player.hp, 100);
  });

  test('grant adds XP, EP, and coins', () {
    final player = PlayerState(maxHp: 100);
    player.grant(xp: 15, ep: 5, coins: 8);
    player.grant(xp: 1);
    expect(player.xp, 16);
    expect(player.ep, 5);
    expect(player.coins, 8);
  });

  test('restoreFull only restores HP', () {
    final player = PlayerState(maxHp: 100, hp: 0)..grant(coins: 3);
    player.restoreFull();
    expect(player.hp, 100);
    expect(player.coins, 3);
  });
}
