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
    if (isJetMoving) return;
    isJetMoving = true;

    int gridBoxNumber = getIt<GameBoardProvider>().gridSize;

    // create first Command
    FighterJetCommand commandA = FighterJetUtils.findShortestPath(
        currentIndex, targetIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide);
    commands.add(commandA);
    currentDirection = commandA.direction;

    // create second Command if necessary
    if (commandA.pathType == FighterJetPath.transit) {
      FighterJetCommand commandB = FighterJetUtils.findShortestPath(
          commandA.index, targetIndex, gridBoxNumber, commandA.direction, screenSize, innerShortestSide);
      commands.add(commandB);
      currentDirection = commandB.direction;
    }

    // set data for next galaxy destination
    if  (furthestIndex != null) {
      furthestIndexData = furthestIndex;
      nextGalaxyDestination = nextGalaxy;
      nextGalaxyStartingIndex = furthestIndex.startingIndexOnNextGalaxy(nextGalaxy!);
    }

    action = FighterJetAction.move;
    currentIndex = targetIndex;
    updateMarks++;
    notifyListeners();
  }

// void rotateJet(FighterJetDirection direction, int index) {
//   action = FighterJetAction.rotate;
//   currentDirection = direction;
//   currentIndex = index;
//   updateMarks++;
//   notifyListeners();
// }
}
