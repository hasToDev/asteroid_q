import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameStatsProvider extends ChangeNotifier {
  int move = 0;
  int rotate = 0;
  int fuel = 0;
  int score = 0;
  int remainingLife = 0;

  Map<String, GalaxyData> gameMap = {};
  GalaxyCoordinates currentCoordinate = GalaxyCoordinates(x: 0, y: 0, size: GalaxySize.large);

  GalaxyData? currentGalaxyData;
  List<int> fuelPodIndices = [];
  List<int> asteroidIndices = [];

  /// Process current Galaxy Data, separate the FuelPod and Asteroid indices
  Future<void> processGalaxyData(GalaxyData galaxyData) async {
    currentGalaxyData = galaxyData;
    fuelPodIndices = [];
    asteroidIndices = [];
    for (GameObjectPosition obj in galaxyData.items) {
      if (obj.type == GameObjectType.asteroid) asteroidIndices.add(obj.index);
      if (obj.type == GameObjectType.fuelPod) fuelPodIndices.add(obj.index);
    }
  }

  /// Update GalaxyData after Asteroid being destroyed
  /// will add 1 Score
  Future<void> asteroidDestroyed(int index) async {
    asteroidIndices.remove(index);
    GalaxyData? updatedData = currentGalaxyData!.removeItemIfExists(index, GameObjectType.asteroid);
    if (updatedData != null) {
      currentGalaxyData = updatedData;
      saveGalaxyData(currentCoordinate, updatedData);
    }
    await updateScore();
  }

  /// Update GalaxyData after FuelPod being harvested
  /// will add 100 Fuel
  Future<void> fuelPodHarvested(int index) async {
    fuelPodIndices.remove(index);
    GalaxyData? updatedData = currentGalaxyData!.removeItemIfExists(index, GameObjectType.fuelPod);
    if (updatedData != null) {
      currentGalaxyData = updatedData;
      saveGalaxyData(currentCoordinate, updatedData);
    }
    await updateFuel();
  }

  Future<void> updateScore() async {
    score = score + 1;
    // TODO: notify the stat listener
  }

  Future<void> updateFuel() async {
    fuel = fuel + 100;
    // TODO: notify the stat listener
  }

  void updateMove() => move++;

  void updateRotate() => rotate++;

  void saveCoordinate(GalaxyCoordinates coordinate) => currentCoordinate = coordinate;

  /// Saves data for a specific grid coordinate
  void saveGalaxyData(GalaxyCoordinates coordinate, GalaxyData data) {
    String key = coordinate.coordinateToKey();
    gameMap[key] = data;
  }

  /// Retrieves data for a specific grid coordinate
  GalaxyData? getGalaxyData(GalaxyCoordinates coordinate) {
    String key = coordinate.coordinateToKey();
    return gameMap[key];
  }
}
