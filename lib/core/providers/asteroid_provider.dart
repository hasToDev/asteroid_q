import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class AsteroidProvider extends ChangeNotifier {
  AsteroidDestructionType explosionReason = AsteroidDestructionType.missile;

  int updateMarks = 0;
  int asteroidIndex = -1;

  void asteroidExplosion(int index, AsteroidDestructionType destructionType) {
    asteroidIndex = index;
    explosionReason = destructionType;
    updateMarks++;
    notifyListeners();
  }

  void reset() {
    updateMarks = 0;
    asteroidIndex = -1;
  }
}
