import 'package:flutter/material.dart';

class GameStatsProvider extends ChangeNotifier {
  int move = 0;
  int rotate = 0;
  int fuel = 0;
  int score = 0;
  int hullIntegrity = 0;

  void updateMove() => move++;

  void updateRotate() => rotate++;
}
