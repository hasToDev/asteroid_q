import 'dart:math';
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
    double innerShortestSide, {
    int? availableFuel,
  }) {
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
      // calculate new direction
      FighterJetDirection direction = findNewDirection(startRow, startCol, targetRow, targetCol, currentDirection);

      // Calculate direct distance for line of sight path
      var (int steps, int calculatedTargetRow, int calculatedTargetCol) = _calculatePossibleSteps(
          startRow, startCol, targetRow, targetCol, availableFuel, direction != currentDirection);

      // Calculate new index from the adjusted position
      int calculatedTargetIndex = calculatedTargetRow * gridSize + calculatedTargetCol;

      // calculate new offset
      Offset targetOffset =
          GameBoardUtils.findIndexOffset(calculatedTargetIndex, gridSize, innerShortestSide, screenSize);

      return FighterJetCommand(
        step: steps,
        index: calculatedTargetIndex,
        offset: targetOffset,
        direction: direction,
        pathType: FighterJetPath.direct,
      );
    }

    // If no line of sight, find intermediate point
    var (intermediateRow, intermediateCol) = _findIntermediatePoint(startRow, startCol, targetRow, targetCol, gridSize);
    int intermediateIndex = intermediateRow * gridSize + intermediateCol;

    // calculate new direction
    FighterJetDirection direction =
        findNewDirection(startRow, startCol, intermediateRow, intermediateCol, currentDirection);

    // Calculate steps to intermediate point
    var (int stepsToIntermediate, int calculatedTargetRow, int calculatedTargetCol) = _calculatePossibleSteps(
        startRow, startCol, intermediateRow, intermediateCol, availableFuel, direction != currentDirection);

    // Calculate new index from the adjusted position
    int calculatedTargetIndex = calculatedTargetRow * gridSize + calculatedTargetCol;

    // path type based on intermediateIndex and calculatedTargetIndex
    // if intermediateIndex is different than calculatedTargetIndex, then there's not enough fuel to continue
    // therefore we need to stop at calculatedTargetIndex and using FighterJetPath.transit
    FighterJetPath pathType =
        intermediateIndex == calculatedTargetIndex ? FighterJetPath.transit : FighterJetPath.direct;

    // calculate new offset
    Offset targetOffset =
        GameBoardUtils.findIndexOffset(calculatedTargetIndex, gridSize, innerShortestSide, screenSize);

    return FighterJetCommand(
      step: stepsToIntermediate,
      index: calculatedTargetIndex,
      offset: targetOffset,
      direction: direction,
      pathType: pathType,
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

  /// Calculates the maximum possible steps based on fuel availability and direction change
  static (int steps, int targetRow, int targetCol) _calculatePossibleSteps(
    int startRow,
    int startCol,
    int targetRow,
    int targetCol,
    int? fuelAvailable,
    bool needsDirectionChange,
  ) {
    int rowDiff = (targetRow - startRow).abs();
    int colDiff = (targetCol - startCol).abs();
    int directDistance = rowDiff > colDiff ? rowDiff : colDiff;

    // return if no need to count fuel availability
    if (fuelAvailable == null) return (directDistance, targetRow, targetCol);

    // Calculate available fuel for movement after direction change
    int remainingFuel = needsDirectionChange ? fuelAvailable - 1 : fuelAvailable;

    // Calculate maximum possible steps with remaining fuel
    int maxPossibleSteps = remainingFuel ~/ fuelCostMOVE;

    // If we can't reach the target, calculate the farthest possible position
    if (maxPossibleSteps < directDistance) {
      // Calculate the ratio to scale down the movement
      double ratio = maxPossibleSteps / directDistance;

      // Calculate new target position
      int newRowDiff = (rowDiff * ratio).floor();
      int newColDiff = (colDiff * ratio).floor();

      // Determine new target coordinates while maintaining direction
      int newTargetRow = startRow;
      int newTargetCol = startCol;

      if (targetRow > startRow) {
        newTargetRow += newRowDiff;
      } else if (targetRow < startRow) {
        newTargetRow -= newRowDiff;
      }

      if (targetCol > startCol) {
        newTargetCol += newColDiff;
      } else if (targetCol < startCol) {
        newTargetCol -= newColDiff;
      }

      return (maxPossibleSteps, newTargetRow, newTargetCol);
    }

    // If we have enough fuel to reach the target
    return (directDistance, targetRow, targetCol);
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

  /// Checks if there are any Asteroid blocking the line of sight between start and end positions
  /// Returns the index of the first blocking Asteroid found, or null if no objects block the line of sight
  static int? findBlockingAsteroid(
    int startIndex,
    int endIndex,
    List<int> asteroidIndices,
    int gridSize,
  ) {
    // Convert 1D indices to 2D coordinates
    int startRow = startIndex ~/ gridSize;
    int startCol = startIndex % gridSize;
    int endRow = endIndex ~/ gridSize;
    int endCol = endIndex % gridSize;

    // Calculate differences and steps
    int dx = (endCol - startCol).abs();
    int dy = (endRow - startRow).abs();
    int stepX = startCol < endCol ? 1 : -1;
    int stepY = startRow < endRow ? 1 : -1;

    // Handle straight lines (horizontal, vertical) and diagonal lines
    if (dx == 0 || dy == 0 || dx == dy) {
      final steps = max(dx, dy);
      int currentRow = startRow;
      int currentCol = startCol;

      // Check each point along the line
      for (int i = 0; i <= steps; i++) {
        int currentIndex = currentRow * gridSize + currentCol;

        // Skip the start position
        if (i > 0) {
          // Check if current position contains an Asteroid
          if (asteroidIndices.contains(currentIndex)) {
            return currentIndex;
          }
        }

        // Move to next position
        if (dx == dy) {
          currentRow += stepY;
          currentCol += stepX;
        } else if (dx > dy) {
          currentCol += stepX;
        } else {
          currentRow += stepY;
        }
      }
    }

    // Check if end position contains an Asteroid
    if (asteroidIndices.contains(endIndex)) {
      return endIndex;
    }

    return null;
  }
}
