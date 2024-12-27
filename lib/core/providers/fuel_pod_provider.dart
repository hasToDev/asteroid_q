import 'package:flutter/material.dart';

class FuelPodProvider extends ChangeNotifier {
  int updateMarks = 0;
  int fuelPodIndex = -1;
  bool isHarvesting = false;

  // TODO: where to call this ??
  void fuelPodHarvesting(int index) {
    if (isHarvesting) return;
    isHarvesting = true;

    fuelPodIndex = index;
    updateMarks++;
    notifyListeners();
  }

  void fuelPodHarvestingDONE() => isHarvesting = false;
}
