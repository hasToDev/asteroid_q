import 'dart:math';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameBoardUtils {
  GameBoardUtils._();

  /// Generates random positions for fuel pods and asteroids on a 17x17 game board.
  /// The positions will not overlap with the fighter jet position or each other.
  static List<GameObjectPosition> generateGamePositions({
    required int fighterJetPosition,
    int numFuelPods = 2,
    int numAsteroids = 6,
  }) {
    final random = Random();
    final usedPositions = <int>{fighterJetPosition};
    final List<GameObjectPosition> objectPositions = [];

    // Generate positions for fuel pods
    for (var i = 0; i < numFuelPods; i++) {
      int position;
      do {
        position = random.nextInt(289); // 17 x 17 = 289 total positions
      } while (usedPositions.contains(position));

      usedPositions.add(position);
      objectPositions.add(GameObjectPosition(index: position, type: GameObjectType.fuelPod));
    }

    // Generate positions for asteroids
    for (var i = 0; i < numAsteroids; i++) {
      int position;
      do {
        position = random.nextInt(289);
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
    double outerItemSize = (outerShortestSide / (gridBoxNumber + 2));
    double outerAxisSpacing = outerItemSize * 0.125;

    // shortest side is HEIGHT
    if (constraints.maxHeight < constraints.maxWidth) {
      // * get the innerShortestSide by reducing outerShortestSide
      // * with SizedBox height and NextGalaxyTile height in COLUMN children of game_board.dart
      outerShortestSide =
          outerShortestSide - (spaceFromScreenEdge * 2) - ((outerItemSize * 0.5) * 2) - (outerAxisSpacing * 2);
    }
    // shortest side is WIDTH
    if (constraints.maxWidth < constraints.maxHeight) {
      // * get the innerShortestSide by reducing outerShortestSide
      // * with SizedBox width and NextGalaxyTile width in ROW children of game_board.dart
      outerShortestSide = outerShortestSide - ((outerItemSize * 0.5) * 2) - ((outerAxisSpacing * 2) * 2);
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
}
