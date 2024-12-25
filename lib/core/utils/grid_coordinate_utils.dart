import 'dart:math';

class GridCoordinateUtils {
  /// Converts a coordinate to a string key with size identifier
  /// Format: x_y_size (e.g., "2_5_big" or "1_3_small")
  static String coordinateToKey(int x, int y, String size) {
    return '${x}_${y}_$size';
  }

  /// Converts a string key back to coordinate and size
  /// Returns a tuple of (x, y, size)
  static (int x, int y, String size) keyToCoordinate(String key) {
    final parts = key.split('_');
    if (parts.length != 3) {
      throw ArgumentError('Invalid key format. Expected: x_y_size');
    }
    return (
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts[2],
    );
  }

  /// Gets adjacent coordinates for a given position
  static Map<String, Point<int>> getAdjacentCoordinates(int x, int y) {
    // return {
    //   'top': Point(x, y - 1),
    //   'right': Point(x + 1, y),
    //   'bottom': Point(x, y + 1),
    //   'left': Point(x - 1, y),
    // };

    return {
      'top': Point(x, y + 1),
      'right': Point(x + 1, y),
      'bottom': Point(x, y - 1),
      'left': Point(x - 1, y),
    };
  }

  /// Stores grid data with coordinate key
  static Map<String, dynamic> gridData = {};

  /// Saves data for a specific grid coordinate
  static void saveGridData(int x, int y, String size, dynamic data) {
    final key = coordinateToKey(x, y, size);
    gridData[key] = data;
  }

  /// Retrieves data for a specific grid coordinate
  static dynamic getGridData(int x, int y, String size) {
    final key = coordinateToKey(x, y, size);
    return gridData[key];
  }
}
