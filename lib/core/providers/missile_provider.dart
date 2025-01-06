import 'dart:math';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class MissileProvider extends ChangeNotifier {
  MissileAction action = MissileAction.move;

  List<FighterJetCommand> commands = [];
  int updateMarks = 0;
  int currentIndex = 0;
  bool isMissileFired = false;

  void fireMissile(Size screenSize, double innerShortestSide) {
    int fuelCount = getIt<GameStatsProvider>().fuel;
    bool isEnoughFuelForMissile = fuelCount >= fuelCostMISSILE;

    if (isMissileFired || !isEnoughFuelForMissile) return;
    isMissileFired = true;

    int jetIndex = getIt<FighterJetProvider>().currentIndex;
    FighterJetDirection jetDirection = getIt<FighterJetProvider>().currentDirection;

    int maxIndex = _findMissileMaximumIndex(jetIndex, jetDirection, getIt<GameBoardProvider>().gridSize);
    if (maxIndex < 0) {
      isMissileFired = false;
      return;
    }

    bool collisionWithAsteroid = false;
    int gridBoxNumber = getIt<GameBoardProvider>().gridSize;

    FighterJetCommand missileCommand = FighterJetUtils.findShortestPath(
        jetIndex, maxIndex, gridBoxNumber, jetDirection, screenSize, innerShortestSide);

    // find Asteroid in the path
    // if any, recalculate command to stop at Asteroid index
    int? asteroidIndex = FighterJetUtils.findBlockingAsteroid(
        jetIndex, missileCommand.index, getIt<GameStatsProvider>().asteroidIndices, gridBoxNumber);
    if (asteroidIndex != null) {
      collisionWithAsteroid = true;
      missileCommand = FighterJetUtils.findShortestPath(
          jetIndex, asteroidIndex, gridBoxNumber, jetDirection, screenSize, innerShortestSide);
    }

    getIt<GameStatsProvider>().useFuelForMissile();
    currentIndex = missileCommand.index;
    commands.add(missileCommand);
    action = MissileAction.move;
    if (collisionWithAsteroid) action = MissileAction.destroyAsteroid;
    updateMarks++;
    notifyListeners();
  }

  void fireMissileDONE(BuildContext context) {
    // check game score, prevent further jet move if player already won
    if (getIt<GameStatsProvider>().score >= 100) {
      getIt<GameFlowProvider>().gameWinner(context);
      return;
    }

    // check for fuel pod on current fighter jet index if remaining fuel is less than 2
    if (getIt<GameStatsProvider>().fuel < minimumFuelLimit) {
      bool isFuelPodExistAtCurrentIndex =
          getIt<GameStatsProvider>().fuelPodIndices.contains(getIt<FighterJetProvider>().currentIndex);
      if (!isFuelPodExistAtCurrentIndex) {
        getIt<GameFlowProvider>().gameOver(context, gameOverFuel);
        return;
      }
    }

    isMissileFired = false;
    getIt<FighterJetProvider>().fireMissileEND();
  }

  /// Calculate the end index position based on fighter jet current index and direction.
  /// The end position will be up to 3 spaces away from start position in the same direction.
  /// If 3 spaces is not available, returns the maximum possible position in that direction.
  /// Returns -1 if no movement is possible in that direction.
  int _findMissileMaximumIndex(
    int startIndex,
    FighterJetDirection direction,
    int gridSize, {
    int maxMissileRange = 3,
  }) {
    // Calculate row and column of start position
    final int startRow = startIndex ~/ gridSize;
    final int startCol = startIndex % gridSize;

    switch (direction) {
      case FighterJetDirection.right:
        final int spacesAvailable = gridSize - 1 - startCol;
        if (spacesAvailable <= 0) return -1;
        return startIndex + min(spacesAvailable, maxMissileRange);

      case FighterJetDirection.left:
        final int spacesAvailable = startCol;
        if (spacesAvailable <= 0) return -1;
        return startIndex - min(spacesAvailable, maxMissileRange);

      case FighterJetDirection.up:
        final int spacesAvailable = startRow;
        if (spacesAvailable <= 0) return -1;
        return startIndex - (min(spacesAvailable, maxMissileRange) * gridSize);

      case FighterJetDirection.down:
        final int spacesAvailable = gridSize - 1 - startRow;
        if (spacesAvailable <= 0) return -1;
        return startIndex + (min(spacesAvailable, maxMissileRange) * gridSize);

      case FighterJetDirection.upLeft:
        final int spacesAvailableUp = startRow;
        final int spacesAvailableLeft = startCol;
        final int spacesAvailable = min(spacesAvailableUp, spacesAvailableLeft);
        if (spacesAvailable <= 0) return -1;
        final int spaces = min(spacesAvailable, maxMissileRange);
        return startIndex - (spaces * gridSize) - spaces;

      case FighterJetDirection.upRight:
        final int spacesAvailableUp = startRow;
        final int spacesAvailableRight = gridSize - 1 - startCol;
        final int spacesAvailable = min(spacesAvailableUp, spacesAvailableRight);
        if (spacesAvailable <= 0) return -1;
        final int spaces = min(spacesAvailable, maxMissileRange);
        return startIndex - (spaces * gridSize) + spaces;

      case FighterJetDirection.downLeft:
        final int spacesAvailableDown = gridSize - 1 - startRow;
        final int spacesAvailableLeft = startCol;
        final int spacesAvailable = min(spacesAvailableDown, spacesAvailableLeft);
        if (spacesAvailable <= 0) return -1;
        final int spaces = min(spacesAvailable, maxMissileRange);
        return startIndex + (spaces * gridSize) - spaces;

      case FighterJetDirection.downRight:
        final int spacesAvailableDown = gridSize - 1 - startRow;
        final int spacesAvailableRight = gridSize - 1 - startCol;
        final int spacesAvailable = min(spacesAvailableDown, spacesAvailableRight);
        if (spacesAvailable <= 0) return -1;
        final int spaces = min(spacesAvailable, maxMissileRange);
        return startIndex + (spaces * gridSize) + spaces;
    }
  }

  void reset() {
    action = MissileAction.move;
    commands = [];
    updateMarks = 0;
    currentIndex = 0;
    isMissileFired = false;
  }
}
