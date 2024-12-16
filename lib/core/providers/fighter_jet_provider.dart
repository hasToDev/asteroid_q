import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class FighterJetProvider extends ChangeNotifier {
  FighterJetAction action = FighterJetAction.none;

  Offset targetOffset = Offset.zero;
  double targetAngle = 0.0;
  int updateMarks = 0;
  int latestIndex = 0;

  void moveJet(Offset offset, int index) {
    action = FighterJetAction.move;
    targetOffset = offset;
    latestIndex = index;
    updateMarks++;
    notifyListeners();
  }

  void rotateJet(double angle, int index) {
    action = FighterJetAction.rotate;
    targetAngle = angle;
    latestIndex = index;
    updateMarks++;
    notifyListeners();
  }
}
