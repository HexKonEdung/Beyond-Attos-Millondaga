/// A discovery objective. Completing it unlocks one route (TICKET-005).
class Objective {
  const Objective({
    required this.id,
    required this.title,
    required this.text,
    required this.locationId,
    required this.unlocksAreaId,
  });

  final String id;
  final String title;
  final String text;

  /// Area where the player must be to complete the objective.
  final String locationId;

  /// Route opened when the objective is complete.
  final String unlocksAreaId;
}

const Objective findOldWatchPath = Objective(
  id: 'find_old_watch_path',
  title: 'Find the Old Watch Path',
  text:
      'Travel to Whispering Wood using the Adventure tab, then search the old watch road for the Old Watch Path.',
  locationId: 'whispering_wood',
  unlocksAreaId: 'old_watch',
);

const List<Objective> mvpObjectives = [findOldWatchPath];

Objective objectiveById(String id) =>
    mvpObjectives.firstWhere((objective) => objective.id == id);
