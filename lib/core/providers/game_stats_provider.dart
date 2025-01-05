import 'dart:convert';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameStatsProvider extends ChangeNotifier {
  int spaceTravelled = 0;
  int rotate = 0;
  int fuel = 50;
  int score = 0;
  int remainingLife = 3;

  int galaxyCount = 0;
  int refuelCount = 0;

  Map<String, GalaxyData> gameMap = {};
  GalaxyCoordinates currentCoordinate = GalaxyCoordinates(x: 0, y: 0, size: GalaxySize.large);

  GalaxyData? currentGalaxyData;
  List<int> fuelPodIndices = [];
  List<int> asteroidIndices = [];
  bool savingData = false;

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
  Future<void> asteroidDestroyed(int index) async {
    asteroidIndices.remove(index);
    GalaxyData? updatedData = currentGalaxyData!.removeItemIfExists(index, GameObjectType.asteroid);
    if (updatedData != null) {
      currentGalaxyData = updatedData;
      saveGalaxyData(currentCoordinate, updatedData);
    }
  }

  /// Update GalaxyData after FuelPod being harvested
  Future<void> fuelPodHarvested(int index) async {
    fuelPodIndices.remove(index);
    GalaxyData? updatedData = currentGalaxyData!.removeItemIfExists(index, GameObjectType.fuelPod);
    if (updatedData != null) {
      currentGalaxyData = updatedData;
      saveGalaxyData(currentCoordinate, updatedData);
    }
  }

  Future<void> updateScore() async {
    score = score + 1;
    await Future.delayed(waitDuration);
    notifyListeners();
  }

  Future<void> updateFuel() async {
    refuelCount++;
    fuel = fuel + fuelAmountInFuelPod;
    await Future.delayed(waitDuration);
    notifyListeners();
  }

  Future<void> reduceLife() async {
    remainingLife = remainingLife - 1;
    await Future.delayed(waitDuration);
    notifyListeners();
  }

  Future<void> useFuelForMissile() async {
    fuel = fuel - fuelCostMISSILE;
    notifyListeners();
  }

  Future<void> useFuelForRotation() async {
    fuel = fuel - fuelCostROTATE;
    notifyListeners();
  }

  Future<void> useFuelForMove(int step) async {
    fuel = fuel - (fuelCostMOVE * step);
    notifyListeners();
  }

  void updateMoveStatsAndFuel(int step) {
    spaceTravelled = spaceTravelled + step;
    useFuelForMove(step);
  }

  void updateRotateStatsAndFuel() {
    rotate++;
    useFuelForRotation();
  }

  void updateVisitedGalaxyCount() {
    galaxyCount++;
  }

  void saveCoordinate(GalaxyCoordinates coordinate) => currentCoordinate = coordinate;

  /// Saves data for a specific grid coordinate
  void saveGalaxyData(GalaxyCoordinates coordinate, GalaxyData data) {
    String key = coordinate.coordinateToKey();
    gameMap[key] = data;
    saveCurrentMapToStorage();
  }

  /// Retrieves data for a specific grid coordinate
  GalaxyData? getGalaxyData(GalaxyCoordinates coordinate) {
    String key = coordinate.coordinateToKey();
    return gameMap[key];
  }

  Future<void> saveCurrentMapToStorage() async {
    if (savingData) return;
    savingData = true;
    await getIt<SharedPreferences>().setString(storedGameGalaxyData, jsonEncode(gameMap));
    savingData = false;
  }

  Future<void> loadMapFromStorage() async {
    String mapJson = getIt<SharedPreferences>().getString(storedGameGalaxyData) ?? '';
    final Map<String, dynamic> jsonMap = jsonDecode(mapJson) as Map<String, dynamic>;
    gameMap = jsonMap.map((key, value) => MapEntry(key, GalaxyData.fromJson(value as Map<String, dynamic>)));
  }

  Future<void> removeFromStorage() async {
    gameMap.clear();
    await getIt<SharedPreferences>().remove(storedGameGalaxyData);
  }

  void reset() {
    spaceTravelled = 0;
    rotate = 0;
    fuel = 50;
    score = 0;
    remainingLife = 3;
    galaxyCount = 0;
    refuelCount = 0;
    gameMap = {};
    currentCoordinate = GalaxyCoordinates(x: 0, y: 0, size: GalaxySize.large);
    currentGalaxyData = null;
    fuelPodIndices = [];
    asteroidIndices = [];
  }
}
