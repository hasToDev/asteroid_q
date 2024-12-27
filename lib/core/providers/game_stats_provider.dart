import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameStatsProvider extends ChangeNotifier {
  int move = 0;
  int rotate = 0;
  int fuel = 0;
  int score = 0;
  int remainingLife = 0;

  Map<String, GalaxyData> gameMap = {};
  GalaxyCoordinates currentCoordinate = GalaxyCoordinates(x: 0, y: 0, size: GalaxySize.normal);

  List<int> fuelPodIndices = [];
  List<int> asteroidIndices = [];

  /// Process current Galaxy Data, separate the FuelPod and Asteroid indices
  Future<void> processGalaxyData(GalaxyData galaxyData) async {
    fuelPodIndices = [];
    asteroidIndices = [];
    for (GameObjectPosition obj in galaxyData.items) {
      if (obj.type == GameObjectType.asteroid) asteroidIndices.add(obj.index);
      if (obj.type == GameObjectType.fuelPod) fuelPodIndices.add(obj.index);
    }
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
