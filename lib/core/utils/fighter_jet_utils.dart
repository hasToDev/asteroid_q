import 'package:flutter/material.dart';
import '../core.dart';

class FighterJetUtils {
  FighterJetUtils._();

  /// Finds the shortest path between two points
  /// Returns a FighterJetCommand
  /// Parameters:
  ///   initialIndex: Starting position on the grid
  ///   targetIndex: Desired destination on the grid
  static FighterJetCommand findShortestPath(
    int initialIndex,
    int targetIndex,
    int gridSize,
    FighterJetDirection currentDirection,
    Size screenSize,
    double innerShortestSide,
  ) {
    // Grid dimensions
    int totalCells = gridSize * gridSize;

    // Validate input indices
    if (initialIndex < 0 || initialIndex >= totalCells || targetIndex < 0 || targetIndex >= totalCells) {
      throw ArgumentError('Invalid index values');
    }

    // Convert indices to 2D coordinates
    final int startRow = initialIndex ~/ gridSize;
    final int startCol = initialIndex % gridSize;
    final int targetRow = targetIndex ~/ gridSize;
    final int targetCol = targetIndex % gridSize;

    // Check if target is in direct line of sight (horizontal, vertical, or 45-degree diagonal)
    bool hasLineOfSight = _hasLineOfSight(startRow, startCol, targetRow, targetCol);

    if (hasLineOfSight) {
      // Calculate direct distance for line of sight path
      int steps = _calculateDirectDistance(startRow, startCol, targetRow, targetCol);

      // calculate new direction
      FighterJetDirection direction = findNewDirection(startRow, startCol, targetRow, targetCol, currentDirection);

      // calculate new offset
      Offset targetOffset = GameBoardUtils.findIndexOffset(targetIndex, gridSize, innerShortestSide, screenSize);

      return FighterJetCommand(
          step: steps, index: targetIndex, offset: targetOffset, direction: direction, pathType: FighterJetPath.direct);
    }

    // If no line of sight, find intermediate point
    var (intermediateRow, intermediateCol) = _findIntermediatePoint(startRow, startCol, targetRow, targetCol, gridSize);
    int intermediateIndex = intermediateRow * gridSize + intermediateCol;

    // Calculate steps to intermediate point
    int stepsToIntermediate = _calculateDirectDistance(startRow, startCol, intermediateRow, intermediateCol);

    // calculate new direction
    FighterJetDirection direction =
        findNewDirection(startRow, startCol, intermediateRow, intermediateCol, currentDirection);

    // calculate new offset
    Offset targetOffset = GameBoardUtils.findIndexOffset(intermediateIndex, gridSize, innerShortestSide, screenSize);

    return FighterJetCommand(
      step: stepsToIntermediate,
      index: intermediateIndex,
      offset: targetOffset,
      direction: direction,
      pathType: FighterJetPath.transit,
    );
  }

  /// Checks if there is a direct line of sight between two points
  static bool _hasLineOfSight(int startRow, int startCol, int targetRow, int targetCol) {
    // Check horizontal and vertical
    if (startRow == targetRow || startCol == targetCol) {
      return true;
    }

    // Check 45-degree diagonals
    int rowDiff = (targetRow - startRow).abs();
    int colDiff = (targetCol - startCol).abs();

    return rowDiff == colDiff;
  }

  /// Calculates the number of steps needed for direct movement
  static int _calculateDirectDistance(int startRow, int startCol, int targetRow, int targetCol) {
    int rowDiff = (targetRow - startRow).abs();
    int colDiff = (targetCol - startCol).abs();

    // For diagonal movement, we only need the maximum of row or column difference
    // since we can move diagonally
    return rowDiff > colDiff ? rowDiff : colDiff;
  }

  /// Finds an intermediate point that can be reached with line of sight
  static (int, int) _findIntermediatePoint(int startRow, int startCol, int targetRow, int targetCol, int gridSize) {
    // Calculate the direction vector
    int rowDir = targetRow - startRow;
    int colDir = targetCol - startCol;

    // Normalize to get the primary movement direction
    int normalizedRowDir = rowDir == 0 ? 0 : rowDir ~/ rowDir.abs();
    int normalizedColDir = colDir == 0 ? 0 : colDir ~/ colDir.abs();

    // Find the closest point that satisfies the 45-degree angle requirement
    int intermediateRow = startRow;
    int intermediateCol = startCol;

    // Move in 45-degree increments until we find a valid intermediate point
    while (true) {
      int nextRow = intermediateRow + normalizedRowDir;
      int nextCol = intermediateCol + normalizedColDir;

      // Check if we've gone too far or out of bounds
      if (nextRow < 0 || nextRow >= gridSize || nextCol < 0 || nextCol >= gridSize) {
        break;
      }

      // Update position
      intermediateRow = nextRow;
      intermediateCol = nextCol;

      // Check if we have line of sight to target from this position
      if (_hasLineOfSight(intermediateRow, intermediateCol, targetRow, targetCol)) {
        break;
      }
    }

    return (intermediateRow, intermediateCol);
  }

  static FighterJetDirection findNewDirection(
    int startRow,
    int startCol,
    int targetRow,
    int targetCol,
    FighterJetDirection currentDirection,
  ) {
    // Calculate relative position
    final int rowDiff = targetRow - startRow;
    final int colDiff = targetCol - startCol;

    // If no movement needed, keep current direction
    if (rowDiff == 0 && colDiff == 0) return currentDirection;

    // Determine target direction based on position differences
    if (rowDiff < 0 && colDiff == 0) return FighterJetDirection.up;
    if (rowDiff > 0 && colDiff == 0) return FighterJetDirection.down;
    if (rowDiff == 0 && colDiff < 0) return FighterJetDirection.left;
    if (rowDiff == 0 && colDiff > 0) return FighterJetDirection.right;

    // Diagonal directions
    if (rowDiff < 0 && colDiff > 0) return FighterJetDirection.upRight;
    if (rowDiff > 0 && colDiff > 0) return FighterJetDirection.downRight;
    if (rowDiff > 0 && colDiff < 0) return FighterJetDirection.downLeft;
    if (rowDiff < 0 && colDiff < 0) return FighterJetDirection.upLeft;

    // Fallback to current direction (should never reach here)
    return currentDirection;
  }
}
