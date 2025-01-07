class LeaderboardEntry {
  final String playerName;
  final int distance;
  final int rotate;
  final int refuel;
  final int galaxy;
  final DateTime timestamp;

  LeaderboardEntry({
    required this.playerName,
    required this.distance,
    required this.rotate,
    required this.refuel,
    required this.galaxy,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'player': playerName,
      'distance': distance.toString(),
      'rotate': rotate.toString(),
      'refuel': refuel.toString(),
      'galaxy': galaxy.toString(),
      'timestamp': timestamp.microsecondsSinceEpoch.toString(),
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      playerName: json['player'] as String,
      distance: int.tryParse(json['distance']) ?? 0,
      rotate: int.tryParse(json['rotate']) ?? 0,
      refuel: int.tryParse(json['refuel']) ?? 0,
      galaxy: int.tryParse(json['galaxy']) ?? 0,
      timestamp: DateTime.fromMicrosecondsSinceEpoch(int.tryParse(json['timestamp']) ?? 0),
    );
  }

  // Compare individual metrics
  bool hasBetterDistance(LeaderboardEntry other) => distance < other.distance;

  bool hasBetterRotate(LeaderboardEntry other) => rotate < other.rotate;

  bool hasBetterRefuel(LeaderboardEntry other) => refuel < other.refuel;

  bool hasBetterGalaxy(LeaderboardEntry other) => galaxy < other.galaxy;

  // Check if any metric is lower
  bool hasBetterPerformance(LeaderboardEntry other) {
    return hasBetterDistance(other) || hasBetterRotate(other) || hasBetterRefuel(other) || hasBetterGalaxy(other);
  }

  @override
  String toString() {
    return 'LeaderboardEntry {playerName: $playerName, distance: $distance, rotate: $rotate, refuel: $refuel, galaxy: $galaxy, timestamp: $timestamp}';
  }
}
