class LeaderboardEntry {
  final String playerName;
  final int distance;
  final int rotate;
  final int refuel;
  final int galaxy;

  LeaderboardEntry({
    required this.playerName,
    required this.distance,
    required this.rotate,
    required this.refuel,
    required this.galaxy,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      playerName: map['playerName'] as String,
      distance: map['distance'] as int,
      rotate: map['rotate'] as int,
      refuel: map['refuel'] as int,
      galaxy: map['galaxy'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'distance': distance,
      'rotate': rotate,
      'refuel': refuel,
      'galaxy': galaxy,
    };
  }
}