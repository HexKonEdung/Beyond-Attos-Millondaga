import 'package:flutter/foundation.dart';

import 'world_data.dart';

/// Bottom-nav destinations, in display order. Must match IndexedStack children.
enum GameTab { character, adventure, inventory, map, settings }

/// Owns navigation and player position for the main game shell.
///
/// Rules:
/// - Map may only VIEW an area. It never changes the player's position.
/// - Only [travelTo] moves the player, and only along a connected, unlocked route.
/// - Any tab can be reached again at any time, so the player is never stuck.
class GameShellState extends ChangeNotifier {
  GameShellState({String startAreaId = kStartingAreaId})
      : _currentAreaId = startAreaId,
        _unlockedAreaIds = <String>{
          for (final area in mvpAreas)
            if (area.openAtStart) area.id,
        };

  GameTab _tab = GameTab.character;
  String _currentAreaId;
  String? _viewedAreaId;
  String? _lastEvent;
  final Set<String> _unlockedAreaIds;

  GameTab get currentTab => _tab;
  String get currentAreaId => _currentAreaId;
  String? get viewedAreaId => _viewedAreaId;

  /// Latest travel message shown on the Adventure page.
  String? get lastEvent => _lastEvent;

  bool isUnlocked(String areaId) => _unlockedAreaIds.contains(areaId);

  LocationStatus statusOf(String areaId) {
    if (areaId == _currentAreaId) return LocationStatus.current;
    if (!isUnlocked(areaId)) return LocationStatus.locked;
    return LocationStatus.available;
  }

  void selectTab(GameTab tab) {
    if (tab == _tab) return;
    _tab = tab;
    notifyListeners();
  }

  /// Escape hatch back to the main game flow from any tab.
  void returnToAdventure() => selectTab(GameTab.adventure);

  /// Map selection: shows details only.
  void viewArea(String areaId) {
    _viewedAreaId = areaId;
    notifyListeners();
  }

  /// Moves the player along a route. Called from Adventure only.
  /// Returns false (and sets [lastEvent]) if the move is not allowed.
  bool travelTo(String areaId) {
    final target = areaById(areaId);
    final here = areaById(_currentAreaId);

    if (areaId == _currentAreaId) {
      _lastEvent = 'You are already in ${target.name}.';
    } else if (!here.connectedAreaIds.contains(areaId)) {
      _lastEvent = 'No known route from ${here.name} to ${target.name}.';
    } else if (!isUnlocked(areaId)) {
      _lastEvent = 'Route locked. ${target.requirement}';
    } else {
      _currentAreaId = areaId;
      _lastEvent = 'You arrive at ${target.name}.';
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  /// Called by the objective system (TICKET-005) when a route is unlocked.
  void unlockArea(String areaId) {
    if (_unlockedAreaIds.add(areaId)) notifyListeners();
  }
}
