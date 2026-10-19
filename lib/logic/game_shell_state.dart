import 'package:flutter/foundation.dart';

import 'world_data.dart';

/// Bottom-nav destinations, in display order. Must match IndexedStack children.
enum GameTab { character, adventure, inventory, map, settings }

/// Owns navigation and player position for the main game shell.
///
/// Rules (TICKET-002):
/// - Map may only VIEW an area. It never changes the player's position.
/// - Only [travelTo] moves the player, and only to an unlocked area.
/// - Any tab can be reached again at any time, so the player is never stuck.
class GameShellState extends ChangeNotifier {
  GameShellState({
    String startAreaId = kStartingAreaId,
    Set<String> unlockedAreaIds = const {},
  })  : _currentAreaId = startAreaId,
        _unlockedAreaIds = {startAreaId, ...unlockedAreaIds};

  GameTab _tab = GameTab.character;
  String _currentAreaId;
  String? _viewedAreaId;
  final Set<String> _unlockedAreaIds;

  GameTab get currentTab => _tab;
  String get currentAreaId => _currentAreaId;
  String? get viewedAreaId => _viewedAreaId;

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

  /// Moves the player. Called from Adventure only.
  /// Returns false if the area is locked or already current.
  bool travelTo(String areaId) {
    if (!isUnlocked(areaId) || areaId == _currentAreaId) return false;
    _currentAreaId = areaId;
    notifyListeners();
    return true;
  }

  /// Called by the objective system (TICKET-005) when a route is unlocked.
  void unlockArea(String areaId) {
    if (_unlockedAreaIds.add(areaId)) notifyListeners();
  }
}
