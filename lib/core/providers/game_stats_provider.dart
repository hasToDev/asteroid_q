import 'dart:convert';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameStatsProvider extends ChangeNotifier {
  int score = 0;
  int fuel = 50;
  int remainingLife = 3;

  int spaceTravelled = 0;
  int rotate = 0;
  int refuelCount = 0;
  int galaxyCount = 0;

  Map<String, GalaxyData> gameMap = {};
  GalaxyCoordinates currentCoordinate = GalaxyCoordinates(x: 0, y: 0, size: GalaxySize.large);

  GalaxyData? currentGalaxyData;
  List<int> fuelPodIndices = [];
  List<int> asteroidIndices = [];
  bool savingData = false;
  bool savingGameStats = false;
  bool savingCoordinate = false;

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

  void saveCoordinate(GalaxyCoordinates coordinate) {
    currentCoordinate = coordinate;
    saveCoordinateToStorage();
  }

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
    if (mapJson.isEmpty) return;

    final Map<String, dynamic> jsonMap = jsonDecode(mapJson) as Map<String, dynamic>;
    gameMap = jsonMap.map((key, value) => MapEntry(key, GalaxyData.fromJson(value as Map<String, dynamic>)));
  }

  Future<void> saveCurrentGameStatsToStorage() async {
    if (savingGameStats) return;
    savingGameStats = true;
    Map<String, dynamic> gameStatsMap = {
      'score': score,
      'fuel': fuel,
      'remainingLife': remainingLife,
      'spaceTravelled': spaceTravelled,
      'rotate': rotate,
      'refuelCount': refuelCount,
      'galaxyCount': galaxyCount,
    };
    await getIt<SharedPreferences>().setString(storedGameStatsData, jsonEncode(gameStatsMap));
    savingGameStats = false;
  }

  Future<void> loadGameStatsFromStorage() async {
    String gameStatsMapJson = getIt<SharedPreferences>().getString(storedGameStatsData) ?? '';
    if (gameStatsMapJson.isEmpty) return;

    Map<String, dynamic> gameStatsMap = jsonDecode(gameStatsMapJson) as Map<String, dynamic>;
    score = gameStatsMap['score'] as int;
    fuel = gameStatsMap['fuel'] as int;
    remainingLife = gameStatsMap['remainingLife'] as int;
    spaceTravelled = gameStatsMap['spaceTravelled'] as int;
    rotate = gameStatsMap['rotate'] as int;
    refuelCount = gameStatsMap['refuelCount'] as int;
    galaxyCount = gameStatsMap['galaxyCount'] as int;
  }

  Future<void> saveCoordinateToStorage() async {
    if (savingCoordinate) return;
    savingCoordinate = true;
    await getIt<SharedPreferences>().setString(storedGameCoordinateData, jsonEncode(currentCoordinate));
    savingCoordinate = false;
  }

  Future<void> loadCoordinateFromStorage() async {
    String coordinateJson = getIt<SharedPreferences>().getString(storedGameCoordinateData) ?? '';
    if (coordinateJson.isEmpty) return;

    final Map<String, dynamic> coordinateMap = jsonDecode(coordinateJson) as Map<String, dynamic>;
    currentCoordinate = GalaxyCoordinates.fromJson(coordinateMap);
  }

  Future<void> removeFromStorage() async {
    gameMap.clear();
    await getIt<SharedPreferences>().remove(storedGameGalaxyData);
    await getIt<SharedPreferences>().remove(storedGameStatsData);
    await getIt<SharedPreferences>().remove(storedGameCoordinateData);
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
