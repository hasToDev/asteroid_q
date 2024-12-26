import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameBoardProvider extends ChangeNotifier {
  double innerShortestSide = 0;
  double gameItemSize = 0;
  Size currentScreenSize = Size.zero;

  setInnerShortestSide(double value, Size screenSize) {
    innerShortestSide = value;
    currentScreenSize = screenSize;
    _calculateGameItemSize(screenSize);
  }

  _calculateGameItemSize(Size screenSize) {
    double itemSize = (innerShortestSide / gridBoxNumber);
    double axisSpacing = itemSize * axisSpacingMultiplier;
    gameItemSize = itemSize - axisSpacing;
  }

  getIndexOffset(int gridIndex) {
    return GameBoardUtils.findIndexOffset(gridIndex, gridBoxNumber, innerShortestSide, currentScreenSize);
  }

  getIndexAdjustedOffset(int gridIndex) {
    Offset offset = GameBoardUtils.findIndexOffset(gridIndex, gridBoxNumber, innerShortestSide, currentScreenSize);
    return Offset(offset.dx - (gameItemSize / 2), offset.dy - (gameItemSize / 2));
  }
}
