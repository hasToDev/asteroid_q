import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class FighterJetProvider extends ChangeNotifier {
  FighterJetAction action = FighterJetAction.none;

  List<FighterJetCommand> commands = [];
  FighterJetDirection currentDirection = FighterJetDirection.up;
  int updateMarks = 0;
  int currentIndex = 0;
  bool isJetMoving = false;

  FurthestIndex? furthestIndexData;
  NextGalaxy? nextGalaxyDestination;
  int? nextGalaxyStartingIndex;

  void setGridIndex(int index) {
    currentIndex = index;
  }

  void jetFinishMoving() => isJetMoving = false;

  void jetMovingToNewGalaxy() {
    furthestIndexData = null;
    nextGalaxyDestination = null;
    nextGalaxyStartingIndex = null;
    isJetMoving = false;
  }

  void moveJet(
    int targetIndex,
    Size screenSize,
    double innerShortestSide, {
    FurthestIndex? furthestIndex,
    NextGalaxy? nextGalaxy,
  }) {
    // TODO: check from game stats provider if the jet still have remaining fuel to move

    if (isJetMoving) return;
    isJetMoving = true;

    bool collisionWithAsteroid = false;
    int gridBoxNumber = getIt<GameBoardProvider>().gridSize;

    // create first Command
    FighterJetCommand commandA = FighterJetUtils.findShortestPath(
        currentIndex, targetIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide);

    // find Asteroid in the path
    // if any, recalculate commandA to stop at Asteroid index
    int? asteroidIndex = FighterJetUtils.findBlockingAsteroid(
        currentIndex, commandA.index, getIt<GameStatsProvider>().asteroidIndices, gridBoxNumber);
    if (asteroidIndex != null) {
      collisionWithAsteroid = true;
      commandA = FighterJetUtils.findShortestPath(
          currentIndex, asteroidIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide);
    }
    currentIndex = commandA.index;
    commands.add(commandA);
    currentDirection = commandA.direction;

    // create second Command if necessary
    if (commandA.pathType == FighterJetPath.transit) {
      FighterJetCommand commandB = FighterJetUtils.findShortestPath(
          commandA.index, targetIndex, gridBoxNumber, commandA.direction, screenSize, innerShortestSide);

      // find Asteroid in the path
      // if any, recalculate commandB to stop at Asteroid index
      int? asteroidIndex = FighterJetUtils.findBlockingAsteroid(
          commandA.index, commandB.index, getIt<GameStatsProvider>().asteroidIndices, gridBoxNumber);
      if (asteroidIndex != null) {
        collisionWithAsteroid = true;
        commandB = FighterJetUtils.findShortestPath(
            commandA.index, asteroidIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide);
      }
      currentIndex = commandB.index;
      commands.add(commandB);
      currentDirection = commandB.direction;
    }

    // set data for next galaxy destination
    if (furthestIndex != null) {
      furthestIndexData = furthestIndex;
      nextGalaxyDestination = nextGalaxy;
      nextGalaxyStartingIndex = furthestIndex.startingIndexOnNextGalaxy(nextGalaxy!);

      // make correction to jet direction for next galaxy if jet currentIndex and targetIndex is the same
      // FighterJetUtils.findShortestPath will not give the right direction under that circumstances
      if (commands.length == 1 && commands[0].step == 0) {
        commands[0].setDirectionForNextGalaxy(nextGalaxy);
      }
    }

    action = FighterJetAction.move;
    if (collisionWithAsteroid) action = FighterJetAction.asteroidCollision;
    updateMarks++;
    notifyListeners();
  }

  void recoverFromCollision() {
    // TODO: check from game stats provider if the jet still have remaining life to recover from asteroid collision
    action = FighterJetAction.collisionRecover;
    updateMarks++;
    notifyListeners();
  }
}
