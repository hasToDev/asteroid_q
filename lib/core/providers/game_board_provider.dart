import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameBoardProvider extends ChangeNotifier {
  // TODO: try change it to 11 from 17
  int gridSize = 17;

  // TODO: adjust it to match the grid size
  // for gridSize 17 :the max index is 17 x 17 = 288
  int maxIndexForGRidSize = 288;

  double innerShortestSide = 0;
  double gameItemSize = 0;
  Size currentScreenSize = Size.zero;

  setGridSize(int value) {
    gridSize = value;
    maxIndexForGRidSize = value * value;
  }

  setInnerShortestSide(double value, Size screenSize) {
    innerShortestSide = value;
    currentScreenSize = screenSize;
    _calculateGameItemSize(screenSize);
  }

  _calculateGameItemSize(Size screenSize) {
    double itemSize = (innerShortestSide / gridSize);
    double axisSpacing = itemSize * axisSpacingMultiplier;
    gameItemSize = itemSize - axisSpacing;
  }

  getIndexOffset(int gridIndex) {
    return GameBoardUtils.findIndexOffset(gridIndex, gridSize, innerShortestSide, currentScreenSize);
  }

  getIndexAdjustedOffset(int gridIndex) {
    Offset offset = GameBoardUtils.findIndexOffset(gridIndex, gridSize, innerShortestSide, currentScreenSize);
    return Offset(offset.dx - (gameItemSize / 2), offset.dy - (gameItemSize / 2));
  }
}
