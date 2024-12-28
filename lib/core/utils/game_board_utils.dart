import 'dart:math';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameBoardUtils {
  GameBoardUtils._();

  /// Generates random positions for fuel pods and asteroids on game board.
  /// The positions will not overlap with the fighter jet position or each other.
  static List<GameObjectPosition> generateGamePositions({
    required int fighterJetPosition,
    required GalaxySize galaxySize,
    required int gridSize,
  }) {
    late int numFuelPods;
    late int numAsteroids;

    switch (galaxySize) {
      case GalaxySize.small:
        numFuelPods = GalaxySize.small.fuelPod;
        numAsteroids = GalaxySize.small.asteroid;
        break;
      case GalaxySize.medium:
        numFuelPods = GalaxySize.medium.fuelPod;
        numAsteroids = GalaxySize.medium.asteroid;
        break;
      case GalaxySize.large:
        numFuelPods = GalaxySize.large.fuelPod;
        numAsteroids = GalaxySize.large.asteroid;
        break;
    }

    final random = Random();
    final usedPositions = <int>{fighterJetPosition};
    final List<GameObjectPosition> objectPositions = [];

    // Generate positions for fuel pods
    for (var i = 0; i < numFuelPods; i++) {
      int position;
      do {
        position = random.nextInt(gridSize);
      } while (usedPositions.contains(position));

      usedPositions.add(position);
      objectPositions.add(GameObjectPosition(index: position, type: GameObjectType.fuelPod));
    }

    // Generate positions for asteroids
    for (var i = 0; i < numAsteroids; i++) {
      int position;
      do {
        position = random.nextInt(gridSize);
      } while (usedPositions.contains(position));

      usedPositions.add(position);
      objectPositions.add(GameObjectPosition(index: position, type: GameObjectType.asteroid));
    }

    return objectPositions;
  }

  /// calculate innerShortestSide as seen in game_board.dart
  /// this is necessary to get the correct offset
  static double calculateInnerShortestSide(BoxConstraints constraints) {
    double outerShortestSide =
        constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;
    double outerItemSize = (outerShortestSide / (getIt<GameBoardProvider>().gridSize + 2));
    double outerAxisSpacing = outerItemSize * 0.125;

    // shortest side is HEIGHT
    if (constraints.maxHeight < constraints.maxWidth) {
      // * get the innerShortestSide by reducing outerShortestSide
      // * with SizedBox height and NextGalaxyTile height in COLUMN children of game_board.dart
      outerShortestSide =
          outerShortestSide - (spaceFromScreenEdge * 2) - ((outerItemSize * 0.5) * 2) - (outerAxisSpacing * 4);
    }
    // shortest side is WIDTH
    if (constraints.maxWidth < constraints.maxHeight) {
      // * get the innerShortestSide by reducing outerShortestSide
      // * with SizedBox width and NextGalaxyTile width in ROW children of game_board.dart
      outerShortestSide =
          outerShortestSide - (spaceFromScreenEdge * 2) - ((outerItemSize * 0.5) * 2) - ((outerAxisSpacing * 2) * 2);
    }

    return outerShortestSide;
  }

  /// calculate offset based on gridview index
  static Offset findIndexOffset(int targetIndex, int gridColumnSpan, double innerShortestSide, Size screenSize) {
    // Calculate grid item position
    int row = targetIndex ~/ gridColumnSpan;
    int col = targetIndex % gridColumnSpan;

    double itemSize = innerShortestSide / gridColumnSpan;
    double gridSize = itemSize * gridColumnSpan;

    // Calculate the actual position considering grid is centered
    double leftOffset = (screenSize.width - gridSize) / 2;
    double topOffset = (screenSize.height - gridSize) / 2;

    double itemX = leftOffset + (col * itemSize) + (itemSize / 2);
    double itemY = topOffset + (row * itemSize) + (itemSize / 2);

    return Offset(itemX, itemY);
  }

  /// Finds the furthest available indices in all four directions from the current position
  ///
  /// [currentIndex] - The starting position index
  /// Returns a Map with keys 'top', 'bottom', 'left', 'right' containing the furthest indices
  static FurthestIndex findFurthestIndex(int currentIndex, int gridColumnSpan) {
    final int row = currentIndex ~/ gridColumnSpan;
    final int col = currentIndex % gridColumnSpan;

    // Calculate furthest points
    final int topIndex = col; // Same column, top row (row 0)
    final int bottomIndex = (gridColumnSpan - 1) * gridColumnSpan + col; // Same column, bottom row
    final int leftIndex = row * gridColumnSpan; // Same row, leftmost column
    final int rightIndex = row * gridColumnSpan + (gridColumnSpan - 1); // Same row, rightmost column

    return FurthestIndex(top: topIndex, right: rightIndex, bottom: bottomIndex, left: leftIndex);
  }
}
