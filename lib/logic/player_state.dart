import 'dart:math';

import 'package:flutter/foundation.dart';

/// Field tonic healing (design: "Restore 24 HP").
const int kTonicHealing = 24;

/// Starting tonics (design: "×3").
const int kStartingTonics = 3;

/// Player resources that persist between battles and across tabs.
/// Defeat keeps XP, EP, coins, and used tonics; it only restores HP.
class PlayerState extends ChangeNotifier {
  PlayerState({
    required this.maxHp,
    int? hp,
    int? tonics,
  })  : _hp = hp ?? maxHp,
        _tonics = tonics ?? kStartingTonics;

  final int maxHp;
  int _hp;
  int _tonics;
  int _xp = 0;
  int _ep = 0;
  int _coins = 0;

  int get hp => _hp;
  int get tonics => _tonics;
  int get xp => _xp;
  int get ep => _ep;
  int get coins => _coins;
  bool get isAlive => _hp > 0;

  void takeDamage(int amount) {
    _hp = max(0, _hp - amount);
    notifyListeners();
  }

  /// Safe point after defeat: full HP, everything else kept.
  void restoreFull() {
    _hp = maxHp;
    notifyListeners();
  }

  /// Uses one tonic. Returns false if none are left. Healing is capped at max HP.
  bool useTonic() {
    if (_tonics == 0) return false;
    _tonics--;
    _hp = min(maxHp, _hp + kTonicHealing);
    notifyListeners();
    return true;
  }

  void grant({int xp = 0, int ep = 0, int coins = 0}) {
    _xp += xp;
    _ep += ep;
    _coins += coins;
    notifyListeners();
  }
}
