/// Static MVP world data (TICKET-004). Names follow the design screens.
enum LocationStatus { current, available, locked }

class AreaInfo {
  const AreaInfo({
    required this.id,
    required this.name,
    required this.threat,
    required this.description,
    required this.requirement,
    required this.connectedAreaIds,
    this.openAtStart = false,
  });

  final String id;
  final String name;
  final String threat;
  final String description;

  /// Shown on locked routes so the player knows what is needed.
  final String requirement;

  /// Areas reachable directly from this one.
  final List<String> connectedAreaIds;

  /// True if the route is open from the beginning of the game.
  final bool openAtStart;
}

const String kStartingAreaId = 'greyhaven';

const List<AreaInfo> mvpAreas = [
  AreaInfo(
    id: 'greyhaven',
    name: 'GREYHAVEN',
    threat: 'NONE',
    description: 'A town of shutters, salt smoke, and stories no one finishes.',
    requirement: 'Starting town.',
    connectedAreaIds: ['whispering_wood'],
    openAtStart: true,
  ),
  AreaInfo(
    id: 'whispering_wood',
    name: 'WHISPERING WOOD',
    threat: 'LOW',
    description: 'The trees lean inward. Fresh tracks cross the old watch road.',
    requirement: 'Open from the start.',
    connectedAreaIds: ['greyhaven', 'old_watch'],
    openAtStart: true,
  ),
  AreaInfo(
    id: 'old_watch',
    name: 'THE OLD WATCH',
    threat: 'HIGH',
    description: 'A broken tower above the marsh. The hidden bell waits below.',
    requirement: 'Complete the first objective: find the Old Watch Path.',
    connectedAreaIds: ['whispering_wood'],
  ),
];

AreaInfo areaById(String id) =>
    mvpAreas.firstWhere((area) => area.id == id);

/// Area where the Mire Hound encounter and the objective are found.
const String kEncounterAreaId = 'whispering_wood';
