import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class FighterJetProvider extends ChangeNotifier {
  FighterJetAction action = FighterJetAction.none;

  List<FighterJetCommand> commands = [];
  FighterJetDirection currentDirection = FighterJetDirection.up;
  int updateMarks = 0;
  int currentIndex = 0;
  bool isJetMoving = false;
  bool isJetRefueling = false;
  bool isMissileFired = false;

  FurthestIndex? furthestIndexData;
  NextGalaxy? nextGalaxyDestination;
  int? nextGalaxyStartingIndex;

  void setGridIndex(int index) {
    currentIndex = index;
  }

  void loadJetValueFromStorage(int jetIndex, FighterJetDirection jetDirection) {
    currentIndex = jetIndex;
    currentDirection = jetDirection;
  }

  void jetFinishMoving(BuildContext context) async {
    // check game score, prevent further jet move if player already won
    if (getIt<GameStatsProvider>().score >= 100) {
      getIt<GameFlowProvider>().gameWinner(context);
      return;
    }

    // check for fuel pod on current index if remaining fuel is less than 2
    if (getIt<GameStatsProvider>().fuel < minimumFuelLimit) {
      bool isFuelPodExistAtCurrentIndex = getIt<GameStatsProvider>().fuelPodIndices.contains(currentIndex);
      if (!isFuelPodExistAtCurrentIndex) {
        getIt<GameFlowProvider>().gameOver(context, gameOverFuel);
        return;
      }
    }
    isJetMoving = false;
    getIt<GameStatsProvider>().saveCurrentGameStatsToStorage(currentIndex, currentDirection);
  }

  void jetMovingToNewGalaxy() {
    furthestIndexData = null;
    nextGalaxyDestination = null;
    nextGalaxyStartingIndex = null;
    isJetMoving = false;
    getIt<GameStatsProvider>().saveCurrentGameStatsToStorage(currentIndex, currentDirection);
  }

  void moveJet(
    int targetIndex,
    Size screenSize,
    double innerShortestSide, {
    FurthestIndex? furthestIndex,
    NextGalaxy? nextGalaxy,
  }) {
    if (isJetMoving || isJetRefueling || isMissileFired) return;
    isJetMoving = true;

    bool collisionWithAsteroid = false;
    int gridBoxNumber = getIt<GameBoardProvider>().gridSize;
    int fuelCount = getIt<GameStatsProvider>().fuel;

    if (fuelCount == 0) {
      isJetMoving = false;
      return;
    }

    // * create first Command
    // * --------------------------------------------------------------------------
    FighterJetCommand commandA = FighterJetUtils.findShortestPath(
        currentIndex, targetIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide,
        availableFuel: fuelCount);

    // find Asteroid in the path
    // if any, recalculate commandA to stop at Asteroid index
    int? asteroidIndex = FighterJetUtils.findBlockingAsteroid(
        currentIndex, commandA.index, getIt<GameStatsProvider>().asteroidIndices, gridBoxNumber);
    if (asteroidIndex != null) {
      collisionWithAsteroid = true;
      commandA = FighterJetUtils.findShortestPath(
          currentIndex, asteroidIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide,
          availableFuel: fuelCount);
    }

    // calculate remaining fuel based on commandA action
    int totalStepCommandA = commandA.step;
    int fuelCostCommandA = totalStepCommandA * fuelCostMOVE;
    if (currentDirection != commandA.direction) {
      fuelCostCommandA += fuelCostROTATE;
    }
    fuelCount = fuelCount - fuelCostCommandA;

    // update data based on commandA
    currentIndex = commandA.index;
    commands.add(commandA);
    currentDirection = commandA.direction;

    // * create second Command if any
    // * --------------------------------------------------------------------------
    if (commandA.pathType == FighterJetPath.transit) {
      FighterJetCommand commandB = FighterJetUtils.findShortestPath(
          commandA.index, targetIndex, gridBoxNumber, commandA.direction, screenSize, innerShortestSide,
          availableFuel: fuelCount);

      // find Asteroid in the path
      // if any, recalculate commandB to stop at Asteroid index
      int? asteroidIndex = FighterJetUtils.findBlockingAsteroid(
          commandA.index, commandB.index, getIt<GameStatsProvider>().asteroidIndices, gridBoxNumber);
      if (asteroidIndex != null) {
        collisionWithAsteroid = true;
        commandB = FighterJetUtils.findShortestPath(
            commandA.index, asteroidIndex, gridBoxNumber, currentDirection, screenSize, innerShortestSide,
            availableFuel: fuelCount);
      }

      // update data based on commandB
      currentIndex = commandB.index;
      commands.add(commandB);
      currentDirection = commandB.direction;
    }

    // set data for next galaxy destination if jet not collided with any asteroid
    if (furthestIndex != null && !collisionWithAsteroid) {
      furthestIndexData = furthestIndex;
      nextGalaxyDestination = nextGalaxy;
      nextGalaxyStartingIndex = furthestIndex.startingIndexOnNextGalaxy(nextGalaxy!);

      // make correction to jet direction for next galaxy if jet currentIndex and targetIndex is the same
      // FighterJetUtils.findShortestPath will not give the right direction under that circumstances
      if (commands.length == 1 && commands[0].step == 0) {
        commands[0].setDirectionForNextGalaxy(nextGalaxy);
        currentDirection = commands[0].direction;
      }
    }

    action = FighterJetAction.move;
    if (collisionWithAsteroid) action = FighterJetAction.asteroidCollision;
    updateMarks++;
    notifyListeners();
  }

  void recoverFromCollision(BuildContext context) async {
    getIt<GameStatsProvider>().reduceLife();
    await Future.delayed(const Duration(milliseconds: 75));
    if (!context.mounted) return;

    int lifeCount = getIt<GameStatsProvider>().remainingLife;
    if (lifeCount >= 1) {
      getIt<GameStatsProvider>().saveCurrentGameStatsToStorage(currentIndex, currentDirection);
      action = FighterJetAction.collisionRecover;
      updateMarks++;
      notifyListeners();
    } else {
      getIt<GameFlowProvider>().gameOver(context, gameOverLife);
    }
  }

  void refuelingSTART() => isJetRefueling = true;

  void refuelingEND() {
    isJetRefueling = false;
    getIt<GameStatsProvider>().saveCurrentGameStatsToStorage(currentIndex, currentDirection);
  }

  void fireMissileSTART() => isMissileFired = true;

  void fireMissileEND() {
    isMissileFired = false;
    getIt<GameStatsProvider>().saveCurrentGameStatsToStorage(currentIndex, currentDirection);
  }

  void reset() {
    action = FighterJetAction.none;
    commands = [];
    currentDirection = FighterJetDirection.up;
    updateMarks = 0;
    currentIndex = 0;
    isJetMoving = false;
    isJetRefueling = false;
    isMissileFired = false;
    furthestIndexData = null;
    nextGalaxyDestination = null;
    nextGalaxyStartingIndex = null;
  }
}
