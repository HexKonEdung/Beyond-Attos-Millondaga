import 'dart:math';

import 'package:flutter/foundation.dart';

import 'character.dart';
import 'player_state.dart';

/// Fixed MVP rewards (TICKET-007). Design calls these placeholder EXP and Gold.
class Rewards {
  const Rewards({required this.xp, required this.ep, required this.coins});

  final int xp;
  final int ep;
  final int coins;

  String get summary => '+$xp XP · +$ep EP · +$coins coins';
}

class Enemy {
  const Enemy({
    required this.name,
    required this.threat,
    required this.maxHp,
    required this.defense,
    required this.damage,
    required this.rewards,
  });

  final String name;
  final String threat;
  final int maxHp;
  final int defense;

  /// Flat damage per enemy turn (MVP simplification, matches the design).
  final int damage;

  final Rewards rewards;
}

const Enemy mireHound = Enemy(
  name: 'Mire Hound',
  threat: 'COMMON',
  maxHp: 100,
  defense: 4,
  damage: 4,
  rewards: Rewards(xp: 15, ep: 5, coins: 8),
);

enum BattlePhase { inactive, playerTurn, victory, defeat }

/// One turn-based encounter. Player HP and resources live in [player].
class BattleState extends ChangeNotifier {
  BattleState({required this.character, required this.player});

  final Character character;
  final PlayerState player;

  Enemy? _enemy;
  int _enemyHp = 0;
  int _turn = 0;
  BattlePhase _phase = BattlePhase.inactive;
  final List<String> _log = [];

  int get playerHp => player.hp;
  int get playerMaxHp => player.maxHp;
  Enemy? get enemy => _enemy;
  int get enemyHp => _enemyHp;
  int get turn => _turn;
  BattlePhase get phase => _phase;
  List<String> get log => List.unmodifiable(_log);
  bool get isActive => _phase != BattlePhase.inactive;
  bool get canAct => _phase == BattlePhase.playerTurn;

  /// Design formula for Strike: ATK × 1.0 − DEF / 2, minimum 1.
  int strikeDamage(Enemy enemy) =>
      max(1, character.finalStats['ATK']! - (enemy.defense ~/ 2));

  void startEncounter(Enemy enemy) {
    if (isActive) return;
    _enemy = enemy;
    _enemyHp = enemy.maxHp;
    _turn = 1;
    _phase = BattlePhase.playerTurn;
    _log
      ..clear()
      ..add('A ${enemy.name} (${enemy.threat}) blocks your path!')
      ..add('Turn 1: your move.');
    notifyListeners();
  }

  void strike() {
    if (!canAct) return;
    final foe = _enemy!;
    final damage = strikeDamage(foe);
    _enemyHp = max(0, _enemyHp - damage);
    _log.add('You strike the ${foe.name} for $damage damage.');

    if (_enemyHp == 0) {
      _phase = BattlePhase.victory;
      player.grant(
        xp: foe.rewards.xp,
        ep: foe.rewards.ep,
        coins: foe.rewards.coins,
      );
      _log.add('${foe.name} is defeated. Victory!');
      _log.add('Rewards: ${foe.rewards.summary}.');
      notifyListeners();
      return;
    }
    _enemyTurn();
  }

  /// Uses a Field tonic. It costs the turn, so the enemy responds.
  /// With no tonics left, nothing happens and the turn is kept.
  void useTonic() {
    if (!canAct) return;
    if (!player.useTonic()) {
      _log.add('Your tonic pouch is empty.');
      notifyListeners();
      return;
    }
    _log.add('You drink a Field tonic. +$kTonicHealing HP.');
    _enemyTurn();
  }

  void _enemyTurn() {
    final foe = _enemy!;
    player.takeDamage(foe.damage);
    _log.add('${foe.name} strikes back for ${foe.damage} damage.');

    if (!player.isAlive) {
      _phase = BattlePhase.defeat;
      _log.add('You fall. Defeat.');
    } else {
      _turn++;
      _log.add('Turn $_turn: your move.');
    }
    notifyListeners();
  }

  /// Closes the encounter. After a defeat, HP is restored to full at the safe point.
  void finishEncounter() {
    if (_phase == BattlePhase.defeat) player.restoreFull();
    _phase = BattlePhase.inactive;
    _enemy = null;
    notifyListeners();
  }
}
