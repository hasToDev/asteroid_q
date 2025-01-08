class GameStatusCheck {
  GameStatusCheck({
    required this.inMaintenance,
  });

  late bool inMaintenance;

  factory GameStatusCheck.fromJson(Map<String, dynamic> json) {
    return GameStatusCheck(
      inMaintenance: json['inMaintenance'] ?? false,
    );
  }

  @override
  String toString() {
    return "in maintenance: $inMaintenance";
  }
}
