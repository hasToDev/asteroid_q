import 'package:flutter/material.dart';

class AsteroidProvider extends ChangeNotifier {
  int updateMarks = 0;
  int asteroidIndex = -1;

  void asteroidExplosion(int index) {
    asteroidIndex = index;
    updateMarks++;
    notifyListeners();
  }
}
