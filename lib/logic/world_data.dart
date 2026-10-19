/// Static MVP world data (TICKET-004). Names follow the v1.9 design screens.
enum LocationStatus { current, available, locked }

class AreaInfo {
  const AreaInfo({
    required this.id,
    required this.name,
    required this.threat,
    required this.description,
    required this.requirement,
  });

  final String id;
  final String name;
  final String threat;
  final String description;

  /// Shown on locked routes so the player knows what is needed.
  final String requirement;
}

const String kStartingAreaId = 'greyhaven';

const List<AreaInfo> mvpAreas = [
  AreaInfo(
    id: 'greyhaven',
    name: 'GREYHAVEN',
    threat: 'NONE',
    description: 'A town of shutters, salt smoke, and stories no one finishes.',
    requirement: 'Starting town.',
  ),
  AreaInfo(
    id: 'whispering_wood',
    name: 'WHISPERING WOOD',
    threat: 'LOW',
    description: 'The trees lean inward. Fresh tracks cross the old watch road.',
    requirement: 'Complete the first objective (TICKET-005).',
  ),
  AreaInfo(
    id: 'old_watch',
    name: 'THE OLD WATCH',
    threat: 'HIGH',
    description: 'A broken tower above the marsh. The hidden bell waits below.',
    requirement: 'Complete the Whispering Wood objective (TICKET-005).',
  ),
];

AreaInfo areaById(String id) =>
    mvpAreas.firstWhere((area) => area.id == id);
