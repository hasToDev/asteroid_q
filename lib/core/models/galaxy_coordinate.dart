import 'package:asteroid_q/core/core.dart';

class GalaxyCoordinates {
  final int x;
  final int y;
  final GalaxySize size;

  GalaxyCoordinates({
    required this.x,
    required this.y,
    required this.size,
  });

  factory GalaxyCoordinates.fromJson(Map<String, dynamic> json) {
    return GalaxyCoordinates(
      x: json['x'] as int,
      y: json['y'] as int,
      size: _galaxySizeFromString(json['size'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'size': size.name,
    };
  }

  static GalaxySize _galaxySizeFromString(String value) {
    return GalaxySize.values.firstWhere((e) => e.name == value);
  }

  /// Converts a coordinate to a string key with size identifier
  /// Format: x_y_size (e.g., "2_5_normal" or "1_3_small")
  String coordinateToKey() {
    return '${x}_${y}_${size.name}';
  }

  @override
  String toString() {
    return 'GalaxyCoordinates ${x}_${y}_${size.name}';
  }
}
