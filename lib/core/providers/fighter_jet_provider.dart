import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class FighterJetProvider extends ChangeNotifier {
  FighterJetAction action = FighterJetAction.none;

  List<FighterJetCommand> commands = [];
  FighterJetDirection currentDirection = FighterJetDirection.up;
  int updateMarks = 0;
  int currentIndex = 0;

  void setGridIndex(int index) {
    currentIndex = index;
  }

  void moveJet(int targetIndex, Size screenSize, double innerShortestSide) {
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
