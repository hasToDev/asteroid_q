import 'package:flutter/material.dart';

class FuelPodProvider extends ChangeNotifier {
  int updateMarks = 0;
  int fuelPodIndex = -1;
  bool isHarvesting = false;

  void fuelPodHarvesting(int index) {
    if (isHarvesting) return;
    isHarvesting = true;

    fuelPodIndex = index;
    updateMarks++;
    notifyListeners();
  }

  void fuelPodHarvestingDONE() => isHarvesting = false;
}
