import 'package:asteroid_q/core/core.dart';

class GridCoordinateUtils {
  /// Converts a string key back to coordinate and size
  /// Returns a tuple of (x, y, size)
  static GalaxyCoordinates keyToCoordinate(String key) {
    final parts = key.split('_');
    if (parts.length != 3) {
      throw ArgumentError('Invalid key format. Expected: x_y_size');
    }
    return GalaxyCoordinates(x: int.parse(parts[0]), y: int.parse(parts[1]), size: _galaxySizeFromString(parts[2]));
  }

  /// convert String to GalaxySize
  static GalaxySize _galaxySizeFromString(String value) {
    return GalaxySize.values.firstWhere((e) => e.name == value);
  }

  /// Gets next coordinates for a given position based on the destination
  static GalaxyCoordinates getNextCoordinate(NextGalaxy destination, GalaxyCoordinates coordinate) {
    switch (destination) {
      case NextGalaxy.top:
        return GalaxyCoordinates(x: coordinate.x, y: coordinate.y + 1, size: coordinate.size);
      case NextGalaxy.right:
        return GalaxyCoordinates(x: coordinate.x + 1, y: coordinate.y, size: coordinate.size);
      case NextGalaxy.bottom:
        return GalaxyCoordinates(x: coordinate.x, y: coordinate.y - 1, size: coordinate.size);
      case NextGalaxy.left:
        return GalaxyCoordinates(x: coordinate.x - 1, y: coordinate.y, size: coordinate.size);
    }
  }
}
