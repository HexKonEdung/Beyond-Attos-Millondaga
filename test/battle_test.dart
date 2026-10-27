import 'package:flutter_test/flutter_test.dart';

import 'package:beyond_flutter/logic/battle.dart';
import 'package:beyond_flutter/logic/player_state.dart';

import 'test_helpers.dart';

void main() {
  test('encounter starts on the player turn with full enemy HP', () {
    final battle = BattleState(character: testCharacter(), player: testPlayer());
    battle.startEncounter(mireHound);

    expect(battle.phase, BattlePhase.playerTurn);
    expect(battle.enemyHp, mireHound.maxHp);
    expect(battle.canAct, isTrue);
  });

  test('strike deals ATK minus half enemy DEF, then the enemy strikes back', () {
    final battle = BattleState(character: testCharacter(), player: testPlayer());
    battle.startEncounter(mireHound);
    battle.strike();

    // ATK 18 (16 base + 2 bonus) minus DEF 4 / 2 = 16 damage.
    expect(battle.enemyHp, mireHound.maxHp - 16);
    expect(battle.playerHp, battle.playerMaxHp - mireHound.damage);
    expect(battle.turn, 2);
  });

  test('victory grants the fixed rewards exactly once', () {
    final player = testPlayer();
    final battle = BattleState(character: testCharacter(), player: player);
    battle.startEncounter(mireHound);
    for (var i = 0; i < 10 && battle.canAct; i++) {
      battle.strike();
    }

    expect(battle.phase, BattlePhase.victory);
    expect(player.xp, mireHound.rewards.xp);
    expect(player.ep, mireHound.rewards.ep);
    expect(player.coins, mireHound.rewards.coins);
    expect(battle.log.last, contains('Rewards'));

    battle.strike();
    expect(player.xp, mireHound.rewards.xp, reason: 'no double reward');
  });

  test('HP lost in a battle carries over after victory', () {
    final battle = BattleState(character: testCharacter(), player: testPlayer());
    battle.startEncounter(mireHound);
    for (var i = 0; i < 10 && battle.canAct; i++) {
      battle.strike();
    }
    final afterVictory = battle.playerHp;
    battle.finishEncounter();
    expect(battle.playerHp, afterVictory);
    expect(battle.isActive, isFalse);
  });

  test('defeat keeps rewards and tonics, and finishing restores full HP', () {
    final player = testPlayer(hp: 4);
    player.grant(xp: 30, coins: 12);
    final battle = BattleState(character: testCharacter(), player: player);
    battle.startEncounter(mireHound);
    battle.strike();

    expect(battle.phase, BattlePhase.defeat);
    expect(battle.playerHp, 0);

    battle.finishEncounter();
    expect(battle.isActive, isFalse);
    expect(battle.playerHp, battle.playerMaxHp);
    expect(player.xp, 30, reason: 'XP kept after defeat');
    expect(player.coins, 12, reason: 'coins kept after defeat');
  });

  test('using a tonic heals, costs one tonic, and the enemy still responds', () {
    final player = testPlayer(hp: 50);
    final battle = BattleState(character: testCharacter(), player: player);
    battle.startEncounter(mireHound);
    battle.useTonic();

    expect(player.tonics, kStartingTonics - 1);
    expect(player.hp, 50 + kTonicHealing - mireHound.damage);
    expect(battle.turn, 2);
  });

  test('tonic healing never exceeds max HP', () {
    final player = testPlayer();
    final battle = BattleState(character: testCharacter(), player: player);
    battle.startEncounter(mireHound);
    battle.useTonic();

    expect(player.hp, player.maxHp - mireHound.damage);
  });

  test('with no tonics left, the item action does nothing and keeps the turn', () {
    final player = testPlayer(hp: 50);
    for (var i = 0; i < kStartingTonics; i++) {
      player.useTonic();
    }
    final hpBefore = player.hp;
    final battle = BattleState(character: testCharacter(), player: player);
    battle.startEncounter(mireHound);
    battle.useTonic();

    expect(player.hp, hpBefore);
    expect(battle.turn, 1);
    expect(battle.log.last, contains('empty'));
  });
}
